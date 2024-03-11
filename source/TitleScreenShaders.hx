package;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxShader;

/**
 * By @Ne_Eo_Twitch, modded a bit by lunar
 */
class NTSCSFilter extends FlxShader {
	@:glFragmentSource('
	#pragma header

	// DECODE NTSC AND CRT EFFECTS

	uniform float uFrame;
	uniform float uScanlineEffect;

	const float XRES = 54.0 * 8.0;
	const float YRES = 33.0 * 8.0;

	#define BRIGHTNESS 1.1
	#define SATURATION 1.8
	#define BLUR 0.7
	#define BLURSIZE 0.2
	#define CHROMABLUR 0.1
	#define CHROMASIZE 5.0
	#define SUBCARRIER 2.1
	#define CROSSTALK 0.1
	#define SCANFLICKER 0.2
	#define INTERFERENCE1 1.0
	#define INTERFERENCE2 0.01

	const float fishEyeX = 0.1;
	const float fishEyeY = 0.24;
	const float vignetteRounding = 160.0;
	const float vignetteSmoothness = 1.;

	#define PI 3.14159265

	// Fish-eye effect
	vec2 fisheye(vec2 uv) {
		uv *= vec2(1.0+(uv.y*uv.y)*fishEyeX,1.0+(uv.x*uv.x)*fishEyeY);
		return uv;
	}

	float vignette(vec2 uv) {
		uv *= 2.0;
		float amount = 1.0 - sqrt(pow(abs(uv.x), vignetteRounding) + pow(abs(uv.y), vignetteRounding));
		float vhard = smoothstep(0., vignetteSmoothness, amount);
		return(vhard);
	}

	float hash12(vec2 p)
	{
		vec3 p3 = fract(vec3(p.xyx) * .1031);
		p3 += dot(p3, p3.yzx + 33.33);
		return fract((p3.x + p3.y) * p3.z);
	}

	float random(vec2 p, float t) {
		return hash12((p * 0.152 + t * 1500. + 50.0));
	}

	float peak(float x, float xpos, float scale) {
		return clamp((1.0 - x) * scale * log(1.0 / abs(x - xpos)), 0.0, 1.0);
	}

	void main() {
		vec2 uv = openfl_TextureCoordv.xy;
		vec2 fragCoord = uv * openfl_TextureSize.xy;

		float scany = floor(uv.y * YRES + 0.5);

		uv -= 0.5;
		uv = fisheye(uv);
		float vign = vignette(uv);
		uv += 0.5;
		uv.y += 1.0 / YRES * SCANFLICKER;

		// interference
		float r = random(vec2(0.0, scany), uFrame/60.);
		if (r > 0.99) {r *= 3.0;}
		float ifx1 = INTERFERENCE1 * 2.0 / openfl_TextureSize.x * r;
		float ifx2 = INTERFERENCE2 * (r * peak(uv.y, 0.2, 0.2));
		uv.x += ifx1 + -ifx2;

		vec4 out_color = texture2D(bitmap, uv);

		float scanl = 0.5 + 0.5 * abs(sin(PI * uv.y * YRES));

		vec3 rgb = vign * out_color.rgb;
		gl_FragColor = vec4(mix(rgb, rgb * scanl, uScanlineEffect), out_color.a);
	}
	')
	public function new(scanlineEffect:Float = 1) {
		super();
		this.uFrame.value = [0];
		this.uScanlineEffect.value = [scanlineEffect];
	}

	public function update(elapsed:Float) {
		this.uFrame.value[0] += elapsed;
	}
}

class NTSCGlitch extends FlxShader // stolen from that one popular vhs shader used in ourple guy criminal
{
	@:glFragmentSource('
     #pragma header

#define round(a) floor(a + 0.5)
#define iResolution vec3(openfl_TextureSize, 0.)
uniform float time;
#define iChannel0 bitmap
uniform sampler2D iChannel1;
uniform sampler2D iChannel2;
uniform sampler2D iChannel3;
#define texture flixel_texture2D

// third argument fix
vec4 flixel_texture2D(sampler2D bitmap, vec2 coord, float bias) {
	vec4 color = texture2D(bitmap, coord, bias);
	if (!hasTransform)
	{
		return color;
	}
	if (color.a == 0.0)
	{
		return vec4(0.0, 0.0, 0.0, 0.0);
	}
	if (!hasColorTransform)
	{
		return color * openfl_Alphav;
	}
	color = vec4(color.rgb / color.a, color.a);
	mat4 colorMultiplier = mat4(0);
	colorMultiplier[0][0] = openfl_ColorMultiplierv.x;
	colorMultiplier[1][1] = openfl_ColorMultiplierv.y;
	colorMultiplier[2][2] = openfl_ColorMultiplierv.z;
	colorMultiplier[3][3] = openfl_ColorMultiplierv.w;
	color = clamp(openfl_ColorOffsetv + (color * colorMultiplier), 0.0, 1.0);
	if (color.a > 0.0)
	{
		return vec4(color.rgb * color.a * openfl_Alphav, color.a * openfl_Alphav);
	}
	return vec4(0.0, 0.0, 0.0, 0.0);
}

// variables which is empty, they need just to avoid crashing shader
uniform float timeDelta;
uniform float iFrameRate;
uniform int iFrame;
#define iChannelTime float[4](time, 0., 0., 0.)
#define iChannelResolution vec3[4](iResolution, vec3(0.), vec3(0.), vec3(0.))
uniform vec4 iMouse;
uniform vec4 iDate;

uniform float AMPLITUDE;
uniform float SPEED;

vec4 rgbShift( in vec2 p , in vec4 shift) {
    shift *= 2.0*shift.w - 1.0;
    vec2 rs = vec2(shift.x,-shift.y);
    vec2 gs = vec2(shift.y,-shift.z);
    vec2 bs = vec2(shift.z,-shift.x);
    
    float r = texture(iChannel0, p+rs, 0.0).x;
    float g = texture(iChannel0, p+gs, 0.0).y;
    float b = texture(iChannel0, p+bs, 0.0).z;
    
    return vec4(r,g,b,1.0);
}

vec4 noise( in vec2 p ) {
    return texture(iChannel1, p, 0.0);
}

vec4 vec4pow( in vec4 v, in float p ) {
    return vec4(pow(v.x,p),pow(v.y,p),pow(v.z,p),v.w); 
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
	vec2 p = openfl_TextureCoordv.xy;
    vec4 c = vec4(0.0,0.0,0.0,1.0);
    
    // Elevating shift values to some high power (between 8 and 16 looks good)
    // helps make the stuttering look more sudden
    vec4 shift = vec4pow(noise(vec2(SPEED*time,2.0*SPEED*time/25.0 )),8.0)
        		*vec4(AMPLITUDE,AMPLITUDE,AMPLITUDE,1.0);;
    
    c += rgbShift(p, shift);
    
	fragColor = c;
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}
    ')
	public override function new(?_glitch:Float = 2)
	{
		super();

		time.value = [0];
		AMPLITUDE.value = [FlxG.width, FlxG.height];

		setGlitch(_glitch);
	}

	public inline function setGlitch(?amount:Float = 0)
	{
		AMPLITUDE.value = [amount];
		SPEED.value = [0.1];
	}

	public inline function update(elapsed:Float)
	{
		time.value[0] += elapsed;
	}
}

class TVStatic extends FlxShader {
	@:glFragmentSource('
    #pragma header

	uniform float iTime;
	uniform float strengthMulti;
	uniform float imtoolazytonamethis;

	const float maxStrength = .8;
	const float minStrength = 0.3;

	const float speed = 20.00;

	float random (vec2 noise)
	{
		return fract(sin(dot(noise.xy,vec2(10.998,98.233)))*12433.14159265359);
	}

	void main()
	{
		
		vec2 uv = openfl_TextureCoordv.xy;
		vec2 uv2 = fract(openfl_TextureCoordv.xy*fract(sin(iTime*speed)));
		
		float _maxStrength = clamp(sin(iTime/2.0),minStrength+imtoolazytonamethis,maxStrength) * strengthMulti;
		
		vec3 colour = vec3(random(uv2.xy) - 0.1)*_maxStrength;
		vec3 background = vec3(flixel_texture2D(bitmap, uv));
		
		gl_FragColor = vec4(background-colour,1.0);
	}
	')

	public override function new() {
		super();
		iTime.value = [0];
		strengthMulti.value = [1];
		imtoolazytonamethis.value = [0];
	}

	public function update(elapsed:Float) {
		iTime.value[0] += elapsed;
	}
}

class Abberation extends FlxShader // https://www.shadertoy.com/view/ltByR3
{
	@:glFragmentSource('
    #pragma header
    
    uniform float aberrationAmount;

    void main()
    {
        vec2 uv = openfl_TextureCoordv.xy;
        vec2 distFromCenter = uv - 0.5;

        vec2 aberrated = aberrationAmount * pow(distFromCenter, vec2(3.0, 3.0));
        
        gl_FragColor = vec4
        (
            flixel_texture2D(bitmap, uv - aberrated).r,
            flixel_texture2D(bitmap, uv).g,
            flixel_texture2D(bitmap, uv + aberrated).b,
            1.0
        );
    }
    ')
	public override function new(?chrom:Float = 0)
	{
		super();
		setChrom(chrom);
	}

	public inline function setChrom(?amount:Float = 0.1)
	{
		aberrationAmount.value = [amount];
	}
}

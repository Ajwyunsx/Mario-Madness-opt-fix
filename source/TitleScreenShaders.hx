package;

import flixel.FlxG;
import flixel.system.FlxAssets.FlxShader;

/**
 * By @Ne_Eo_Twitch, modded a bit by lunar
 */
class NTSCSFilter extends FlxShader {
	@:glFragmentSource('
	#pragma header
	uniform float time;

	// DECODE NTSC AND CRT EFFECTS

	void main()
{
    vec2 uv = openfl_TextureCoordv.xy;
    gl_FragColor = texture2D(iChannel0, uv) + time;
 }
	')
	public function new(scanlineEffect:Float = 1) {
		super();
		this.time.value = [0];
		//this.uScanlineEffect.value = [scanlineEffect];
	}

	public function update(elapsed:Float) {
		this.time.value[0] += elapsed;
	}
}

class NTSCGlitch extends FlxShader // stolen from that one popular vhs shader used in ourple guy criminal
{
	@:glFragmentSource('
     #pragma header

    uniform float time;
    uniform vec2 resolution;

    uniform float glitchAmount;

    #define PI 3.14159265

    vec4 tex2D( sampler2D _tex, vec2 _p ){
        vec4 col = texture2D( _tex, _p );
        if ( 0.5 < abs( _p.x - 0.5 ) ) {
            col = vec4( 0.1 );
        }
        return col;
    }

    float hash( vec2 _v ){
        return fract( sin( dot( _v, vec2( 89.44, 19.36 ) ) ) * 22189.22 );
    }

    float iHash( vec2 _v, vec2 _r ){
        float h00 = hash( vec2( floor( _v * _r + vec2( 0.0, 0.0 ) ) / _r ) );
        float h10 = hash( vec2( floor( _v * _r + vec2( 1.0, 0.0 ) ) / _r ) );
        float h01 = hash( vec2( floor( _v * _r + vec2( 0.0, 1.0 ) ) / _r ) );
        float h11 = hash( vec2( floor( _v * _r + vec2( 1.0, 1.0 ) ) / _r ) );
        vec2 ip = vec2( smoothstep( vec2( 0.0, 0.0 ), vec2( 1.0, 1.0 ), mod( _v*_r, 1. ) ) );
        return ( h00 * ( 1. - ip.x ) + h10 * ip.x ) * ( 1. - ip.y ) + ( h01 * ( 1. - ip.x ) + h11 * ip.x ) * ip.y;
    }

    float noise( vec2 _v ){
        float sum = 0.;
        for( int i=1; i<9; i++ )
        {
            sum += iHash( _v + vec2( i ), vec2( 2. * pow( 2., float( i ) ) ) ) / pow( 2., float( i ) );
        }
        return sum;
    }

    void main(){
        vec2 uvn = openfl_TextureCoordv.xy;

        // tape wave
        uvn.x += ( noise( vec2( uvn.y, time ) ) - 0.5 )* 0.002;
        uvn.x += ( noise( vec2( uvn.y * 100.0, time * 10.0 ) ) - 0.5 ) * (0.01*glitchAmount);

        vec4 col = tex2D( bitmap, uvn );

        col *= 1.0 + clamp( noise( vec2( 0.0, uvn.y + time * 0.2 ) ) * 0.6 - 0.25, 0.0, 0.1 );

        gl_FragColor = col;
    }
    ')
	public override function new(?_glitch:Float = 2)
	{
		super();

		time.value = [0];
		resolution.value = [FlxG.width, FlxG.height];

		setGlitch(_glitch);
	}

	public inline function setGlitch(?amount:Float = 0)
	{
		glitchAmount.value = [amount];
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
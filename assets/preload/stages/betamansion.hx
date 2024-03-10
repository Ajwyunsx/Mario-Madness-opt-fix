var bg;
var scarymansion;
var betafire1;
var betafire2;
var scaryfloor;
var starmanGF;
var lluvia;

function onCreate()
{
bg = new BGSprite('mario/LuigiBeta/Skybox', -1200, -850, 1.8, 1.8);
					bg.antialiasing = ClientPrefs.globalAntialiasing;
					addBehindGF(bg);

					scarymansion = new BGSprite('mario/LuigiBeta/BackBG', -1200, -850, 1.8, 1.8);
					scarymansion.antialiasing = ClientPrefs.globalAntialiasing;
					add(scarymansion);

					addBehindGF(gfGroup);

					betafire1 = new BGSprite('mario/LuigiBeta/Alone_Fire', -320, -630, ['fire'], true);
					//betafire.setGraphicSize(Std.int(lluvia.width * 1.7));
					betafire1.antialiasing = ClientPrefs.globalAntialiasing;
					addBehindGF(betafire1);

					betafire2 = new BGSprite('mario/LuigiBeta/Alone_Fire', 1270, -630, ['fire'], true);
					//betafire.setGraphicSize(Std.int(lluvia.width * 1.7));
					betafire2.antialiasing = ClientPrefs.globalAntialiasing;
					betafire2.flipX = true;
					addBehindGF(betafire2);

					scaryfloor = new BGSprite('mario/LuigiBeta/FrontBG', -1200, -850);
					scaryfloor.antialiasing = ClientPrefs.globalAntialiasing;
					scaryfloor.scale.set(2, 2);
					addBehindGF(scaryfloor);

					starmanGF = new BGSprite('characters/Beta_Luigi_GF_Assets', 570, 100, 1, 1, ["GFIdle"], false);
					starmanGF.animation.addByIndices('danceRight', 'GFIdle', [15,16,17,18,19,20,21,22,23,24,25,26,27,28,29], "", 24, false);
					starmanGF.animation.addByIndices('danceLeft', 'GFIdle', [30,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14], "", 24, false);
					starmanGF.animation.addByPrefix('sad', "GFMiss", 24, false);
					starmanGF.antialiasing = ClientPrefs.globalAntialiasing;
					addBehindGF(starmanGF);

					lluvia = new BGSprite('mario/LuigiBeta/old/Beta_Luigi_Rain_V1', -170, 50, ['RainLuigi'], true);
					lluvia.setGraphicSize(Std.int(lluvia.width * 1.7));
					lluvia.alpha = 0;
					lluvia.antialiasing = ClientPrefs.globalAntialiasing;
					lluvia.cameras = [camEst];
					addBehindGF(lluvia);
}
function noteMiss()
{
starmanGF.animation.play('sad');
}

function onBeatHit()
{
if (curBeat % 2 == 0){
if (starmanGF.animation.curAnim.name != 'hey' || (starmanGF.animation.curAnim.name == 'hey' && starmanGF.animation.curAnim.finished)){
starmanGF.animation.play('danceRight', true);
}
}
else{
starmanGF.animation.play('danceLeft', true);
}
}
var bg;
var scarymansion;
var betafire1;
var betafire2;
var scaryfloor;


function onCreate()
{
                 bg = new FlxSprite(-1200, -850).loadGraphic(Paths.image('mario/LuigiBeta/Skybox'));
					bg.antialiasing = ClientPrefs.globalAntialiasing;
					bg.scale.set(1.8, 1.8);
					addBehindGF(bg);

				    scarymansion = new FlxSprite(-1200, -850).loadGraphic(Paths.image('mario/LuigiBeta/BackBG'));
				    scarymansion.scale.set(1.8, 1.8);
					scarymansion.antialiasing = ClientPrefs.globalAntialiasing;
					add(scarymansion);

					//addBehindGF(gfGroup);

					betafire1 = new BGSprite('mario/LuigiBeta/Alone_Fire', -320, -630, ['fire'], true);
					//betafire.setGraphicSize(Std.int(lluvia.width * 1.7));
					betafire1.antialiasing = ClientPrefs.globalAntialiasing;
					addBehindGF(betafire1);
					
					betafire1 = new flixel.FlxSprite();
					betafire1.x = -320;
					betafire1.y = -630;
                    betafire1.scale.set(1, 1);
                    betafire1.frames = Paths.getSparrowAtlas('mario/LuigiBeta/Alone_Fire');
                    betafire1.animation.addByPrefix('fire', 'fire', 24, true);
                    betafire1.animation.play('fire');
                    betafire1.scrollFactor.set(1,1);
                    addBehindGF(betafire1);
					
					betafire2 = new flixel.FlxSprite();
					betafire2.x = 1270;
					betafire2.y = -630;
                    betafire2.scale.set(1, 1);
                    betafire2.frames = Paths.getSparrowAtlas('mario/LuigiBeta/Alone_Fire');
                    betafire2.animation.addByPrefix('fire', 'fire', 24, true);
                    betafire2.animation.play('fire');
                    betafire2.scrollFactor.set(1,1);
                    addBehindGF(betafire2);

					scaryfloor = new FlxSprite(-1200, -850).loadGraphic(Paths.image('mario/LuigiBeta/FrontBG'));
					scaryfloor.antialiasing = ClientPrefs.globalAntialiasing;
					scaryfloor.scale.set(2, 2);
					addBehindGF(scaryfloor);

}
var fartree;
var backtree;
var lashojas;
var ramasnose;
function onCreate()
{
 fartree = new FlxSprite(-1300, -750).loadGraphic(Paths.image('mario/Turmoil/ThirdBGTrees'));
				fartree.scale.set(3.5, 3.5);
				fartree.updateHitbox();
				addBehindGF(fartree);

				backtree = new FlxSprite(-1300, -750).loadGraphic(Paths.image('mario/Turmoil/SecondBGTrees'));
				backtree.scale.set(3.5, 3.5);
				backtree.updateHitbox();
				addBehindGF(backtree);

				floor = new FlxSprite(-1300, -750).loadGraphic(Paths.image('mario/Turmoil/MainFloorAndTrees'));
				floor.scale.set(3.35, 3.35);
				floor.updateHitbox();
				addBehindGF(floor);

				lashojas = new FlxSprite(-1300, -350).loadGraphic(Paths.image('mario/Turmoil/TreeLeaves'));
				lashojas.scale.set(3.5, 3.5);
				lashojas.updateHitbox();
				addBehindGF(lashojas);

				ramasnose = new FlxSprite(-1300, -350).loadGraphic(Paths.image('mario/Turmoil/TreesForeground'));
				ramasnose.scale.set(3.35, 3.35);
				ramasnose.updateHitbox();
				addBehindGF(ramasnose);
}

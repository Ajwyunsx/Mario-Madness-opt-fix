function onCreate()
{
var fartree:FlxSprite = new FlxSprite(-1300, -750).loadGraphic(Paths.image('mario/Turmoil/ThirdBGTrees'));
				fartree.scale.set(3.5, 3.5);
				fartree.updateHitbox();
				add(fartree);

				var backtree:FlxSprite = new FlxSprite(-1300, -750).loadGraphic(Paths.image('mario/Turmoil/SecondBGTrees'));
				backtree.scale.set(3.5, 3.5);
				backtree.updateHitbox();
				add(backtree);

				var floor:FlxSprite = new FlxSprite(-130, -750).loadGraphic(Paths.image('mario/Turmoil/MainFloorAndTrees'));
				floor.scale.set(3.35, 3.35);
				floor.updateHitbox();
				add(floor);

				var lashojas:FlxSprite = new FlxSprite(-1300, -350).loadGraphic(Paths.image('mario/Turmoil/TreeLeaves'));
				lashojas.scale.set(3.5, 3.5);
				lashojas.updateHitbox();
				add(lashojas);

				var ramasnose:FlxSprite = new FlxSprite(-1300, -350).loadGraphic(Paths.image('mario/Turmoil/TreesForeground'));
				ramasnose.scale.set(3.35, 3.35);
				ramasnose.updateHitbox();
				add(ramasnose);
}

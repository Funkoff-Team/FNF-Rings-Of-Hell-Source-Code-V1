package states.stages;

import states.stages.objects.*;
import objects.Character;

class CrystalLake extends BaseStage
{
	override function create()
	{
		var daX:Float = -250;
		var daY:Float = -600;
		var daScale:Float = 1.5;
		var draenogMountains:FlxSprite = new FlxSprite(daX, daY).loadGraphic(Paths.image('stages/act1/mountains'));
		draenogMountains.scale.set(daScale, daScale);
		add(draenogMountains);

		var draenogCliffs:FlxSprite = new FlxSprite(daX, daY).loadGraphic(Paths.image('stages/act1/cliffs'));
		draenogCliffs.scale.set(daScale, daScale);
		add(draenogCliffs);

		var draepostorGrass:FlxSprite = new FlxSprite(daX, daY + 100).loadGraphic(Paths.image('stages/act1/grass'));
		draepostorGrass.scale.set(daScale, daScale);
		add(draepostorGrass);
 	}
}
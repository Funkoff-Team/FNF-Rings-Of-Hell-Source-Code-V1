package states.stages;

import states.stages.objects.*;
import objects.Character;

class TheFungle extends BaseStage
{
	var draepostorMountain:BGSprite;
	var draepostorObjects:BGSprite;
	var draepostorGrass:BGSprite;

	override function create()
	{
		draepostorMountain = new BGSprite('stages/act1-fungle/mountain', -500, -200, 0.5, 0.5);
		add(draepostorMountain);

		draepostorObjects = new BGSprite('stages/act1-fungle/objects', -500, -200, 0.7, 0.7);
		add(draepostorObjects);

		draepostorGrass = new BGSprite('stages/act1-fungle/grass', -500, 0, 1, 1);
		add(draepostorGrass);
	}
}
package states;

import flixel.FlxObject;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import states.editors.MasterEditorMenu;
import options.OptionsState;
import states.credits.CreditsMenuState;
import states.SoundTestMenu;

class MainMenuState extends MusicBeatState
{
	public static var gameVersion:String = '1.0.0';

	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	var xval:Int = 850;
	var optionShit:Array<String> = [
		'sm',
		'fr',
		'cr',
		'st'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	public static var firstStart:Bool = true;

	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		Paths.clearStoredMemory();
    Paths.clearUnusedMemory();

		#if MODS_ALLOWED
		Mods.pushGlobalMods();
		Mods.loadTopMod();
		#end

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		/*transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;*/

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = 0;
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menus/EYX/mainmenu/menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		var logo:FlxSprite = new FlxSprite(10, 0).loadGraphic(Paths.image('menus/EYX/mainmenu/verylogo'));
		logo.scrollFactor.set(0, yScroll);
		logo.scale.set(0.2, 0.2);
		logo.updateHitbox();
		logo.antialiasing = ClientPrefs.data.antialiasing;
		add(logo);

		var bars:FlxSprite = new FlxSprite(1000).loadGraphic(Paths.image('menus/EYX/mainmenu/menuFrames'));
		bars.scrollFactor.set(0, yScroll);
		bars.antialiasing = ClientPrefs.data.antialiasing;
		add(bars);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		FlxTween.tween(bars,{x: 0}, {ease: FlxEase.expoInOut});

		var scale:Float = 0.9;

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 120) + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.antialiasing = ClientPrefs.data.antialiasing;
			menuItem.frames = Paths.getSparrowAtlas('menus/EYX/mainmenu/menu' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', 'menu' + optionShit[i] + " Normal", 24);
			menuItem.animation.addByPrefix('selected', 'menu' + optionShit[i] + " Selected", 24);
			menuItem.animation.play('idle');
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if (optionShit.length < 6)
				scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.updateHitbox();
			if (firstStart)
				FlxTween.tween(menuItem,{x: xval},1 + (i * 0.25) ,{ease: FlxEase.expoInOut, onComplete: function(flxTween:FlxTween)
					{
						if(i == optionShit.length - 1)
						{
							finishedFunnyMove = true;
							changeItem();
						}
					}});
			else{
				menuItem.x = xval;
				finishedFunnyMove = true;
			}
			xval = xval + 0;
		}

		var gameVer:FlxText = new FlxText(12, FlxG.height - 24, 0, "Rings Of Hell v" + gameVersion + " | Funkin' v0.2.8", 12);
		gameVer.scrollFactor.set();
		gameVer.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(gameVer);
		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		// Unlocks "Freaky on a Friday Night" achievement if it's a Friday and between 18:00 PM and 23:59 PM
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18)
			Achievements.unlock('friday_night_play');

		#if MODS_ALLOWED
		Achievements.reloadList();
		#end
		#end

		super.create();

		FlxG.camera.follow(camFollow, null, 0.15);
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * elapsed;
			if (FreeplayState.vocals != null)
				FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
				changeItem(-1);

			if (controls.UI_DOWN_P)
				changeItem(1);

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'));
					selectedSomethin = true;

					FlxFlicker.flicker(menuItems.members[curSelected], 1, 0.06, false, false, function(flick:FlxFlicker)
					{
						switch (optionShit[curSelected])
						{
							case 'sm':
								MusicBeatState.switchState(new StoryMenuState());
							case 'fr':
								MusicBeatState.switchState(new FreeplayState());
							case 'cr':
								MusicBeatState.switchState(new CreditsMenuState());
							case 'st':
								MusicBeatState.switchState(new OptionsState());
								OptionsState.onPlayState = false;
								if (PlayState.SONG != null)
								{
									PlayState.SONG.arrowSkin = null;
									PlayState.SONG.splashSkin = null;
									PlayState.stageUI = 'normal';
								}
						}
					});

					for (i in 0...menuItems.members.length)
					{
						if (i == curSelected)
							continue;
						FlxTween.tween(menuItems.members[i], {x: 3000}, 1, {
							ease: FlxEase.expoInOut, //quadOut
							onComplete: function(twn:FlxTween)
							{
								menuItems.members[i].kill();
							}
						});
					}
				}
			}
			#if desktop
			if (controls.justPressed('debug_1'))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		super.update(elapsed);
	}
	
	function changeItem(huh:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'));
		menuItems.members[curSelected].animation.play('idle');
		menuItems.members[curSelected].updateHitbox();

		menuItems.members[curSelected].x = xval;

		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.members[curSelected].animation.play('selected');
		menuItems.members[curSelected].x = xval - 50;
		menuItems.members[curSelected].centerOffsets();
		//menuItems.members[curSelected].updateHitbox();
		
		camFollow.setPosition(menuItems.members[curSelected].getGraphicMidpoint().x,
			menuItems.members[curSelected].getGraphicMidpoint().y - (menuItems.length > 4 ? menuItems.length * 8 : 0));
	}
}
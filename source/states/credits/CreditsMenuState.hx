package states.credits;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.input.keyboard.FlxKey;
import objects.Alphabet;
import backend.Paths;
import backend.Controls;

import states.credits.ArtistsState;
import states.credits.ComposersState;
import states.credits.ProgrammersState;
import states.credits.ChartersState;
import states.credits.VAState;
import states.credits.ExtraCreditsState;

using StringTools;

class CreditsMenuState extends MusicBeatState
{
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxText>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;

	var xval:Int = 25;
	
	var optionShit:Array<String> = [
		'artists',
		'programmers',
		'composers',
		'charters',
		'voice actors',
		'extra'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	public static var firstStart:Bool = true;

	public static var finishedFunnyMove:Bool = false;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Credits Menu", null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		/*transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;*/ //P.S.: Idk why it's dying probably smth broken

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = 0;//Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('menus/EYX/mainmenu/menuBG'));
		bg.scrollFactor.set(0, yScroll);
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		var bars:FlxSprite = new FlxSprite(-1000).loadGraphic(Paths.image('menus/EYX/credits/bar'));
		bars.scrollFactor.set(0, yScroll);
		bars.antialiasing = ClientPrefs.data.antialiasing;
		add(bars);

		var bars2:FlxSprite = new FlxSprite(-1000, -100).loadGraphic(Paths.image('menus/EYX/credits/menus'));
		bars2.scrollFactor.set(0, yScroll);
		bars2.antialiasing = ClientPrefs.data.antialiasing;
		bars2.scale.set(1, 1.5);
		add(bars2);

		var logo:FlxSprite = new FlxSprite(-1000, -100).loadGraphic(Paths.image('menus/EYX/credits/title'));
		logo.scrollFactor.set(0, yScroll);
		logo.antialiasing = ClientPrefs.data.antialiasing;
		add(logo);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);
		
		// magenta.scrollFactor.set();

		menuItems = new FlxTypedGroup<FlxText>();
		add(menuItems);

		FlxTween.tween(bars,{x: 0}, {ease: FlxEase.expoInOut});
		FlxTween.tween(bars2,{x: 0}, {ease: FlxEase.expoInOut});
		FlxTween.tween(logo,{x: 0}, {ease: FlxEase.expoInOut});

		var scale:Float = 0.9;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 258 - (Math.max(optionShit.length, 4) - 4) * 20; //140
			var menuItem:FlxText = new FlxText(-3000, (i * 80)  + offset, 0, optionShit[i], 32);
			menuItem.setFormat('NiseSegaSonic.ttf', 32, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.ID = i;
			//menuItem.screenCenter(X);
			menuItems.add(menuItem);
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
			menuItem.scrollFactor.set(0, scr);
			menuItem.antialiasing = ClientPrefs.data.antialiasing;

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
				finishedFunnyMove=true;
			}

			xval = xval + 0;
		}

		firstStart = false;

		FlxG.camera.follow(camFollowPos, null, 1);

		changeItem();

    #if mobile
    addVirtualPad(UP_DOWN, A_B);
    #end

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = FlxMath.bound(elapsed * 7.5, 0, 1);	
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

				//if(ClientPrefs.flashing) FlxFlicker.flicker(magenta, 1.1, 0.15, false);

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {x: 3000}, 1, {
							ease: FlxEase.expoInOut, //quadOut
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
						{
							var daChoice:String = optionShit[curSelected];

							switch (daChoice)
							{
								case 'artists':
									MusicBeatState.switchState(new ArtistsState());
								case 'programmers':
									MusicBeatState.switchState(new ProgrammersState());
								case 'composers':
									MusicBeatState.switchState(new ComposersState());
								case 'charters':
									MusicBeatState.switchState(new ChartersState());
								case 'voice actors':
									MusicBeatState.switchState(new VAState());
								case 'extra':
									MusicBeatState.switchState(new ExtraCreditsState());
							}
						});
					}
				});
			}
		}
		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxText)
		{
			spr.color = FlxColor.GRAY;

			if (spr.ID == curSelected)
			{
				spr.color = FlxColor.WHITE;
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
			}
		});
	}
}

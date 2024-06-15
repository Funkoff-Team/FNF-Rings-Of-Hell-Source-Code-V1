package states;

import objects.AttachedText;
import options.Option;
import objects.CheckboxThingie;
import backend.ClientPrefs;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.effects.FlxFlicker;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Lib;
import flixel.addons.display.FlxBackdrop;
import flixel.addons.display.FlxGridOverlay;


class LanguageState extends MusicBeatState
{
	public static var leftState:Bool = false;

	private var canMove:Bool = false;

	private var canPressSpace:Bool = false;

	private var warnText:FlxText;
	private var curOption:Option = null;
	private var curSelected:Int = 0;
	private var optionsArray:Array<Option>;

	private var grpOptions:FlxTypedGroup<Alphabet>;
	private var checkboxGroup:FlxTypedGroup<CheckboxThingie>;
	private var grpTexts:FlxTypedGroup<AttachedText>;

	private var camFollow:FlxPoint;
	private var camFollowPos:FlxObject;

	private var camGame:FlxCamera;
	private var camHUD:FlxCamera;

	private var optionTitle:Alphabet;
	private var warnTitle:FlxText;
	private var infoTexts:Array<FlxText> = [];

	override function create()
	{
		super.create();

		camGame = new FlxCamera();

		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		camFollow = new FlxPoint((FlxG.width / 2), (FlxG.height / 2));
		camFollowPos = new FlxObject((FlxG.width / 2), (FlxG.height / 2), 1, 1);

		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		FlxG.camera.focusOn(camFollow);

		var bg:FlxSprite = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xff2d003f);
		bg.antialiasing = ClientPrefs.data.antialiasing;
		add(bg);

		var grid:FlxBackdrop = new FlxBackdrop(FlxGridOverlay.createGrid(80, 80, 160, 160, true, 0x33FFFFFF, 0x0));
		grid.velocity.set(40, 40);
		grid.alpha = 0;
		FlxTween.tween(grid, {alpha: 0.5}, 0.5, {ease: FlxEase.quadOut});
		add(grid);

		addInfoTexts();

		FlxTween.tween(warnTitle, {y: 140}, 1, {
			ease: FlxEase.backOut,
			startDelay: 0,
			onComplete: function(twn:FlxTween)
			{
				FlxTween.color(warnTitle, 1, FlxColor.WHITE, FlxColor.YELLOW, {type: PINGPONG});
				FlxTween.tween(warnText, {y: 460}, 1, {
					startDelay: 0.5,
					ease: FlxEase.backOut,
					onComplete: function(twn:FlxTween)
					{
						FlxTween.tween(warnTitle, {x: (FlxG.width / 3) - 160, y: 100 - 55, size: 120}, 1.5, {startDelay: 0.1, ease: FlxEase.circInOut});

						FlxTween.tween(warnText, {
							x: 560,
							y: 230 - 55,
							size: 30,
							height: 57,
							fieldWidth: 700
						}, 1.5, {
							startDelay: 0.1,
							ease: FlxEase.circInOut
						});

						new FlxTimer().start(0.7, function(tmr:FlxTimer)
						{
							tweenOptions();
						});
					}
				});
			}
		});

		grpOptions = new FlxTypedGroup<Alphabet>();
		add(grpOptions);

		grpTexts = new FlxTypedGroup<AttachedText>();
		add(grpTexts);

		checkboxGroup = new FlxTypedGroup<CheckboxThingie>();
		add(checkboxGroup);

		var option:Option = new Option('Language',
			"Set language what you want to use.",
			'language',
			'string',
			['en-us', 'ko-kr']);
		addOption(option);

		genOptions();
	}

	function addOption(option:Option)
	{
		if (optionsArray == null || optionsArray.length < 1)
			optionsArray = [];
		optionsArray.push(option);
	}

	function addInfoTexts()
	{
		warnTitle = new FlxText(0, -340, FlxG.width, "Notice - 알림", 21);
		warnTitle.setFormat(Paths.font('DungGeunMo.ttf'), 200, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		warnTitle.cameras = [camHUD];
		add(warnTitle);

		warnText = new FlxText(0, 850, FlxG.width, "This mod contains Language Option.", 21);
		warnText.setFormat(Paths.font('DungGeunMo.ttf'), 50, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		warnText.applyMarkup("This mod contains $Language Option$.\n이 모드에는 $언어 설정$이 포함되어 있습니다.",
			[new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.YELLOW), "$")]);
		warnText.cameras = [camHUD];
		add(warnText);

		var text:FlxText = new FlxText(560 + 700, 400, 700, "", 21);
		text.setFormat(Paths.font('DungGeunMo.ttf'), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.applyMarkup("It is recomended to check the full $options$ menu.\n전체 $설정$ 메뉴를 확인하는 것을 권장합니다.", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.YELLOW), "$")]);
		text.cameras = [camHUD];
		add(text);

		infoTexts.push(text);

		var text:FlxText = new FlxText(560 + 700, 650, 700, "", 21);
		text.setFormat(Paths.font('DungGeunMo.ttf'), 30, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		text.applyMarkup("$Tap$ to continue.\n$Tap$를 눌러 계속하기.", [new FlxTextFormatMarkerPair(new FlxTextFormat(FlxColor.YELLOW), "$")]);
		text.cameras = [camHUD];
		add(text);

		infoTexts.push(text);
	}

	function tweenInfoTexts()
	{
		for (text in infoTexts)
		{
			FlxTween.tween(text, {x: text.x - 700}, 1, {startDelay: 0.5 + (0.3 * infoTexts.indexOf(text)), ease: FlxEase.backOut});
		}

		new FlxTimer().start(1 + (0.5 + (0.3 * (infoTexts.length - 1))), function(tmr:FlxTimer)
		{
			canPressSpace = true;
		});
	}

	function genOptions()
	{
		optionTitle = new Alphabet(0, 0, "accessibility", true);
		optionTitle.setScale(0.9, 0.9);
		optionTitle.isMenuItem = false;
		optionTitle.alpha = 0.5;
		optionTitle.x = 50;
		optionTitle.y = -100;
		optionTitle.cameras = [camGame];
		add(optionTitle);

		for (i in 0...optionsArray.length)
		{
			var optionText:Alphabet = new Alphabet(0, 0, optionsArray[i].name, true);
			optionText.isMenuItem = false;
			optionText.cameras = [camGame];

			optionText.y = 250 + (150 * i);
			optionText.x = 215 + (30 * i);

			optionText.x -= 700;

			grpOptions.add(optionText);

			var checkbox:CheckboxThingie = new CheckboxThingie(optionText.x - 105, optionText.y, optionsArray[i].getValue());
			checkbox.sprTracker = optionText;
			checkbox.scale.set(0.8, 0.8);
			checkbox.updateHitbox();
			checkbox.ID = i;
			checkbox.cameras = [camGame];

			@:privateAccess
			checkbox.animationFinished(checkbox.daValue ? 'checking' : 'unchecking');

			checkbox.offsetY = -65;
			checkbox.offsetX = -5;

			switch (i)
			{
				case 0:
					checkbox.offsetX += 1;
				case 1:
					checkbox.offsetX -= 3;
				case 2 | 3:
					checkbox.offsetX -= 1;
			}

			checkboxGroup.add(checkbox);
		}

		changeSelection();
		reloadCheckboxes();
	}

	function tweenOptions()
	{
		FlxTween.tween(optionTitle, {y: 90}, 0.9, {
			ease: FlxEase.circInOut,
			onComplete: function(twn:FlxTween)
			{
				tweenInfoTexts();
			}
		});

		for (option in grpOptions)
		{
			FlxTween.tween(option, {x: option.x + 700}, 0.7, {
				ease: FlxEase.backOut,
				onComplete: function(twn:FlxTween)
				{
					canMove = true;
				},
				startDelay: 0.35 * grpOptions.members.indexOf(option)
			});
		}
	}

	function changeSelection(change:Int = 0)
	{
		curSelected += change;
		if (curSelected < 0)
			curSelected = optionsArray.length - 1;
		if (curSelected >= optionsArray.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpOptions.members) {
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			if (item.targetY == 0) {
				item.alpha = 1;
			}
		}
		for (text in grpTexts) {
			text.alpha = 0.6;
			if(text.ID == curSelected) {
				text.alpha = 1;
			}
		}

		curOption = optionsArray[curSelected];

		camFollow.set((FlxG.width / 2) + (2 * curSelected), (FlxG.height / 2) + (100 * curSelected));

		FlxG.sound.play(Paths.sound('scrollMenu'));
	}

	function reloadCheckboxes()
	{
		for (checkbox in checkboxGroup)
		{
			checkbox.daValue = (optionsArray[checkbox.ID].getValue() == true);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (camFollow != null && camFollowPos != null)
		{
			var lerpVal:Float = FlxMath.bound(elapsed * 10, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
		}

		if (canMove)
		{
			if (controls.UI_UP_P)
				changeSelection(-1);

			if (controls.UI_DOWN_P)
				changeSelection(1);

			if (FlxG.keys.justPressed.ENTER)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				curOption.setValue((curOption.getValue() == true) ? false : true);
				curOption.change();
				reloadCheckboxes();
			}

		var pressedEnter:Bool = FlxG.keys.justPressed.ENTER || controls.ACCEPT;

		#if mobile
		for (touch in FlxG.touches.list)
		{
			if (touch.justPressed)
			{
				pressedEnter = true;
			}
		}
		#end

			if (#if desktop FlxG.keys.justPressed.SPACE #else pressedEnter #end && canPressSpace)
			{
				leftState = true;
				canMove = false;

				FlxTween.tween(camGame, {alpha: 0}, 1);
				FlxTween.tween(camHUD, {alpha: 0}, 1);

				FlxG.sound.play(Paths.sound('confirmMenu'));

				FlxFlicker.flicker(infoTexts[1]);

				new FlxTimer().start(1.2, function(tmr:FlxTimer)
				{
					ClientPrefs.saveSettings();

					MusicBeatState.switchState(new TitleState());
				});
			}
		}
	}
}
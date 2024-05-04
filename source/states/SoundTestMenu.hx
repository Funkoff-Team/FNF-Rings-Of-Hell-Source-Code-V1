package states;

import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;
import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.FlxCamera;
import openfl.filters.ShaderFilter;
import backend.Song;
import states.MainMenuState;

class SoundTestMenu extends MusicBeatState
{
	var woahmanstopspammin:Bool = true;
	var whiteshit:FlxSprite;

	var daValue:Int = 0;
	var pcmValue:Int = 0;
	var amogusCode:Int = 0;
	var soundCooldown:Bool = true;
	var funnymonke:Bool = true;
	var incameo:Bool = false;

	var cameoBg:FlxSprite;
	var cameoImg:FlxSprite;
	var cameoThanks:FlxSprite;

	var pcmNO = new FlxText(FlxG.width / 6, FlxG.height / 2, 0, 'PCM  NO .', 23);
	var daNO = new FlxText(FlxG.width * .6, FlxG.height / 2, 0, 'DA  NO .', 23);
	var pcmNO_NUMBER = new FlxText(FlxG.width / 6, FlxG.height / 2, 0, '0', 23);
	var daNO_NUMBER = new FlxText(FlxG.width / 6, FlxG.height / 2, 0, '0', 23);

	var cam:FlxCamera;

    override function create()
    {

			cam = new FlxCamera();
			FlxG.cameras.reset(cam);
			cam.bgColor.alpha = 0;
			FlxG.cameras.setDefaultDrawTarget(cam, true);

			DiscordClient.changePresence('In the Sound Test Menu', null);

			whiteshit = new FlxSprite().makeGraphic(1280, 720, FlxColor.WHITE);
			whiteshit.alpha = 0;

			cameoBg = new FlxSprite();
			cameoImg = new FlxSprite();
			cameoThanks = new FlxSprite();

			FlxG.sound.music.stop();

			var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('menus/EYX/backgroundST'));
			bg.scrollFactor.x = 0;
			bg.scrollFactor.y = 0;
			bg.setGraphicSize(Std.int(bg.width * 1));
			bg.updateHitbox();
			bg.screenCenter();
			bg.antialiasing = true;
			add(bg);

			var soundtesttext;
			switch(ClientPrefs.data.language.toLowerCase()){
				case 'ko-kr':
					soundtesttext = new FlxText(0, 0, 0, '사운드 테스트', 25);
					soundtesttext.screenCenter();
					soundtesttext.y -= 180;
					soundtesttext.x -= 33;
					soundtesttext.setFormat("DungGeunMo", 25, FlxColor.fromRGB(0, 163, 255));
					soundtesttext.setBorderStyle(SHADOW, FlxColor.BLACK, 4, 1);
				default:
					soundtesttext = new FlxText(0, 0, 0, 'SOUND TEST', 25);
					soundtesttext.screenCenter();
					soundtesttext.y -= 180;
					soundtesttext.x -= 33;
					soundtesttext.setFormat("Sonic CD Menu Font Regular", 25, FlxColor.fromRGB(0, 163, 255));
					soundtesttext.setBorderStyle(SHADOW, FlxColor.BLACK, 4, 1);
			}
			add(soundtesttext);

			pcmNO.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromRGB(174, 179, 251));
			pcmNO.setBorderStyle(SHADOW, FlxColor.fromRGB(106, 110, 159), 4, 1);

			daNO.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromRGB(174, 179, 251));
			daNO.setBorderStyle(SHADOW, FlxColor.fromRGB(106, 110, 159), 4, 1);

			pcmNO.y -= 70;
			pcmNO.x += 100;
			daNO.y -= 70;

			add(pcmNO);
			add(daNO);

			pcmNO_NUMBER.y -= 70;
			pcmNO_NUMBER.x += 270;
			pcmNO_NUMBER.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromRGB(174, 179, 251));
			pcmNO_NUMBER.setBorderStyle(SHADOW, FlxColor.fromRGB(106, 110, 159), 4, 1);
			add(pcmNO_NUMBER);

			daNO_NUMBER.y -= 70;
			daNO_NUMBER.x += daNO.x - 70;
			daNO_NUMBER.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromRGB(174, 179, 251));
			daNO_NUMBER.setBorderStyle(SHADOW, FlxColor.fromRGB(106, 110, 159), 4, 1);
			add(daNO_NUMBER);

			cameoBg.visible = false;
			add(cameoBg);

			cameoThanks.visible = false;
			add(cameoThanks);

			cameoImg.visible = false;
			add(cameoImg);
			add(whiteshit);
   }

	function changeNumber(selection:Int) 
	{
		if (funnymonke)
		{
			pcmValue += selection;
			if (pcmValue < 0) pcmValue = 69;
			if (pcmValue > 69) pcmValue = 0;
		}
		else
		{
			daValue += selection;
			if (daValue < 0) daValue = 37;
			if (daValue > 37) daValue = 0;
		}
	}

	function flashyWashy(a:Bool)
	{
		if (a == true)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'));
			FlxTween.tween(whiteshit, {alpha: 1}, 0.4);
		}
		else
			FlxTween.color(whiteshit, 0.1, FlxColor.WHITE, FlxColor.BLUE);
			FlxTween.tween(whiteshit, {alpha: 0}, 0.2);

	}

	function doTheThing(first:Int, second:Int) 
	{
		if (first == 12 && second == 25)
		{
			woahmanstopspammin = false;
			PlayState.SONG = Song.loadFromJson('endless-hard', 'endless');
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = 2;
			PlayState.storyWeek = 1;

			flashyWashy(true);
			new FlxTimer().start(2, function(tmr:FlxTimer)
			{
				LoadingState.loadAndSwitchState(new PlayState());
			});
		}
		else
		{
			if (soundCooldown)
			{
				soundCooldown = false;
				FlxG.sound.play(Paths.sound('deniedMOMENT'));
				new FlxTimer().start(0.8, function(tmr:FlxTimer)
				{
					soundCooldown = true;
				});
			}
    }
	}

	override public function update(elapsed:Float)
		{
			if (FlxG.keys.justPressed.RIGHT || FlxG.keys.justPressed.LEFT || FlxG.keys.justPressed.A || FlxG.keys.justPressed.D) if (woahmanstopspammin) funnymonke = !funnymonke;

			if (FlxG.keys.justPressed.DOWN || FlxG.keys.justPressed.S)  changeNumber(1);

			if (FlxG.keys.justPressed.UP || FlxG.keys.justPressed.W) changeNumber(-1);

			if (FlxG.keys.justPressed.ENTER && woahmanstopspammin) doTheThing(pcmValue, daValue);

			if (amogusCode == 6)
				{
				//	PlayStateChangeables.nocheese = false;
					PlayState.SONG = Song.loadFromJson('sussus-hillus-hard', 'sussus-hillus');
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = 2;
					PlayState.storyWeek = 1;

					flashyWashy(true);
					new FlxTimer().start(2, function(tmr:FlxTimer)
					{
						LoadingState.loadAndSwitchState(new PlayState());
					});
				}

			if (FlxG.keys.justPressed.ENTER && !woahmanstopspammin && incameo) LoadingState.loadAndSwitchState(new SoundTestMenu());

			if (FlxG.keys.justPressed.ESCAPE && woahmanstopspammin && !incameo) LoadingState.loadAndSwitchState(new MainMenuState());

			if (funnymonke)
			{
				pcmNO.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromRGB(254, 174, 0));
				pcmNO.setBorderStyle(SHADOW, FlxColor.fromRGB(253, 36, 3), 4, 1);
		
				daNO.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromRGB(174, 179, 251));
				daNO.setBorderStyle(SHADOW, FlxColor.fromRGB(106, 110, 159), 4, 1);
			}
			else
			{
				pcmNO.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromRGB(174, 179, 251));
				pcmNO.setBorderStyle(SHADOW, FlxColor.fromRGB(106, 110, 159), 4, 1);
	
				daNO.setFormat("Sonic CD Menu Font Regular", 23, FlxColor.fromRGB(254, 174, 0));
				daNO.setBorderStyle(SHADOW, FlxColor.fromRGB(253, 36, 3), 4, 1);
			}

			if (pcmValue < 10)	pcmNO_NUMBER.text = '0' + Std.string(pcmValue);
			else pcmNO_NUMBER.text = Std.string(pcmValue);

			if (daValue < 10)	daNO_NUMBER.text = '0' + Std.string(daValue);
			else daNO_NUMBER.text = Std.string(daValue);

			if (FlxG.keys.justPressed.A)
				if (amogusCode == 0)
					amogusCode = 1;
				else
					amogusCode == 0;
			if (FlxG.keys.justPressed.M)
				if (amogusCode == 1)
					amogusCode = 2;
				else
					amogusCode == 0;
			if (FlxG.keys.justPressed.O)
				if (amogusCode == 2)
					amogusCode = 3;
				else
					amogusCode == 0;
			if (FlxG.keys.justPressed.G)
				if (amogusCode == 3)
					amogusCode = 4;
				else
					amogusCode == 0;
			if (FlxG.keys.justPressed.U)
				if (amogusCode == 4)
					amogusCode = 5;
				else
					amogusCode == 0;
			if (FlxG.keys.justPressed.S)
				if (amogusCode == 5)
					amogusCode = 6;
				else
					amogusCode == 0;
				//lol i copied this from titlestate lmfao
	
			super.update(elapsed);
		}

	override function destroy(){
		FlxG.sound.playMusic(Paths.music('freakyMenu'));
	}
}

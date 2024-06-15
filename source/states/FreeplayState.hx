package states;

import backend.WeekData;
import backend.Highscore;
import backend.Song;
import backend.SkewSpriteGroup;
import objects.HealthIcon;
import flixel.group.FlxGroup.FlxTypedGroup;
import substates.GameplayChangersSubstate;
import substates.ResetScoreSubState;
import flixel.addons.effects.FlxSkewedSprite;
import flixel.math.FlxMath;
import openfl.utils.Assets;

class FreeplayState extends MusicBeatState
{
	var folderList:Array<String> = returnAssetsLibrary('data', 'assets/shared');

	var maxSelect:Int = 0;
	public static var curSelected:Int = 0;
	var curDifficulty:Int = 1;
	private static var lastDifficultyName:String = '';

	var boxedShit:SkewSpriteGroup;

	var songArray:Array<String> = ['1'];

    var boxSprite:FlxSprite;
    var boxArt:FlxSprite;

	var whiteshit:FlxSprite;

	var songText:FlxText;

	var scoreText:FlxText;
    var scoreBG:FlxSprite;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	public static var vocals:FlxSound = null;
	var missingText:FlxText;
	var missingTextTimer:FlxTimer;

	override function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("Freeplay Menu", null);
		#end

		var background:FlxSprite = new FlxSprite().loadGraphic(Paths.image('menus/EYX/backgroundlool'));
		background.antialiasing = false;
		background.setGraphicSize(1280, 720);
		background.scrollFactor.set(0.43, 0.43);
		background.screenCenter();
		add(background);

		var songSlider:FlxSprite = new FlxSprite(0, 0).makeGraphic(15, 1280, 0xFF000000);
		songSlider.angle = 90;
		songSlider.screenCenter();
		add(songSlider);

		var spikyBarTopLeft:FlxSprite = new FlxSprite(-355, -245);
		spikyBarTopLeft.loadGraphic(Paths.image('menus/EYX/freeplay/sidebar'));
		spikyBarTopLeft.scale.set(1, 1);
		spikyBarTopLeft.angle = -90;
		spikyBarTopLeft.flipY = true;
		add(spikyBarTopLeft);

		var spikyBarTopRight:FlxSprite = new FlxSprite(355, -245);
		spikyBarTopRight.loadGraphic(Paths.image('menus/EYX/freeplay/sidebar'));
		spikyBarTopRight.scale.set(1, 1);
		spikyBarTopRight.angle = -90;
		add(spikyBarTopRight);

		var spikyBarBottomLeft:FlxSprite = new FlxSprite(-355, 245);
		spikyBarBottomLeft.loadGraphic(Paths.image('menus/EYX/freeplay/sidebar'));
		spikyBarBottomLeft.scale.set(1, 1);
		spikyBarBottomLeft.angle = 90;
		add(spikyBarBottomLeft);

		var spikyBarBottomRight:FlxSprite = new FlxSprite(355, 245);
		spikyBarBottomRight.loadGraphic(Paths.image('menus/EYX/freeplay/sidebar'));
		spikyBarBottomRight.scale.set(1, 1);
		spikyBarBottomRight.flipY = true;
		spikyBarBottomRight.angle = 90;
		add(spikyBarBottomRight);

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 32, FlxColor.WHITE, CENTER);

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		add(scoreText);

		boxedShit = new SkewSpriteGroup();
		add(boxedShit);

		var folderNum:Int = 0;
		for (i in folderList)
		{
			if (Assets.exists(Paths.getPath('data/${i}/${i}.json', TEXT)) || Assets.exists(Paths.getPath('data/${i}/${i}-hard.json', TEXT)))
			{
				var boxLol:FlxSkewedSprite = new FlxSkewedSprite((folderNum * 420), 0);
				boxLol.loadGraphic(Paths.image('menus/EYX/freeplay/FreeBox'));
				boxLol.antialiasing = true;
				boxLol.ID = folderNum;
				boxLol.setGraphicSize(Std.int(boxLol.width / 1.7));
				boxedShit.add(boxLol);

				var artShit:FlxSkewedSprite = new FlxSkewedSprite((folderNum * 420), 0);
				if (Assets.exists(Paths.getPath('images/menus/EYX/freeplay/portraits/${i}.png', TEXT)))
					artShit.loadGraphic(Paths.image('menus/EYX/freeplay/portraits/${i}'));
				else
					artShit.loadGraphic(Paths.image('menus/EYX/freeplay/portraits/error'));

				artShit.setGraphicSize(Std.int(boxLol.width / 1.7));

				artShit.ID = folderNum;
				boxedShit.add(artShit);

				songArray.push(i);

        		//curDifficulty = 1;

				folderNum += 1;

				trace('found song ${i}');
			}
/*			else if (FileSystem.exists(Paths.getPath('data/${i}/${i}.json', TEXT)))
			{
				var boxLol:FlxSkewedSprite = new FlxSkewedSprite((folderNum * 420), 0);
				boxLol.loadGraphic(Paths.image('menus/EYX/freeplay/FreeBox'));
				boxLol.antialiasing = true;
				boxLol.ID = folderNum;
				boxLol.setGraphicSize(Std.int(boxLol.width / 1.7));
				boxedShit.add(boxLol);

				var artShit:FlxSkewedSprite = new FlxSkewedSprite((folderNum * 420), 0);
					
				if (FileSystem.exists('assets/images/menus/EYX/freeplay/portraits/${i}.png'))
					artShit.loadGraphic(Paths.image('menus/EYX/freeplay/portraits/${i}'));
				else
					artShit.loadGraphic(Paths.image('menus/EYX/freeplay/portraits/error'));

				artShit.setGraphicSize(Std.int(boxLol.width / 1.7));

				artShit.ID = folderNum;
				boxedShit.add(artShit);

				songArray.push(i);

				folderNum += 1;

				curDifficulty = 1;

				trace('found song ${i}');
			}*/
			else
			{
				trace('didnt find song ${i}');
			}
		}

		songArray.remove('1');

		songText = new FlxText(805, 635, FlxG.width, '', 30);
		songText.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 30, FlxColor.WHITE, CENTER);
		songText.screenCenter(X);
		add(songText);

		if(lastDifficultyName == '')
		{
			lastDifficultyName = Difficulty.getDefault();
		}

		curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));

		boxedShit.forEach(function(sprite:FlxSkewedSprite)
		{
			if (sprite.ID == curSelected - 1 || sprite.ID == curSelected + 1)
			{
				var diff = curSelected - sprite.ID;
				trace(diff, sprite.ID, curSelected);
				FlxTween.tween(sprite, {alpha: 0.5}, 0.2);
				FlxTween.tween(sprite.scale, {x: 0.465, y: 0.465}, 0.2, {ease: FlxEase.expoOut});
				FlxTween.tween(sprite.skew, {x: 0, y: 0}, 0.2, {ease: FlxEase.expoOut});
			}
			else
			{
				FlxTween.tween(sprite, {alpha: 1}, 0.2);
				FlxTween.tween(sprite.scale, {x: 0.58, y: 0.58}, 0.2, {ease: FlxEase.expoOut});
				FlxTween.tween(sprite.skew, {x: 0, y: 0}, 0.2, {ease: FlxEase.expoOut});
			}
		});

		boxedShit.forEach(function(sprite:FlxSkewedSprite)
		{
			FlxTween.tween(sprite, {x: sprite.x - (curSelected * 420)}, 0.2, {ease: FlxEase.expoOut});
		});

		whiteshit = new FlxSprite().makeGraphic(1280, 720, FlxColor.WHITE);
		whiteshit.alpha = 0;
		add(whiteshit);

		songText.text = songArray[curSelected];
	
	#if mobile
	addVirtualPad(LEFT_RIGHT, A_B);
	addVirtualPadCamera(false);
	#end
	}

	var selectin:Bool = false;

	var cdman:Bool = true;

	override function closeSubState() {
		changeSelection(0);
		persistentUpdate = true;
		super.closeSubState();
	}

	override function update(elapsed:Float)
	{

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (cdman)
		{
			if (controls.UI_RIGHT_P)
			{
				changeSelection(1);
			}

			if (controls.UI_LEFT_P)
			{
				changeSelection(-1);
			}

			if (controls.BACK)
			{
				selectin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}

			if (controls.ACCEPT && cdman)
			{
				cdman = false;
				var songLowercase:String = Paths.formatToSongPath(songArray[curSelected].toLowerCase());
				try {
					if (Difficulty.getString() != Difficulty.getDefault()) {
						if(Difficulty.getString() == null){
							PlayState.SONG = Song.loadFromJson(songLowercase, songArray[curSelected].toLowerCase());
							PlayState.isStoryMode = false;
							curDifficulty = 1;
							PlayState.storyDifficulty = curDifficulty;
								if (FlxG.keys.pressed.SHIFT){
								LoadingState.loadAndSwitchState(new states.editors.ChartingState());
							FlxG.sound.music.volume = 0;
							destroyFreeplayVocals();
							}else{
								LoadingState.loadAndSwitchState(new states.PlayState());
							FlxG.sound.music.volume = 0;
							destroyFreeplayVocals();
							}
						}else{
							PlayState.SONG = Song.loadFromJson(songLowercase, songArray[curSelected].toLowerCase() + "-" + Difficulty.getString());
							PlayState.isStoryMode = false;
							curDifficulty = 1;
							PlayState.storyDifficulty = curDifficulty;
							if (FlxG.keys.pressed.SHIFT){
								LoadingState.loadAndSwitchState(new states.editors.ChartingState());
								FlxG.sound.music.volume = 0;
								destroyFreeplayVocals();
							}else{
								LoadingState.loadAndSwitchState(new states.PlayState());
								FlxG.sound.music.volume = 0;
								destroyFreeplayVocals();
							}
						}
					}
					else 
					{
						PlayState.SONG = Song.loadFromJson(songArray[curSelected].toLowerCase(), songArray[curSelected].toLowerCase());
						PlayState.isStoryMode = false;
						curDifficulty = 1;
						PlayState.storyDifficulty = curDifficulty;
						if (FlxG.keys.pressed.SHIFT){
							LoadingState.loadAndSwitchState(new states.editors.ChartingState());
							FlxG.sound.music.volume = 0;
							destroyFreeplayVocals();
						}else{
							LoadingState.loadAndSwitchState(new PlayState());
							FlxG.sound.music.volume = 0;
							destroyFreeplayVocals();
						}
					}
				}
				catch(e)
				{
					trace('ERROR! $e');

					var errorStr:String = e.toString();
					if(errorStr.startsWith('[file_contents,assets/data/')) errorStr = 'Missing file: ' + errorStr.substring(27, errorStr.length-1); //Missing chart
					
					if(missingText == null)
					{
						missingText = new FlxText(50, 0, FlxG.width - 100, '', 24);
						missingText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
						missingText.scrollFactor.set();
						add(missingText);
					}
					else missingTextTimer.cancel();
					missingText.text = 'ERROR WHILE LOADING CHART:\n$errorStr';
					missingText.screenCenter(Y);

					missingTextTimer = new FlxTimer().start(5, function(tmr:FlxTimer) {
						remove(missingText);
						missingText.destroy();
					});
					FlxG.sound.play(Paths.sound('cancelMenu'));
				}
			}
		}
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeSelection(change:Int)
	{
		var posChange:Int = 0;
		var negChange:Int = 0;

		if (!selectin) 
		{
			if (change == 1 && curSelected != songArray.length - 1)
			{
				cdman = false;
				posChange = 1;
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				FlxTween.tween(boxedShit, {x: boxedShit.x - 420}, 0.2, {ease: FlxEase.expoOut, onComplete: function(sus:FlxTween)
					{
						cdman = true;
					}
				});
				curSelected += posChange;
			}
			else if (change == -1 && curSelected != 0)
			{
				cdman = false;
				negChange = -1;
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
				FlxTween.tween(boxedShit, {x: boxedShit.x + 420}, 0.2, {ease: FlxEase.expoOut, onComplete: function(sus:FlxTween)
					{
						cdman = true;
					}
				});
				curSelected += negChange;
			}
			
			boxedShit.forEach(function(sprite:FlxSkewedSprite)
			{
				if (sprite.ID == curSelected)
				{
					FlxTween.tween(sprite, {alpha: 1}, 0.2);
					FlxTween.tween(sprite.scale, {x: 0.58, y: 0.58}, 0.2, {ease: FlxEase.expoOut});
				}
				else
				{
					FlxTween.tween(sprite, {alpha: 0.5}, 0.2);
					FlxTween.tween(sprite.scale, {x: 0.465, y: 0.465}, 0.2, {ease: FlxEase.expoOut});
				}
			});
			songText.text = songArray[curSelected];
		}
	}

	public static function returnAssetsLibrary(library:String, ?subDir:String = 'assets/shared/images'):Array<String>
	{
		var libraryArray:Array<String> = [];

		#if sys
		var unfilteredLibrary = Assets.list().filter(text -> text.contains('$subDir/$library'));

		for (folder in unfilteredLibrary)
		{
			if (!folder.contains('.'))
				libraryArray.push(folder);
		}
		trace(libraryArray);
		#end

		return libraryArray;
	}

	override function destroy():Void
	{
		super.destroy();

		FlxG.autoPause = ClientPrefs.data.autoPause;
		if (!FlxG.sound.music.playing)
			FlxG.sound.playMusic(Paths.music('freakyMenu'));
	}	
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Int = -7179779;
	public var folder:String = "";
	public var lastDifficulty:String = null;

	public function new(song:String, week:Int, songCharacter:String, color:Int)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = color;
		this.folder = Mods.currentModDirectory;
		if(this.folder == null) this.folder = '';
	}
}
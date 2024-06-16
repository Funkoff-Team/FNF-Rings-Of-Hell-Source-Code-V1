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
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxText;
import flixel.FlxSound;
import flixel.FlxTimer;
import flixel.FlxTween;
import flixel.util.FlxColor;
import flixel.text.FlxTextBorderStyle;
import flixel.tweens.FlxEase;

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
    var selectin:Bool = false;
    var cdman:Bool = true;

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

        createSpikyBars();

        scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
        scoreText.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 32, FlxColor.WHITE, CENTER);

        scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
        scoreBG.alpha = 0.6;
        add(scoreBG);

        add(scoreText);

        boxedShit = new SkewSpriteGroup();
        add(boxedShit);

        populateSongList();

        songText = new FlxText(805, 635, FlxG.width, '', 30);
        songText.setFormat(Paths.font("sonic-cd-menu-font.ttf"), 30, FlxColor.WHITE, CENTER);
        songText.screenCenter(X);
        add(songText);

        if (lastDifficultyName == '')
        {
            lastDifficultyName = Difficulty.getDefault();
        }

        curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));

        updateSongSelection();

        whiteshit = new FlxSprite().makeGraphic(1280, 720, FlxColor.WHITE);
        whiteshit.alpha = 0;
        add(whiteshit);

        songText.text = songArray[curSelected];

        #if mobile
        addVirtualPad(LEFT_RIGHT, A_B);
        addVirtualPadCamera(false);
        #end
    }

    function createSpikyBars():Void
    {
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
    }

    function populateSongList():Void
    {
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
                folderNum += 1;

                trace('found song ${i}');
            }
            else
            {
                trace('didnt find song ${i}');
            }
        }

        songArray.remove('1');
    }

    override function update(elapsed:Float)
    {
        super.update(elapsed);

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
                try
                {
                    loadSong(songLowercase);
                }
                catch (e:Dynamic)
                {
                    handleLoadingError(e);
                }
            }
        }
    }

    function loadSong(songLowercase:String):Void
    {
        if (Difficulty.getString() != Difficulty.getDefault())
        {
            if (Difficulty.getString() == null)
            {
                PlayState.SONG = Song.loadFromJson(songLowercase, songArray[curSelected].toLowerCase());
                PlayState.isStoryMode = false;
                curDifficulty = 1;
                PlayState.storyDifficulty = curDifficulty;
                if (FlxG.keys.pressed.SHIFT)
                {
                    LoadingState.loadAndSwitchState(new states.editors.ChartingState());
                    FlxG.sound.music.volume = 0;
                    destroyFreeplayVocals();
                }
                else
                {
                    LoadingState.loadAndSwitchState(new states.PlayState());
                    FlxG.sound.music.volume = 0;
                    destroyFreeplayVocals();
                }
            }
            else
            {
                PlayState.SONG = Song.loadFromJson(songLowercase, songArray[curSelected].toLowerCase() + "-" + Difficulty.getString());
                PlayState.isStoryMode = false;
                curDifficulty = Math.max(0, Difficulty.defaultList.indexOf(Difficulty.getString()));
                PlayState.storyDifficulty = curDifficulty;
                if (FlxG.keys.pressed.SHIFT)
                {
                    LoadingState.loadAndSwitchState(new states.editors.ChartingState());
                    FlxG.sound.music.volume = 0;
                    destroyFreeplayVocals();
                }
                else
                {
                    LoadingState.loadAndSwitchState(new states.PlayState());
                    FlxG.sound.music.volume = 0;
                    destroyFreeplayVocals();
                }
            }
        }
    }

    function destroyFreeplayVocals():Void
    {
        if (vocals != null)
        {
            vocals.destroy();
            vocals = null;
        }
    }

    function handleLoadingError(e:Dynamic):Void
    {
        selectin = false;
        cdman = true;
        FlxG.sound.play(Paths.sound('cancelMenu'));
        missingText.alpha = 1;
        missingText.text = 'MISSING SONG FILE!';
        missingText.screenCenter();
        missingText.cameras = [camHUD];
        missingTextTimer = new FlxTimer().start(1, function(tmr:FlxTimer) { missingText.alpha = 0; }, 1);
    }

    function changeSelection(amount:Int):Void
    {
        curSelected += amount;
        if (curSelected >= songArray.length)
        {
            curSelected = 0;
        }
        if (curSelected < 0)
        {
            curSelected = songArray.length - 1;
        }

        updateSongSelection();
    }

    function updateSongSelection():Void
    {
        songText.text = songArray[curSelected];

        for (box in boxedShit.members)
        {
            if (box != null)
            {
                var dif:Float = Math.abs(box.ID - curSelected);
                if (dif == 0)
                {
                    box.alpha = 1;
                }
                else if (dif == 1)
                {
                    box.alpha = 0.6;
                }
                else
                {
                    box.alpha = 0.2;
                }

                var scaleNum:Float = FlxMath.remapToRange(dif, 0, 3, 1.1, 0.7);
                box.scale.set(scaleNum, scaleNum);

                var targetX:Float = FlxMath.remapToRange(box.ID, 0, boxedShit.length - 1, 150, FlxG.width - 200);
                var targetY:Float = FlxMath.remapToRange(Math.abs(box.ID - curSelected), 0, 3, FlxG.height / 3, FlxG.height / 2 + 100);
                FlxTween.tween(box, { x: targetX, y: targetY }, 0.2, { ease: FlxEase.quadOut });
            }
        }
    }
}

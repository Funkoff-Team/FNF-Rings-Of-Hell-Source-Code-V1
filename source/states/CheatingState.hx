package states;

import states.TitleState;
import lime.app.Application;

#if VIDEOS_ALLOWED
import hxvlc.flixel.FlxVideo;
#end


class CheatingState extends MusicBeatState
{
 public static var isChartEditor:Bool = false;
 public static var isCharacterEditor:Bool = false;

 override function create(){
   	Application.current.window.title = "Friday Night Funkin': Rings Of Hell - Cheating!";

		var filepath:String = Paths.video('ikwhatyouredoing');
    var screamer:FlxVideo = new FlxVideo();

  function playScreamer(filePath:String) {

    if (screamer != null)
    {
      screamer.onEndReached.add(onScreamerEnd);
      add(screamer);

      openfl.Assets.loadBytes(filePath).onComplete(function(bytes:openfl.utils.ByteArray):Void
      {
        if (screamer.load(bytes))
          screamer.play();
      });
    }
    else
    {
      trace('ALERT: Video is null! Could not play cutscene!');
    }
  }
  playScreamer(filePath);
 }

function funnyDialogs(){
  if (isCharacterEditor) {
  isCharacterEditor = true;
  Application.current.window.title = "I want to know your IP!";
  	new FlxTimer().start(0.6, e -> Application.current.window.alert('\n RingsOfHell.exe has failed to log into your current internet connection!'));
  new FlxTimer().start(1, function(tmr:FlxTimer) {
    MusicBeatState.switchState(new TitleState());
   Application.current.window.title = "Friday Night Funkin': Rings Of Hell";
			});
  }

  if (isChartEditor) {
  Application.current.window.title = "I want to see you!";
  new FlxTimer().start(0.6, e -> Application.current.window.alert('\n Access to webcam declined!'));
  new FlxTimer().start(1, function(tmr:FlxTimer) {
    MusicBeatState.switchState(new TitleState());
   Application.current.window.title = "Friday Night Funkin': Rings Of Hell";
			});
  }
 }

	override function update(elapsed:Float)
	{
  function onScreamerEnd():Void
  {
    if (screamer != null)
    {
      screamer.stop();
      remove(screamer);
    }
    screamer.destroy();
    screamer = null;
    funnyDialogs(); 
  }
	}
}
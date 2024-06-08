package states;

import states.TitleState;
import lime.app.Application;

#if VIDEOS_ALLOWED
import videos.Video;

class CheatingState extends MusicBeatState
{
 public static var isChartEditor:Bool = false;
 public static var isCharacterEditor:Bool = false;

 override function create(){
   	Application.current.window.title = "Friday Night Funkin': Rings Of Hell - Cheating!";

    var cutVid:Video = new Video();
		cutVid.startVideo(Paths.video('ikwhatyouredoing'));
		add(cutVid);
    cutVid.onVideoEnd.addOnce(funnyDialogs());
 }

function funnyDialogs(){
  	cutVid.destroy();
		remove(cutVid);
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
}
#end
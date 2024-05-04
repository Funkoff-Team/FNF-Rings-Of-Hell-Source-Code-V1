package states;

import states.TitleState;
import lime.app.Application;

#if VIDEOS_ALLOWED
#if (hxCodec >= "3.0.0") import hxcodec.flixel.FlxVideo as VideoHandler;
#elseif (hxCodec >= "2.6.1") import hxcodec.VideoHandler as VideoHandler;
#elseif (hxCodec == "2.6.0") import VideoHandler;
#else import vlc.MP4Handler as VideoHandler; #end
#end

class CheatingState extends MusicBeatState
{
 public static var isChartEditor:Bool = false;
 public static var isCharacterEditor:Bool = false;

 override function create(){
   	Application.current.window.title = "Friday Night Funkin': Rings Of Hell - Cheating!";

		var filepath:String = Paths.video('ikwhatyouredoing');
 		var screamer:VideoHandler = new VideoHandler();
			#if (hxCodec >= "3.0.0")
			screamer.play(filepath);
			screamer.onEndReached.add(function()
			{
				screamer.dispose();
				funnyDialogs();
			}, true);
			#else
			screamer.playVideo(filepath);
			screamer.finishCallback = function()
			{
				funnyDialogs();
			}
			#end
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
}
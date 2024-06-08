package states;

#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end
import openfl.utils.Assets as OpenFlAssets;

import states.TitleState;
import lime.app.Application;
import flixel.FlxBasic;

#if VIDEOS_ALLOWED
import videos.Video;

class CheatingState extends MusicBeatState
{
 public static var isChartEditor:Bool = false;
 public static var isCharacterEditor:Bool = false;
  var cutVid:Video = new Video();

 override function create(){
   	Application.current.window.title = "Friday Night Funkin': Rings Of Hell - Cheating!";
   var fileName:String = Paths.video('ikwhatyouredoing');

		  cutVid.startVideo(fileName);
			cutVid.onVideoEnd.addOnce(() -> {
			 funnyDialogs();
			});
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
#end
package states;

#if sys
import sys.*;
import sys.io.*;
#elseif js
import js.html.*;
#end
import openfl.utils.Assets as OpenFlAssets;

#if VIDEOS_ALLOWED
import videos.Video;
import flixel.FlxBasic;
import states.TitleState;

using StringTools;

class Intro extends MusicBeatState
{
	public var finishCallback:Void->Void;
	  var cutVid:Video = new Video();
		var foundFile:Bool = false;

    override public function create()
    {
		var fileName:String = Paths.video('newgroundsintro');
		
    	#if sys
    	if (FileSystem.exists(fileName))
    	#else
    	if (OpenFlAssets.exists(fileName))
    	#end 
    	foundFile = true;

		if(foundFile) {
		  cutVid.startVideo(fileName);
			cutVid.onVideoEnd.addOnce(() -> {
	   	if (finishCallback != null)
			finishCallback();
			 MusicBeatState.switchState(new TitleState()); 
			});
    } else {
		if (finishCallback != null)
			finishCallback();
			FlxG.log.warn('Couldnt find video file: ' + fileName);
		}
  }
}
#end
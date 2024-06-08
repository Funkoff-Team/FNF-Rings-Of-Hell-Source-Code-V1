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
import states.TitleState;

using StringTools;

class Intro extends MusicBeatState
{
	  var cutVid:Video = new Video();
		var foundFile:Bool = false;

    override public function create()
    {
		var fileName:String = Paths.video('newgroundsintro');

    	if (OpenFlAssets.exists(fileName))
    	foundFile = true;

		  cutVid.startVideo(fileName);
			cutVid.onVideoEnd.addOnce(() -> {
			 MusicBeatState.switchState(new TitleState()); 
			});
  }
}
#end
package videos;

#if VIDEOS_ALLOWED 
#if hxCodec
#if (hxCodec >= "3.0.0") import hxcodec.flixel.FlxVideoSprite as MainVideoSprite;
#elseif (hxCodec >= "2.6.1") import hxcodec.VideoSprite as MainVideoSprite;
#elseif (hxCodec == "2.6.0") import VideoSprite as MainVideoSprite;
#else import vlc.MP4Sprite as MainVideoSprite; #end
#elseif hxvlc
import hxvlc.flixel.FlxVideoSprite as MainVideoSprite;
#end
#end
import haxe.extern.EitherType;
import flixel.util.FlxSignal;
import hxvlc.util.Handle;
class VideoSprite extends MainVideoSprite
{
	@:isVar
	public var playbackRate(get, set):Float;
	public var paused(default, set):Bool = false;
	public var onVideoEnd:FlxSignal;
	public var onVideoStart:FlxSignal;
	private var loaded:Bool = false;

	public function new(x:Int = 0, y:Int = 0)
	{
		super(x, y);
		onVideoEnd = new FlxSignal();
		onVideoEnd.add(destroy);
		onVideoStart = new FlxSignal();
		#if ((hxCodec >= "3.0.0" && hxCodec) || hxvlc)
		onVideoEnd.add(destroy);
		bitmap.onOpening.add(onVideoStart.dispatch);
		bitmap.onEndReached.add(onVideoEnd.dispatch);
		#elseif (hxCodec < "3.0.0" && hxCodec)
		bitmap.openingCallback = onVideoStart.dispatch;
		bitmap.finishCallback = onVideoEnd.dispatch;
		#end
		if(Std.isOfType(MusicBeatState.getState(), PlayState))
			PlayState.instance.videoSprites.push(this);
	}

	public function startVideo(path:String, loop:Bool = false #if hxvlc ,?options:Array<String> #end):VideoSprite
	{
		if(loop)
			onVideoEnd.remove(destroy);
		#if (hxCodec >= "3.0.0" && hxCodec)
		    /*#if android
		    play(Asset2File.getPath(path), loop);
		    #else*/
        play(path, loop);
        //#end
        #elseif (hxCodec < "3.0.0"  && hxCodec)
        /*#if android
        playVideo(Asset2File.getPath(path), loop, false);
        #else*/
        playVideo(path, loop, false);
        //#end
        #elseif hxvlc
		if(options == null)
			options = [];
		if(loop)
			options.push(':input-repeat=65535');
		else
			options.push(':input-repeat=0');
		if(!loaded)
		  loadVideo(path, options);
        play();
		#end
		return this;
	}

	#if hxvlc
	public function loadVideo(path:String, loop:Bool = false, ?options:Array<String>)
	{
		loaded = true;
		if(options == null)
			options = [];
		if(loop)
			options.push(':input-repeat=65535');
		else
			options.push(':input-repeat=0');
		/*#if android
		load(Asset2File.getPath(path), options);
		#else*/
		load(path, options);
		//#end
	}
	#end

	@:noCompletion
	private function set_paused(shouldPause:Bool)
	{
		/*#if hxvlc
		if(shouldPause)
		{
			autoPause = false;
			pause();
		}
		else
		{
			autoPause = FlxG.autoPause;
			resume();
		}
		#elseif hxCodec*/
		#if ((hxCodec && hxCodec >= "3.0.0") || hxvlc)
		var parentResume = resume;
		var parentPause = pause;
		#end
		#if (hxCodec < "3.0.0" && hxCodec)
		#if (hxCodec == "2.5.1")
		var parentResume = video.resume;
		var parentPause = video.pause;
		#else
		var parentResume = bitmap.resume;
		var parentPause = bitmap.pause;
		#end
		#end

		if (shouldPause)
		{
			#if ((hxCodec >= "3.0.0" && hxCodec) || hxvlc)
			pause();
			#end
			#if (hxCodec < "3.0.0" && hxCodec)
			#if (hxCodec == "2.5.1")
			video.pause();
			#else
			bitmap.pause();
			#end
			#end

			if (FlxG.autoPause)
			{
				if (FlxG.signals.focusGained.has(parentResume))
					FlxG.signals.focusGained.remove(parentResume);

				if (FlxG.signals.focusLost.has(parentPause))
					FlxG.signals.focusLost.remove(parentPause);
			}
		}
		else
		{
			#if ((hxCodec >= "3.0.0" && hxCodec) || hxvlc)
			resume();
			#end
			#if (hxCodec < "3.0.0" && hxCodec)
			#if (hxCodec == "2.5.1")
			video.resume();
			#else
			bitmap.resume();
			#end
			#end

			if (FlxG.autoPause)
			{
				FlxG.signals.focusGained.add(parentResume);
				FlxG.signals.focusLost.add(parentPause);
			}
		}
		// #end
		return shouldPause;
	}
	
	public function endVideo() {
		try {
			#if ((hxCodec >= "3.0.0" && hxCodec) || hxvlc)
			bitmap.dispose();
			#elseif (hxCodec == "2.5.1" && hxCodec)
			video.finishVideo();
			#elseif hxCodec
			bitmap.onEndReached();
			#end
		} catch (e:Dynamic) trace('exploded: $e');
	}

	@:noCompletion
	private function set_playbackRate(multi:Float)
	{
		playbackRate = bitmap.rate = multi;
		return multi;
	}

	@:noCompletion
	private function get_playbackRate():Float
	{
		return bitmap.rate;
	}

	override function destroy()
	{
		super.destroy();
		try
		{
			#if (hxCodec == "2.5.1" && hxCodec)
			video.finishVideo();
			#elseif (hxCodec < "3.0.0")
			bitmap.onEndReached();
			#end
		}
		catch (e:Dynamic)
		{
			trace(e);
		}
	}
}
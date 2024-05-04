package states;

#if cpp
import cpp.ConstCharStar;
import cpp.Native;
import cpp.UInt64;
#end
import flixel.FlxG;
import lime.app.Application;
import openfl.system.Capabilities;
import backend.MusicBeatState;
import WindowsAPI;
import states.Intro;

#if windows
@:cppFileCode("#include <windows.h>")
#elseif (linux && mobile)
@:headerCode("#include <stdio.h>")
#end
class SpecsDetector extends MusicBeatState
{
	var cache:Bool = false;
	var isCacheSupported:Bool = false;

	override public function create()
	{
		Paths.clearStoredMemory();
		Paths.clearUnusedMemory();

		FlxG.save.bind('funkin', CoolUtil.getSavePath());

		ClientPrefs.loadPrefs();

		FlxG.mouse.visible = true;
		
		super.create();

		FlxG.save.data.cachestart = checkSpecs();
		MusicBeatState.switchState(new Intro());
	}

	function checkSpecs():Bool
	{
		var cpu:Bool = Capabilities.supports64BitProcesses;
		var ram:Int = WindowsAPI.obtainRAM();

		trace('\n--- SYSTEM INFO ---\nMEMORY AMOUNT: $ram\nCPU 64 BITS: $cpu');

		// cpu = false; testing methods
		#if desktop
		if (cpu && ram >= 4096) //it's for shader, etc. sorry
		#else
		if (cpu && ram >= 3072)
		#end
			return true;
		else
		{
			return messageBox("Friday Night Funkin': Rings Of Hell",
				"EN: Your PC does not meet the requirements Rings Of Hell has.\nWhile you can still play the mod, you may experience framedrops and/or lag spikes.\n\nDo you want to play anyway?" + 
				"\nKR: 컴퓨터 사양이 '저사양'으로 감지되었습니다. \n이는 플레이어 영향을 끼칠 수 있습니다.\n창을 닫고 계속하시겠습니까?");
		}

		return true;
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	function messageBox(title:ConstCharStar = null, msg:ConstCharStar = null)
	{
		#if windows
		var msgID:Int = untyped MessageBox(null, msg, title, untyped __cpp__("MB_ICONQUESTION | MB_YESNO"));

		if (msgID == 7)
		{
			Sys.exit(0);
		}

		return true;
		#else
		lime.app.Application.current.window.alert(cast msg, cast title);
		return true;
		#end
	}
}

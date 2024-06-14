package;

import haxe.crypto.Md5;
import openfl.utils.Assets;
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class Asset2File
{
	public static var path:String = lime.system.System.applicationStorageDirectory;

	public static function getPath(id:String)
	{
		#if android
		var file = Assets.getBytes(id);
		var md5 = Md5.encode(Md5.make(file).toString());
		var filePath = path + md5;

		if (!FileSystem.exists(filePath))
			File.saveBytes(filePath, file);

		return filePath;
		#else
		return #if sys Sys.getCwd() + #end id;
		#end
	}
}
package ;

import org.flixel.FlxG;
import nme.Assets;

/**
 * ...
 * @author sirGustav
 */

class Game 
{
	public static var Width : Int = 640;
	public static var Height : Int = 480;
	
	public static inline function rnd(from:Float, to:Float):Float
	{
		return from + ((to - from) * Math.random());
	}
	
	#if flash
		public static var SoundExtension:String = ".mp3";
	#else
		public static var SoundExtension:String = ".wav";
	#end
	
	#if flash
		public static var MusicExtension:String = ".mp3";
	#else
		public static var MusicExtension:String = ".ogg";
	#end
	
	public static function sfx(f:String)
	{
		var path : String = "assets/sfx/" + f + SoundExtension;
		//Assets.getSound(path)
		FlxG.play(path, 1, false);
	}
	
	public static function music(f:String)
	{
		var sound = Assets.getSound("assets/music/" + f + MusicExtension);
		FlxG.playMusic(sound, .8);
	}
}
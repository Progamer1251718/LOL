package;

//This made by Sirox for using with whatever you want
import haxe.crypto.Md5;
import openfl.utils.Assets;
import webm.*;
import flixel.system.FlxSound;
import flixel.FlxCamera;
import openfl.Assets;
import openfl.media.Sound;
import flixel.FlxSprite;
import flixel.FlxG;
import openfl.Lib;
#if sys
import sys.FileSystem;
import sys.io.File;
import Sys;
#end

using StringTools;

class WebmPlayerS extends FlxSprite
{
	public var videoplayer:WebmPlayer;
	public var endcallback:Void->Void = null;
	public var startcallback:Void->Void = null;
	public var sound:FlxSound;
    public var soundMultiplier:Float = 1;
    public var prevSoundMultiplier:Float = 1;
    public var videoFrames:Int = 0;
    public var doShit:Bool = false;
    public var io:WebmIo;
    public var altSource:String;
    
    public var stopped:Bool = false;
	public var restarted:Bool = false;
	public var started:Bool = false;
	public var ended:Bool = false;
	public var paused:Bool = false;
	
	public function new(source:String, ownCamera:Bool = false, frameSkipLimit:Int = -1, okX:Float = null, okY:Float = null, okWidth:Float = null, okHeight:Float = null) 
    {
    	x = 0;
        y = 0;

    	if (okX != null) {
        	x = okX;
        }
        if (okY != null) {
        	y = okY;
        }
        if (okWidth != null) {
        	width = okWidth;
        }
        if (okHeight != null) {
        	height = okHeight;
        }

        super(x, y);
        
        altSource = source;
        
        io = new WebmIoFile(getThing(altSource));
		videoplayer = new WebmPlayer();
		videoplayer.fuck(io, false);
		videoplayer.addEventListener(WebmEvent.PLAY, function(e) {
			trace("playing");
			if (startcallback != null) {
				startcallback();
			}
			started = true;
		});
		videoplayer.addEventListener(WebmEvent.COMPLETE, function(e) {
			trace("ended");
			if (endcallback != null) {
				endcallback();
			}
			ended = true;
		});
		videoplayer.addEventListener(WebmEvent.STOP, function(e) {
			trace("stopped");
			stopped = true;
		});
		videoplayer.addEventListener(WebmEvent.RESTART, function(e) {
			trace("restarted");
			restarted = true;
		});
		
		loadGraphic(videoplayer.bitmapData);
		
		if (ownCamera) {
		    var cam = new FlxCamera();
	        FlxG.cameras.add(cam);
		    cam.bgColor.alpha = 0;
		    cameras = [cam];
		}
    }
    
    public function getThing(source:String)
    {
    	#if mobile
        return source;
        #elseif desktop
        return Sys.getCwd() + source;
        #else
        return null;
        #end
    }
	
	public function play():Void
	{
		videoplayer.play();
	}
	
	public function stop():Void
	{
		videoplayer.stop();
	}
	
	public function restart():Void
	{
		videoplayer.restart();
	}
	
	public function togglePause():Void
	{
		if (paused)
		{
			resume();
		} else {
			pause();
		}
	}
	
	public function clearPause():Void
	{
		paused = false;
		videoplayer.removePause();
	}
	
	public function pause():Void
	{
		videoplayer.changePlaying(false);
		paused = true;
	}
	
	public function resume():Void
	{
		videoplayer.changePlaying(true);
		paused = false;
	}
	
	public function setAlpha(ok:Float):Void
	{
		videoplayer.alpha = ok;
	}
	
	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}
	
	override public function destroy() {
        videoplayer.stop();
        super.destroy();
    }
}

class Dimensions
{
	public static var width:Int = 1280;
	public static var height:Int = 720;
}
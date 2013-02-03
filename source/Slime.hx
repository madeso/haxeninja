package ;
import org.flixel.FlxBasic;
import org.flixel.FlxEmitter;
import org.flixel.FlxGroup;
import org.flixel.FlxPath;
import org.flixel.FlxPoint;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;

/**
 * ...
 * @author sirGustav
 */

class Slime extends FlxSprite
{
	private var em : FlxGroup;
	private var flying : Bool = false;
	public function new(X:Float, Y:Float, F : Bool, path : FlxPath, E : FlxGroup)
	{
		super(X, Y);
		loadGraphic("assets/items.png", true, true, 40, 40);
		
		em = E;
		flying = F;
		
		if ( flying )
		{
			height = 14;
			offset.y = 13;
			width = 16;
			offset.x = 12;
		}
		else
		{
			height = 12;
			offset.y = 28;
			width = 18;
			offset.x = 11;
		}
		
		y += offset.y;
		
		var imageBase : Int = flying ? 17 : 14;
		addAnimation("moving", [imageBase, imageBase + 1], 4);
		addAnimation("dead", [imageBase + 2]);
		play("moving");
		
		if ( path != null )
		{
			var p : FlxPoint;
			for (p in path.nodes)
			{
				p.x += width;
				p.y -= height/2;
			}
			x = path.nodes[0].x;
			y = path.nodes[0].y;
			followPath(path, 30, FlxObject.PATH_YOYO, false);
		}
	}
	
	override public function update():Void 
	{
		if ( velocity.x > 0 )
		{
			facing = FlxObject.RIGHT;
		}
		
		if ( velocity.x < 0 )
		{
			facing = FlxObject.LEFT;
		}
		
		super.update();
	}
	
	override public function kill():Void 
	{
		super.kill();
		Game.sfx("kill");
		cast(em.recycle(DeadSlime), DeadSlime).startDead(x, y, flying);
	}
}
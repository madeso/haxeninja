package ;
import org.flixel.FlxSprite;
import org.flixel.FlxG;
import org.flixel.FlxObject;

/**
 * ...
 * @author sirGustav
 */

class Player extends FlxSprite
{
	private static inline var RUN_SPEED:Int = 100;
	private static inline var GRAVITY:Int = 800;
	private static inline var JUMP_SPEED:Int = 250;
	private static inline var JUMP_TIME:Float = 0.2;
	
	private var jumpTimer : Float = 0;
	private var canDoubleJump : Bool = false;
	
	private var touchdir : TouchDir;
	
	private var lastTouchDir : Int;
	private var lastPower : Float;
	
	var gl : GameState;
	
	public function hitSpike() : Void
	{
		velocity.y = -350;
		hurt(1);
		Game.sfx("onspike");
	}
	
	public function hitSlime() : Void
	{
		velocity.y = -150;
		hurt(1);
		Game.sfx("onslime");
	}
	
	public function killSlime() : Void
	{
		velocity.y = -250;
		canDoubleJump = true;
	}
	
	override public function hurt(Damage:Float):Void 
	{
		if ( flickering == false )
		{
			flicker();
			super.hurt(Damage);
		}
	}

	public function new(X:Float, Y:Float, Parent: GameState)
	{
		super(X, Y);
		health = 3;
		gl = Parent;
		lastTouchDir = 5;
		
		touchdir = new TouchDir();
		
		loadGraphic("assets/items.png", true, true, 40, 40);
		
		drag.x = RUN_SPEED * 8;
		drag.y = RUN_SPEED * 8;
		acceleration.y = GRAVITY;
		maxVelocity.x = RUN_SPEED;
		maxVelocity.y = JUMP_SPEED * 2;
		
		height = 37;
		offset.y = 3;
		width = 18;
		offset.x = 7;
		
		addAnimation("walking", [0, 1, 2, 3], 12, true);
		addAnimation("idle", [3]);
		addAnimation("jump", [2]);
		
		play("idle");
	}
	
	override public function kill():Void 
	{
		FlxG.switchState(new DeadState());
		super.kill();
	}
	
	private static function b2s(b:Bool):String
	{
		if ( b ) return "O";
		else return "-";
	}
	
	private var lastvely : Float = 0;
	
	public function vy() : Float
	{
		return lastvely;
	}
	
	public override function update():Void
	{
		var coly : Float = 0;
		if (justTouched(FlxObject.FLOOR))
		{
			coly = lastvely;
			//trace("hit: " + Std.string(coly));
		}
		lastvely = velocity.y;
		
		var moveLeft : Bool = false;
		var moveRight : Bool = false;
		var newJump : Bool = false;
		var keepJump : Bool = false;
		
		// get key input - keyboard
		if (FlxG.keys.LEFT)
		{
			moveLeft = true;
		}
		else if (FlxG.keys.RIGHT)
		{
			moveRight = true;
		}
		if (FlxG.keys.justPressed("UP") )
		{
			newJump = true;
		}
		if ( FlxG.keys.UP )
		{
			keepJump = true;
		}
		
		// get key input - swiping
		touchdir.update();
		var dir:Int = touchdir.getDir();
		if ( dir != 0 )
		{
			lastTouchDir = dir;
			lastPower = touchdir.getPower();
			
			trace("Dir: " + Std.string(lastTouchDir) + " | Power: " + Std.string(lastPower));
		}
		if ( dir == 7 || dir == 8 || dir == 9 ) newJump = true;
		if ( lastPower >= 3 )
		{
			if ( lastTouchDir == 7 || lastTouchDir == 8 || lastTouchDir == 9 ) keepJump = true;
		}
		if ( lastTouchDir == 9 || lastTouchDir == 6 || lastTouchDir == 3) moveRight = true;
		if ( lastTouchDir == 7 || lastTouchDir == 4 || lastTouchDir == 1) moveLeft = true;
		
		if ( coly > 100 )
		{
			if ( lastTouchDir == 7 || lastTouchDir == 8 || lastTouchDir == 9 )
			{
				lastTouchDir -= 3;
				keepJump = false;
			}
		}
		
		//gl.hud.text = "Dir: " + Std.string(lastTouchDir) + " / " + b2s(moveLeft) + b2s(moveRight) + b2s(newJump) + b2s(keepJump);
		
		if (isTouching(FlxObject.FLOOR))
		{
			if ( keepJump == false )
			{
				jumpTimer = 0;
				canDoubleJump = true;
			}
		}
		
		if ( newJump ) keepJump = true;
		acceleration.x = 0;
		if (moveLeft)
		{
			facing = FlxObject.LEFT; 
			acceleration.x = -drag.x;
		}
		else if (moveRight)
		{
			facing = FlxObject.RIGHT;
			acceleration.x = drag.x;				
		}
		
		if ( newJump && jumpTimer <= 0 )
		{
			jumpTimer = 0;
			Game.sfx("jump");
		}
		else if ( newJump && canDoubleJump )
		{
			canDoubleJump = false;
			jumpTimer = 0;
			Game.sfx("djump");
		}
		
		if ( jumpTimer < JUMP_TIME && keepJump )
		{
			velocity.y = -JUMP_SPEED;
		}
		
		if ( keepJump )
		{
			jumpTimer += FlxG.elapsed;
		}
		else
		{
			jumpTimer = jumpTimer * 2;
		}
		
		super.update();
	}
}
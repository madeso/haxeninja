package;

import nme.Assets;
import nme.geom.Rectangle;
import nme.net.SharedObject;
import org.flixel.FlxButton;
import org.flixel.FlxEmitter;
import org.flixel.FlxG;
import org.flixel.FlxGroup;
import org.flixel.FlxObject;
import org.flixel.FlxPath;
import org.flixel.FlxSave;
import org.flixel.FlxSprite;
import org.flixel.FlxState;
import org.flixel.FlxText;
import org.flixel.FlxTilemap;
import org.flixel.FlxU;
import org.flixel.tmx.TmxObject;
import org.flixel.tmx.TmxObjectGroup;

import org.flixel.tmx.TmxMap;

/**
 * ...
 * @author sirGustav
 */

class GameState  extends FlxState
{
	private var player : Player;
	private var map_collide:FlxTilemap;
	private var tmx : TmxMap;
	public var hud : FlxText;
	
	public var coins : FlxGroup;
	public var spikes : FlxGroup;
	public var slimes : FlxGroup;
	public var blocks : FlxGroup;
	
	private static var PLAYER_ID : Int = 0;
	private static var COIN_ID : Int = 20;
	private static var SPIKE_ID : Int = 21;
	private static var WALKING_SLIME_ID : Int = 14;
	private static var FLYING_SLIME_ID : Int = 17;
	private static var TIME_BLOCK_ID : Int = 22;
	private static var BREAK_BLOCK_ID : Int = 23;
	
	private var slimeEm : FlxGroup;
	
	private var timeBlockEm : FlxEmitter;
	private var breakBlockEm : FlxEmitter;
	
	private function addGfxLayer(layer:String, scroll:Float):Void
	{
		var map : FlxTilemap = new FlxTilemap();
		var csv : String = tmx.getLayer(layer).toCsv(tmx.getTileSet('tiles'));
		map.loadMap(csv, "assets/tiles.png", 40, 40, FlxTilemap.OFF);
		
		map.scrollFactor.x = scroll;
		
		//map.follow();
		add(map);
	}
	
	private function findPath(objects:TmxObjectGroup, parent:TmxObject) : FlxPath
	{
		var o : TmxObject;
		for (o in objects.objects )
		{
			if ( o.gid == -1 && o.x == parent.x && o.y == parent.y )
			{
				return o.polyline;
			}
		}
		
		return null;
	}
	
	override public function create():Void
	{
		Game.music("andsoitbegins");
		tmx = new TmxMap( nme.Assets.getText('assets/test.tmx') );
		map_collide = new FlxTilemap();

		map_collide.loadMap(tmx.getLayer('block').toCsv(tmx.getTileSet('tiles')), "assets/tiles.png", 40, 40, FlxTilemap.OFF);
		map_collide.follow();
		
		coins = new FlxGroup();
		spikes = new FlxGroup();
		slimes = new FlxGroup();
		blocks = new FlxGroup();
		
		addGfxLayer("distant", 0.6);
		addGfxLayer("bkg", 0.9);
		addGfxLayer("gfx", 1);
		add(map_collide);
		
		FlxG.bgColor = 0xff131c1b;
		FlxG.bgColor = 0xffd0f4f7; // correct
		
		var objects : TmxObjectGroup = tmx.getObjectGroup("objects");
		var o : TmxObject;
		var base : Int = tmx.getTileSet("items").firstGID;
		
		var playerx : Float = 10;
		var playery : Float = 10;
		
		slimeEm = new FlxGroup();
		
		timeBlockEm = new FlxEmitter();
		add(timeBlockEm);
		timeBlockEm.setXSpeed( -120, 0);
		timeBlockEm.setYSpeed( -400, 0);
		timeBlockEm.setRotation( -360, 360);
		timeBlockEm.makeParticles("assets/timeblock.png", 16, 16, true);
		timeBlockEm.gravity = 500;
		
		breakBlockEm = new FlxEmitter();
		add(breakBlockEm);
		breakBlockEm.setXSpeed( -120, 0);
		breakBlockEm.setYSpeed( -400, 0);
		breakBlockEm.setRotation( -360, 360);
		breakBlockEm.makeParticles("assets/breakblock.png", 16, 16, true);
		breakBlockEm.gravity = 500;
		
		for (o in objects.objects)
		{
			if ( o.gid != -1 )
			{
				var id : Int = o.gid - base;
				var name : String = "Unknown (" + Std.string(id) + ")";
				
				var ox : Float = o.x;
				var oy : Float = o.y - 40;
				
				switch(id)
				{
					case PLAYER_ID:
						name = "player";
						playerx = ox;
						playery = oy;
					case COIN_ID:
						name = "coin";
						coins.add( new Coin(ox, oy) );
					case SPIKE_ID:
						name = "spike";
						spikes.add( new Spike(ox, oy) );
					case WALKING_SLIME_ID:
						name = "walking slime";
						slimes.add(new Slime(ox, oy, false, findPath(objects, o), slimeEm));
					case FLYING_SLIME_ID:
						name = "flying slime";
						slimes.add(new Slime(ox, oy, true, findPath(objects, o), slimeEm));
					case TIME_BLOCK_ID:
						name = "timeblock";
						blocks.add( new TimeBlock(ox, oy, timeBlockEm) );
					case BREAK_BLOCK_ID:
						name = "breakblock";
						blocks.add( new BreakBlock(ox, oy, breakBlockEm) );
					default:
						trace( name + " at " + Std.string(o.x) + ", " + Std.string(o.y) );
				}
			}
		}
		
		add(coins);
		add(spikes);
		add(slimes);
		add(blocks);
		
		add(slimeEm);
		
		player = new Player(playerx, playery, this);
		add(player);
		FlxG.camera.follow(player, 1);
		
		hud = new FlxText(0, 0, Game.Width, "");
		hud.scrollFactor.x = 0;
		hud.scrollFactor.y = 0;
		add(hud);
	}
	
	override public function destroy():Void
	{
		super.destroy();
	}

	override public function update():Void
	{
		super.update();
		FlxG.collide(player, map_collide);
		FlxG.overlap(player, coins, cb_player_coin);
		FlxG.overlap(player, spikes, cb_player_spike);
		FlxG.overlap(player, slimes, cb_player_slime);
		FlxG.collide(player, blocks, cb_player_block);
		//FlxG.collide(timeBlockEm, map_collide);
		//FlxG.collide(breakBlockEm, map_collide);
		
		// hud.text = "Height: " +  Std.string(map_collide.height) + " / Y: " + Std.string(player.y);
		
		if ( player.y > map_collide.height )
		{
			player.kill();
		}
	}
	
	private function cb_player_block(p:FlxObject, c:FlxObject) : Void
	{
		var dmg : Float = 1;
		if ( cast(p, Player).vy() >= 0 ) dmg = 0;
		c.hurt(dmg);
	}
	
	private function cb_player_coin(p:FlxObject, c:FlxObject) : Void
	{
		c.kill();
		c.exists = false;
	}
	
	private function cb_player_spike(p:FlxObject, c:FlxObject) : Void
	{
		cast(p, Player).hitSpike();
	}
	
	private function cb_player_slime(p:FlxObject, slime:FlxObject) : Void
	{
		var result : String = "???";
		var pvy : Float = p.velocity.y;
		if ( p.y < slime.y && pvy > 0 )
		{
			if ( p.flickering == false )
			{
				slime.kill();
				cast(p, Player).killSlime();
				result = "killed slime";
			}
		}
		else
		{
			cast(p, Player).hitSlime();
			result = "hurt by slime";
		}
		
		//trace( result + ": " + Std.string(player.y) + " at " + Std.string(pvy)+ "| " +  Std.string(player.velocity.y) +" / " + Std.string(slime.y));
	}
}
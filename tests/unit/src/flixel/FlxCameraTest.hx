package flixel;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.util.FlxColor;
import massive.munit.Assert;

class FlxCameraTest extends FlxTest
{
	var camera:FlxCamera;
	
	@Before
	function before()
	{
		camera = new FlxCamera();
		FlxG.resetGame();
		step(1);
		destroyable = camera;
	}
	
	@Test
	function testDefaultBgColor():Void
	{
		Assert.areEqual(FlxColor.BLACK, FlxG.cameras.bgColor);
	}

	@Test
	function testDefaultZoom():Void
	{
		Assert.areEqual(1, FlxG.camera.zoom);
		Assert.areEqual(1, FlxCamera.defaultZoom);
	}

	@Test
	function testDefaultLength():Void
	{
		Assert.areEqual(1, FlxG.cameras.list.length);
	}
	
	@Test
	function testDefaultCameras():Void
	{
		Assert.areEqual(FlxG.cameras.list, FlxCamera.defaultCameras);
	}
	
	@Test
	function testDefaultCamerasStateSwitch():Void
	{
		FlxCamera.defaultCameras = [FlxG.camera];
		FlxG.switchState(new FlxState());
		
		step();
		Assert.areEqual(FlxG.cameras.list, FlxCamera.defaultCameras);
	}
	
	@Test
	function testAddAndRemoveCamera():Void
	{
		FlxG.cameras.add(camera);
		Assert.areEqual(2, FlxG.cameras.list.length);
		
		FlxG.cameras.remove(camera);
		Assert.areEqual(1, FlxG.cameras.list.length);
	}
	
	@Test // #1515
	function testFollowNoLerpChange()
	{
		FlxG.updateFramerate = 30;
		camera = new FlxCamera();
		
		var defaultLerp = camera.followLerp;
		camera.follow(new FlxObject());
		Assert.areEqual(defaultLerp, camera.followLerp);
	}
	
	@Test
	function testFadeInFadeOut()
	{
		testFadeCallback(true, false);
	}
	
	@Test // #1666
	function testFadeOutFadeIn()
	{
		testFadeCallback(false, true);
	}
	
	function testFadeCallback(firstFade:Bool, secondFade:Bool)
	{
		var secondCallback = false;
		fade(firstFade, function() {
            fade(secondFade, function() {
				secondCallback = true;
			});
        });
		
		step(10);
		Assert.isTrue(secondCallback);
	}
	
	@Test
	function testFadeAlreadyStarted()
	{
		testDoubleFade(true, false, false);
	}
	
	@Test
	function testFadeForce()
	{
		testDoubleFade(false, true, true);
	}
	
	function testDoubleFade(firstResult:Bool, secondResult:Bool, force:Bool)
	{
		var callback1 = false;
		var callback2 = false;
		fade(false, function() { callback1 = true; });
		fade(false, function() { callback2 = true; }, force);
		
		step(20);
		Assert.areEqual(firstResult, callback1);
		Assert.areEqual(secondResult, callback2);
	}
	
	function fade(fadeIn:Bool = false, ?onComplete:Void->Void, force:Bool = false)
	{
		FlxG.camera.fade(FlxColor.BLACK, 0.05, fadeIn, onComplete, force);
	}
}
/*********************************************************************
 *	
 *	SpaceManager
 *
 *	GameDelegate.m
 *
 *	game delegate for initializing sequence
 *
 *	http://www.mobile-bros.com
 *
 *	Created by matt on 5/11/09.
 *	Copyright 2009 Mobile Bros. All rights reserved.
 *
 **********************************************************************/

#import "GameDelegate.h"
#import "GameLayer.h"
#import "Serialize.h"

@interface GameDelegate (PrivateMethods)

@end

@implementation GameDelegate

#pragma mark GameDelegate Methods
- (void)applicationDidFinishLaunching:(UIApplication *)application
{
	[application setIdleTimerDisabled:YES];
	
	// NEW: Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	[window setUserInteractionEnabled:YES];
	[window setMultipleTouchEnabled:YES];

	[CCDirector setDirectorType:CCDirectorTypeThreadMainLoop];
	[[CCDirector sharedDirector] setDeviceOrientation:CCDeviceOrientationLandscapeLeft];
	[[CCDirector sharedDirector] setDisplayFPS:YES];

	[[CCDirector sharedDirector] attachInWindow:window];	
	
	[window makeKeyAndVisible];

	CCScene *game = [CCScene node];
#if SERIALIZE_TEST
	Serialize *layer = [Serialize node];
#else
	GameLayer *layer = [GameLayer node];
#endif
	[game addChild:layer];
	[[CCDirector sharedDirector] runWithScene:game];
}

- (void)applicationWillTerminate:(UIApplication*)application
{
	[[CCDirector sharedDirector] end];
}

-(void)dealloc
{
	[window release];
	[super dealloc];
}

-(void) applicationWillResignActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] pause];
}

-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[CCTextureCache sharedTextureCache] removeAllTextures];
}

@end

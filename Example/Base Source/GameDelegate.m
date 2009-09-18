/*********************************************************************
 *	
 *	Particles
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

	[Director useFastDirector];
	[[Director sharedDirector] setLandscape: YES];
	//[[Director sharedDirector] setDisplayFPS:YES];

	[[Director sharedDirector] attachInWindow:window];	
	
	[window makeKeyAndVisible];

	Scene *game = [Scene node];
	GameLayer *layer = [GameLayer node];
	[game addChild:layer];
	
	[[Director sharedDirector] runWithScene:game];
}

- (void)applicationWillTerminate:(UIApplication*)application
{
}

-(void)dealloc
{
	[window release];
	[super dealloc];
}


-(void) applicationWillResignActive:(UIApplication *)application
{
	[[Director sharedDirector] pause];
}


-(void) applicationDidBecomeActive:(UIApplication *)application
{
	[[Director sharedDirector] resume];
}


- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[[TextureMgr sharedTextureMgr] removeAllTextures];
}


@end

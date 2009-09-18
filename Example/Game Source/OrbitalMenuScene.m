/*********************************************************************
 *	
 *	Particles
 *
 *	OrbitalMenuScene.m
 *
 *	menu scene for handling game menus
 *
 *	http://www.mobile-bros.com
 *
 *	Created by matt on 6/08/09.
 *	Copyright 2009 Mobile Bros. All rights reserved.
 *
 **********************************************************************/

#import "OrbitalMenuScene.h"
#import "MenuScene.h"
#import "GameScene.h"


@interface OrbitalMenuScene (PrivateMethods)
- (void) addOrbs;
@end

@interface OrbitalMenuLayer (PrivateMethods)
- (void) addOrbs;
- (void) loadGame:(id)sender;
- (void) startGame:(id)sender;
@end

#pragma mark OrbitalmenuScene Class
@implementation OrbitalMenuScene

#pragma mark OrbitalMenuScene Initialize/Deallocation
-(id)init
{
	self = [super init];
	if (self)
	{
		NSString *imagefile = [NSString stringWithString:_PLANETNAMES[g_planetIndex]];
		imagefile = [imagefile stringByAppendingString:@".png"];
		imagefile = [imagefile lowercaseString];
		
		Sprite * planet_image = [Sprite spriteWithFile:imagefile];
		
        [planet_image setPosition:cpv(240, 160)];
				
		[self addChild:planet_image];
		[self addChild:[OrbitalMenuLayer node]];
	}
	
	return self;
}


-(void) dealloc
{		
	[super dealloc];
}

@end

#define MENU_TAG	1

#pragma mark OrbitalMenuLayer Class
@implementation OrbitalMenuLayer

#pragma mark OrbitalMenuLayer Initialize/Deallocation
- (id) init {
    self = [super init];
    if (self != nil)
	{
		start = [[MenuItemImage itemFromNormalImage:@"LAUNCH.png"
									 selectedImage:@"LAUNCH_SELECTED.png"
												target:self
											  selector:@selector(startGame:)] retain];
		start.position = cpv(450, 32);
		start.visible = FALSE;
		
		MenuItem *returnToRadar = [MenuItemImage itemFromNormalImage:@"RADAR.png"
														selectedImage:@"RADAR_SELECTED.png"
												target:self
											  selector:@selector(returnToLaunchMenu:)];
		returnToRadar.position = cpv(27, 27);
		
		id rotRad = [RepeatForever actionWithAction:[RotateBy actionWithDuration:2.0 angle:360]];
		[returnToRadar runAction:rotRad];
		
		
		Menu *menu = [Menu menuWithItems:start,returnToRadar, nil];
		menu.position = cpvzero;
		[self addChild:menu z:1 tag:MENU_TAG];
		
		_shuttle = [Sprite spriteWithFile:@"shuttle.png"];
		Sprite *thrust = [Sprite spriteWithFile:@"thruster.png"];
		ParticleSystem *fire = [ParticleSun node];
		fire.size = 5;
		fire.totalParticles = 70;
		fire.position = cpvadd(thrust.transformAnchor, cpv(0,5));

		[thrust addChild:fire];
		thrust.position = cpv(22,-10);
		[_shuttle addChild:thrust];
		_shuttle.position = cpv(295,180);
		_shuttle.rotation = 15;
		[self addChild:_shuttle];
			
		[self loadState];
		[self addOrbs];
	}
    return self;
}

- (void) dealloc
{
	[start release];
	[super dealloc];
}

-(void)loadState
{
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	_completed = [prefs integerForKey:_PLANETNAMES[g_planetIndex]];
	
	[prefs setInteger:-1 forKey:@"CurrentLevel"];
}

- (void) addOrbs
{
	RadialMenu *rmenu = [[RadialMenu alloc] initWithRadius:120 spacing:72];
	rmenu.position = cpvzero;
	MenuItemImage* level;
	NSString *file;
	
	for (int i = 0; i < 5; i++)
	{
		file = [NSString stringWithFormat:@"L%dicon.png", i+1]; 
		level = [MenuItemImage itemFromNormalImage:file 
									 selectedImage:file
									 disabledImage:@"lockicon.png"
											target:self 
										  selector:@selector(levelSelected:)];
		[rmenu addChild:level];
		
		level.tag = LEVEL1+i;
		
		ParticleSystem* p = [ParticleFlower node];
		p.size = 10;
		p.totalParticles = 40;
		p.position = level.transformAnchor;
		[level addChild:p];
		
		if (i <= _completed)
			level.scale = .50;
		else
		{
			level.isEnabled = NO;
			p.scale = 0.5;
		}
	}
	
	[self addChild:rmenu];	

	[rmenu release];
}

#pragma mark MenuLayer Methods
-(void)startGame: (id)sender
{
	if (_selectedLevel)
	{
		[self removeChildByTag:MENU_TAG cleanup:YES];
		
		id action = [EaseIn actionWithAction:[MoveBy actionWithDuration:1.3 position:cpv(95,250)] rate:4];
		id seq = [Sequence actions:action, [CallFunc actionWithTarget:self selector:@selector(loadGame:)], nil];
		[_shuttle runAction:seq];
	}
}

-(void)loadGame: (id)sender
{		
	if (_selectedLevel)
	{
		GameScene *game = [GameScene sceneWithLevel:[_selectedLevel tag] planet:g_planetIndex];
		[[Director sharedDirector] replaceScene:[ZoomFlipAngularTransition transitionWithDuration:0.25 scene:game]];
	}
}

-(void)returnToLaunchMenu: (id)sender
{
	MenuScene *menu = [MenuScene node];
	
	//[[Director sharedDirector] replaceScene:[ZoomFlipAngularTransition transitionWithDuration:0.5 scene: menu]];
	[[Director sharedDirector] replaceScene:[ShrinkGrowTransition transitionWithDuration:0.25 scene: menu]];
	
}

-(void)levelSelected: (id)sender
{
	id scaleToNormal = [ScaleTo actionWithDuration:.5 scale:.50];
	id scaleToAction = [ScaleTo actionWithDuration:.5 scale:1.0];
	
	[_selectedLevel runAction:scaleToNormal];
	_selectedLevel = sender;
	[sender runAction:scaleToAction];
	
	start.visible = TRUE;
}

@end



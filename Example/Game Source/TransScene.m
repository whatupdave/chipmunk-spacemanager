/*********************************************************************
 *	
 *	Particles
 *
 *	TransitionScene.m
 *
 *	menu scene for handling game menus
 *
 *	http://www.mobile-bros.com
 *
 *	Created by matt on 6/08/09.
 *	Copyright 2009 Mobile Bros. All rights reserved.
 *
 **********************************************************************/

#import "TransScene.h"
#import "MenuScene.h"
#import "GameScene.h"
#import "OrbitalMenuScene.h"


@interface TransScene (PrivateMethods)

@end

@interface TransLayer (PrivateMethods)
- (void) fireRocket;
@end

#pragma mark TransScene Class
@implementation TransScene

#pragma mark TransScene Initialize/Deallocation
- (id) initWithLevel:(int)level planet:(int)planetIdx
{
	self = [super init];
	if (self)
	{
		Sprite * back_image = [Sprite spriteWithFile:@"transition.png"];
        [back_image setPosition:cpv(240, 160)];
		[self addChild:back_image];
				
		[self addChild:[[[TransLayer alloc] initWithLevel:level planet:planetIdx] autorelease]];
	}
	
	return self;
}


-(void) dealloc
{		
	[super dealloc];
}

@end


#pragma mark TransLayer Class
@implementation TransLayer

#pragma mark TransLayer Initialize/Deallocation

- (id) initWithLevel:(int)level planet:(int)planetIdx
{
	self = [super init];
	
	_level = level;
	_planetIdx = planetIdx;
	
	
	NSMutableString *labelStr = [NSMutableString stringWithString:@"Now navigating to"];
	
	Label *label = [Label labelWithString:labelStr fontName:@"Helvetica" fontSize:24];
	Label *label2 = [Label labelWithString:_PLANETNAMES[_planetIdx] fontName:@"Helvetica" fontSize:28];
	
	label.position = cpv(240,160);
	label2.position = cpv(240, 130);
		
	[self addChild:label];
	[self addChild:label2];
		
	id action = [Sequence actionOne:[DelayTime actionWithDuration:3.2] two:[CallFunc actionWithTarget:self selector:@selector(launchGame:)]];
	[self runAction:action];
	
	[self fireRocket];

	return self;
}

-(void)launchGame: (id)sender
{
	GameScene *game = [GameScene sceneWithLevel:_level planet:_planetIdx];
	[[Director sharedDirector] replaceScene:[ShrinkGrowTransition transitionWithDuration:0.25 scene:game]];
}

- (void) fireRocket
{
	Sprite *_shuttle = [Sprite spriteWithFile:@"shuttle.png"];
	Sprite *thrust = [Sprite spriteWithFile:@"thruster.png"];
	ParticleSystem *fire = [ParticleSun node];
	fire.size = 5;
	fire.totalParticles = 70;
	fire.position = cpvadd(thrust.transformAnchor, cpv(0,5));
	
	[thrust addChild:fire];
	thrust.position = cpv(22,-10);
	[_shuttle addChild:thrust];
	_shuttle.position = cpv(-35,300);
	_shuttle.rotation = 80;
	[self addChild:_shuttle];
	
	id action = [MoveTo actionWithDuration:1.8 position:cpv(550,300)];
	[_shuttle runAction:action];
}

@end



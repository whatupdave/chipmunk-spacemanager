//
//  LightCollector.m
//  Particles
//
//  Created by Robert Blackwood on 5/16/09.
//  Copyright 2009 isee systems. All rights reserved.
//

#import "LightCollector.h"
#import "lightParticle.h"
#import "lightEmitter.h"

//stand-alone c-functions defined at bottom
static int collParticleCollector(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data);

@interface LightCollector (PrivateMethods)

-(void) addLightExplosionAt:(cpVect)pt;

@end


@implementation LightCollector

@synthesize color = _color;

-(id) initWithSpaceManager:(SpaceManager*)spm color:(Colors)c
{	
	_color = c;
	
	NSString * colorString;
	
	switch(_color)
	{
		case GREEN: colorString = @"Green"; break;
		case BLUE: colorString = @"Blue"; break;
		case RED: colorString = @"Red"; break;
		case WHITE: colorString = @"White"; break;
	}
	
	[super initWithFile: [NSString stringWithFormat:@"LightCollector%@1.png", colorString]];
	
	_currentFrame = 0;
	
	//Create our meter, complete with several frames, delay has no effect
	Animation* animation = [Animation animationWithName:@"collector" delay:1.0];
	for (int i=1;i<8;i++)
		[animation addFrameWithFilename: [NSString stringWithFormat:@"LightCollector%@%d.png", colorString, i]];
	
	//add frames to ourself
	[self addAnimation:animation];
	
	//alloc our explosions tracker
	_explosions = [[NSMutableArray alloc] init];
	
	//add Shape
	self.shape = [spm addRectAt:self.position mass:4 width:8 height:20 rotation:0];
	shape->data = self;
	shape->collision_type = COLLECTOR_TYPE;
	
	//add a collision callback for particles
	cpSpaceAddCollisionPairFunc([spm getSpace], PARTICLE_TYPE, COLLECTOR_TYPE, &collParticleCollector, self);
	
	return self;
}

-(void) dealloc
{
	[_explosions release];
	[super dealloc];
}

-(void) addLightExplosionAt:(cpVect)pt
{
	//cleanup old explosions
	for (ParticleSystem* psc in _explosions)
	{
		if (!psc.active && psc.particleCount == 0)
			[self removeChild:psc cleanup:YES];
	}
	
	ccColorF white;
	white.r = 0.5f;
	white.g = 0.5f;
	white.b = 1.0f;
	white.a = 1.0f;
	
	ParticleSystem* ps = [ParticleSun node];
	ps.duration = .1;
	ps.size = 8;
	ps.startColor = white;
	//ps.position = cpvsub(self.position, pt);
	ps.position = pt;
	[self addChild:ps];
	[_explosions addObject:ps];
}

-(void) addTime:(ccTime)time
{
	_timeCollected += time;
}

-(void) step:(ccTime)time
{	
	_timeCollected -= time;
	
	if (_timeCollected < 0)
		_timeCollected = 0;
	else if (_timeCollected > MAX_TIME_COLLECTED)
		_timeCollected = MAX_TIME_COLLECTED;
	
	int oldFrame = _currentFrame;
	
	if (_timeCollected > 6)
		_currentFrame = 6;
	else if (_timeCollected > 5)
		_currentFrame = 5;
	else if (_timeCollected > 4)
		_currentFrame = 4;
	else if (_timeCollected > 3)
		_currentFrame = 3;
	else if (_timeCollected > 2)
		_currentFrame = 2;
	else if (_timeCollected > 1)
		_currentFrame = 1;
	else
		_currentFrame = 0;
	
	if (oldFrame != _currentFrame)
		[self setDisplayFrame:@"collector" index:_currentFrame];
}

- (float) getTimeCollected
{
	return _timeCollected;
}

- (BOOL) isFull
{
	return _currentFrame == 6;
}

@end

static int collParticleCollector(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data)
{
	LightParticle* lp = a->data;
	LightCollector* lc = b->data;

	if (lc.color == lp.color && [lc getTimeCollected] < MAX_TIME_COLLECTED-2)
	{	
		[lc addLightExplosionAt:cpv(5,7)];
		
		[lc addTime:1.8];
		[(LightEmitter*)[[lp parent] parent] recycleParticle:lp];
	}
	
	return 0;
}

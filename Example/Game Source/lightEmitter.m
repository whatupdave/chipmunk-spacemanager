//
//  lightParticle.m
//  Particles
//
//  Created by matt on 5/13/09.
//  Copyright 2009 Mobile-Bros. All rights reserved.
//

#import "LightEmitter.h"

@interface LightEmitter (PrivateMethods)

-(void) addEmitterSprite;
-(void) fireParticle;
-(void) zeroParticle:(LightParticle*)lp;
@end

@implementation LightEmitter

@synthesize life = _life;
@synthesize color = _color;
@synthesize emitVariance = _emitVariance;
@synthesize speedVariance = _speedVariance;

-(id) initAt:(cpVect)pos color:(Colors)color direction:(cpVect)dir life:(float)life spaceManager:(SpaceManager*)sm
{
	[super init];

	_life = life;
	_color = color;
	_totalParticles = 0;
	_emitDir = cpvnormalize(dir);
	_emitPos = pos;
	_emitVariance = 0;
	_speedVariance = 0;
	_smgr = sm;
	_queued = [[NSMutableSet alloc] init];
	_mgr = [AtlasSpriteManager spriteManagerWithFile:@"particles.png" capacity:1000];
	[self addChild:_mgr z:0];
	
	[self addEmitterSprite];
	
	return self;
}

- (void) dealloc
{
	[_queued removeAllObjects];
	[_queued release];

	[super dealloc];
}

-(void) addParticles:(int)count
{
	for (int i = 0; i < count; i++)
		[self addParticle];
}

-(void) addEmitterSprite
{	
	ParticleSystem *ps = [[ParticleFlower alloc] initWithTotalParticles:40];
	ps.radialAccel = -160;
	ps.position = _emitPos;
	ps.size = 12;
	
	float r;
	float g;
	float b;
	
	if (_color == GREEN)
	{
		r = b = 0.05;
		g = 0.9;
	}
	else if (_color == RED)
	{
		g = b = 0.05;
		r = 0.9;
	}
	else if (_color == BLUE)
	{
		r = g = 0.05;
		b = 0.9;	
	}
	else if (_color == WHITE)
	{
		r = b = g = 0.7;	
	}
	
	ccColorF startColor, endColor, startColorVar, endColorVar;
	
	startColor.r = r;
	startColor.g = g;
	startColor.b = b;
	
	endColor.r = r;
	endColor.g = g;
	endColor.b = b;
	endColor.a = 0.9;
	
	startColorVar.r = 0.0;
	startColorVar.g = 0.0;
	startColorVar.b = 0.0;
	startColorVar.a = 0.0;
	
	endColorVar.r = 0.0;
	endColorVar.g = 0.0;
	endColorVar.b = 0.0;
	endColorVar.a = 0.0;
	
	ps.startColor = startColor;
	ps.endColor = endColor;
	ps.startColorVar = startColorVar;
	ps.endColorVar = endColorVar;
	
	[self addChild:ps];
	[ps release];
}

-(void) addParticle
{	
	cpShape* s = [_smgr addCircleAt:_emitPos mass:1 radius:2];
	s->collision_type = PARTICLE_TYPE;
	
	LightParticle* lp = [[LightParticle alloc] initWithShape:s manager:_mgr color:WHITE];
	
	[self zeroParticle:lp];

	//[_smgr removeShape:lp.shape];

	lp.life = _life;
	lp.color = _color;
	lp.visible = NO;

	[_mgr addChild:lp];
	[self addChild:lp.streak]; //add the streak;
	[_queued addObject:lp];
	
	[lp release];
}

-(void) fireParticle
{
	if ([_queued count] != 0)
	{
		LightParticle* lp = [_queued anyObject];
		[self zeroParticle:lp];
		
		cpVect perp = cpvperp(_emitDir);
		cpVect pos = _emitPos;
		
		if (_emitVariance)
			pos = cpvadd(_emitPos, cpvmult(perp, -_emitVariance/2+(rand()%_emitVariance)));
		lp.position = pos;
		lp.visible = YES;
		
		[lp.streak setVisible:YES];
		
		lp.life = _life;
		lp.color = _color;
		
		int speed = LIGHT_SPEED;
		
		if (_speedVariance)
			speed += -_speedVariance/2 + (rand()%_speedVariance);
		
		cpBodyResetForces(lp.shape->body); //Make sure theres not weird force on it
		cpBodyApplyImpulse(lp.shape->body, cpvmult(_emitDir,speed), cpvzero);		
		
		[_queued removeObject:lp];
	}
}

-(void) zeroParticle:(LightParticle*)lp
{
	//effectively stop particle
	[lp.streak reset];
	[lp.streak setVisible:NO];
	lp.visible = NO;
	lp.position = cpv(-100,-100);
	lp.shape->body->v = cpvzero;
	lp.shape->body->w = 0.0;
	lp.shape->body->t = 0.0;	
}

-(void) recycleParticle:(LightParticle*)lp
{	
	[self zeroParticle:lp];
	[_queued addObject:lp];
}

-(void) setColor:(Colors)c
{
	_color = c;
}

-(void) step:(ccTime)dt
{
	static ccTime t = 0.0;
	
	t+=dt;
	float r = .11+((rand()%25)/100.0);
	
	if (t > r)
	{
		[self fireParticle];
		t = 0.0;
	}
}

@end

/*********************************************************************
 *	
 *	cpAtlasSprite
 *
 *	cpAtlasSprite.m
 *
 *	Chipmunk Atlas Sprite Object
 *
 *	http://www.mobile-bros.com
 *
 *	Created by Robert Blackwood on 02/22/2009.
 *	Copyright 2009 Mobile Bros. All rights reserved.
 *
 **********************************************************************/

#import "cpAtlasSprite.h"


@implementation cpAtlasSprite

+ (id) spriteWithShape:(cpShape*)s manager:(AtlasSpriteManager*)sm rect:(CGRect)rect
{
	return [[[self alloc] initWithShape:s manager:sm rect:rect] autorelease];
}

-(id)initWithShape:(cpShape*)s manager:(AtlasSpriteManager*)sm rect:(CGRect)rect
{
	[super initWithRect:rect spriteManager:sm];
	_implementation = [[cpCCNode alloc] initWithShape:s];
	if (s)
		s->data = self;

	
	return self;
}

- (void) dealloc
{
	[_implementation release];
	[super dealloc];
}

-(void)setRotation:(float)rot
{	
	[_implementation setRotation:rot oldRotation:rotation_];
	[super setRotation:rot];
}

-(void)setPosition:(cpVect)pos
{
	[_implementation setPosition:pos oldPosition:position_];	
	[super setPosition:pos];
}

-(void) applyImpulse:(cpVect)impulse
{
	[_implementation applyImpulse:impulse];
}

-(void) applyForce:(cpVect)force
{
	[_implementation applyForce:force];
}

-(void) resetForces
{
	[_implementation resetForces];
}


///property implementation
-(void) setIgnoreRotation:(BOOL)ignore
{
	_implementation.ignoreRotation = ignore;
}

-(BOOL) ignoreRotation
{
	return _implementation.ignoreRotation;
}

-(void) setIntegrationDt:(cpFloat)dt
{
	_implementation.integrationDt = dt;
}

-(cpFloat) integrationDt
{
	return _implementation.integrationDt;
}

-(void) setShape:(cpShape*)shape
{
	_implementation.shape = shape;
}

-(cpShape*) shape
{
	return _implementation.shape;
}


@end

/*********************************************************************
 *	
 *	Chipmunk Sprite
 *
 *	cpSprite.m
 *
 *	Chipmunk Sprite Object
 *
 *	http://www.mobile-bros.com
 *
 *	Created by Robert Blackwood on 04/24/2009.
 *	Copyright 2009 Mobile Bros. All rights reserved.
 *
 **********************************************************************/

#import "cpSprite.h"


@implementation cpSprite

+ (id) spriteWithShape:(cpShape*)s file:(NSString*) filename
{
	return [[[self alloc] initWithShape:s file:filename] autorelease];
}

- (id) initWithShape:(cpShape*)s file:(NSString*) filename
{
	[super initWithFile:filename];
	
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

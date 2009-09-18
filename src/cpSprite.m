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

@synthesize shape = _shape;
@synthesize ignoreRotation = _ignoreRotation;
@synthesize integrateSetPosition = _integrateSetPosition;

+ (id) spriteWithShape:(cpShape*)s file:(NSString*) filename
{
	return [[[self alloc] initWithShape:s file:filename] autorelease];
}

- (id) initWithShape:(cpShape*)s file:(NSString*) filename
{
	[super initWithFile:filename];
	
	_shape = s;
	s->data = self;
	
	_integrateSetPosition = YES;
	
	return self;
}

-(void)setRotation:(float)rot
{	
	if (!_ignoreRotation)
	{
		[super setRotation:rot];	
		if (_shape != nil)
			cpBodySetAngle(_shape->body, -CC_DEGREES_TO_RADIANS(self.rotation));
	}
}

-(void)setPosition:(cpVect)pos
{
	cpVect oldPos = self.position;
	
	[super setPosition:pos];
	if (_shape != nil)
	{
		if (cpvlength(cpvsub(_shape->body->p,pos)) != 0)
		{
			_shape->body->p = self.position;

		//Experimental (Euler integration)
			if (_integrateSetPosition)
			{
				cpVect velocity = cpvmult(cpvsub(pos,oldPos), 30); //mult by 30 cause dt is 1/30
				_shape->body->v = velocity;
			}
		}
	}
}

-(void) applyImpulse:(cpVect)impulse
{
	if (_shape != nil)
		cpBodyApplyImpulse(_shape->body, impulse, cpvzero);
}

-(void) applyForce:(cpVect)force
{
	if (_shape != nil)
		cpBodyApplyForce(_shape->body, force, cpvzero);	
}

-(void) resetForces
{
	if (_shape != nil)
		cpBodyResetForces(_shape->body);
}

@end

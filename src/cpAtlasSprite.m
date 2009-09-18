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

@synthesize shape = _shape;
@synthesize ignoreRotation = _ignoreRotation;
@synthesize integrateSetPosition = _integrateSetPosition;

+ (id) spriteWithShape:(cpShape*)s manager:(AtlasSpriteManager*)sm rect:(CGRect)rect
{
	return [[[self alloc] initWithShape:s manager:sm rect:rect] autorelease];
}

-(id)initWithShape:(cpShape*)s manager:(AtlasSpriteManager*)sm rect:(CGRect)rect
{
	_shape = s;
	s->data = self;	
	return self;
}

-(void)setRotation:(float)rot
{	
	if (!_ignoreRotation)
	{
		[super setRotation:rot];	
		if (_shape != nil)
			cpBodySetAngle(_shape->body, CC_DEGREES_TO_RADIANS(-self.rotation));
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

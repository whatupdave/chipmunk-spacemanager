/*********************************************************************
 *	
 *	cpCCNodeImpl.m
 *
 *	http://www.mobile-bros.com
 *
 *	Created by Robert Blackwood on 02/22/2009.
 *	Copyright 2009 Mobile Bros. All rights reserved.
 *
 **********************************************************************/

#import "cpCCNode.h"


@implementation cpCCNodeImpl

@synthesize shape = _shape;
@synthesize ignoreRotation = _ignoreRotation;
@synthesize integrationDt = _integrationDt;
@synthesize spaceManager = _spaceManager;
@synthesize autoFreeShape = _autoFreeShape;

- (id) init
{
	return [self initWithShape:nil];
}

- (id) initWithShape:(cpShape*)s
{	
	_shape = s;
	_integrationDt = 1.0/60.0;
	
	return self;
}

-(void) dealloc
{
	if (_shape)
	{
		_shape->data = NULL;
		if (_autoFreeShape)
			[_spaceManager scheduleToRemoveAndFreeShape:_shape];
	}
	_shape = nil;
		
	[super dealloc];
}

-(BOOL)setRotation:(float)rot
{	
	if (!_ignoreRotation)
	{	
		//Needs a calculation for angular velocity and such
		if (_shape != nil)
			cpBodySetAngle(_shape->body, -CC_DEGREES_TO_RADIANS(rot));
	}
	
	return !_ignoreRotation;
}

-(void)setPosition:(cpVect)pos
{	
	if (_shape != nil)
	{
		//If we're out of sync with chipmunk
		if (cpvlength(cpvsub(_shape->body->p,pos)) != 0)
		{
			//(Basic Euler integration)
			if (_integrationDt)
				cpBodySlew(_shape->body, pos, _integrationDt);
			
			//update position
			_shape->body->p = pos;
			
			//If we're static, we need to tell our space that we've changed
			if (_spaceManager && _shape->body->m == STATIC_MASS)
				[_spaceManager rehashStaticShape:_shape];
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


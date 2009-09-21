/*********************************************************************
 *	
 *	cpCCNode.m
 *
 *	Example
 *
 *	Manage the space for the application
 *
 *	http://www.mobile-bros.com
 *
 *	Created by Robert Blackwood on 02/22/2009.
 *	Copyright 2009 Mobile Bros. All rights reserved.
 *
 **********************************************************************/

#import "cpCCNode.h"


@implementation cpCCNode

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
	if (_autoFreeShape)
		[_spaceManager removeAndFreeShape:_shape];
		
	[super dealloc];
}

-(void)setRotation:(float)rot oldRotation:(float)oldRot
{	
	if (!_ignoreRotation)
	{	
		if (_shape != nil)
			cpBodySetAngle(_shape->body, -CC_DEGREES_TO_RADIANS(rot));
	}
}

-(void)setPosition:(cpVect)pos oldPosition:(cpVect)oldPos
{	
	if (_shape != nil)
	{
		if (cpvlength(cpvsub(_shape->body->p,pos)) != 0)
		{
			_shape->body->p = pos;
			
			//Experimental, integrationDt should go away
			if (_integrationDt)
			{
				if (_spaceManager)
					cpBodyUpdateVelocity(_shape->body, _spaceManager.gravity, _spaceManager.damping,_spaceManager.lastDt);
				else
				{
					//(Basic Euler integration)
					cpVect velocity = cpvmult(cpvsub(pos,oldPos), 1.0/_integrationDt);
					_shape->body->v = velocity;
				}
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


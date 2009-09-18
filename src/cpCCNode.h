/*********************************************************************
 *	
 *	cpCCNode.h
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

#import "chipmunk.h"
#import "cocos2d.h"


@interface cpCCNode : NSObject {

@protected
	cpShape* _shape;
	BOOL	_ignoreRotation;
	cpFloat	_integrationDt;
	
}

@property (readwrite,assign) BOOL ignoreRotation;
@property (readwrite,assign) cpFloat integrationDt;
@property (readwrite,assign) cpShape *shape;

- (id) initWithShape:(cpShape*)s;

-(void)setRotation:(float)rot oldRotation:(float)oldRot;
-(void)setPosition:(cpVect)pos oldPosition:(cpVect)oldPos;

-(void) applyImpulse:(cpVect)impulse;
-(void) applyForce:(cpVect)force;
-(void) resetForces;

@end

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
#import "SpaceManager.h"


@interface cpCCNode : NSObject {

@protected
	cpShape*		_shape;
	SpaceManager*	_spaceManager;
	BOOL			_ignoreRotation;
	BOOL		_autoFreeShape;
	cpFloat		_integrationDt;	
}

@property (readwrite,assign) BOOL ignoreRotation;
@property (readwrite,assign) BOOL autoFreeShape;
@property (readwrite,assign) cpFloat integrationDt;
@property (readwrite,assign) cpShape *shape;
@property (readwrite,assign) SpaceManager *spaceManager;

- (id) initWithShape:(cpShape*)s;

-(void)setRotation:(float)rot oldRotation:(float)oldRot;
-(void)setPosition:(cpVect)pos oldPosition:(cpVect)oldPos;

-(void) applyImpulse:(cpVect)impulse;
-(void) applyForce:(cpVect)force;
-(void) resetForces;

@end

#define CPCCNODE_MEM_VARS cpCCNode *_implementation;

#define CPCCNODE_MEM_VARS_INIT(shape)	\
_implementation = [[cpCCNode alloc] initWithShape:shape];\
if (shape)\
	shape->data = self;

#define CPCCNODE_FUNC_DECLARE	\
@property (readwrite,assign) BOOL ignoreRotation;\
@property (readwrite,assign) cpFloat integrationDt;\
@property (readwrite,assign) BOOL autoFreeShape;\
@property (readwrite,assign) cpShape *shape;\
@property (readwrite,assign) SpaceManager *spaceManager;\
-(void) applyImpulse:(cpVect)impulse;\
-(void) applyForce:(cpVect)force;\
-(void) resetForces;

#define CPCCNODE_FUNC_SRC	\
- (void) dealloc\
{\
	[_implementation release];\
	[super dealloc];\
}\
-(void)setRotation:(float)rot\
{\
	[_implementation setRotation:rot oldRotation:rotation_];\
	[super setRotation:rot];\
}\
-(void)setPosition:(cpVect)pos\
{\
	[_implementation setPosition:pos oldPosition:position_];\
	[super setPosition:pos];\
}\
-(void) applyImpulse:(cpVect)impulse\
{\
	[_implementation applyImpulse:impulse];\
}\
-(void) applyForce:(cpVect)force\
{\
	[_implementation applyForce:force];\
}\
\
-(void) resetForces\
{\
	[_implementation resetForces];\
}\
-(void) setIgnoreRotation:(BOOL)ignore\
{\
	_implementation.ignoreRotation = ignore;\
}\
-(BOOL) ignoreRotation\
{\
	return _implementation.ignoreRotation;\
}\
-(void) setIntegrationDt:(cpFloat)dt\
{\
	_implementation.integrationDt = dt;\
}\
-(cpFloat) integrationDt\
{\
	return _implementation.integrationDt;\
}\
-(void) setShape:(cpShape*)shape\
{\
	_implementation.shape = shape;\
}\
-(cpShape*) shape\
{\
	return _implementation.shape;\
}\
-(void) setSpaceManager:(SpaceManager*)spaceManager\
{\
_implementation.spaceManager = spaceManager;\
}\
-(SpaceManager*) spaceManager\
{\
return _implementation.spaceManager;\
}\
-(void) setAutoFreeShape:(BOOL)autoFree\
{\
_implementation.autoFreeShape = autoFree;\
}\
-(BOOL) autoFreeShape\
{\
return _implementation.autoFreeShape;\
}

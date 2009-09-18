/*********************************************************************
 *	
 *	Space Manager
 *
 *	SpaceManager.h
 *
 *	Manage the space for the application
 *
 *	http://www.mobile-bros.com
 *
 *	Created by Robert Blackwood on 02/22/2009.
 *	Copyright 2009 Mobile Bros. All rights reserved.
 *
 **********************************************************************/

//Comment this out if you don't want cocos2d support
//(cleaner to move it to target specific options)
#define _SPACE_MANAGER_FOR_COCOS2D

// 0x00 HI ME LO
// 00   00 00 01
#define SPACE_MANAGER_VERSION 0x00000001

#ifdef _SPACE_MANAGER_FOR_COCOS2D
#import "cocos2d.h"
#endif
#import "chipmunk.h"

//A more definitive sounding define
#define STATIC_MASS	INFINITY

void defaultEachShape(void *ptr, void* data);

@interface SpaceManager : NSObject
{
	
@private
	/* our chipmunk space! */
	cpSpace			*_space;
	
	/* Internal devices */
	NSMutableArray	*_freeShapes;
	NSMutableArray	*_removedShapes;
	NSMutableArray	*_invocations;
	Timer			*_timer;
	
	/* Helpful Shapes/Bodies */
	cpShape			*topWall,*bottomWall,*rightWall,*leftWall;
	cpBody			*_staticBody;
	
	/* Number of steps (across dt) perform on each step call */
	int		_steps;
	
	/* Options:
		-cleanupBodyDepenencies will also free contraints connected to a free'd shape
		-iterateStatic will call _iterateFunc on static shapes
		-iterateFunc; default will update cocosnodes for pos and rotation
		-constantDt; set this to a non-zero number to always step the simulation with that dt
	*/
	BOOL				_cleanupBodyDependencies;
	BOOL				_iterateStatic;
	cpSpaceHashIterator	_iterateFunc;
	cpFloat				_constantDt;
}

@property (readwrite, assign) cpShape *topWall,*bottomWall,*rightWall,*leftWall;
@property (readwrite, assign) int steps;
@property (readwrite, assign) BOOL iterateStatic;
@property (readwrite, assign) cpSpaceHashIterator iterateFunc;
@property (readonly) cpBody *staticBody;
@property (readwrite, assign) cpFloat constantDt;
@property (readwrite, assign) BOOL cleanupBodyDependencies;

-(id) initWithSize:(int)size count:(int)count;

#ifdef _SPACE_MANAGER_FOR_COCOS2D
-(void) start;
-(void) start:(float)dt;
-(void) stop;
#endif

-(void) step: (ccTime) delta;

-(cpSpace*) getSpace;

-(void) addWindowContainmentWithFriction:(cpFloat)friction elasticity:(cpFloat) elasticity inset:(cpVect)inset;

-(cpShape*) addCircleAt:(cpVect)pos mass:(cpFloat)mass radius:(int)radius;
-(cpShape*) addRectAt:(cpVect)pos mass:(cpFloat)mass width:(int)width height:(int)height rotation:(cpFloat)r;
-(cpShape*) addPolyAt:(cpVect)pos mass:(cpFloat)mass rotation:(cpFloat)r numPoints:(int)numPoints points:(cpVect)pt, ... ;

-(cpShape*) getShapeAt:(cpVect)pos layers:(cpLayers)layers group:(cpLayers)group;
-(cpShape*) getShapeAt:(cpVect)pos;

/* Use if you need to call getShapes before you've actually started simulating */
- (void) rehashActiveShapes;
- (void) rehashStaticShapes;

/*! This function actually returns an Array of NSValues with pointers... (incompatability with C objects)
	Use [value pointerValue] to pull out the cpShape
 */
-(NSArray*) getShapesAt:(cpVect)pos layers:(cpLayers)layers group:(cpLayers)group;
-(NSArray*) getShapesAt:(cpVect)pos;

/*! Queries the space as to whether this two shapes are in persistent contact */
-(BOOL) isPersistentContactOnShape:(cpShape*)shape contactShape:(cpShape*)shape2;

/*! Will return an array of NSValues that point to the cpConstraints */
-(NSArray*) getConstraints;
-(NSArray*) getConstraintsOnBody:(cpBody*)body;

/*! Use schedule when removing & freeing shapes during collisions */
-(void) scheduleToRemoveAndFreeShape:(cpShape*)shape;
-(void) removeAndFreeShape:(cpShape*)shape;

/*! Use schedule when removing shapes during collisions */
-(void) scheduleToRemoveShape:(cpShape*)shape;
-(void) removeShape:(cpShape*)shape;
-(void) addShape:(cpShape*)shape;

-(cpShape*) morphShapeToStatic:(cpShape*)shape;
-(cpShape*) morphShapeToActive:(cpShape*)shape mass:(cpFloat)mass;

-(void) ignoreCollionBetweenType:(unsigned int)type1 otherType:(unsigned int)type2;
-(void) addCollisionCallbackBetweenType:(unsigned int)type1 otherType:(unsigned int)type2 target:(id)target selector:(SEL)selector;
-(void) removeCollisionCallbackBetweenType:(unsigned int)type1 otherType:(unsigned int)type2;

-(void) removeConstraint:(cpConstraint*)constraint;
-(void) removeAndFreeConstraint:(cpConstraint*)constraint;
-(void) removeAndFreeConstraintsOnBody:(cpBody*)body;

/*! All our constraints that we can add */
-(cpConstraint*) addSpringToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody toBodyAnchor:(cpVect)anchr1 fromBodyAnchor:(cpVect)anchr2 restLength:(cpFloat)rest stiffness:(cpFloat)stiff damping:(cpFloat)damp;
-(cpConstraint*) addSpringToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody restLength:(cpFloat)rest stiffness:(cpFloat)stiff damping:(cpFloat)damp;
-(cpConstraint*) addSpringToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody stiffness:(cpFloat)stiff;

-(cpConstraint*) addGrooveToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody grooveAnchor1:(cpVect)groove1 grooveAnchor2:(cpVect)groove2 fromBodyAnchor:(cpVect)anchor2;
-(cpConstraint*) addGrooveToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody grooveLength:(cpFloat)length isHorizontal:(bool)horiz fromBodyAnchor:(cpVect)anchor2;
-(cpConstraint*) addGrooveToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody grooveLength:(cpFloat)length isHorizontal:(bool)horiz;

-(cpConstraint*) addSlideToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody toBodyAnchor:(cpVect)anchr1 fromBodyAnchor:(cpVect)anchr2 minLength:(cpFloat)min maxLength:(cpFloat)max;
-(cpConstraint*) addSlideToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody minLength:(cpFloat)min maxLength:(cpFloat)max;

-(cpConstraint*) addPinToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody toBodyAnchor:(cpVect)anchr1 fromBodyAnchor:(cpVect)anchr2;
-(cpConstraint*) addPinToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody;

-(cpConstraint*) addPivotToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody toBodyAnchor:(cpVect)anchr1 fromBodyAnchor:(cpVect)anchr2;
-(cpConstraint*) addPivotToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody worldAnchor:(cpVect)anchr;
-(cpConstraint*) addPivotToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody;

-(cpConstraint*) addMotorToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody rate:(cpFloat)rate;
-(cpConstraint*) addMotorToBody:(cpBody*)toBody rate:(cpFloat)rate;

-(cpConstraint*) addGearToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody phase:(cpFloat)phase ratio:(cpFloat)ratio;
-(cpConstraint*) addGearToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody ratio:(cpFloat)ratio;

-(cpConstraint*) addBreakableToConstraint:(cpConstraint*)breakConstraint maxForce:(cpFloat)max;

-(cpConstraint*) addRotaryLimitToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody min:(cpFloat)min max:(cpFloat)max;
-(cpConstraint*) addRotaryLimitToBody:(cpBody*)toBody min:(cpFloat)min max:(cpFloat)max;

-(cpConstraint*) addRatchetToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody direction:(cpFloat)direction;
-(cpConstraint*) addRatchetToBody:(cpBody*)toBody direction:(cpFloat)direction;

-(cpConstraint*) addRotarySpringToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody restAngle:(cpFloat)restAngle stiffness:(cpFloat)stiff damping:(cpFloat)damp;
-(cpConstraint*) addRotarySpringToBody:(cpBody*)toBody restAngle:(cpFloat)restAngle stiffness:(cpFloat)stiff damping:(cpFloat)damp;

@end

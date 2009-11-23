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
// 00   00 00 04
#define SPACE_MANAGER_VERSION 0x00000004

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
#ifdef _SPACE_MANAGER_FOR_COCOS2D
	Timer			*_timer;
#endif
	
	/* Helpful Shapes/Bodies */
	cpShape			*topWall,*bottomWall,*rightWall,*leftWall;
	cpBody			*_staticBody;
	
	/* Number of steps (across dt) perform on each step call */
	int		_steps;
	
	/* The dt used last within step */
	cpFloat	_lastDt;
	
	/* hack to fix rehashing one static */
	BOOL _rehashNextStep;
	
	/* Options:
		-cleanupBodyDepenencies will also free contraints connected to a free'd shape
		-iterateStatic will call _iterateFunc on static shapes
		-rehashStaticEveryStep will rehash static shapes at the end of every step
		-iterateFunc; default will update cocosnodes for pos and rotation
		-constantDt; set this to a non-zero number to always step the simulation with that dt
	*/
	BOOL				_cleanupBodyDependencies;
	BOOL				_iterateStatic;
	BOOL				_rehashStaticEveryStep;
	cpSpaceHashIterator	_iterateFunc;
	cpFloat				_constantDt;
}

/*! The actual chipmunk space */
@property (readonly) cpSpace* space;

@property (readwrite, assign) cpShape *topWall,*bottomWall,*rightWall,*leftWall;

/*! Number of steps (across dt) perform on each step call */
@property (readwrite, assign) int steps;

/*! The dt value that was used in step last */
@property (readonly) cpFloat lastDt;

/*! The gravity of the space */
@property (readwrite, assign) cpVect gravity;

/*! The damping of the space (viscousity in "air") */
@property (readwrite, assign) cpFloat damping;

/*! If this is set to YES/TRUE then step will call iterateFunc on static shapes */
@property (readwrite, assign) BOOL iterateStatic;

/*! If this is set to YES/TRUE then step will call rehashStatic before stepping */
@property (readwrite, assign) BOOL rehashStaticEveryStep;

/*! Set the iterateFunc; the default will update cocosnodes for pos and rotation */
@property (readwrite, assign) cpSpaceHashIterator iterateFunc;

/*! A staticBody for any particular reusable purpose */
@property (readonly) cpBody *staticBody;

/*! If this is set to anything other than zero, the step routine will use its
 value as the dt (constant) */
@property (readwrite, assign) cpFloat constantDt;

/*! Setting this to YES/TRUE will also free contraints connected to a free'd shape */
@property (readwrite, assign) BOOL cleanupBodyDependencies;

/*! initialization method
	@param size The average size of shapes in space
	@param count The expected number of shapes in a space (larger is better)
 */
-(id) initWithSize:(int)size count:(int)count;

/* initialization method that takes a precreated space */
-(id) initWithSpace:(cpSpace*)space;

///Incomplete///
-(void) loadSpaceFromFile:(NSString*)file;
-(void) saveSpaceToFile:(NSString*)file;
-(void) loadSpaceFromPath:(NSString*)path;
-(void) saveSpaceToPath:(NSString*)path;

#ifdef _SPACE_MANAGER_FOR_COCOS2D

/*! Schedule a timed loop (against step:) using Cocos2d's default dt */
-(void) start;

/*! Schedule a timed loop (against step:) using dt */
-(void) start:(float)dt;

/*! Stop the timed loop */
-(void) stop;

/*! Convenience method for adding a containment rect around the view */
-(void) addWindowContainmentWithFriction:(cpFloat)friction elasticity:(cpFloat) elasticity inset:(cpVect)inset;

#endif

/*! Manually advance time within the space */
-(void) step: (cpFloat) delta;

/*! add a circle shape */
-(cpShape*) addCircleAt:(cpVect)pos mass:(cpFloat)mass radius:(cpFloat)radius;

/*! add a rectangle shape */
-(cpShape*) addRectAt:(cpVect)pos mass:(cpFloat)mass width:(cpFloat)width height:(cpFloat)height rotation:(cpFloat)r;

/*! add a polygon shape */
-(cpShape*) addPolyAt:(cpVect)pos mass:(cpFloat)mass rotation:(cpFloat)r numPoints:(int)numPoints points:(cpVect)pt, ... ;

/* add a segment shape using world coordinates */
-(cpShape*) addSegmentAtWorldAnchor:(cpVect)fromPos toWorldAnchor:(cpVect)toPos mass:(cpFloat)mass radius:(cpFloat)radius;

/* add a segment shape using local coordinates */
-(cpShape*) addSegmentAt:(cpVect)pos fromLocalAnchor:(cpVect)fromPos toLocalAnchor:(cpVect)toPos mass:(cpFloat)mass radius:(cpFloat)radius;

/*! Retrieve the first shape found at this position matching layers and group */
-(cpShape*) getShapeAt:(cpVect)pos layers:(cpLayers)layers group:(cpLayers)group;

/*! Retrieve the first shape found at this position */
-(cpShape*) getShapeAt:(cpVect)pos;

/*! Use if you need to call getShapes before you've actually started simulating */
-(void) rehashActiveShapes;

/*! Use if you move static shapes during simulation */
-(void) rehashStaticShapes;

/*! Use to only rehash one static shape */
-(void) rehashStaticShape:(cpShape*)shape;

/*! Return an array of NSValues with a pointer to a cpShape */
-(NSArray*) getShapesAt:(cpVect)pos layers:(cpLayers)layers group:(cpLayers)group;

/*! @see getShapesAt:layers:group: */
-(NSArray*) getShapesAt:(cpVect)pos;

/*! Queries the space as to whether this two shapes are in persistent contact */
-(BOOL) isPersistentContactOnShape:(cpShape*)shape contactShape:(cpShape*)shape2;

/*! Queries the space as to whether this shape has ANY persistent contact */
-(cpShape*) persistentContactOnShape:(cpShape*)shape;

/*! Will return an array of NSValues that point to the cpConstraints */
-(NSArray*) getConstraints;

/*! Will return an array of NSValues that point to the cpConstraints on given body */
-(NSArray*) getConstraintsOnBody:(cpBody*)body;

/*! Schedule is used for removing & freeing shapes during collisions */
-(void) scheduleToRemoveAndFreeShape:(cpShape*)shape;

/*! Use when removing & freeing shapes */
-(void) removeAndFreeShape:(cpShape*)shape;

/*! Schedule is used for removing shapes during collisions, ownership is given to caller */
-(void) scheduleToRemoveShape:(cpShape*)shape;

/*! Use when removing shapes, will pass ownership to caller */
-(cpShape*) removeShape:(cpShape*)shape;

/*! Manually add a shape to the space */
-(void) addShape:(cpShape*)shape;

/*! This will force a shape into a static shape */
-(cpShape*) morphShapeToStatic:(cpShape*)shape;

/*! This will force a shape active and give it the given mass */
-(cpShape*) morphShapeToActive:(cpShape*)shape mass:(cpFloat)mass;

/*! This will take a shape (any) and split it into the number of pieces you specify,
	@return An NSArray* of NSValues* with cpShape* as the value (the fragments) or nil if failed
 */
-(NSArray*) fragmentShape:(cpShape*)shape piecesNum:(int)pieces eachMass:(float)mass;

/*! This will take a rect and split it into the number of pieces (Rows x Cols) you specify,
 @return An NSArray* of NSValues* with cpShape* as the value (the fragments) or nil if failed
 */
-(NSArray*) fragmentRect:(cpPolyShape*)poly rowPiecesNum:(int)rows colPiecesNum:(int)cols eachMass:(float)mass;

/*! This will take a circle and split it into the number of pieces you specify,
 @return An NSArray* of NSValues* with cpShape* as the value (the fragments) or nil if failed
 */
-(NSArray*) fragmentCircle:(cpCircleShape*)circle piecesNum:(int)pieces eachMass:(float)mass;

/*! This will take a segment and split it into the number of pieces you specify,
 @return An NSArray* of NSValues* with cpShape* as the value (the fragments) or nil if failed
 */
-(NSArray*) fragmentSegment:(cpSegmentShape*)segment piecesNum:(int)pieces eachMass:(float)mass;

/*! */
//-(void) mergeShape:(cpShape*)shape withShape:(cpShape*)shape2;

/*! Unique Collision: will ignore the effects a collsion between types */
-(void) ignoreCollionBetweenType:(unsigned int)type1 otherType:(unsigned int)type2;

/*! Register a collision callback between types */
-(void) addCollisionCallbackBetweenType:(unsigned int)type1 otherType:(unsigned int)type2 target:(id)target selector:(SEL)selector;

/*! Unregister a collision callback between types */
-(void) removeCollisionCallbackBetweenType:(unsigned int)type1 otherType:(unsigned int)type2;

/*! Use when removing constraints, ownership is given to caller*/
-(cpConstraint*) removeConstraint:(cpConstraint*)constraint;

/*! This will remove and free the constraint */
-(void) removeAndFreeConstraint:(cpConstraint*)constraint;

/*! This will calculate all constraints on a body and remove & free them */
-(void) removeAndFreeConstraintsOnBody:(cpBody*)body;

/*! Add a spring to two bodies at the body anchor points */
-(cpConstraint*) addSpringToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody toBodyAnchor:(cpVect)anchr1 fromBodyAnchor:(cpVect)anchr2 restLength:(cpFloat)rest stiffness:(cpFloat)stiff damping:(cpFloat)damp;
-(cpConstraint*) addSpringToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody restLength:(cpFloat)rest stiffness:(cpFloat)stiff damping:(cpFloat)damp;
-(cpConstraint*) addSpringToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody stiffness:(cpFloat)stiff;

/*! Add a groove (aka sliding pin) between two bodies */
-(cpConstraint*) addGrooveToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody grooveAnchor1:(cpVect)groove1 grooveAnchor2:(cpVect)groove2 fromBodyAnchor:(cpVect)anchor2;
-(cpConstraint*) addGrooveToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody grooveLength:(cpFloat)length isHorizontal:(bool)horiz fromBodyAnchor:(cpVect)anchor2;
-(cpConstraint*) addGrooveToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody grooveLength:(cpFloat)length isHorizontal:(bool)horiz;

/*! Add a sliding joint between two bodies */
-(cpConstraint*) addSlideToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody toBodyAnchor:(cpVect)anchr1 fromBodyAnchor:(cpVect)anchr2 minLength:(cpFloat)min maxLength:(cpFloat)max;
-(cpConstraint*) addSlideToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody minLength:(cpFloat)min maxLength:(cpFloat)max;

/*! Create a pin (rod) between two bodies */
-(cpConstraint*) addPinToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody toBodyAnchor:(cpVect)anchr1 fromBodyAnchor:(cpVect)anchr2;
-(cpConstraint*) addPinToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody;

/*! Add a shared point between two bodies that they may rotate around */
-(cpConstraint*) addPivotToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody toBodyAnchor:(cpVect)anchr1 fromBodyAnchor:(cpVect)anchr2;
-(cpConstraint*) addPivotToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody worldAnchor:(cpVect)anchr;
-(cpConstraint*) addPivotToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody;

/*! Add a motor that applys torque to a specified body(s) */
-(cpConstraint*) addMotorToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody rate:(cpFloat)rate;
-(cpConstraint*) addMotorToBody:(cpBody*)toBody rate:(cpFloat)rate;

/*! Add gears between two bodies */
-(cpConstraint*) addGearToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody phase:(cpFloat)phase ratio:(cpFloat)ratio;
-(cpConstraint*) addGearToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody ratio:(cpFloat)ratio;

/*! */
-(cpConstraint*) addBreakableToConstraint:(cpConstraint*)breakConstraint maxForce:(cpFloat)max;

/*! */
-(cpConstraint*) addRotaryLimitToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody min:(cpFloat)min max:(cpFloat)max;
-(cpConstraint*) addRotaryLimitToBody:(cpBody*)toBody min:(cpFloat)min max:(cpFloat)max;

/*! */
-(cpConstraint*) addRatchetToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody direction:(cpFloat)direction;
-(cpConstraint*) addRatchetToBody:(cpBody*)toBody direction:(cpFloat)direction;

/*! */
-(cpConstraint*) addRotarySpringToBody:(cpBody*)toBody fromBody:(cpBody*)fromBody restAngle:(cpFloat)restAngle stiffness:(cpFloat)stiff damping:(cpFloat)damp;
-(cpConstraint*) addRotarySpringToBody:(cpBody*)toBody restAngle:(cpFloat)restAngle stiffness:(cpFloat)stiff damping:(cpFloat)damp;

@end

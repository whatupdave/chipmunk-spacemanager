/*********************************************************************
 *	
 *	cpShapeNode.h
 *
 *	Provide Drawing for Shapes
 *
 *	http://www.mobile-bros.com
 *
 *	Created by Robert Blackwood on 02/22/2009.
 *	Copyright 2009 Mobile Bros. All rights reserved.
 *
 **********************************************************************/

#import "cocos2d.h"
#import "chipmunk.h"
#import "cpCCNode.h"


@interface cpShapeNode : CCNode <CCRGBAProtocol, cpCCNodeProtocol>
{
@protected	
	ccColor3B _color;
	GLubyte _opacity;
	
	cpFloat _pointSize;
	cpFloat _lineWidth;
	BOOL	_smoothDraw;
	BOOL	_fillShape;
	BOOL	_drawDecoration;
	
	CPCCNODE_MEM_VARS;
}

/*! Color of our drawn shape */
@property (readwrite, assign) ccColor3B color;

/*! Opacity of our drawn shape */
@property (readwrite, assign) GLubyte opacity;

/*! Size of drawn points, default is 3 */
@property (readwrite, assign) cpFloat pointSize;

/*! Width of the drawn lines, default is 1 */
@property (readwrite, assign) cpFloat lineWidth;

/*! If this is set to YES/TRUE then the shape will be drawn
 with smooth lines/points */
@property (readwrite, assign) BOOL smoothDraw;

/*! If this is set to YES/TRUE then the shape will be filled
 when drawn */
@property (readwrite, assign) BOOL fillShape;

/*! Currently only circle has a "decoration" it is an extra line
 to see the rotation */
@property (readwrite, assign) BOOL drawDecoration;

/*! Use if you do not want the sprite to rotate with the shape */
@property (readwrite,assign) BOOL ignoreRotation;

/*! If this is anything other than zero, a position change will update the
 shapes velocity using integrationDt to calculate it */
@property (readwrite,assign) cpFloat integrationDt;

/*! If this is set to true & spaceManager is set, then the shape
 is deleted when dealloc is called */
@property (readwrite,assign) BOOL autoFreeShape;

/*! The shape we're connected to */
@property (readwrite,assign) cpShape *shape;

/*! The space manager, set this if you want autoFreeShape to work */
@property (readwrite,assign) SpaceManager *spaceManager;

/*! Apply an impulse (think gun shot) to our shape's body */
-(void) applyImpulse:(cpVect)impulse;

/*! Apply a constant force to our shape's body */
-(void) applyForce:(cpVect)force;

/*! Reset any forces accrued on this shape's body */
-(void) resetForces;

/*! Return an autoreleased node */
+ (id) nodeWithShape:(cpShape*)shape;

/*! Initialization Method */
- (id) initWithShape:(cpShape*)shape;

@end

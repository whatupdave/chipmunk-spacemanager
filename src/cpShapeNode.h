/*********************************************************************
 *	
 *	cpShapeNode
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


@interface cpShapeNode : CocosNode <CocosNodeRGBA>
{
@protected
	cpShape *_shape;
	
	ccColor3B _color;
	GLubyte _opacity;
	
	cpFloat _pointSize;
	cpFloat _lineWidth;
	BOOL	_smoothDraw;
	BOOL	_fillShape;
	BOOL	_drawDecoration;
	BOOL	_integrateSetPosition;
}
	
@property (readonly) cpShape* shape;
@property (readwrite, assign) ccColor3B color;
@property (readwrite, assign) GLubyte opacity;

@property (readwrite, assign) cpFloat pointSize;
@property (readwrite, assign) cpFloat lineWidth;
@property (readwrite, assign) BOOL smoothDraw;
@property (readwrite, assign) BOOL fillShape;
@property (readwrite, assign) BOOL drawDecoration;
@property (readwrite, assign) BOOL integrateSetPosition;


+ (id) nodeWithShape:(cpShape*)shape;
- (id) initWithShape:(cpShape*)shape;

@end

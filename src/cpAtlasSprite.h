/*********************************************************************
 *	
 *	cpAtlasSprite
 *
 *	cpAtlasSprite.h
 *
 *	Chipmunk Atlas Sprite Object
 *
 *	http://www.mobile-bros.com
 *
 *	Created by Robert Blackwood on 02/22/2009.
 *	Copyright 2009 Mobile Bros. All rights reserved.
 *
 **********************************************************************/

#import "cocos2d.h"
#import "chipmunk.h"

@interface cpAtlasSprite : AtlasSprite 
{
@protected
	cpShape*	_shape;
	BOOL		_ignoreRotation;
	BOOL		_integrateSetPosition;
}

@property (readwrite,assign) cpShape *shape;
@property (readwrite,assign) BOOL ignoreRotation;
@property (readwrite,assign) BOOL integrateSetPosition;

+ (id) spriteWithShape:(cpShape*)s manager:(AtlasSpriteManager*)sm rect:(CGRect)rect;
- (id) initWithShape:(cpShape*)s manager:(AtlasSpriteManager*)sm rect:(CGRect)rect;

-(void) applyImpulse:(cpVect)impulse;
-(void) applyForce:(cpVect)force;
-(void) resetForces;

@end

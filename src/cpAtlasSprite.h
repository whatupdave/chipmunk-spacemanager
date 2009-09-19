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
#import "cpCCNode.h"

@interface cpAtlasSprite : AtlasSprite 
{
	CPCCNODE_MEM_VARS
}

@property (readwrite,assign) BOOL ignoreRotation;
@property (readwrite,assign) cpFloat integrationDt;
@property (readwrite,assign) BOOL autoFreeShape;
@property (readwrite,assign) cpShape *shape;
@property (readwrite,assign) SpaceManager *spaceManager;

-(void) applyImpulse:(cpVect)impulse;
-(void) applyForce:(cpVect)force;

+ (id) spriteWithShape:(cpShape*)s manager:(AtlasSpriteManager*)sm rect:(CGRect)rect;
- (id) initWithShape:(cpShape*)s manager:(AtlasSpriteManager*)sm rect:(CGRect)rect;

@end

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

CPCCNODE_FUNC_DECLARE

+ (id) spriteWithShape:(cpShape*)s manager:(AtlasSpriteManager*)sm rect:(CGRect)rect;
- (id) initWithShape:(cpShape*)s manager:(AtlasSpriteManager*)sm rect:(CGRect)rect;

@end

/*********************************************************************
 *	
 *	cpAtlasSprite
 *
 *	cpAtlasSprite.m
 *
 *	Chipmunk Atlas Sprite Object
 *
 *	http://www.mobile-bros.com
 *
 *	Created by Robert Blackwood on 02/22/2009.
 *	Copyright 2009 Mobile Bros. All rights reserved.
 *
 **********************************************************************/

#import "cpAtlasSprite.h"


@implementation cpAtlasSprite

+ (id) spriteWithShape:(cpShape*)shape manager:(AtlasSpriteManager*)sm rect:(CGRect)rect
{
	return [[[self alloc] initWithShape:shape manager:sm rect:rect] autorelease];
}

-(id)initWithShape:(cpShape*)shape manager:(AtlasSpriteManager*)sm rect:(CGRect)rect
{
	[super initWithRect:rect spriteManager:sm];
	
	CPCCNODE_MEM_VARS_INIT(shape)
	
	[self setPosition:shape->body->p];
	[self setRotation:CC_RADIANS_TO_DEGREES(-shape->body->a)];
	
	return self;
}

CPCCNODE_FUNC_SRC

@end

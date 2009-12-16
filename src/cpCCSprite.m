/*********************************************************************
 *	
 *	Chipmunk Sprite
 *
 *	cpSprite.m
 *
 *	Chipmunk Sprite Object
 *
 *	http://www.mobile-bros.com
 *
 *	Created by Robert Blackwood on 04/24/2009.
 *	Copyright 2009 Mobile Bros. All rights reserved.
 *
 **********************************************************************/

#import "cpCCSprite.h"


@implementation cpCCSprite

+ (id) spriteWithShape:(cpShape*)shape file:(NSString*) filename
{
	return [[[self alloc] initWithShape:shape file:filename] autorelease];
}

- (id) initWithShape:(cpShape*)shape file:(NSString*) filename
{
	[super initWithFile:filename];
	
	CPCCNODE_MEM_VARS_INIT(shape)
	
	return self;
}

-(id) initWithShape:(cpShape*)shape spriteSheet:(CCSpriteSheet*)spriteSheet rect:(CGRect)rect
{
	[self initWithTexture:[spriteSheet.textureAtlas texture] rect:rect];
	[self setParentIsSpriteSheet:YES];
	[self setTextureAtlas:textureAtlas_];

	return self;
}

CPCCNODE_FUNC_SRC

@end
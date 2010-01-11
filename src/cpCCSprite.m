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

+ (id) spriteWithShape:(cpShape*)shape spriteSheet:(CCSpriteSheet*)spriteSheet rect:(CGRect)rect
{
	return [[[self alloc] initWithShape:shape spriteSheet:spriteSheet rect:rect] autorelease];
}

+ (id) spriteWithShape:(cpShape *)shape texture:(CCTexture2D*)texture
{
	return [[[self alloc] initWithShape:shape texture:texture] autorelease];
}

+ (id) spriteWithShape:(cpShape *)shape texture:(CCTexture2D*)texture rect:(CGRect)rect
{
	return [[[self alloc] initWithShape:shape texture:texture rect:rect] autorelease];
}

+ (id) spriteWithShape:(cpShape *)shape texture:(CCTexture2D*)texture rect:(CGRect)rect offset:(CGPoint) offset
{	
	return [[[self alloc] initWithShape:shape texture:texture rect:rect offset:offset] autorelease];
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
	
	CPCCNODE_MEM_VARS_INIT(shape)

	return self;
}

- (id) initWithShape:(cpShape *)shape texture:(CCTexture2D*)texture
{
	CGRect rect = CGRectZero;
	rect.size = texture.contentSize;
	return [self initWithShape:shape texture:texture rect:rect];
}

- (id) initWithShape:(cpShape *)shape texture:(CCTexture2D*)texture rect:(CGRect)rect
{
	return [self initWithTexture:texture rect:rect offset:CGPointZero];
}

- (id) initWithShape:(cpShape *)shape texture:(CCTexture2D*)texture rect:(CGRect)rect offset:(CGPoint)offset
{
	[super initWithTexture:texture rect:rect offset:offset];
	
	CPCCNODE_MEM_VARS_INIT(shape)
	
	return self;
}

CPCCNODE_FUNC_SRC

@end
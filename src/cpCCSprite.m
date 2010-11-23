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

+ (id) spriteWithShape:(cpShape*)shape spriteSheet:(CCSpriteBatchNode*)spriteSheet rect:(CGRect)rect
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

- (id) initWithShape:(cpShape*)shape file:(NSString*) filename
{
	[super initWithFile:filename];
	
	CPCCNODE_MEM_VARS_INIT(shape)
	
	return self;
}

-(id) initWithShape:(cpShape*)shape spriteSheet:(CCSpriteBatchNode*)spriteSheet rect:(CGRect)rect
{
	[super initWithBatchNode:spriteSheet rect:rect];
	
	CPCCNODE_MEM_VARS_INIT(shape)

	return self;
}

- (id) initWithShape:(cpShape *)shape texture:(CCTexture2D*)texture
{
	[super initWithTexture:texture];
	
	CPCCNODE_MEM_VARS_INIT(shape)
	
	return self;
}

- (id) initWithShape:(cpShape *)shape texture:(CCTexture2D*)texture rect:(CGRect)rect
{
	[super initWithTexture:texture rect:rect];
	
	CPCCNODE_MEM_VARS_INIT(shape)
	
	return self;
}

#define RENDER_IN_SUBPIXEL

-(void) draw
{
	cpShape *shape = _implementation.shape;
	if (shape && shape->klass->type == CP_CIRCLE_SHAPE)
	{
		cpVect offset = cpCircleShapeGetOffset(shape);
		
		if (offset.x != 0 && offset.y != 0)
		{
			glPushMatrix();
			ccglTranslate(RENDER_IN_SUBPIXEL(offset.x*CC_CONTENT_SCALE_FACTOR()), 
						  RENDER_IN_SUBPIXEL(offset.y*CC_CONTENT_SCALE_FACTOR()), 0);
			[super draw];
			glPopMatrix();
		}
		else
			[super draw];
	}
	else
		[super draw];
}

CPCCNODE_FUNC_SRC

@end
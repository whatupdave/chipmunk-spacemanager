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

#import "cpSprite.h"


@implementation cpSprite

+ (id) spriteWithShape:(cpShape*)s file:(NSString*) filename
{
	return [[[self alloc] initWithShape:s file:filename] autorelease];
}

- (id) initWithShape:(cpShape*)s file:(NSString*) filename
{
	[super initWithFile:filename];
	
	CPCCNODE_MEM_VARS_INIT(s)
	
	return self;
}

CPCCNODE_FUNC_SRC

@end
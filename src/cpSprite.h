/*********************************************************************
 *	
 *	Chipmunk Sprite
 *
 *	cpSprite.h
 *
 *	Chipmunk Sprite Object
 *
 *	http://www.mobile-bros.com
 *
 *	Created by Robert Blackwood on 04/24/2009.
 *	Copyright 2009 Mobile Bros. All rights reserved.
 *
 **********************************************************************/

#import "cocos2d.h"
#import "chipmunk.h"
#import "cpCCNode.h"

@interface cpSprite : Sprite 
{
	CPCCNODE_MEM_VARS
}

CPCCNODE_FUNC_DECLARE

+ (id) spriteWithShape:(cpShape*)s file:(NSString*) filename;
- (id) initWithShape:(cpShape*)s file:(NSString*) filename;


@end

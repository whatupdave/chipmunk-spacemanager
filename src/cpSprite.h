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
	cpCCNode *_implementation;
}

@property (readwrite,assign) BOOL ignoreRotation;
@property (readwrite,assign) cpFloat integrationDt;
@property (readwrite,assign) cpShape *shape;

+ (id) spriteWithShape:(cpShape*)s file:(NSString*) filename;
- (id) initWithShape:(cpShape*)s file:(NSString*) filename;

-(void) applyImpulse:(cpVect)impulse;
-(void) applyForce:(cpVect)force;
-(void) resetForces;

@end

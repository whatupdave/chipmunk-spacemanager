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

@interface cpSprite : CCSprite<cpCCNodeDelegate>
{
	CPCCNODE_MEM_VARS;
}

/*! Use if you do not want the sprite to rotate with the shape */
@property (readwrite,assign) BOOL ignoreRotation;

/*! If this is anything other than zero, a position change will update the
 shapes velocity using integrationDt to calculate it */
@property (readwrite,assign) cpFloat integrationDt;

/*! If this is set to true & spaceManager is set, then the shape
 is deleted when dealloc is called */
@property (readwrite,assign) BOOL autoFreeShape;

/*! The shape we're connected to */
@property (readwrite,assign) cpShape *shape;

/*! The space manager, set this if you want autoFreeShape to work */
@property (readwrite,assign) SpaceManager *spaceManager;

/*! Apply an impulse (think gun shot) to our shape's body */
-(void) applyImpulse:(cpVect)impulse;

/*! Apply a constant force to our shape's body */
-(void) applyForce:(cpVect)force;

/*! Return an autoreleased cpSprite */
+ (id) spriteWithShape:(cpShape*)shape file:(NSString*) filename;

/*! Initialization method */
- (id) initWithShape:(cpShape*)shape file:(NSString*) filename;


@end

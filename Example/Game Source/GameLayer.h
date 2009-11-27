//
//  GameLayer.h
//  Example For Example
//
//  Created by Rob Blackwood on 5/11/09.
//

#import "cocos2d.h"
#import "SpaceManager.h"
#import "cpSprite.h"
#import "cpShapeNode.h"

#pragma mark GameLayer Class
@interface GameLayer : Layer
{
	SpaceManager *smgr;
	cpSprite *ballSprite;
	cpShapeNode *fragShapeNode;
	Label *label;
}

@property (readonly) Label *label;

- (void) doFragmentingAction;

@end


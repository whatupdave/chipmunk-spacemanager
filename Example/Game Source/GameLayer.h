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
@interface GameLayer : CCLayer
{
	SpaceManager *smgr;
	cpSprite *ballSprite;
	CCLabel *label;
}

@property (readonly) CCLabel *label;

@end


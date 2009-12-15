//
//  GameLayer.h
//  Example For Example
//
//  Created by Rob Blackwood on 5/11/09.
//

#import "cocos2d.h"
#import "SpaceManager.h"
#import "cpCCSprite.h"
#import "cpShapeNode.h"

#pragma mark GameLayer Class
@interface GameLayer : CCLayer
{
	SpaceManager *smgr;
	cpCCSprite *ballSprite;
	CCLabel *label;
}

@property (readonly) CCLabel *label;

@end


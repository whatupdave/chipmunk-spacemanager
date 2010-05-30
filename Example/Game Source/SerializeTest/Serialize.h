//
//  Serialize.h
//  Example For Example
//
//  Created by Rob Blackwood on 5/30/10.
//

#import "cocos2d.h"
#import "SpaceManager.h"
#import "cpCCSprite.h"
#import "cpShapeNode.h"

#pragma mark Serialize Class
@interface Serialize : CCLayer<SpaceManagerSerializeDelegate>
{
	SpaceManager *smgr;
	NSMutableArray *balls;
}

-(BOOL) aboutToReadShape:(cpShape*)shape shapeId:(long)id;

@end


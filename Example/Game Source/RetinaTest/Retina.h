//
//  Retina.h
//  Example
//
//  Created by Robert Blackwood on 11/1/10.
//  Copyright Mobile Bros 2010. All rights reserved.
//

#import "cocos2d.h"
#import "chipmunk.h"
#import "SpaceManager.h"

@interface Retina : CCLayer
{
	SpaceManager *smgr;
	CGPoint _lastPt;
}

-(void) step: (ccTime) dt;
-(BOOL) drawTerrainAt:(CGPoint)pt;

@end

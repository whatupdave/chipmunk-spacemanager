//
//  LightCollector.h
//  Particles
//
//  Created by Robert Blackwood on 5/16/09.
//  Copyright 2009 isee systems. All rights reserved.
//

#import "cpSprite.h"
#import "SpaceManager.h"
#import "lightParticle.h"

#define COLLECTOR_TYPE	2
#define MAX_TIME_COLLECTED 9

@interface LightCollector : cpSprite 
{
	float _timeCollected;
	int	  _currentFrame;
	
	NSMutableArray* _explosions;
	Colors _color;
}
@property (readwrite, assign) Colors color;

- (id) initWithSpaceManager:(SpaceManager*)spm color:(Colors)c;
- (void) addTime:(ccTime)time;
- (void) step:(ccTime)time;

- (float) getTimeCollected;
- (BOOL) isFull;

@end

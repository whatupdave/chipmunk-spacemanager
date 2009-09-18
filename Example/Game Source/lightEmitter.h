//
//  lightParticle.h
//  Particles
//
//  Created by matt on 5/13/09.
//  Copyright 2009 Mobile-Bros. All rights reserved.
//

#import "cocos2d.h"
#import "LightParticle.h"
#import "SpaceManager.h"

#define LIGHT_SPEED 100

@interface LightEmitter : Layer 
{
	AtlasSpriteManager 	*_mgr;
	SpaceManager 		*_smgr;
	NSMutableSet		*_queued;
	Colors				_color;
	
	int	_speedVariance;
	int	_emitVariance;
	
	cpVect	_emitPos;
	cpVect 	_emitDir;

	float	_life;
	int		_totalParticles;
}

@property (readwrite,assign) int speedVariance;
@property (readwrite,assign) int emitVariance;
@property (readwrite,assign,setter=setColor:) Colors color;
@property (readwrite,assign) float life;

-(id) initAt:(cpVect)pos color:(Colors)color direction:(cpVect)dir life:(float)life spaceManager:(SpaceManager*)sm;
-(void) addParticles:(int)count;
-(void) addParticle;
-(void) recycleParticle:(LightParticle*)lp;
-(void) step:(ccTime)dt;
-(void) setColor:(Colors)c;

@end

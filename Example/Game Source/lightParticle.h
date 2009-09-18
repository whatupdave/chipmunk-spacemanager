//
//  lightParticle.h
//  Particles
//
//  Created by matt on 5/13/09.
//  Copyright 2009 Mobile-Bros. All rights reserved.
//

#import "SpaceManager.h"
#import "cpAtlasSprite.h"
#import "MotionStreak.h"

#define PARTICLE_TYPE	1

#define PARTICLE_SIZE	4

typedef enum {
	GREEN = 0,
	BLUE = 1,
	RED = 2,
	WHITE = 3
}Colors;

@interface LightParticle : cpAtlasSprite 
{
	Colors	_color;
	float	life;	
	MotionStreak *streak;
}

@property (readwrite,assign, setter=setColor:) Colors color;
@property (readwrite,assign) float life;
@property (readwrite,assign) MotionStreak* streak;

- (id) initWithShape:(cpShape*)s manager:(AtlasSpriteManager*)sm color:(Colors)c;

- (void)setColor:(Colors)color;
- (void)setGreen;
- (void)setBlue;
- (void)setRed;
- (void)setWhite;
@end

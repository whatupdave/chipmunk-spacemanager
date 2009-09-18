//
//  particleChanger.h
//  Particles
//
//  Created by matt on 5/18/09.
//  Copyright 2009 Mobile-Bros. All rights reserved.
//

#import "SpaceManager.h"
#import "cocos2d.h"
#import "lightParticle.h"

#define CHANGER_TYPE 4

@interface ParticleChanger : Sprite {
	SpaceManager* _spm;
	int	_radius;
	Colors _color; 
}
@property (readwrite, assign) Colors color;

// methods go here
- (id) initWithSpaceManager:(SpaceManager*)spm position:(cpVect)pos file:(NSString*)file radius:(int)radius color:(Colors)c;
- (void) setPosition:(cpVect)pos;
- (BOOL) pointInChanger:(cpVect)pt;

@end

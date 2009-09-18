//
//  Orb.h
//  Particles
//
//  Created by Matt Blackwood on 5/11/09.
//  Copyright 2009 Mobile-Bros. All rights reserved.
//

#import "SpaceManager.h"
#import "cpSprite.h"

#define ORB_TYPE 3
#define MIN_RADIUS 20
#define MAX_RADIUS 70

@interface Orb : cpSprite 
{
	SpaceManager* _spm;
	ForceField*	_ff;
	float	_radius;
	Sprite* _selected;
}

//methods go here
- (id)initWithSpaceManager:(SpaceManager*)spm position:(cpVect)pos force:(cpVect)f file:(NSString*)file radius:(int)radius rotation:(float)r;

-(BOOL)pointInOrb:(cpVect)pt;
-(float)radius;
-(void)resizeOrbBySize:(float)size;
-(void)setOrbSelected:(BOOL)isSelected;

@end

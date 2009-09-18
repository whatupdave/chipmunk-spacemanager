//
//  particleChanger.m
//  Particles
//
//  Created by matt on 5/18/09.
//  Copyright 2009 Mobile-Bros. All rights reserved.
//

#import "particleChanger.h"


static int collChangeColor(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data);

@implementation ParticleChanger

@synthesize color = _color;

- (id) initWithSpaceManager:(SpaceManager*)spm position:(cpVect)pos file:(NSString*)file radius:(int)radius color:(Colors)c
{
	[super initWithFile:file];

	_color = c;
	_radius = radius;
	_spm = spm;
	
	self.position = pos;	
	cpShape *shape = [_spm addCircleAt:pos mass:4 radius: _radius];
	shape->collision_type = CHANGER_TYPE; 
	shape->data = self;
	
	int angle = 360;
	if (rand()%2)
		angle *= -1;
	if (rand()%2)
		angle += 35;
	
	id action = [RepeatForever actionWithAction:[RotateBy actionWithDuration:8.0 angle:angle]];
	[self runAction:action];	 
	
	cpSpaceAddCollisionPairFunc([_spm getSpace], PARTICLE_TYPE, CHANGER_TYPE, &collChangeColor, nil);
	
	return self;
}

- (void) setRotation:(float)rot
{
	//dilemma... chipmunk tries to set rotation every step,
	//however the it always tries to set it to zero, so we catch it
	if (rot != 0)
		[super setRotation:rot];
}

- (void) setPosition:(cpVect)pos
{
	[super setPosition:pos];	
	cpSpaceRehashStatic([_spm getSpace]);
}

- (BOOL) pointInChanger:(cpVect)pt
{
	return cpvlength(cpvsub(pt, self.position)) < _radius;
}

@end

static int collChangeColor(cpShape *a, cpShape *b, cpContact *contacts, int numContacts, cpFloat normal_coef, void *data)
{
	LightParticle* lp = a->data;
	ParticleChanger* pc = b->data;
	
	switch(pc.color)
	{
		case GREEN: [lp setGreen]; break;
		case BLUE: [lp setBlue]; break;
		case RED: [lp setRed]; break;
		case WHITE: [lp setWhite]; break;
	}
	
	return 0;
}



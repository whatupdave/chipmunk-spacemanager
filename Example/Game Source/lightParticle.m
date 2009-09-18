//
//  lightParticle.m
//  Particles
//
//  Created by matt on 5/13/09.
//  Copyright 2009 Mobile-Bros. All rights reserved.
//

#import "lightParticle.h"
@implementation LightParticle

@synthesize life;
@synthesize streak;
@synthesize color = _color;

- (id) initWithShape:(cpShape*)s manager:(AtlasSpriteManager*)sm color:(Colors)c
{
	[super initWithRect:CGRectMake(0,0,PARTICLE_SIZE,PARTICLE_SIZE) spriteManager:sm];
	self.shape = s;
	s->data = self;
	
	_color = c;
	
	//motion streak stuff here//
	streak = [MotionStreak streakWithFade:.2 minSeg:1 image:@"particleWhite.png" width:3 length:3 color:0xFFFFFF00];
	
	return self;
}

- (void) setPosition:(cpVect) pos
{
	[super setPosition:pos];
	[streak setPosition:pos];
}

-(void) setOpacity:(GLubyte) op
{
	[super setOpacity:op];
}

- (void) setColor:(Colors)color
{
	if (color == GREEN)
		[self setGreen];
	else if (color == RED)
		[self setRed];
	else if (color == BLUE)
		[self setBlue];
	else if (color == WHITE)
		[self setWhite];
}


- (void) setGreen
{
	_color = GREEN;
	[self setTextureRect:CGRectMake(0,0,PARTICLE_SIZE,PARTICLE_SIZE)];
	streak.color = 0x9EFF9B00;
}

- (void) setRed
{
	_color = RED;
	[self setTextureRect:CGRectMake(0,PARTICLE_SIZE,PARTICLE_SIZE,PARTICLE_SIZE)];
	streak.color = 0xFF8C9000;
}

- (void) setBlue
{
	_color = BLUE;
	[self setTextureRect:CGRectMake(0,PARTICLE_SIZE*2,PARTICLE_SIZE,PARTICLE_SIZE)];
	streak.color = 0x89A7FF00;
}

- (void) setWhite
{
	_color = WHITE;
	[self setTextureRect:CGRectMake(0,PARTICLE_SIZE*3,PARTICLE_SIZE,PARTICLE_SIZE)];
	streak.color = 0xC0C0C000;
}

@end

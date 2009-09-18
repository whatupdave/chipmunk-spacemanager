//
//  Orb.m
//  Particles
//
//  Created by Matt Blackwood on 5/11/09.
//  Copyright 2009 Mobile-Bros. All rights reserved.
//

#import "Orb.h"

void drawOrbCircle( float x, float y, float r, int segs);
void setOrbGLColor(uint color);

@implementation Orb

- (id)initWithSpaceManager:(SpaceManager*)spm position:(cpVect)pos force:(cpVect)f file:(NSString*)file radius:(int)radius rotation:(float)rotate
{
	[super initWithFile:file];
	
	_selected = [Sprite spriteWithFile:@"selected_orb.png"];
	_selected.position = transformAnchor;
	_selected.opacity = 0;
	
	[self addChild:_selected];
	
	if (radius > MAX_RADIUS)
		_radius = MAX_RADIUS;
	else if (radius < MIN_RADIUS)
		_radius = MIN_RADIUS;
	else
		_radius = radius;
	
	_spm = spm;
	self.position = pos;	
	
	_ff = [[spm addCircleForceFieldAt:pos force:f radius:_radius] retain];
	self.shape = _ff.shape;
	self.rotation = rotate;

	return self;
}

-(void) dealloc
{
	[_ff release];
	[super dealloc];
}

-(void)setPosition:(cpVect)pos
{
	[super setPosition:pos];
	
	// Try to optimize, be efficient and don't rehash everytime
	static int hashCounter = 1;
	if (hashCounter++ > 1)
	{
		hashCounter = 0;
		cpSpaceRehashStatic([_spm getSpace]);
	}
}

-(BOOL)pointInOrb:(cpVect)pt
{
	float rad = _radius;
	
	if (rad <= MIN_RADIUS)
		rad += 5;
	
	return cpvlength(cpvsub(pt, self.position)) <= rad;
}

-(float)radius
{
	return _radius;
}

-(void)draw
{
	[super draw];
	
	if (self.visible && self.opacity > 0)
		drawOrbCircle(transformAnchor.x, transformAnchor.y, _radius, 20);
}

/* resize the orb - used by two touch event for orb resizing */
-(void)resizeOrbBySize:(float)size
{
	if ((_radius + size) > MAX_RADIUS)
		((cpCircleShape*)(self.shape))->r = MAX_RADIUS;
	else if ((_radius + size) < MIN_RADIUS)
		((cpCircleShape*)(self.shape))->r = MIN_RADIUS;
	else
		((cpCircleShape*)(self.shape))->r += size;

	_radius = ((cpCircleShape*)(self.shape))->r;
	cpSpaceRehashStatic([_spm getSpace]);
}

/* change orb image depending on it's selected state */
-(void)setOrbSelected:(BOOL)isSelected
{
	if (isSelected && _selected.opacity == 0)
	{		
		id select_action = [FadeIn actionWithDuration:.25];
		[_selected runAction:select_action];
	}
	else if (!isSelected && _selected.opacity > 0)
	{
		id unselect_action = [FadeOut actionWithDuration:.25];
		[_selected runAction:unselect_action];
	}
}

-(void) setOpacity:(GLubyte)op
{
	[super setOpacity:op];
	_selected.opacity = op;
}

@end

void drawOrbCircle( float x, float y, float r, int segs)
{
	float j, k, a = 0;
	
	const float coef = 2.0f * (float)M_PI/segs;
	
	float *vertices = malloc( sizeof(float)*2*(segs+2));
	if( ! vertices )
		return;
	
	memset( vertices,0, sizeof(float)*2*(segs+2));
	
	for(int i=0;i<=segs;i++)
	{
		float rads = i*coef;
		j = r * cosf(rads + a) + x;
		k = r * sinf(rads + a) + y;
		
		vertices[i*2] = j;
		vertices[i*2+1] =k;
	}
	vertices[(segs+1)*2] = j;
	vertices[(segs+1)*2+1] = k;
	
	setOrbGLColor(0xE2E2E270);
	
	glLineWidth(1.0);
	glVertexPointer(2, GL_FLOAT, 0, vertices);
	glEnableClientState(GL_VERTEX_ARRAY);
	glDrawArrays(GL_LINE_STRIP, 0, segs+2);
	glDisableClientState(GL_VERTEX_ARRAY);
	
	free( vertices );
}

void setOrbGLColor(uint color)
{
	GLubyte r = color >> 24 & 0xFF;
    GLubyte g = color >> 16 & 0xFF;
    GLubyte b = color >> 8 & 0xFF;
    GLubyte a = color & 0xDD;
	
	glColor4ub(r, g, b, a); 
}
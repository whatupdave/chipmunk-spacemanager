/*********************************************************************
 *	
 *	cpShapeNode.m
 *
 *	Provide Drawing for Shapes
 *
 *	http://www.mobile-bros.com
 *
 *	Created by Robert Blackwood on 02/22/2009.
 *	Copyright 2009 Mobile Bros. All rights reserved.
 *
 **********************************************************************/

#import "cpShapeNode.h"
#import "CCDrawingPrimitives.h"


@interface cpShapeNode (PrivateMethods)
- (void) drawCircleShape;
- (void) drawPolyShape;
- (void) drawSegmentShape;
@end


@implementation cpShapeNode

@synthesize color = _color;
@synthesize opacity = _opacity;
@synthesize pointSize = _pointSize;
@synthesize lineWidth = _lineWidth;
@synthesize smoothDraw = _smoothDraw;
@synthesize fillShape = _fillShape;
@synthesize drawDecoration = _drawDecoration;


- (id) initWithShape:(cpShape*)shape;
{
	[super initWithShape:shape];
	
	_color = ccBLACK;
	_opacity = 255;
	_pointSize = 3;
	_lineWidth = 1;
	_smoothDraw = NO;	
	_fillShape = YES;
	_drawDecoration = YES;
	
	return self;
}

- (void) draw
{
	[super draw];
	
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisable(GL_TEXTURE_2D);
	
	glPointSize(_pointSize);
	glLineWidth(_lineWidth);
	if (_smoothDraw && _lineWidth <= 1) //OpelGL ES doesn't support smooth lineWidths > 1
	{
		glEnable(GL_LINE_SMOOTH);
		glEnable(GL_POINT_SMOOTH);
	}
	else
	{
		glDisable(GL_LINE_SMOOTH);
		glDisable(GL_POINT_SMOOTH);
	}
	
	if( _opacity != 255 )
		glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
		
	glColor4ub(_color.r, _color.g, _color.b, _opacity);
	
	switch(_implementation.shape->klass->type)
	{
		case CP_CIRCLE_SHAPE:
			[self drawCircleShape];
			break;
		case CP_SEGMENT_SHAPE:
			[self drawSegmentShape];
			break;
		case CP_POLY_SHAPE:
			[self drawPolyShape];
			break;
	}
	
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
	
	if( _opacity != 255 )
		glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
}

- (void) drawCircleShape
{
	
	static const GLfloat circleVAR[] = {
		0.0000,  1.0000,
		0.2588,  0.9659,
		0.5000,  0.8660,
		0.7071,  0.7071,
		0.8660,  0.5000,
		0.9659,  0.2588,
		1.0000,  0.0000,
		0.9659, -0.2588,
		0.8660, -0.5000,
		0.7071, -0.7071,
		0.5000, -0.8660,
		0.2588, -0.9659,
		0.0000, -1.0000,
		-0.2588, -0.9659,
		-0.5000, -0.8660,
		-0.7071, -0.7071,
		-0.8660, -0.5000,
		-0.9659, -0.2588,
		-1.0000, -0.0000,
		-0.9659,  0.2588,
		-0.8660,  0.5000,
		-0.7071,  0.7071,
		-0.5000,  0.8660,
		-0.2588,  0.9659,
		0.0000,  1.0000,
		0.0f, 0.45f, // For an extra line to see the rotation.
	};
	static const int circleVAR_count = sizeof(circleVAR)/sizeof(GLfloat)/2;
	
	cpCircleShape *circle = (cpCircleShape*)_implementation.shape;
	//cpBody *body = _shape->body;
	int extraPtOffset = _drawDecoration ? 0 : 1;
	
	glVertexPointer(2, GL_FLOAT, 0, circleVAR);
	
	glPushMatrix(); {
		//cpVect center = cpvadd(body->p, cpvrotate(circle->c, body->rot));
		//glTranslatef(center.x, center.y, 0.0f);
		//glRotatef(body->a*180.0/M_PI, 0.0f, 0.0f, 1.0f);
		glScalef(circle->r, circle->r, 1.0f);
		
		if (_fillShape)
			glDrawArrays(GL_TRIANGLE_FAN, 0, circleVAR_count-extraPtOffset-1);
		else
			glDrawArrays(GL_LINE_STRIP, 0, circleVAR_count-extraPtOffset);
	} glPopMatrix();
}

-(void)drawSegmentShape
{
	static const GLfloat pillVAR[] = {
		0.0000,  1.0000,
		0.2588,  0.9659,
		0.5000,  0.8660,
		0.7071,  0.7071,
		0.8660,  0.5000,
		0.9659,  0.2588,
		1.0000,  0.0000,
		0.9659, -0.2588,
		0.8660, -0.5000,
		0.7071, -0.7071,
		0.5000, -0.8660,
		0.2588, -0.9659,
		0.0000, -1.0000,
		
		0.0000, -1.0000,
		-0.2588, -0.9659,
		-0.5000, -0.8660,
		-0.7071, -0.7071,
		-0.8660, -0.5000,
		-0.9659, -0.2588,
		-1.0000, -0.0000,
		-0.9659,  0.2588,
		-0.8660,  0.5000,
		-0.7071,  0.7071,
		-0.5000,  0.8660,
		-0.2588,  0.9659,
		0.0000,  1.0000,
	};
	static const int pillVAR_count = sizeof(pillVAR)/sizeof(GLfloat)/2;
	
	cpSegmentShape *seg = (cpSegmentShape*)_implementation.shape;
	
	cpVect a = seg->a;//cpvadd(body->p, cpvrotate(seg->a, body->rot));
	cpVect b = seg->b;//cpvadd(body->p, cpvrotate(seg->b, body->rot));
		
	if(seg->r){
		cpVect delta = cpvsub(b, a);
		cpFloat len = cpvlength(delta)/seg->r;
		
		GLfloat VAR[pillVAR_count*2];
		memcpy(VAR, pillVAR, sizeof(pillVAR));
		
		for(int i=0, half=pillVAR_count; i<half; i+=2)
			VAR[i] += len;
		
		glVertexPointer(2, GL_FLOAT, 0, VAR);
		glPushMatrix(); {
			GLfloat x = a.x;
			GLfloat y = a.y;
			GLfloat cos = delta.x/len;
			GLfloat sin = delta.y/len;
			
			const GLfloat matrix[] = {
				cos,  sin, 0.0f, 0.0f,
				-sin,  cos, 0.0f, 0.0f,
				0.0f, 0.0f, 1.0f, 1.0f,
				x,    y, 0.0f, 1.0f,
			};
			
			glMultMatrixf(matrix);
			
			if (_fillShape)
				glDrawArrays(GL_TRIANGLE_FAN, 0, pillVAR_count);
			else
				glDrawArrays(GL_LINE_LOOP, 0, pillVAR_count);
		} glPopMatrix();
	} else 
	{
		float *array = malloc( sizeof(float)*4);
		array[0] = a.x;
		array[1] = a.y;
		array[2] = b.x;
		array[3] = b.y;
		
		glVertexPointer(2, GL_FLOAT, 0, array);
		
		glDrawArrays(GL_LINES, 0, 2);	
		
		free(array);
	}
}

- (void) drawPolyShape
{
	cpPolyShape *poly = (cpPolyShape*)_implementation.shape;
	
	int count = count=poly->numVerts;
	GLfloat VAR[count*2];
	glVertexPointer(2, GL_FLOAT, 0, VAR);
	
	cpVect *verts = poly->verts;
	for(int i=0; i<count; i++){
		cpVect v = verts[i];//cpvadd(body->p, cpvrotate(verts[i], body->rot));
		VAR[2*i    ] = v.x;
		VAR[2*i + 1] = v.y;
	}
	
	if (_fillShape)
		glDrawArrays(GL_TRIANGLE_FAN, 0, count);
	else
		glDrawArrays(GL_LINE_LOOP, 0, count);
}

@end

//
//  Retina.m
//  Example
//
//  Created by Robert Blackwood on 11/1/10.
//  Copyright Mobile Bros 2010. All rights reserved.
//


// Import the interfaces
#import "Retina.h"
#import "cpShapeNode.h"
#import "cpConstraintNode.h"


@implementation Retina

-(id) init
{
	if( (self=[super init])) 
	{
		smgr = [[SpaceManagerCocos2d alloc] init];
		[smgr addWindowContainmentWithFriction:1.0 elasticity:1.0 inset:cpv(0,0)];
		
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
		
		self.isAccelerometerEnabled = YES;
		[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1.0/30.0f];
		
		cpShapeNode *ball = [cpShapeNode nodeWithShape:[smgr addCircleAt:ccp(240,160) mass:50 radius:14]];
		ball.color = ccRED;
		[self addChild:ball];
		
		cpShapeNode *box = [cpShapeNode nodeWithShape:[smgr addRectAt:ccp(300,200) mass:50 width:28 height:28 rotation:0]];
		box.color = ccBLUE;
		[self addChild:box];
		
		cpConstraintNode *pin = [cpConstraintNode nodeWithConstraint:[smgr addPinToBody:ball.shape->body
																			   fromBody:box.shape->body]];
		pin.color = ccORANGE;
		[self addChild:pin];
		
		cpConstraintNode *gear = [cpConstraintNode nodeWithConstraint:[smgr addGearToBody:ball.shape->body
																				 fromBody:box.shape->body
																					ratio:2]];
		gear.color = ccGREEN;
		[self addChild:gear];
		
		[smgr addMotorToBody:ball.shape->body rate:3];
		
		//// Quick Ray test
		[smgr step:1/60.0];
		CGPoint dir = ccpNormalize(ccpSub(ball.position, box.position));
		CGPoint pt1 = ccpAdd(ball.position, ccpMult(dir, -100));
		CGPoint pt2 = ccpAdd(box.position, ccpMult(dir, 100));

		NSArray *array = [smgr getShapesFromRayCastSegment:pt1 end:pt2];
		NSAssert([array count] == 2, @"Raycast did not find ball and box");
		
		array = [smgr getInfosFromRayCastSegment:pt1 end:pt2];
		NSAssert([array count] == 2, @"Raycast did not find ball and box infos");
		/////////////////////
		
		[self schedule: @selector(step:)];
	}
	
	return self;
}

-(void) dealloc
{
	[smgr release];
	[super dealloc];
}

-(void) onEnter
{
	[super onEnter];
	
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0 / 60)];
}

-(void) step: (ccTime) delta
{
	[smgr step:delta];
}

- (BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint pt = [self convertTouchToNodeSpace:touch];
	
	_lastPt = pt;
	
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint pt = [self convertTouchToNodeSpace:touch];
	
	[self drawTerrainAt:pt];
}

- (BOOL) drawTerrainAt:(CGPoint)pt
{
	float r2 = ccpLengthSQ(ccpSub(pt, _lastPt));
	
	if (r2 > 25)
	{
		cpShape* shape = [smgr addSegmentAtWorldAnchor:_lastPt
										 toWorldAnchor:pt mass:STATIC_MASS radius:5];
		
		cpShapeNode* node = [cpShapeNode nodeWithShape:shape];
		node.spaceManager = smgr;
		node.autoFreeShape = YES;
		node.color = ccWHITE;
		[self addChild:node];
		
		_lastPt = pt;
		
		return YES;
	}
	
	return NO;
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
#define kFilterFactor 0.05f
	
	float accelX = (float) acceleration.x * kFilterFactor + (1- kFilterFactor)*prevX;
	float accelY = (float) acceleration.y * kFilterFactor + (1- kFilterFactor)*prevY;
	
	prevX = accelX;
	prevY = accelY;
	
	CGPoint v = ccp( -accelY, accelX);
	
	smgr.gravity = ccpMult(v, 200);
}
@end

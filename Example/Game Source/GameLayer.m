//
//  GameLayer.m
//  Example For SpaceManager
//
//  Created by Rob Blackwood on 5/11/09.
//

#import "GameLayer.h"
#import "cpConstraintNode.h"
#import "cpShapeNode.h"

@interface GameLayer (PrivateMethods)
- (void) setupExample;
- (int) handleCollisionWithRect:(cpShape*)rect;
- (int) handleCollisionWithCircle:(cpShape*)circle 
							 ball:(cpShape*)ball 
					   contactPts:(cpContact*)contacts 
					  numContacts:(int)numContacts 
					   normalCoef:(cpFloat)coef;
@end

#define kBallCollisionType		1
#define kCircleCollisionType	2
#define kRectCollisionType		3


@implementation GameLayer

- (id) init
{
	[super init];
	
	isTouchEnabled = YES;
	
	//add a background
	Sprite *background = [Sprite spriteWithFile:@"splash_developed_by.png"];
	background.position = ccp(240,160);
	[self addChild:background];
	
	//do our example
	[self setupExample];

	return self;
}


- (void) dealloc
{	
	[smgr release];
	[super dealloc];
}

- (void) setupExample
{
	//allocate our space manager
	smgr = [[SpaceManager alloc] init];
	
	//add four walls to our screen
	[smgr addWindowContainmentWithFriction:1.0 elasticity:1.0 inset:cpvzero];
	
	//Constant dt is recommended for chipmunk
	smgr.constantDt = 1.0/55.0;

	//active shape, ball shape
	cpShape *ball = [smgr addCircleAt:cpv(240,160) mass:1.0 radius:10];
	ball->collision_type = kBallCollisionType;
	ballSprite = [cpSprite spriteWithShape:ball file:@"ball.png"];
	[self addChild:ballSprite];
	
	//static shapes, STATIC_MASS is the key concept here
	cpShape *staticCircle = [smgr addCircleAt:cpv(100,160) mass:STATIC_MASS radius:25];
	cpShape *staticRect = [smgr addRectAt:cpv(380,160) mass:STATIC_MASS width:50 height:50 rotation:0];
	
	//We need to assign a type for recognizing specific collisions
	staticRect->collision_type = kRectCollisionType;
	staticCircle->collision_type = kCircleCollisionType;
	
	//Connect our shapes to sprites
	cpSprite *sCircleSprite = [cpSprite spriteWithShape:staticCircle file:@"staticcircle.png"];
	cpSprite *sRectSprite = [cpSprite spriteWithShape:staticRect file:@"staticrect.png"];
	
	//Add our sprites
	[self addChild:sCircleSprite];
	[self addChild:sRectSprite];
	
	//Lets get our staticRect moving
	[sRectSprite runAction:[RepeatForever actionWithAction:[Sequence actions:
															[MoveBy actionWithDuration:2 position:ccp(60,0)],
															[MoveBy actionWithDuration:2 position:ccp(-60,0)], nil]]];
	
	// This will cause the rectangle to update it's velocity based on the movement we're giving it
	// It's important to set the spacemanger here, as static shapes need to report when they've
	// changed, whereas active shapes do not, alternatively you could set this:
	//
	//  smgr.rehashStaticEveryStep = YES;
	//
	// Setting this would make the smgr recalculate all static shapes positions every step
	sRectSprite.integrationDt = 1.0/55.0;
	sRectSprite.spaceManager = smgr;
	
	//set up collisions, notice differing signatures in selectors (it's ok!)
	[smgr addCollisionCallbackBetweenType:kRectCollisionType 
								otherType:kBallCollisionType 
								   target:self 
								 selector:@selector(handleCollisionWithRect:)];
	
	[smgr addCollisionCallbackBetweenType:kCircleCollisionType 
								otherType:kBallCollisionType 
								   target:self 
								 selector:@selector(handleCollisionWithCircle:ball:contactPts:numContacts:normalCoef:)];

	//add a segment in for good measure
	cpShape* seg = [smgr addSegmentAtWorldAnchor:cpv(100,260) toWorldAnchor:cpv(380,260) mass:STATIC_MASS radius:6];
	cpShapeNode *segn = [cpShapeNode nodeWithShape:seg];
	segn.color = ccBLUE;
	[self addChild:segn];
	
	//collisions will change label text
	label = [Label labelWithString:@"" fontName:@"Helvetica" fontSize:20];
	label.position = ccp(240,280);
	[self addChild:label];
	
	//Set up two legs that'll form our teepee thing
	cpShape *leg1 = [smgr addRectAt:cpv(220,80) mass:.5 width:10 height:60 rotation:CC_DEGREES_TO_RADIANS(-35.5)];
	cpShape *leg2 = [smgr addRectAt:cpv(260,80) mass:.5 width:10 height:60 rotation:CC_DEGREES_TO_RADIANS(35.5)];
	
	//Shapes in a group do not affect each other
	leg1->group = 1;
	leg2->group = 1;
	cpSprite *leg1s = [cpSprite spriteWithShape:leg1 file:@"rect.png"];
	cpSprite *leg2s = [cpSprite spriteWithShape:leg2 file:@"rect.png"];

	//Our dangling rect on the slide joint
	cpShape *weight = [smgr addRectAt:cpv(240,230) mass:2 width:10 height:60 rotation:0];
	cpSprite *weights = [cpSprite spriteWithShape:weight file:@"rect.png"];
	
	//Set up our joints
	cpConstraint *joint1 = [smgr addPinToBody:leg1->body fromBody:leg2->body toBodyAnchor:cpv(5,30) fromBodyAnchor:cpv(-5,30)];
	cpConstraint *joint2 = [smgr addSlideToBody:leg1->body fromBody:leg2->body minLength:30.0f maxLength:45.0f];	
	cpConstraint *joint3 = [smgr addGrooveToBody:smgr.topWall->body fromBody:weight->body grooveAnchor1:cpv(80,250) grooveAnchor2:cpv(400, 250) fromBodyAnchor:cpv(0,50)];	
	cpConstraint *joint4 = [smgr addSpringToBody:weight->body fromBody:ball->body toBodyAnchor:cpv(0,-30) fromBodyAnchor:cpv(0,0) restLength:0.0f stiffness:1.0f damping:0.0f];
	
	//Fun part, these babies will draw themselves depending on what joint type
	cpConstraintNode *jn1 = [cpConstraintNode nodeWithConstraint:joint1];
	cpConstraintNode *jn2 = [cpConstraintNode nodeWithConstraint:joint2];
	cpConstraintNode *jn3 = [cpConstraintNode nodeWithConstraint:joint3];
	cpConstraintNode *jn4 = [cpConstraintNode nodeWithConstraint:joint4];
	
	//make them white
	jn1.color = ccWHITE;
	jn2.color = ccWHITE;
	jn3.color = ccWHITE;
	jn4.color = ccWHITE;
	
	//Add all the CocosNodes
	[self addChild:leg1s];
	[self addChild:leg2s];
	[self addChild:weights];
	
	[self addChild:jn1];
	[self addChild:jn2];
	[self addChild:jn3];
	[self addChild:jn4];

	//start the manager!
	[smgr start]; 	
}

#pragma mark Touch Functions
- (BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{	
	//Calculate a vector based on where we touched and where the ball is
	CGPoint pt = [self convertTouchToNodeSpace:[touches anyObject]];
	CGPoint forceVect = ccpSub(pt, ballSprite.position);
	
	//This applys a one-time force, pretty much like firing a bullet
	[ballSprite applyImpulse:ccpMult(forceVect, 1.2)];

	return kEventHandled;
}

- (int) handleCollisionWithRect:(cpShape*)rect
{
	[label setString:@"You hit the Rectangle!"];
	//1 to accept collision, 0 to ignore it
	return 1;
}

- (int) handleCollisionWithCircle:(cpShape*)circle 
							 ball:(cpShape*)ball 
					   contactPts:(cpContact*)contacts 
					  numContacts:(int)numContacts 
					   normalCoef:(cpFloat)coef
{
	[label setString:@"You hit the Circle!"];
	return 1;
}

@end


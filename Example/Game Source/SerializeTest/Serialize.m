//
//  Serialize.m
//  Example For SpaceManager
//
//  Created by Rob Blackwood on 5/30/10.
//

#import "Serialize.h"

@interface Serialize (PrivateMethods)
- (void) setupTest;
@end

@implementation Serialize

- (id) init
{
	[super init];
	
	self.isTouchEnabled = YES;
	balls = [[NSMutableArray alloc] init];
	
	//add a background
	CCSprite *background = [CCSprite spriteWithFile:@"splash_developed_by.png"];
	background.position = ccp(240,160);
	[self addChild:background];
	
	//do our example
	[self setupTest];

	return self;
}

- (void) onExit
{
	[smgr stop];
	[smgr saveSpaceToUserDocs:@"cpSerialized.xml" delegate:self];	
	[super onExit];
}

- (void) dealloc
{	
	[smgr release];
	[super dealloc];
}

- (void) setupTest
{
	//allocate our space manager
	smgr = [[SpaceManager alloc] init];
	
	//Constant dt is recommended for chipmunk
	smgr.constantDt = 1.0/55.0;
	
	//Try to load it from file, if not create from scratch
	if (![smgr loadSpaceFromUserDocs:@"cpSerialized.xml" delegate:self])
	{
		//add four walls to our screen
		[smgr addWindowContainmentWithFriction:1.0 elasticity:1.0 inset:cpvzero];
	
		for (int i = 0; i < 12; i++)
		{
			cpShape *ball = [smgr addCircleAt:cpv(40+i*25,100+i*5) mass:1.0 radius:10];
			cpCCSprite *ballSprite = [cpCCSprite spriteWithShape:ball file:@"ball.png"];
			[self addChild:ballSprite z:100];
			
			[balls addObject:ballSprite];
		}
	}
		
	//start the manager!
	[smgr start]; 	
}

-(BOOL) aboutToReadShape:(cpShape*)shape shapeId:(long)id
{
	//If its static mass, then its the walls, just ignore them
	if (shape->body->m != STATIC_MASS)
	{
		//We know it has to be a ball
		cpCCSprite *ballSprite = [cpCCSprite spriteWithShape:shape file:@"ball.png"];
		[self addChild:ballSprite];
		
		[balls addObject:ballSprite];
	}
	
	return YES; //This just means accept the reading of this shape
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{	
	//Calculate a vector based on where we touched and where the ball is
	CGPoint pt = [self convertTouchToNodeSpace:[touches anyObject]];
	
	for (cpCCSprite *ballSprite in balls)
	{
		CGPoint forceVect = ccpSub(pt, ballSprite.position);
		
		//This applys a one-time force, pretty much like firing a bullet
		[ballSprite applyImpulse:ccpMult(forceVect, 1)];
	}
	
	return YES;
}
@end


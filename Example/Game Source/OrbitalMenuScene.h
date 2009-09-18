/*********************************************************************
 *	
 *	Particles
 *
 *	OrbitalMenuScene.h
 *
 *	menu scene for handling game menus
 *
 *	http://www.mobile-bros.com
 *
 *	Created by matt on 6/08/09.
 *	Copyright 2009 Mobile Bros. All rights reserved.
 *
 **********************************************************************/

#import <UIKit/UIKit.h>
#import "cocos2d.h"
#import "RadialMenu.h"
#import "Savable.h"

enum _LEVELINDEX {
	LEVEL1 = 1,
	LEVEL2,
	LEVEL3,
	LEVEL4,
	LEVEL5
};

#define NUM_LEVELS	5

static NSString * _PLANETLEVELS[10][6] = {
{@"",			@"",		@"",		@"",		@"",		@""},
{@"Mercury",	@"level1",	@"level2",	@"level3",	@"level4",	@"level5"},
{@"Venus",		@"level6",	@"level7",	@"level8",	@"level9",	@"level10"},
{@"Earth",		@"",		@"",		@"",		@"",		@""},
{@"Mars",		@"level11",	@"level12",	@"level13",	@"level14",	@"level15"},
{@"Jupiter",	@"level16",	@"level17",	@"level18",	@"level19",	@"level20"},
{@"Saturn",		@"level21",	@"level22",	@"level23",	@"level24",	@"level25"},
{@"Uranus",		@"level26",	@"level27",	@"level28",	@"level29",	@"level30"},
{@"Neptune",	@"level31",	@"level32",	@"level33",	@"level34",	@"level35"},
{@"Pluto",		@"level36",	@"level37",	@"level38",	@"level39",	@"level40"}
};


#pragma mark OrbitalMenuScene Class
@interface OrbitalMenuScene : SavableScene
{
	
}

#pragma mark OrbitalMenuScene Methods

@end

#pragma mark OrbitalMenuLayer Class
@interface OrbitalMenuLayer : SavableLayer
{
	MenuItem *start;
	id _selectedLevel;
	Sprite *_shuttle;
	
	int _completed;
}

@end

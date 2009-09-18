/*********************************************************************
 *	
 *	Particles
 *
 *	TransitionScene.h
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


#pragma mark TransScene Class
@interface TransScene : SavableScene
{
	
}

#pragma mark TransScene Methods
- (id) initWithLevel:(int)level planet:(int)planetIdx;

@end

#pragma mark TransLayer Class
@interface TransLayer : SavableLayer
{
	int _level;
	int _planetIdx;
}

-(void)launchGame: (id)sender;

@end

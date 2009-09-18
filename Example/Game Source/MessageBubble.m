//
//  MessageBubble.m
//  Particles
//
//  Created by Robert Blackwood on 7/1/09.
//  Copyright 2009 Mobile Bros. All rights reserved.
//

#import "MessageBubble.h"


@implementation MessageBubble

- (void) setOpacity:(GLubyte)op
{
	[super setOpacity:op];
	
	for (CocosNode<CocosNodeOpacity> *cc in children)
		[cc setOpacity:op];
}



@end

/* cocos2d for iPhone
 *
 * http://www.cocos2d-iphone.org
 *
 * Copyright (C) 2009 Matt Oswald
 * Copyright (C) 2009 Ricardo Quesada
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the 'cocos2d for iPhone' license.
 *
 * You will find a copy of this license within the cocos2d for iPhone
 * distribution inside the "LICENSE" file.
 *
 */

#import "ccConfig.h"
#import "CCSprite.h"
#import "CCSpriteSheet.h"
#import "CCGrid.h"
#import "CCDrawingPrimitives.h"
#import "Support/CGPointExtension.h"

const int defaultCapacity = 29;

#pragma mark -
#pragma mark CCSpriteSheet

@interface CCSpriteSheet (private)
-(void) updateBlendFunc;
@end

@implementation CCSpriteSheet

@synthesize textureAtlas = textureAtlas_;
@synthesize blendFunc = blendFunc_;

-(void)dealloc
{	
	[textureAtlas_ release];

	[super dealloc];
}

/*
 * creation with CCTexture2D
 */
+(id)spriteSheetWithTexture:(CCTexture2D *)tex
{
	return [[[CCSpriteSheet alloc] initWithTexture:tex capacity:defaultCapacity] autorelease];
}

+(id)spriteSheetWithTexture:(CCTexture2D *)tex capacity:(NSUInteger)capacity
{
	return [[[CCSpriteSheet alloc] initWithTexture:tex capacity:capacity] autorelease];
}

/*
 * creation with File Image
 */
+(id)spriteSheetWithFile:(NSString*)fileImage capacity:(NSUInteger)capacity
{
	return [[[CCSpriteSheet alloc] initWithFile:fileImage capacity:capacity] autorelease];
}

+(id)spriteSheetWithFile:(NSString*) imageFile
{
	return [[[CCSpriteSheet alloc] initWithFile:imageFile capacity:defaultCapacity] autorelease];
}


/*
 * init with CCTexture2D
 */
-(id)initWithTexture:(CCTexture2D *)tex capacity:(NSUInteger)capacity
{
	if( (self=[super init])) {
		
		blendFunc_.src = CC_BLEND_SRC;
		blendFunc_.dst = CC_BLEND_DST;
		textureAtlas_ = [[CCTextureAtlas alloc] initWithTexture:tex capacity:capacity];
		
		[self updateBlendFunc];
		
		// no lazy alloc in this node
		children = [[NSMutableArray alloc] initWithCapacity:capacity];
	}

	return self;
}

/*
 * init with FileImage
 */
-(id)initWithFile:(NSString *)fileImage capacity:(NSUInteger)capacity
{
	if( (self=[super init]) ) {
		
		blendFunc_.src = CC_BLEND_SRC;
		blendFunc_.dst = CC_BLEND_DST;
		textureAtlas_ = [[CCTextureAtlas alloc] initWithFile:fileImage capacity:capacity];
		
		[self updateBlendFunc];
		
		// no lazy alloc in this node
		children = [[NSMutableArray alloc] initWithCapacity:capacity];
	}
	
	return self;
}


#pragma mark CCSpriteSheet - composition

// override visit.
// Don't call visit on it's children
-(void) visit
{

	// CAREFUL:
	// This visit is almost identical to CocosNode#visit
	// with the exception that it doesn't call visit on it's children
	//
	// The alternative is to have a void CCSprite#visit, but this
	// although is less mantainable, is faster
	//
	if (!visible)
		return;
	
	glPushMatrix();
	
	if ( grid && grid.active)
		[grid beforeDraw];
	
	[self transform];
	
	[self draw];
	
	if ( grid && grid.active)
		[grid afterDraw:self.camera];
	
	glPopMatrix();
}

-(NSUInteger)indexForNewChildAtZ:(int)z
{
	NSUInteger index = 0;

	for( CCSprite *sprite in children) {
		if ( sprite.zOrder > z ) {
			break;
		}
		index++;
	}
		
	return index;
}

-(CCSprite*) createSpriteWithRect:(CGRect)rect
{
	CCSprite *sprite = [CCSprite spriteWithTexture:textureAtlas_.texture rect:rect];
	[sprite setParentIsSpriteSheet:YES];
	[sprite setTextureAtlas:textureAtlas_];
	return sprite;
}

-(void) initSprite:(CCSprite*)sprite rect:(CGRect)rect
{
	[sprite initWithTexture:textureAtlas_.texture rect:rect];
	[sprite setParentIsSpriteSheet:YES];
	[sprite setTextureAtlas:textureAtlas_];
}


// override addChild:
-(id) addChild:(CCSprite*)child z:(int)z tag:(int) aTag
{
	NSAssert( child != nil, @"Argument must be non-nil");
	NSAssert( [child isKindOfClass:[CCSprite class]], @"CCSpriteSheet only supports CCSprites as children");
	NSAssert( child.texture.name == textureAtlas_.texture.name, @"CCSprite is not using the same texture id");
	
	if(textureAtlas_.totalQuads == textureAtlas_.capacity)
		[self increaseAtlasCapacity];

	NSUInteger index = [self indexForNewChildAtZ:z];
	[child setTextureAtlas:textureAtlas_];
	[child insertInAtlasAtIndex:index];
	
	[child setParentIsSpriteSheet:YES];

	[super addChild:child z:z tag:aTag];

	NSUInteger count = [children count];
	index++;
	for(; index < count; index++) {
		CCSprite *sprite = (CCSprite *)[children objectAtIndex:index];
		NSAssert([sprite atlasIndex] == index - 1, @"CCSpriteSheet: index failed");
		[sprite setAtlasIndex:index];		
	}
	
	return self;
}

// override reorderChild
-(void) reorderChild:(CCSprite*)child z:(int)z
{
	// reorder child in the children array
	[super reorderChild:child z:z];
	
	
	// What's the new atlas index ?
	NSUInteger newAtlasIndex = 0;
	for( CCSprite *sprite in children) {
		if( [sprite isEqual:child] )
			break;
		newAtlasIndex++;
	}
	
	if( newAtlasIndex != child.atlasIndex ) {
		
		[textureAtlas_ insertQuadFromIndex:child.atlasIndex atIndex:newAtlasIndex];
		
		// update atlas index
		NSUInteger count = MAX( newAtlasIndex, child.atlasIndex);
		NSUInteger index = MIN( newAtlasIndex, child.atlasIndex);
		for( ; index < count+1 ; index++ ) {
			CCSprite *sprite = (CCSprite *)[children objectAtIndex:index];
			[sprite setAtlasIndex: index];
		}
	}
}

// override removeChild:
-(void)removeChild: (CCSprite *)sprite cleanup:(BOOL)doCleanup
{
	// explicit nil handling
	if (sprite == nil)
		return;

	// ignore non-children
	// XXX. why ? This should raise an exception.
	if( ![children containsObject:sprite] )
		return;
	
	NSUInteger index= sprite.atlasIndex;
	
	// When the CCSprite is removed, the index should be invalidated. issue #569
	[sprite setAtlasIndex: CCSpriteIndexNotInitialized];

	// when removed, in case it would be child of a "normal" node, set as "no render using manager"
	[sprite setParentIsSpriteSheet:NO];

	[super removeChild:sprite cleanup:doCleanup];

	[textureAtlas_ removeQuadAtIndex:index];

	// update all sprites beyond this one
	NSUInteger count = [children count];
	for(; index < count; index++)
	{
		CCSprite *other = (CCSprite *)[children objectAtIndex:index];
		NSAssert([other atlasIndex] == index + 1, @"CCSpriteSheet: index failed");
		[other setAtlasIndex:index];
	}	
}

-(void)removeChildAtIndex:(NSUInteger)index cleanup:(BOOL)doCleanup
{
	[self removeChild:(CCSprite *)[children objectAtIndex:index] cleanup:doCleanup];
}

-(void)removeAllChildrenWithCleanup:(BOOL)doCleanup
{
	// Invalidate atlas index. issue #569
	for( CCSprite *sprite in children ) {
		[sprite setAtlasIndex:CCSpriteIndexNotInitialized];
		[sprite setParentIsSpriteSheet:NO];
	}
	
	[super removeAllChildrenWithCleanup:doCleanup];
	
	[textureAtlas_ removeAllQuads];
}

#pragma mark CCSpriteSheet - draw
-(void)draw
{
	if(textureAtlas_.totalQuads == 0)
		return;
	
	for( CCSprite *child in children )
	{
		if( child.dirty )
			[child updatePosition];
		
#if CC_SPRITESHEET_DEBUG_DRAW
		CGRect rect = [child boundingBox]; //Inssue 528
		CGPoint vertices[4]={
			ccp(rect.origin.x,rect.origin.y),
			ccp(rect.origin.x+rect.size.width,rect.origin.y),
			ccp(rect.origin.x+rect.size.width,rect.origin.y+rect.size.height),
			ccp(rect.origin.x,rect.origin.y+rect.size.height),
		};
		ccDrawPoly(vertices, 4, YES);
#endif // CC_SPRITESHEET_DEBUG_DRAW
	}

	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
	glEnable(GL_TEXTURE_2D);
	
	BOOL newBlend = NO;
	if( blendFunc_.src != CC_BLEND_SRC || blendFunc_.dst != CC_BLEND_DST ) {
		newBlend = YES;
		glBlendFunc( blendFunc_.src, blendFunc_.dst );
	}
	
	[textureAtlas_ drawQuads];
	if( newBlend )
		glBlendFunc(CC_BLEND_SRC, CC_BLEND_DST);
		
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_VERTEX_ARRAY);
}

#pragma mark CCSpriteSheet - private
-(void) increaseAtlasCapacity
{
	// if we're going beyond the current TextureAtlas's capacity,
	// all the previously initialized sprites will need to redo their texture coords
	// this is likely computationally expensive
	NSUInteger quantity = (textureAtlas_.capacity + 1) * 4 / 3;

	CCLOG(@"cocos2d: Resizing TextureAtlas capacity, from [%d] to [%d].", textureAtlas_.capacity, quantity);


	if( ! [textureAtlas_ resizeCapacity:quantity] ) {
		// serious problems
		CCLOG(@"cocos2d: WARNING: Not enough memory to resize the atlas");
		NSAssert(NO,@"XXX: SpriteSheet#increateAtlasCapacity SHALL handle this assert");
	}	
}

#pragma mark CCSpriteSheet - CocosNodeTexture protocol

-(void) updateBlendFunc
{
	if( ! [textureAtlas_.texture hasPremultipliedAlpha] ) {
		blendFunc_.src = GL_SRC_ALPHA;
		blendFunc_.dst = GL_ONE_MINUS_SRC_ALPHA;
	}
}

-(void) setTexture:(CCTexture2D*)texture
{
	textureAtlas_.texture = texture;
	[self updateBlendFunc];
}

-(CCTexture2D*) texture
{
	return textureAtlas_.texture;
}
@end

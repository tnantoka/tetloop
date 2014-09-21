//
//  TLOpeningScene.h
//  Tetloop
//
//  Created by Tatsuya Tobioka on 9/6/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TLOpeningScene : SKScene

@property (nonatomic, weak) id delegate;

+ (instancetype)scene;

@end

@interface NSObject (TLOpeningSceneDelegate)

- (void)openingSceneDidFadeOut;

@end

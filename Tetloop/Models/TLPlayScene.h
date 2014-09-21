//
//  TLPlayScene.h
//  Tetloop
//
//  Created by Tatsuya Tobioka on 8/23/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TLPlayScene : SKScene

@property (nonatomic, weak) id delegate;

+ (instancetype)scene;

@end

@interface NSObject (TLPlaySceneDelegate)

- (void)playSceneDidGameOver;

@end

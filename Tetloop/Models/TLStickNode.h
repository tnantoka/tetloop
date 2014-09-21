//
//  TLStickNode.h
//  Tetloop
//
//  Created by Tatsuya Tobioka on 8/24/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TLStickNode : SKNode

@property (nonatomic) NSInteger rank;
@property (nonatomic) UIColor *borderColor;
@property (nonatomic) BOOL withSound;

- (void)moveLeft;
- (void)moveRight;

- (void)removeWithCallback:(void (^)())callback;
- (void)removeWithCallback:(void (^)())callback deleted:(BOOL)deleted;

@end

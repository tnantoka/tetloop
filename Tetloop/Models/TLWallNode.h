//
//  TLWallNode.h
//  Tetloop
//
//  Created by Tatsuya Tobioka on 8/25/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface TLWallNode : SKNode

@property (nonatomic) NSInteger cols;
@property (nonatomic) UIColor *borderColor;

- (id)initWithCols:(NSInteger)cols;

- (void)remove;

@end

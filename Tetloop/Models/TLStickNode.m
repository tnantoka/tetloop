//
//  TLStickNode.m
//  Tetloop
//
//  Created by Tatsuya Tobioka on 8/24/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import "TLStickNode.h"

#import "TLSettingsForm.h"

@interface TLStickNode ()

@property (nonatomic) NSMutableArray *blockNodes;
@property (nonatomic) NSMutableArray *borderNodes;

@property (nonatomic) SKAction *crashAction;

@end

@implementation TLStickNode

- (id)init {
    if (self = [super init]) {
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0.0f, 0.0f, kBlockSize, kBlockSize));

        self.zPosition = 1.0f;
        self.borderColor = kPlaySceneBackgroundColor;

        if ([[NSBundle mainBundle] pathForResource:@"crash" ofType:@"caf"]) {
            self.crashAction = [SKAction playSoundFileNamed:@"crash.caf" waitForCompletion:NO];
        }
        self.withSound = [TLSettingsForm shared].sound;
        
        self.blockNodes = @[].mutableCopy;
        self.borderNodes = @[].mutableCopy;
        for (int i = 0; i < 4; i++) {
            SKSpriteNode *blockNode = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(kBlockSize, kBlockSize)];
            blockNode.position = CGPointMake(0.0f, kBlockSize * (1.5f - 1.0f * i));
            [self addChild:blockNode];
            
            SKShapeNode *borderNode = [SKShapeNode node];
            borderNode.path = path;
            borderNode.strokeColor = self.borderColor;
            borderNode.position = CGPointMake(blockNode.position.x - kBlockSize / 2.0f, blockNode.position.y - kBlockSize / 2.0f);
            borderNode.antialiased = NO;
            [self addChild:borderNode];
            
            [self.blockNodes addObject:blockNode];
            [self.borderNodes addObject:borderNode];
        }
    }
    return self;
}

- (void)moveLeft {
    if ([self hasActions]) {
        return;
    }
    SKAction *leftAction = [SKAction moveByX:-kBlockSize y:0.0f duration:0.02f];
    [self runAction:leftAction];
}

- (void)moveRight {
    if ([self hasActions]) {
        return;
    }
    SKAction *rightAction = [SKAction moveByX:kBlockSize y:0.0f duration:0.02f];
    [self runAction:rightAction];
}

- (void)removeWithCallback:(void (^)())callback {
    [self removeWithCallback:callback deleted:YES];
}

- (void)removeWithCallback:(void (^)())callback deleted:(BOOL)deleted {
    self.rank--;
    if (self.rank > -1) {
        return;
    }
    
    NSString *sparkPath = [[NSBundle mainBundle] pathForResource:@"spark" ofType:@"sks"];
    SKEmitterNode *sparkNode = [NSKeyedUnarchiver unarchiveObjectWithFile:sparkPath];
    //sparkNode.particleScale = 0.1f;
    sparkNode.xScale = sparkNode.yScale = 0.7f;
    [self addChild:sparkNode];
    
    SKAction *fadeOutAction = [SKAction fadeOutWithDuration:0.5f];
    __weak typeof(self) weakSelf = self;
    SKAction *removeAction = [SKAction runBlock:^{
        if (callback) {
            callback();
        }
        if (deleted) {
            [weakSelf removeFromParent];
        }
    }];

    SKAction *sequence;
    if (self.withSound) {
        sequence = [SKAction sequence:@[
                                        self.crashAction,
                                        fadeOutAction,
                                        removeAction,
                                        ]];
    } else {
        sequence = [SKAction sequence:@[
                                        fadeOutAction,
                                        removeAction,
                                        ]];
    }

    if (deleted) {
        [self runAction:sequence];
    } else {
        [sparkNode runAction:fadeOutAction];
        [self runAction:removeAction];
    }
}

- (void)setRank:(NSInteger)rank {
    _rank = rank;
    if (rank > -1) {
        UIColor *color = [TLGlobals colorWithRank:rank];
        for (SKSpriteNode *blockNode in self.blockNodes) {
            blockNode.color = color;
        }
    }
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    for (SKShapeNode *borderNode in self.borderNodes) {
        borderNode.strokeColor = borderColor;
    }
}

@end

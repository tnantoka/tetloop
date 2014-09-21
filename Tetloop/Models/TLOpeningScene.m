//
//  TLOpeningScene.m
//  Tetloop
//
//  Created by Tatsuya Tobioka on 9/6/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import "TLOpeningScene.h"

#import "TLStickNode.h"
#import "TLWallNode.h"

static const NSInteger ROWS = 20;
static const NSInteger COLS = 10;

static const CGFloat DURATION = 4.0f;

@interface TLOpeningScene ()

@property (nonatomic) BOOL contentCreated;

@end

@implementation TLOpeningScene

+ (instancetype)scene {
    return [self sceneWithSize:CGSizeMake(kBlockSize * COLS, kBlockSize * ROWS)];
}

- (void)didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
        [self createSceneContents];
        self.contentCreated = YES;
    }
}

- (void)createSceneContents {
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.backgroundColor = kBackgroundColor;
    [self first];
}

- (void)first {
    [self addLabelNodes:@[
                          NSLocalizedString(@"- Stick-Wall War -", nil)
                          ]];
    __weak typeof(self) weakSelf = self;
    [self addAnimationNodeWithCallBack:^{
        [weakSelf second];
    } deleted:YES];
}

- (void)second {
    [self addLabelNodes:@[
                          NSLocalizedString(@"The seesaw game seems", nil),
                          NSLocalizedString(@"like endless time...", nil),
                          ]];
    __weak typeof(self) weakSelf = self;
    [self addAnimationNodeWithCallBack:^{
        [weakSelf third];
    } deleted:YES];
}

- (void)third {
    [self addLabelNodes:@[
                          NSLocalizedString(@"It came from", nil),
                          NSLocalizedString(@"out of the blue.", nil)
                          ]];
    __weak typeof(self) weakSelf = self;
    [self addAnimationNodeWithCallBack:^{
        [weakSelf last];
    } deleted:NO];
}

- (void)last {
    [self addLabelNodes:@[
                          NSLocalizedString(@"\"I don't die easy.", nil),
                          NSLocalizedString(@"I'll end the loop!\"", nil)
                          ]];
    
    __weak typeof(self) weakSelf = self;
    dispatch_time_t when = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(DURATION * (double)NSEC_PER_SEC));
    dispatch_after(when, dispatch_get_main_queue(), ^(void){
        [weakSelf fadeOut];
    });
}

- (void)fadeOut {
    if ([self.delegate respondsToSelector:@selector(openingSceneDidFadeOut)]) {
        [self.delegate openingSceneDidFadeOut];
    }
    [self removeAllChildren];
}

- (void)addAnimationNodeWithCallBack:(void (^)())callback deleted:(BOOL)deleted {
    TLStickNode *stickNode = [TLStickNode node];
    stickNode.position = CGPointMake(0.0f, CGRectGetMidY(self.frame));
    stickNode.rank = 0;
    stickNode.withSound = NO;
    stickNode.borderColor = self.backgroundColor;
    stickNode.zRotation = 90 * M_PI / 180.0f;
    stickNode.xScale = stickNode.yScale = 0.7f;
    [self addChild:stickNode];
    
    SKNode *wallNode = [SKNode node];
    wallNode.position = CGPointMake(CGRectGetWidth(self.frame), CGRectGetMidY(self.frame) - kBlockSize * 3.85f);
    wallNode.xScale = wallNode.yScale = 0.7f;
    wallNode.zRotation = 90 * M_PI / 180.0f;
    
    NSInteger cols = 5;
    TLWallNode *wallNode1 = [[TLWallNode alloc] initWithCols:cols];
    wallNode1.position = CGPointMake(kBlockSize * cols / 2.0f, 0.0f);
    wallNode1.borderColor = self.backgroundColor;
    
    TLWallNode *wallNode2 = [[TLWallNode alloc] initWithCols:COLS - cols - 1];
    wallNode2.position = CGPointMake(kBlockSize * (COLS - cols - 1) / 2.0f + kBlockSize * (cols + 1), 0.0f);
    wallNode2.borderColor = self.backgroundColor;
    
    [wallNode addChild:wallNode1];
    [wallNode addChild:wallNode2];
    [self addChild:wallNode];
    
    SKAction *rightAction = [SKAction moveToX:CGRectGetMidX(self.frame) duration:DURATION];
    SKAction *removeAction = [SKAction runBlock:^{
        [stickNode removeWithCallback:^{
            if (callback) {
                callback();                
            }
        } deleted:deleted];
        if (!deleted) {
            stickNode.rank = 9;
            SKAction *waitAction = [SKAction waitForDuration:2.0f];
            SKAction *fadeOutAction = [SKAction fadeOutWithDuration:DURATION - 2.0f];
            //SKAction *removeAction = [SKAction removeFromParent];
            SKAction *sequence = [SKAction sequence:@[
                                                      waitAction,
                                                      fadeOutAction,
                                                      //removeAction
                                                      ]];
            [stickNode runAction:sequence];
        }
        NSArray *wallNodes = wallNode.children;
        for (TLWallNode *wallNode in wallNodes) {
            [wallNode remove];
        }
    }];
    SKAction *sequence = [SKAction sequence:@[rightAction, removeAction]];
    [stickNode runAction:sequence];
    
    SKAction *leftAction = [SKAction moveToX:CGRectGetMidX(self.frame) duration:DURATION];
    [wallNode runAction:leftAction];
}

- (void)addLabelNodes:(NSArray *)messages {
    CGFloat y = 0.0f;
    CGFloat fontSize = 10.0f;
    CGFloat lineHeight = fontSize * 1.5f;
    SKNode *labelsNode = [SKNode node];
    labelsNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetHeight(self.frame) - lineHeight * 4.0f);
    [self addChild:labelsNode];
    for (NSString *message in messages) {
        SKLabelNode *labelNode = [SKLabelNode labelNodeWithFontNamed:@"Mosamosa"];
        labelNode.fontSize = fontSize;
        labelNode.color = kNormalTextColor;
        labelNode.colorBlendFactor = 1.0f;
        labelNode.text = message;
        labelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
        labelNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        labelNode.position = CGPointMake(0.0f, y);
        [labelsNode addChild:labelNode];
        y -= lineHeight;
    }
    
    SKAction *waitAction = [SKAction waitForDuration:3.0f];
    SKAction *fadeOutAction = [SKAction fadeOutWithDuration:DURATION - 3.0f];
    SKAction *removeAction = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[
                           waitAction,
                           fadeOutAction,
                           removeAction
                           ]];
    [labelsNode runAction:sequence];
}

# pragma mark - Touch

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self fadeOut];
}


@end

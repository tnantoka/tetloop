//
//  TLPlayScene.m
//  Tetloop
//
//  Created by Tatsuya Tobioka on 8/23/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import "TLPlayScene.h"

#import "TLStickNode.h"
#import "TLWallNode.h"
#import "TLSettingsForm.h"

#ifdef DEBUG
//#import "YMCPhysicsDebugger.h"
#endif

static const NSInteger ROWS = 20;
static const NSInteger COLS = 10;
static const CGFloat STICK_BUFFER = 4.0f;
static const CGFloat PRESS_DURATION = 0.2f;
static const CGFloat INTERVAL = 4.0f;
static const CGFloat INTERVAL_BUFFER = 2.0f;
static const CGFloat PADDING = 5.0f;

static const uint32_t stickCategory = 0x1 << 0;
static const uint32_t wallCategory = 0x1 << 1;

static NSString * const GRID_NAME = @"grid";
static NSString * const WALL_NAME = @"wall";

#define LABEL_FONT_SIZE ([iOSDetector is568h] ? 10.0f : 12.0f)

@interface TLPlayScene () <SKPhysicsContactDelegate>

@property (nonatomic) BOOL contentCreated;

@property (nonatomic) TLStickNode *stickNode;
@property (nonatomic) NSDate *touchedAt;

@property (nonatomic) CGFloat speed;
@property (nonatomic) BOOL longPressing;

@property (nonatomic) NSTimeInterval elapsedTime;
@property (nonatomic) NSTimeInterval lastTime;

@property (nonatomic) NSDate *wallAddedAt;

@property (nonatomic) SKLabelNode *timeNode;
@property (nonatomic) SKLabelNode *scoreNode;
@property (nonatomic) NSInteger score;
@property (nonatomic) NSInteger removedLines;

@property (nonatomic) SKAction *breakAction;

@end

@implementation TLPlayScene

+ (instancetype)scene {
    return [self sceneWithSize:CGSizeMake(kBlockSize * COLS, kBlockSize * ROWS)];
}

- (void)didMoveToView:(SKView *)view {
    if (!self.contentCreated) {
#ifdef DEBUG
        //[YMCPhysicsDebugger init];
#endif
        [self createSceneContents];
        self.contentCreated = YES;
#ifdef DEBUG
        //[self drawPhysicsBodies];
#endif
    }
}

- (void)createSceneContents {
    self.scaleMode = SKSceneScaleModeAspectFit;
    self.backgroundColor = kPlaySceneBackgroundColor;
    self.speed = 1.0f;
    self.lastTime = 0.0f;
    self.elapsedTime = 0.0f;
    self.wallAddedAt = [NSDate date];
    self.score = 0;
    self.removedLines = 0;
#ifdef DEBUG
    //self.score = 15782;
#endif
    
    if ([[NSBundle mainBundle] pathForResource:@"break2" ofType:@"caf"]) {
        self.breakAction = [SKAction playSoundFileNamed:@"break.caf" waitForCompletion:NO];
    }
    
    //[self addGridNode];
    [self addStickNode];
    [self addTimeNode];
    [self addScoreNode];
    [self addHelpNode];
    
    [self setRecognizer];
    
    self.physicsWorld.contactDelegate = self;
}

# pragma mark - Callbacks

- (void)update:(NSTimeInterval)currentTime {
    if (self.lastTime) {
        self.elapsedTime += (currentTime - self.lastTime);
        
        int ms = (int)(self.elapsedTime * 100.0f) % 100;
        int s = (int)self.elapsedTime % 60;
        int m = (int)self.elapsedTime / 60;
        self.timeNode.text = [NSString stringWithFormat:@"%02d:%02d:%02d", m, s, ms];
    }
    self.lastTime = currentTime;
    CGFloat interval = INTERVAL + arc4random_uniform(INTERVAL_BUFFER) / self.speed;
    if ([[NSDate date] timeIntervalSinceDate:self.wallAddedAt] > interval ||
        (self.elapsedTime > INTERVAL && ![self childNodeWithName:WALL_NAME])) {
        [self addWallNode];
        self.wallAddedAt = [NSDate date];
    }
    
    self.speed += 0.0001f;
    CGFloat speed = self.longPressing ? self.speed * 5.0f : self.speed;
    [self enumerateChildNodesWithName:WALL_NAME usingBlock:^(SKNode *node, BOOL *stop) {
        node.speed = speed;
    }];
    
    self.scoreNode.text = [NSString stringWithFormat:kScoreFormat, self.score];
}

- (void)didEvaluateActions {
    if (self.stickNode.position.x < kBlockSize / 2.0f) {
        self.stickNode.position = CGPointMake(kBlockSize / 2.0f, self.stickNode.position.y);
    } else if (self.stickNode.position.x > CGRectGetWidth(self.frame) - kBlockSize / 2.0f) {
        self.stickNode.position = CGPointMake(CGRectGetWidth(self.frame) - kBlockSize / 2.0f, self.stickNode.position.y);
    }

    __weak typeof(self) weakSelf = self;
    [self enumerateChildNodesWithName:WALL_NAME usingBlock:^(SKNode *node, BOOL *stop) {
        TLWallNode *wallNode = (TLWallNode *)node;
        //CGFloat stickTopY = self.stickNode.position.y + kBlockSize * 2.0f - STICK_BUFFER;
        CGFloat stickBottomY = weakSelf.stickNode.position.y - kBlockSize * 2.0f/* + STICK_BUFFER*/;
        //CGFloat wallTopY = wallNode.position.y + kBlockSize * 2.0f;
        CGFloat wallBottomY = wallNode.position.y - kBlockSize * 2.0f;
        if (!wallNode.userData && stickBottomY < wallBottomY) {
            for (TLWallNode *node in [wallNode children]) {
                [node remove];
            }

            //[wallNode removeFromParent];
            wallNode.userData = @ { @"crashed" : @YES }.mutableCopy;

            weakSelf.removedLines++;
            weakSelf.score += (weakSelf.removedLines * (1.0f - weakSelf.elapsedTime / 10000.0f)) * 2;

            if ([TLSettingsForm shared].sound) {
                [weakSelf runAction:weakSelf.breakAction];
            }
        } else if (wallBottomY > CGRectGetMaxY(weakSelf.frame)) {
            [wallNode removeFromParent];
        }
    }];
}

# pragma mark - Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.touchedAt = [NSDate date];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!self.longPressing) {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    CGPoint prevLocation = [touch previousLocationInNode:self];

    CGFloat diff = location.x - prevLocation.x;
    [self moveStickNodeWithDiff:diff border:4.0f];
 }

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if ([self.stickNode hasActions]) {
        return;
    }
    
    if ([[NSDate date] timeIntervalSinceDate:self.touchedAt] > PRESS_DURATION - 0.05f) {
        return;
    }

    self.touchedAt = nil;

    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    CGFloat diff = location.x - self.stickNode.position.x;
    [self moveStickNodeWithDiff:diff border:kBlockSize / 2.0f];
}

- (void)moveStickNodeWithDiff:(CGFloat)diff border:(CGFloat)border {
    if (diff < -border) {
        [self.stickNode moveLeft];
    } else if (diff > border) {
        [self.stickNode moveRight];
    }
}

# pragma mark - Actions

- (void)sceneDidLongPress:(id)sender {
    UILongPressGestureRecognizer *longPressRecognizer = (UILongPressGestureRecognizer *)sender;
    if (longPressRecognizer.state == UIGestureRecognizerStateBegan) {
        self.longPressing = YES;
    } else if (longPressRecognizer.state == UIGestureRecognizerStateEnded) {
        self.longPressing = NO;
    }
}

# pragma mark - Utils

- (void)addGridNode {
    SKNode *gridNode = [SKNode node];
    gridNode.name = GRID_NAME;
    [self addChild:gridNode];
    for (int i = 0; i < ROWS; i++) {
        SKSpriteNode *hNode = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(kBlockSize * COLS, 1.0f)];
        hNode.position = CGPointMake(kBlockSize * COLS / 2, i * kBlockSize);
        [gridNode addChild:hNode];
        for (int j = 0; j < COLS; j++) {
            SKSpriteNode *vNode = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor] size:CGSizeMake(1.0f, kBlockSize * ROWS)];
            vNode.position = CGPointMake(j * kBlockSize, kBlockSize * ROWS / 2);
            [gridNode addChild:vNode];
        }
    }
}

- (void)addStickNode {
    self.stickNode = [TLStickNode node];
    self.stickNode.position = CGPointMake(kBlockSize * 4.0f + kBlockSize / 2.0f, CGRectGetMaxY(self.frame) + kBlockSize * 4.0f);
    self.stickNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(kBlockSize - STICK_BUFFER * 2.0f, kBlockSize * 4.0f - STICK_BUFFER * 2.0f)];
    self.stickNode.physicsBody.categoryBitMask = stickCategory;
    //self.stickNode.physicsBody.collisionBitMask = wallCategory;
    self.stickNode.physicsBody.collisionBitMask = 0;
    self.stickNode.physicsBody.contactTestBitMask = wallCategory;
    self.stickNode.physicsBody.allowsRotation = NO;
    self.stickNode.physicsBody.affectedByGravity = NO;
    self.stickNode.rank = [TLGlobals rankForHighScore];
    [self addChild:self.stickNode];
    
    //SKAction *moveAction = [SKAction moveTo:CGPointMake(self.stickNode.position.x, kBlockSize * 11.0f) duration:1.0f];
    SKAction *moveAction = [SKAction moveTo:CGPointMake(self.stickNode.position.x, kBlockSize * 11.0f) duration:INTERVAL];
    [self.stickNode runAction:moveAction];
}

- (void)addWallNode {
    SKNode *wallNode = [SKNode node];
    wallNode.name = WALL_NAME;
    wallNode.position = CGPointMake(0.0f, 0.0f);
    
    NSInteger cols = arc4random_uniform(COLS - 1) + 1;
    [wallNode addChild:[self wallNodeWithCols:cols offset:0]];
    [wallNode addChild:[self wallNodeWithCols:COLS - cols - 1 offset:cols + 1]];
    
    [self addChild:wallNode];

    SKAction *topAction = [SKAction moveByX:0.0f y:kBlockSize duration:0.8f];
    SKAction *foreverAction = [SKAction repeatActionForever:topAction];
    [wallNode runAction:foreverAction];
}

- (SKNode *)wallNodeWithCols:(NSInteger)cols offset:(CGFloat)offset {
    
    TLWallNode *wallNode = [[TLWallNode alloc] initWithCols:cols];
    //wallNode.name = WALL_NAME;
    //wallNode.position = CGPointMake(kBlockSize * cols / 2.0f + kBlockSize * offset, kBlockSize * 2.0f);
    wallNode.position = CGPointMake(kBlockSize * cols / 2.0f + kBlockSize * offset, 0.0f);

    //wallNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(kBlockSize * cols, kBlockSize * 4.0f)];
    wallNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(kBlockSize * cols, kBlockSize * 3.0f)];
    wallNode.physicsBody.categoryBitMask = wallCategory;
    //wallNode.physicsBody.collisionBitMask = stickCategory;
    wallNode.physicsBody.collisionBitMask = 0;
    wallNode.physicsBody.contactTestBitMask = stickCategory;
    wallNode.physicsBody.allowsRotation = NO;
    wallNode.physicsBody.affectedByGravity = NO;
    //[self addChild:wallNode];
    
    //SKAction *topAction = [SKAction moveByX:0.0f y:kBlockSize duration:0.8f];
    //SKAction *foreverAction = [SKAction repeatActionForever:topAction];
    //[wallNode runAction:foreverAction];
    
    return wallNode;
}

- (void)setRecognizer {
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(sceneDidLongPress:)];
    longPressRecognizer.minimumPressDuration = PRESS_DURATION;
    longPressRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:longPressRecognizer];
}

- (void)addTimeNode {
    self.timeNode = [SKLabelNode labelNodeWithFontNamed:@"Mosamosa"];
    self.timeNode.color = kMutedTextColor;
    self.timeNode.colorBlendFactor = 1.0f;
    self.timeNode.position = CGPointMake(PADDING, CGRectGetMaxY(self.frame) - PADDING);
    self.timeNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    self.timeNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    self.timeNode.fontSize = LABEL_FONT_SIZE;
    self.timeNode.zPosition = 2.0f;
    [self addChild:self.timeNode];
}

- (void)addScoreNode {
    self.scoreNode = [SKLabelNode labelNodeWithFontNamed:@"Mosamosa"];
    self.scoreNode.color = kMutedTextColor;
    self.scoreNode.colorBlendFactor = 1.0f;
    self.scoreNode.position = CGPointMake(CGRectGetMaxX(self.frame) - PADDING, CGRectGetMaxY(self.frame) - PADDING);
    self.scoreNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
    self.scoreNode.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
    self.scoreNode.fontSize = LABEL_FONT_SIZE;
    self.scoreNode.zPosition = 2.0f;
    [self addChild:self.scoreNode];
}

- (void)addHelpNode {
    SKNode *helpNode = [SKNode node];
    helpNode.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMaxY(self.frame) - 130.0f);
    helpNode.zPosition = 2.0f;
    [self addChild:helpNode];
    
    SKLabelNode *tapNode =  [SKLabelNode labelNodeWithFontNamed:@"Mosamosa"];
    tapNode.position = CGPointMake(0.0f, 80.0f);
    tapNode.horizontalAlignmentMode = NSTextAlignmentLeft;
    tapNode.fontSize = 12.0f;
    tapNode.text = NSLocalizedString(@"Tap", nil);
    [helpNode addChild:tapNode];

    SKLabelNode *rightLeftNode =  [SKLabelNode labelNodeWithFontNamed:@"Mosamosa"];
    rightLeftNode.position = CGPointMake(0.0f, 70.0f);
    rightLeftNode.horizontalAlignmentMode = NSTextAlignmentLeft;
    rightLeftNode.fontSize = 12.0f;
    rightLeftNode.text = NSLocalizedString(@"<-               ->", nil);
    [helpNode addChild:rightLeftNode];

    SKLabelNode *moveNode =  [SKLabelNode labelNodeWithFontNamed:@"Mosamosa"];
    moveNode.position = CGPointMake(0.0f, 60.0f);
    moveNode.horizontalAlignmentMode = NSTextAlignmentLeft;
    moveNode.fontSize = 12.0f;
    moveNode.text = NSLocalizedString(@"Longtap & move", nil);
    [helpNode addChild:moveNode];

    SKLabelNode *longNode =  [SKLabelNode labelNodeWithFontNamed:@"Mosamosa"];
    longNode.position = CGPointMake(0.0f, 20.0f);
    longNode.horizontalAlignmentMode = NSTextAlignmentLeft;
    longNode.fontSize = 12.0f;
    longNode.text = NSLocalizedString(@"Longtap", nil);
    [helpNode addChild:longNode];

    SKLabelNode *downNode =  [SKLabelNode labelNodeWithFontNamed:@"Mosamosa"];
    downNode.position = CGPointMake(0.0f, 0.0f);
    downNode.horizontalAlignmentMode = NSTextAlignmentLeft;
    downNode.fontSize = 12.0f;
    downNode.text = NSLocalizedString(@"->", nil);
    downNode.zRotation = 270.0f * M_PI / 180.0f;
    [helpNode addChild:downNode];

    SKAction *waitAction = [SKAction waitForDuration:4.0f];
    SKAction *fadeOutAction = [SKAction fadeOutWithDuration:0.3f];
    SKAction *sequence = [SKAction sequence:@[waitAction, fadeOutAction]];
    [helpNode runAction:sequence];
}

# pragma mark - SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody, *secondBody;
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }  else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    if (firstBody.categoryBitMask & stickCategory) {
        secondBody.node.parent.userData = @ { @"crashed" : @YES }.mutableCopy;
        
        [[NSUserDefaults standardUserDefaults] setInteger:self.score forKey:kScoreKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        __weak typeof(self) weakSelf = self;
        [self.stickNode removeWithCallback:^{
            if ([weakSelf.delegate respondsToSelector:@selector(playSceneDidGameOver)]) {
                [weakSelf.delegate playSceneDidGameOver];
            }
        }];
    }
}

@end
//
//  TLWallNode.m
//  Tetloop
//
//  Created by Tatsuya Tobioka on 8/25/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import "TLWallNode.h"

static NSDictionary *colors;

@interface TLWallNode ()

@property (nonatomic) NSArray *layouts;

@property (nonatomic) NSMutableArray *borderNodes;

@end

@implementation TLWallNode

- (id)initWithCols:(NSInteger)cols {
    if (self = [super init]) {
        self.cols = cols;
        [self initLayouts];
        self.borderColor = kPlaySceneBackgroundColor;
        
        CGFloat x = kBlockSize / 2.0f * -(cols - 1);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, CGRectMake(0.0f, 0.0f, kBlockSize, kBlockSize));

        self.borderNodes = @[].mutableCopy;
        for (int i = 0; i < cols; i++) {
            
            for (int j = 0; j < 4; j++) {
                SKSpriteNode *blockNode = [SKSpriteNode spriteNodeWithColor:[self colorWithCol:i row:j] size:CGSizeMake(kBlockSize, kBlockSize)];
                blockNode.position = CGPointMake(x + kBlockSize * i, kBlockSize * (1.5f - 1.0f * j));
                [self addChild:blockNode];
                
                SKShapeNode *borderNode = [SKShapeNode node];
                borderNode.path = path;
                borderNode.strokeColor = self.borderColor;
                borderNode.position = CGPointMake(blockNode.position.x - kBlockSize / 2.0f, blockNode.position.y - kBlockSize / 2.0f);
                borderNode.antialiased = NO;
                [self addChild:borderNode];
                
                [self.borderNodes addObject:borderNode];
            }
        }
    }
    return self;
}

- (void)remove {
    SKAction *fadeOutAction = [SKAction fadeOutWithDuration:0.1f];
    SKAction *removeAction = [SKAction removeFromParent];
    SKAction *sequence = [SKAction sequence:@[
                                              fadeOutAction,
                                              removeAction
                                              ]];
    [self runAction:sequence];
}

- (void)initLayouts {
    switch (self.cols) {
        case 1:
            self.layouts = [self layoutWithString:
                            @"I\n"
                            @"I\n"
                            @"I\n"
                            @"I\n"
                            ];
            break;
        case 2:
            switch (arc4random_uniform(3)) {
                case 0:
                    self.layouts = [self layoutWithString:
                                    @"LL\n"
                                    @"LL\n"
                                    @"LL\n"
                                    @"LL\n"
                                    ];
                    break;
                case 1:
                    self.layouts = [self layoutWithString:
                                    @"JJ\n"
                                    @"JJ\n"
                                    @"JJ\n"
                                    @"JJ\n"
                                    ];
                    break;
                case 2:
                    self.layouts = [self layoutWithString:
                                    @"OO\n"
                                    @"OO\n"
                                    @"OO\n"
                                    @"OO\n"
                                    ];
                    break;
            }
            break;
        case 3:
            switch (arc4random_uniform(3)) {
                case 0:
                    self.layouts = [self layoutWithString:
                                    @"LLL\n"
                                    @"LOO\n"
                                    @"JOO\n"
                                    @"JJJ\n"
                                    ];
                    break;
                case 1:
                    self.layouts = [self layoutWithString:
                                    @"SLL\n"
                                    @"SSL\n"
                                    @"JSL\n"
                                    @"JJJ\n"
                                    ];
                    break;
                case 2:
                    self.layouts = [self layoutWithString:
                                    @"LOO\n"
                                    @"LOO\n"
                                    @"LLL\n"
                                    @"LLL\n"
                                    ];
                    break;
            }
            break;
        case 4:
            switch (arc4random_uniform(3)) {
                case 0:
                    self.layouts = [self layoutWithString:
                                    @"SJJJ\n"
                                    @"SSSJ\n"
                                    @"JSSS\n"
                                    @"JJJS\n"
                                    ];
                    break;
                case 1:
                    self.layouts = [self layoutWithString:
                                    @"LLLZ\n"
                                    @"LZZZ\n"
                                    @"ZZZL\n"
                                    @"ZLLL\n"
                                    ];
                    break;
                case 2:
                    self.layouts = [self layoutWithString:
                                    @"TJJJ\n"
                                    @"TTSJ\n"
                                    @"TTSS\n"
                                    @"TTTS\n"
                                    ];
                    break;
            }
            break;
        case 5:
            switch (arc4random_uniform(3)) {
                case 0:
                    self.layouts = [self layoutWithString:
                                    @"SZZLL\n"
                                    @"SSZZL\n"
                                    @"JSZZL\n"
                                    @"JJJZZ\n"
                                    ];
                    break;
                case 1:
                    self.layouts = [self layoutWithString:
                                    @"TTTSS\n"
                                    @"LTSST\n"
                                    @"LZZTT\n"
                                    @"LLZZT\n"
                                    ];
                    break;
                case 2:
                    self.layouts = [self layoutWithString:
                                    @"LLLSS\n"
                                    @"LZSSJ\n"
                                    @"ZZSSJ\n"
                                    @"ZSSJJ\n"
                                    ];
                    break;
            }
            break;
        case 6:
            switch (arc4random_uniform(3)) {
                case 0:
                    self.layouts = [self layoutWithString:
                                    @"LLLTTT\n"
                                    @"LZZZTJ\n"
                                    @"ZZTZZJ\n"
                                    @"ZTTTJJ\n"
                                    ];
                    break;
                // 5 + 1
                case 1:
                    self.layouts = [self layoutWithString:
                                    @"TTTSSI\n"
                                    @"LTSSTI\n"
                                    @"LZZTTI\n"
                                    @"LLZZTI\n"
                                    ];
                    break;
                case 2:
                    self.layouts = [self layoutWithString:
                                    @"LLLSSI\n"
                                    @"LZSSJI\n"
                                    @"ZZSSJI\n"
                                    @"ZSSJJI\n"
                                    ];
                    break;
            }
            break;
        case 7:
            switch (arc4random_uniform(3)) {
                case 0:
                    self.layouts = [self layoutWithString:
                                    @"ZZLLJJJ\n"
                                    @"LZZLZZJ\n"
                                    @"LZZLJZZ\n"
                                    @"LLZZJJJ\n"
                                    ];
                    break;
                // 5 + 2
                case 1:
                    self.layouts = [self layoutWithString:
                                    @"TTTSSJJ\n"
                                    @"LTSSTJJ\n"
                                    @"LZZTTJJ\n"
                                    @"LLZZTJJ\n"
                                    ];
                    break;
                case 2:
                    self.layouts = [self layoutWithString:
                                    @"LLLSSOO\n"
                                    @"LZSSJOO\n"
                                    @"ZZSSJOO\n"
                                    @"ZSSJJOO\n"
                                    ];
                    break;
            }
            break;
        case 8:
            switch (arc4random_uniform(3)) {
                case 0:
                    self.layouts = [self layoutWithString:
                                    @"LLLIIIII\n"
                                    @"LLLILJJJ\n"
                                    @"OOLILZZJ\n"
                                    @"OOLILLZZ\n"
                                    ];
                    break;
                // 5 + 3
                case 1:
                    self.layouts = [self layoutWithString:
                                    @"TTTSSSLL\n"
                                    @"LTSSTSSL\n"
                                    @"LZZTTJSL\n"
                                    @"LLZZTJJJ\n"
                                    ];
                    break;
                case 2:
                    self.layouts = [self layoutWithString:
                                    @"LLLSSLOO\n"
                                    @"LZSSJLOO\n"
                                    @"ZZSSJLLL\n"
                                    @"ZSSJJLLL\n"
                                    ];
                    break;
            }
            break;
        case 9:
            switch (arc4random_uniform(3)) {
                case 0:
                    self.layouts = [self layoutWithString:
                                    @"JJJIJJJOO\n"
                                    @"OOJIZZJOO\n"
                                    @"OOLIJZZOO\n"
                                    @"LLLIJJJOO\n"
                                    ];
                    break;
                // 5 + 4
                case 1:
                    self.layouts = [self layoutWithString:
                                    @"TTTSSLLLZ\n"
                                    @"LTSSTLZZJ\n"
                                    @"LZZTTZZZL\n"
                                    @"LLZZTZLLL\n"
                                    ];
                    break;
                case 2:
                    self.layouts = [self layoutWithString:
                                    @"LLLSSTJJJ\n"
                                    @"LZSSJTTSJ\n"
                                    @"ZZSSJTTSS\n"
                                    @"ZSSJJTTTS\n"
                                    ];
                    break;
            }
            break;
    }
}

- (NSArray *)layoutWithString:(NSString *)string {
    NSMutableArray *layout = @[].mutableCopy;
    [string enumerateLinesUsingBlock:^(NSString *line, BOOL *stop) {
        NSMutableArray *row = @[].mutableCopy;
        [line enumerateSubstringsInRange:NSMakeRange(0, line.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            [row addObject:substring];
        }];
        [layout addObject:row];
    }];
    return layout;
}

- (UIColor *)colorWithCol:(NSInteger)col row:(NSInteger)row {
    NSString *blockType = self.layouts[row][col];
    return [self colorWithBlockType:blockType];
}

- (UIColor *)colorWithBlockType:(NSString *)blockType {
    if (!colors) {
        colors = @{
                   @"I" : [UIColor robinEggColor],
                   @"J" : [UIColor tealColor],
                   @"L" : [UIColor peachColor],
                   @"O" : [UIColor bananaColor],
                   @"S" : [UIColor yellowGreenColor],
                   @"Z" : [UIColor salmonColor],
                   @"T" : [UIColor lavenderColor]
                   };
    }
    return colors[blockType];
}

- (void)setBorderColor:(UIColor *)borderColor {
    _borderColor = borderColor;
    for (SKShapeNode *borderNode in self.borderNodes) {
        borderNode.strokeColor = borderColor;
    }
}

@end

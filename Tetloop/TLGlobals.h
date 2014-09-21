//
//  TLGlobals.h
//  Tetloop
//
//  Created by Tatsuya Tobioka on 8/24/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import <Foundation/Foundation.h>

static const CGFloat kBlockSize = 24.0f;
static const CGFloat kBlockBorderWidth = 1.0f;
static const CGFloat kStatusBarHeight = 0.0f;

extern NSString * const kHighScoreKey;
extern NSString * const kScoreKey;
extern NSString * const kScoreFormat;
extern NSString *const kAppleId;
extern NSString *const kRemoveAdsId;
extern NSString *const kRemoveAdsKey;

UIColor *kBackgroundColor;
UIColor *kPlaySceneBackgroundColor;
UIColor *kNormalTextColor;
UIColor *kMutedTextColor;
UIColor *kButtonNormalTextColor;
UIColor *kButtonHighlightedTextColor;

@interface TLGlobals : NSObject

+ (UIColor *)colorForHighScore;
+ (NSString *)badgeForHighScore;
+ (NSInteger)rankForHighScore;
+ (UIColor *)colorWithRank:(NSInteger)rank;
+ (NSString *)badgeWithRank:(NSInteger)rank;
+ (NSInteger)rankWithScore:(NSInteger)score;

+ (void)purchase;

@end

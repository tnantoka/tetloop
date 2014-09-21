//
//  TLGlobals.m
//  Tetloop
//
//  Created by Tatsuya Tobioka on 8/24/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import "TLGlobals.h"

NSString * const kHighScoreKey = @"kHighScoreKey";
NSString * const kScoreKey = @"kScoreKey";
NSString * const kScoreFormat = @"%08d";
NSString * const kAppleId = @"916468176";
NSString * const kRemoveAdsId = @"removeads";
NSString * const kRemoveAdsKey = @"kRemoveAdsKey";

static NSArray *colors;
static NSArray *badges;

@implementation TLGlobals

+ (void)load {
    kBackgroundColor = [UIColor blackColor];
    kPlaySceneBackgroundColor = [UIColor blackColor];
    kNormalTextColor = [UIColor ghostWhiteColor];
    kMutedTextColor = [UIColor icebergColor];
    kButtonNormalTextColor = [UIColor babyBlueColor];
    kButtonHighlightedTextColor = [UIColor blueberryColor];
    colors = @[
               [UIColor colorWithWhite:0.50f alpha:1.0f],
               [UIColor colorWithWhite:0.55f alpha:1.0f],
               [UIColor colorWithWhite:0.60f alpha:1.0f],
               [UIColor colorWithWhite:0.65f alpha:1.0f],
               [UIColor colorWithWhite:0.70f alpha:1.0f],
               [UIColor colorWithWhite:0.75f alpha:1.0f],
               [UIColor colorWithWhite:0.80f alpha:1.0f],
               [UIColor colorWithWhite:0.85f alpha:1.0f],
               [UIColor colorWithWhite:0.90f alpha:1.0f],
               [UIColor colorWithWhite:0.95f alpha:1.0f]
               ];
    badges = @[
               NSLocalizedString(@"Cypress", nil),
               NSLocalizedString(@"Iron", nil),
               NSLocalizedString(@"Bronze", nil),
               NSLocalizedString(@"Silver", nil),
               NSLocalizedString(@"Gold", nil),
               NSLocalizedString(@"Platinum", nil),
               NSLocalizedString(@"Mithril", nil),
               NSLocalizedString(@"Diamond", nil),
               NSLocalizedString(@"Orichalcum", nil),
               NSLocalizedString(@"Legend", nil)
               ];
}

+ (UIColor *)colorForHighScore {
    return [self colorWithRank:[self rankForHighScore]];
}

+ (NSString *)badgeForHighScore {
    return [self badgeWithRank:[self rankForHighScore]];
}

+ (NSInteger)rankForHighScore {
    NSInteger highScore = [[NSUserDefaults standardUserDefaults] integerForKey:kHighScoreKey];
    return [self rankWithScore:highScore];
}

+ (UIColor *)colorWithRank:(NSInteger)rank {
    return colors[rank];
}

+ (NSString *)badgeWithRank:(NSInteger)rank {
    return badges[rank];
}

+ (NSInteger)rankWithScore:(NSInteger)score {
    NSInteger rank;
    if (score > 25000) {
        rank = 9;
    } else if (score > 10000) {
        rank = 8;
    } else if (score > 5000) {
        rank = 7;
    } else if (score > 2500) {
        rank = 6;
    } else if (score > 1000) {
        rank = 5;
    } else if (score > 500) {
        rank = 4;
    } else if (score > 250) {
        rank = 3;
    } else if (score > 100) {
        rank = 2;
    } else if (score > 50) {
        rank = 1;
    } else {
        rank = 0;
    }
    return rank;
}


+ (void)purchase {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kRemoveAdsKey];
    [[CJPAdController sharedInstance] removeAdsAndMakePermanent:YES andRemember:YES];
}


@end

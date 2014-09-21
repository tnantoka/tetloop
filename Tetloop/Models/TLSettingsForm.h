//
//  TLSettingsForm.h
//  Tetloop
//
//  Created by Tatsuya Tobioka on 8/23/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TLSettingsForm : NSObject <FXForm, NSCoding>

@property (nonatomic) BOOL sound;

@property (nonatomic) NSString *price;
@property (nonatomic) NSString *localizedDescription;

+ (instancetype)shared;

- (void)serialize;

@end

//
//  TLSettingsForm.m
//  Tetloop
//
//  Created by Tatsuya Tobioka on 8/23/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import "TLSettingsForm.h"

#define DEFAULT_DESCRIPTION NSLocalizedString(@"Loading products...", )

@implementation TLSettingsForm

- (id)init {
    id obj = [[self class] deserialize];
    if (obj) {
        return obj;
    }
    
    if (self = [super init]) {
        self.sound = YES;
        self.price = @"";
        self.localizedDescription = DEFAULT_DESCRIPTION;
    }
    return self;
}

+ (instancetype)shared {
    static TLSettingsForm *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if (!sharedInstance) {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

# pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.sound = [aDecoder decodeBoolForKey:@"sound"];
        self.price = @"";
        self.localizedDescription = DEFAULT_DESCRIPTION;
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeBool:self.sound forKey:@"sound"];
}

# pragma mark - Serialize

- (void)serialize {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:[self class].key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (instancetype)deserialize {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:self.key];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

+ (NSString *)key {
    return NSStringFromClass(self.class);
}

# pragma mark - Override

- (void)setSound:(BOOL)sound {
    _sound = sound;
    [self serialize];
}


- (NSArray *)fields {
    return @[
             @"sound"
             ];
}

- (NSArray *)extraFields {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:kRemoveAdsKey]) {
        return @[
                 @"purchased",
                 @"rate",
                 @"acknowledgements"
                 ];
    } else {
        return @[
                 @"purchase",
                 @"restore",
                 @"rate",
                 @"acknowledgements"
                 ];
    }
}

- (NSDictionary *)purchaseField {
    return @{
             FXFormFieldHeader : NSLocalizedString(@"Remove ads", nil),
             FXFormFieldTitle : [NSString stringWithFormat:NSLocalizedString(@"Purchase %@", nil), self.price],
             FXFormFieldAction : @"purchaseFieldDidTap:",
             FXFormFieldType : FXFormFieldTypeLabel
             };
}

- (NSDictionary *)purchasedField {
    return @{
             FXFormFieldHeader : NSLocalizedString(@"Remove ads", nil),
             FXFormFieldType : FXFormFieldTypeLabel
             };
}

- (NSDictionary *)restoreField {
    return @{
             FXFormFieldAction : @"restoreFieldDidTap:",
             FXFormFieldType : FXFormFieldTypeLabel,
             FXFormFieldFooter : self.localizedDescription,
             };
}

- (NSDictionary *)rateField {
    return @{
             FXFormFieldHeader : @"",
             FXFormFieldAction : @"rateFieldDidTap:",
             FXFormFieldType : FXFormFieldTypeLabel
             };
}

- (NSDictionary *)acknowledgementsField
{
    return @{
             FXFormFieldHeader : @"",
             FXFormFieldAction : @"acknowledgementsFieldDidTap:",
             FXFormFieldType : FXFormFieldTypeLabel,
             FXFormFieldFooter : @"\n© 2014 SpriteKit.jp"
             };
}

@end

//
//  TLResultViewController.h
//  Tetloop
//
//  Created by Tatsuya Tobioka on 8/30/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TLResultViewController : UIViewController

@property (nonatomic) id delegate;

@end

@interface NSObject (TLResultViewControllerDelegate)

- (void)resultControllerDidRetry;

@end

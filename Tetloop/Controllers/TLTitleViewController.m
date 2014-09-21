//
//  TLTitleViewController.m
//  Tetloop
//
//  Created by Tatsuya Tobioka on 8/23/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import "TLTitleViewController.h"

#import "TLPlayViewController.h"
#import "TLSettingsViewController.h"

//static const CGFloat PADDING_HORIZONTAL = [iOSDetector is568h] ? 20.0f : 40.0f;
#define PADDING_HORIZONTAL ([iOSDetector is568h] ? 20.0f : 40.0f)
static const CGFloat PADDING_VERTICAL = 5.0f;

@interface TLTitleViewController ()

@end

@implementation TLTitleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kBackgroundColor;

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = [UIFont fontWithName:@"Mosamosa" size:30.0f];
    titleLabel.text = NSLocalizedString(@"Tetloop", nil);
    titleLabel.textColor = kNormalTextColor;
    [titleLabel sizeToFit];
    titleLabel.frame = CGRectOffset(titleLabel.frame,
                                    CGRectGetMidX(self.view.frame) - CGRectGetMidX(titleLabel.frame),
                                    120.0f
                                    );
    [self.view addSubview:titleLabel];
    
    UIButton *startButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startButton setTitle:NSLocalizedString(@"Start", nil) forState:UIControlStateNormal];
    [startButton setTitleColor:kButtonNormalTextColor forState:UIControlStateNormal];
    [startButton setTitleColor:kButtonHighlightedTextColor forState:UIControlStateHighlighted];
    startButton.titleLabel.font = [UIFont fontWithName:@"Mosamosa" size:18.0f];
    [startButton sizeToFit];
    startButton.frame = CGRectOffset(startButton.frame,
                                    CGRectGetMidX(self.view.frame) - CGRectGetMidX(startButton.frame),
                                    220.0f
                                    );
    [startButton addTarget:self action:@selector(startButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startButton];
    
    UIButton *settingsButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingsButton setTitle:NSLocalizedString(@"Settings", nil) forState:UIControlStateNormal];
    [settingsButton setTitleColor:kButtonNormalTextColor forState:UIControlStateNormal];
    [settingsButton setTitleColor:kButtonHighlightedTextColor forState:UIControlStateHighlighted];
    settingsButton.titleLabel.font = [UIFont fontWithName:@"Mosamosa" size:18.0f];
    [settingsButton sizeToFit];
    settingsButton.frame = CGRectOffset(settingsButton.frame,
                                     CGRectGetMidX(self.view.frame) - CGRectGetMidX(settingsButton.frame),
                                     270.0f
                                     );
    [settingsButton addTarget:self action:@selector(settingsButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:settingsButton];

    UIButton *copyrightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyrightButton setTitle:NSLocalizedString(@"© 2014 SpriteKit.jp", nil) forState:UIControlStateNormal];
    [copyrightButton setTitleColor:kMutedTextColor forState:UIControlStateNormal];
    [copyrightButton setTitleColor:kButtonHighlightedTextColor forState:UIControlStateHighlighted];
    copyrightButton.titleLabel.font = [UIFont fontWithName:@"Mosamosa" size:10.0f];
    [copyrightButton sizeToFit];
    copyrightButton.frame = CGRectOffset(copyrightButton.frame,
                                        CGRectGetMidX(self.view.frame) - CGRectGetMidX(copyrightButton.frame),
                                        CGRectGetHeight(self.view.frame) - CGRectGetHeight(copyrightButton.frame) - PADDING_VERTICAL
                                        );
    [copyrightButton addTarget:self action:@selector(copyrightButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:copyrightButton];
    
    UILabel *highLabel = [[UILabel alloc] init];
    highLabel.font = [UIFont fontWithName:@"Mosamosa" size:12.0f];
    highLabel.text = NSLocalizedString(@"HIGHSCORE", nil);
    highLabel.textColor = kMutedTextColor;
    [highLabel sizeToFit];
    highLabel.frame = CGRectOffset(highLabel.frame,
                                    PADDING_HORIZONTAL,
                                    PADDING_VERTICAL + kStatusBarHeight
                                    );
    [self.view addSubview:highLabel];
    
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.font = [UIFont fontWithName:@"Mosamosa" size:12.0f];
    scoreLabel.text = [NSString stringWithFormat:kScoreFormat, [[NSUserDefaults standardUserDefaults] integerForKey:kHighScoreKey]];
    scoreLabel.textColor = kMutedTextColor;
    [scoreLabel sizeToFit];
    scoreLabel.frame = CGRectOffset(scoreLabel.frame,
                                    CGRectGetWidth(self.view.frame) - CGRectGetWidth(scoreLabel.frame) - PADDING_HORIZONTAL,
                                   PADDING_VERTICAL + kStatusBarHeight
                                   );
    [self.view addSubview:scoreLabel];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

# pragma mark - Actions

- (void)startButtonDidTap:(id)sender {
    TLPlayViewController *playController = [[TLPlayViewController alloc] init];
    [self.navigationController pushViewController:playController animated:NO];
}

- (void)settingsButtonDidTap:(id)sender {
    TLSettingsViewController *settingsController = [[TLSettingsViewController alloc] init];
    //[self.navigationController pushViewController:settingsController animated:YES];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:settingsController];
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)copyrightButtonDidTap:(id)sender {
    NSURL *url = [NSURL URLWithString:@"http://spritekit.jp/games/"];
    [[UIApplication sharedApplication] openURL:url];
}

@end

//
//  TLResultViewController.m
//  Tetloop
//
//  Created by Tatsuya Tobioka on 8/30/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import "TLResultViewController.h"

@interface TLResultViewController ()

@end

@implementation TLResultViewController

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

    NSInteger highScore = [[NSUserDefaults standardUserDefaults] integerForKey:kHighScoreKey];
    NSInteger score = [[NSUserDefaults standardUserDefaults] integerForKey:kScoreKey];
    BOOL isHighScore = NO;
    if (score > highScore) {
        [[NSUserDefaults standardUserDefaults] setInteger:score forKey:kHighScoreKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        isHighScore = YES;
    }

    UILabel *gameOverLabel = [[UILabel alloc] init];
    gameOverLabel.font = [UIFont fontWithName:@"Mosamosa" size:26.0f];
    gameOverLabel.text = NSLocalizedString(@"GAME OVER", nil);
    gameOverLabel.textColor = kNormalTextColor;
    [gameOverLabel sizeToFit];
    gameOverLabel.frame = CGRectOffset(gameOverLabel.frame,
                                    CGRectGetMidX(self.view.frame) - CGRectGetMidX(gameOverLabel.frame),
                                    70.0f
                                    );
    [self.view addSubview:gameOverLabel];
    
    UILabel *scoreLabel = [[UILabel alloc] init];
    scoreLabel.font = [UIFont fontWithName:@"Mosamosa" size:16.0f];
    scoreLabel.text = [NSString stringWithFormat:kScoreFormat, score];
    scoreLabel.textColor = kNormalTextColor;
    [scoreLabel sizeToFit];
    scoreLabel.frame = CGRectOffset(scoreLabel.frame,
                                       CGRectGetMidX(self.view.frame) - CGRectGetMidX(scoreLabel.frame),
                                       130.0f
                                       );
    [self.view addSubview:scoreLabel];
    
    if (isHighScore) {
        UILabel *newLabel = [[UILabel alloc] init];
        newLabel.font = [UIFont fontWithName:@"Mosamosa" size:12.0f];
        newLabel.text = NSLocalizedString(@"New", nil);
        newLabel.textColor = kNormalTextColor;
        newLabel.backgroundColor = [UIColor burntOrangeColor];
        newLabel.contentMode = UIViewContentModeCenter;
        newLabel.textAlignment = NSTextAlignmentCenter;
        [newLabel sizeToFit];
        newLabel.frame = CGRectApplyAffineTransform(newLabel.frame, CGAffineTransformMakeScale(1.4f, 1.4f));
        newLabel.frame = CGRectOffset(newLabel.frame,
                                        CGRectGetMaxX(scoreLabel.frame) + 10.0f,
                                        CGRectGetMinY(scoreLabel.frame)
                                        );
    
        [self.view addSubview:newLabel];
    }

    CGFloat scale = 0.7f;
    CGFloat blockSize = kBlockSize * scale;
    CGFloat borderWidth = kBlockBorderWidth * scale;
    UIView *badgesView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(scoreLabel.frame),
                                                                 190.0f,
                                                                 blockSize,
                                                                 blockSize * 4.0f + borderWidth * 4.0f)];
    //badgesView.transform = CGAffineTransformMakeRotation(30.0f * M_PI / 180.0f);
    for (int i = 0; i < 4; i++) {
        UIView *badgeView = [[UIView alloc] initWithFrame:CGRectMake(0.0f,
                                                                     blockSize * i + borderWidth * i,
                                                                     blockSize,
                                                                     blockSize)];
        badgeView.backgroundColor = [TLGlobals colorWithRank:[TLGlobals rankWithScore:score]];
        [badgesView addSubview:badgeView];
    }
    [self.view addSubview:badgesView];
    
    UILabel *badgeLabel = [[UILabel alloc] init];
    badgeLabel.font = [UIFont fontWithName:@"Mosamosa" size:16.0f];
    badgeLabel.text = [TLGlobals badgeWithRank:[TLGlobals rankWithScore:score]];
    badgeLabel.textColor = kNormalTextColor;
    [badgeLabel sizeToFit];
    badgeLabel.frame = CGRectOffset(badgeLabel.frame,
                                    CGRectGetMinX(scoreLabel.frame) + 30.0f,
                                    CGRectGetMidY(badgesView.frame) - CGRectGetMidY(badgeLabel.frame)
                                    );
    [self.view addSubview:badgeLabel];
    
    UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setTitle:NSLocalizedString(@"Share", nil) forState:UIControlStateNormal];
    [shareButton setTitleColor:kButtonNormalTextColor forState:UIControlStateNormal];
    [shareButton setTitleColor:kButtonHighlightedTextColor forState:UIControlStateHighlighted];
    shareButton.titleLabel.font = [UIFont fontWithName:@"Mosamosa" size:18.0f];
    [shareButton sizeToFit];
    shareButton.frame = CGRectOffset(shareButton.frame,
                                     CGRectGetMidX(self.view.frame) - CGRectGetMidX(shareButton.frame),
                                     300.0f
                                     );
    [shareButton addTarget:self action:@selector(shareButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];

    UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [retryButton setTitle:NSLocalizedString(@"Retry", nil) forState:UIControlStateNormal];
    [retryButton setTitleColor:kButtonNormalTextColor forState:UIControlStateNormal];
    [retryButton setTitleColor:kButtonHighlightedTextColor forState:UIControlStateHighlighted];
    retryButton.titleLabel.font = [UIFont fontWithName:@"Mosamosa" size:18.0f];
    [retryButton sizeToFit];
    retryButton.frame = CGRectOffset(retryButton.frame,
                                     CGRectGetMidX(self.view.frame) - CGRectGetMidX(retryButton.frame),
                                     340.0f
                                     );
    [retryButton addTarget:self action:@selector(retryButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:retryButton];

    UIButton *homeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeButton setTitle:NSLocalizedString(@"Home", nil) forState:UIControlStateNormal];
    [homeButton setTitleColor:kButtonNormalTextColor forState:UIControlStateNormal];
    [homeButton setTitleColor:kButtonHighlightedTextColor forState:UIControlStateHighlighted];
    homeButton.titleLabel.font = [UIFont fontWithName:@"Mosamosa" size:18.0f];
    [homeButton sizeToFit];
    homeButton.frame = CGRectOffset(homeButton.frame,
                                     CGRectGetMidX(self.view.frame) - CGRectGetMidX(homeButton.frame),
                                     380.0f
                                     );
    [homeButton addTarget:self action:@selector(homeButtonDidTap:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:homeButton];

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

# pragma mark - Utils

- (UIImage *)screenCapture {
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size , NO , [UIScreen mainScreen].scale);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *capture = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capture;
}

- (UIImage *)screenCaptureWithRect:(CGRect)rect {
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size , NO , [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, -rect.origin.x, -rect.origin.y);
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    UIImage *capture = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return capture;
}

# pragma mark - Actions

- (void)shareButtonDidTap:(id)sender {
    NSString *text = [NSString stringWithFormat:NSLocalizedString(@"I'm a %@ stick! #tetloop", nil), [TLGlobals badgeForHighScore]];
    NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/tetloop/id%@", kAppleId];
    NSURL *url = [NSURL URLWithString:urlString];
    UIImage *image = [self screenCapture];
    UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:@[text, url, image] applicationActivities:nil];
    [self.navigationController presentViewController:activityController animated:YES completion:nil];
}

- (void)retryButtonDidTap:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
    if ([self.delegate respondsToSelector:@selector(resultControllerDidRetry)]) {
        [self.delegate resultControllerDidRetry];
    }
}

- (void)homeButtonDidTap:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end

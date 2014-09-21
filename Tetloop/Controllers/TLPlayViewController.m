//
//  TLPlayViewController.m
//  Tetloop
//
//  Created by Tatsuya Tobioka on 8/23/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import "TLPlayViewController.h"

#import "TLPlayScene.h"
#import "TLResultViewController.h"

@import SpriteKit;

@interface TLPlayViewController ()

@end

@implementation TLPlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView {
    CGRect applicationFrame = [[UIScreen mainScreen] applicationFrame];

    SKView *skView = [[SKView alloc] initWithFrame:applicationFrame];
    self.view = skView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
#ifdef DEBUG
    //SKView *skView = (SKView *)self.view;
    //skView.showsDrawCount = YES;
    //skView.showsNodeCount = YES;
    //skView.showsFPS = YES;
#endif
    [self start];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

- (BOOL)prefersStatusBarHidden {
    return YES;
}


# pragma mark - Utils

- (void)start {
    SKView *skView = (SKView *)self.view;
    skView.paused = NO;
    
    TLPlayScene *scene = [TLPlayScene scene];
    scene.delegate = self;
    [skView presentScene:scene];
}

# pragma mark - TLPlaySceneDelegate

- (void)playSceneDidGameOver {
    SKView *skView = (SKView *)self.view;
    skView.paused = YES;
    
    TLResultViewController *resultController = [[TLResultViewController alloc] init];
    resultController.delegate = self;
    [self.navigationController pushViewController:resultController animated:NO];
}

# pragma mark - TLResultViewControllerDelegate

- (void)resultControllerDidRetry {
    [self start];
}

@end

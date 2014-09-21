//
//  TLOpeningViewController.m
//  Tetloop
//
//  Created by Tatsuya Tobioka on 9/4/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import "TLOpeningViewController.h"

#import "TLOpeningScene.h"
#import "TLTitleViewController.h"

@import SpriteKit;

@interface TLOpeningViewController ()

@end

@implementation TLOpeningViewController

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
    
    self.view.backgroundColor = [UIColor greenColor];

    SKView *skView = (SKView *)self.view;
#ifdef DEBUG
    //skView.showsDrawCount = YES;
    //skView.showsNodeCount = YES;
    //skView.showsFPS = YES;
#endif

    TLOpeningScene *scene = [TLOpeningScene scene];
    scene.delegate = self;
    [skView presentScene:scene];
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

# pragma mark - TLOpeningSceneDelegate

- (void)openingSceneDidFadeOut {
    TLTitleViewController *titleController = [[TLTitleViewController alloc] init];
    //[self.navigationController pushViewController:titleController animated:YES];
    [self.navigationController setViewControllers:@[titleController] animated:NO];
}

@end

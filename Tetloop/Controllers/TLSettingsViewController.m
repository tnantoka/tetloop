//
//  TLSettingsViewController.m
//  Tetloop
//
//  Created by Tatsuya Tobioka on 8/23/14.
//  Copyright (c) 2014 tnantoka. All rights reserved.
//

#import "TLSettingsViewController.h"

#import "TLSettingsForm.h"

@interface TLSettingsViewController ()

@end

@implementation TLSettingsViewController

- (id)init {
    if (self = [super init]) {
        self.formController.form = [TLSettingsForm shared];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"Settings", nil);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", nil) style:UIBarButtonItemStylePlain target:self action:@selector(closeItemDidTap:)];
    self.navigationItem.leftBarButtonItem = closeItem;
    
    __weak typeof(self) weakSelf = self;
    NSSet *products = [NSSet setWithArray:@[kRemoveAdsId]];
    [[RMStore defaultStore] requestProducts:products success:^(NSArray *products, NSArray *invalidProductIdentifiers) {
        SKProduct *product = products.firstObject;
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
        NSString *localizedPrice = [numberFormatter stringFromNumber:product.price];

        [TLSettingsForm shared].price = [NSString stringWithFormat:@"(%@)", localizedPrice];
        [TLSettingsForm shared].localizedDescription = product.localizedDescription;
        
        [weakSelf reload];
    } failure:^(NSError *error) {
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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

# pragma mark - Actions 

- (void)purchaseFieldDidTap:(id)sender {
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [[RMStore defaultStore] addPayment:kRemoveAdsId success:^(SKPaymentTransaction *transaction) {
        [SVProgressHUD dismiss];
        [TLGlobals purchase];
        [weakSelf reload];
    } failure:^(SKPaymentTransaction *transaction, NSError *error) {
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void)restoreFieldDidTap:(id)sender {
    [SVProgressHUD show];
    __weak typeof(self) weakSelf = self;
    [[RMStore defaultStore] restoreTransactionsOnSuccess:^{
        [SVProgressHUD dismiss];
        [TLGlobals purchase];
        [weakSelf reload];
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }];
}

- (void)rateFieldDidTap:(id)sender {
    NSString *urlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", kAppleId];
    NSURL *url = [NSURL URLWithString:urlString];
    [[UIApplication sharedApplication] openURL:url];
}

- (void)acknowledgementsFieldDidTap:(id)sender {
    VTAcknowledgementsViewController *acknowledgementsController = [VTAcknowledgementsViewController acknowledgementsViewController];
    [self.navigationController pushViewController:acknowledgementsController animated:YES];
}

- (void)closeItemDidTap:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)reload {
    self.formController.form = [TLSettingsForm shared];
    [self.formController.tableView reloadData];
}

@end

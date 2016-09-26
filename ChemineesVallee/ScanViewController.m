//
//  ScanViewController.m
//  ChemineesVallee
//
//  Created by Vincent Jardel on 19/09/2016.
//  Copyright © 2016 Vincent Jardel. All rights reserved.
//

#import "ScanViewController.h"

@interface ScanViewController ()
@end

BOOL scanView;

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.delegate = self;
    
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            self.vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Annuler" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
            self.vc.modalPresentationStyle = UIModalPresentationFormSheet;
        self.vc.delegate = self;
        __weak typeof(self) weakSelf = self;
        [self.vc setCompletionWithBlock:^(NSString *resultAsString) {
            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:resultAsString]]];
        }];
        
        [self displayQRCodeView];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Le lecteur n'est pas supporté par l'appareil" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!scanView) {
        [self displayQRCodeView];
    }
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    [reader stopScanning];
    [self removeQRCodeView];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [self removeQRCodeView];
    [self.tabBarController setSelectedIndex:0];
}

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"item: %ld", theTabBarController.selectedIndex);
    if (theTabBarController.selectedIndex == 1 && !scanView && ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]])) {
        [self displayQRCodeView];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (!webView.isLoading) {
       [self.hud removeFromSuperview];
    }
}

- (void)displayQRCodeView {
    [self addChildViewController:self.vc];
    [self.view addSubview:self.vc.view];
    [self.vc didMoveToParentViewController:self];
    scanView = YES;
}

- (void)removeQRCodeView {
    [self.vc willMoveToParentViewController:nil];
    [self.vc.view removeFromSuperview];
    [self.vc removeFromParentViewController];
    scanView = NO;
}

@end

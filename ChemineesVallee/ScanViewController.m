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

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.delegate = self;
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        self.vc = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            self.vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Annuler" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
            self.vc.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        self.vc.delegate = self;
        __weak typeof(self) weakSelf = self;
        [self.vc setCompletionWithBlock:^(NSString *resultAsString) {
            [weakSelf.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:resultAsString]]];
        }];
        
        [self.tabBarController presentViewController:self.vc animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Le lecteur n'est pas supporté par l'appareil" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    [reader stopScanning];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
//    [self.tabBarController setSelectedIndex:0];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController {
    NSUInteger indexOfTab = [theTabBarController.viewControllers indexOfObject:viewController];
    if (indexOfTab == 1 && ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]])) {
        [self.tabBarController presentViewController:self.vc animated:YES completion:NULL];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.hud removeFromSuperview];
}



@end

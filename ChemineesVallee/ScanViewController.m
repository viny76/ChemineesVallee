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
    
    NSString *scriptString = @"var styleTag = document.createElement(\"style\"); styleTag.textContent = 'div#SITE_HEADER {display:none !important;} div#PAGES_CONTAINER {position: absolute !important; top: 1% !important; left: 0px !important;}'; document.documentElement.appendChild(styleTag);";
    WKUserScript *script = [[WKUserScript alloc] initWithSource:scriptString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addUserScript:script];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.delegate = self;
    
    // If it is present, create a WKWebView. If not, create a UIWebView.
    if (NSClassFromString(@"WKWebView")) {
        self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        self.view = self.wkWebView;
        self.wkWebView.navigationDelegate = self;
        if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            self.vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Annuler" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
            self.vc.modalPresentationStyle = UIModalPresentationFormSheet;
            self.vc.delegate = self;
            __weak typeof(self) weakSelf = self;
            [self.vc setCompletionWithBlock:^(NSString *resultAsString) {
                [weakSelf.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:resultAsString]]];
            }];
            
            [self displayQRCodeView];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Le lecteur n'est pas supporté par l'appareil" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    } else {
        self.webView = [[UIWebView alloc] initWithFrame: [self.view bounds]];
        self.webView.delegate = self;
        self.view = self.webView;
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
//    [self removeQRCodeView];
    [self.tabBarController setSelectedIndex:0];
}

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"item: %ld", theTabBarController.selectedIndex);
    if (theTabBarController.selectedIndex == 1 && ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]])) {
        if (scanView) {
        } else {
            [self displayQRCodeView];
        }
    }
}

// UIWebView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    scanView = NO;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.hud hide:YES afterDelay:10.0];
    self.hud.mode = MBProgressHUDModeIndeterminate;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    scanView = NO;
    if (!webView.isLoading) {
        NSString *cssString = @"div#SITE_HEADER {display:none;} div#PAGES_CONTAINER {position: absolute !important; top: 1% !important; left: 0px !important;}";
        NSString *javascriptString = @"var style = document.createElement('style'); style.innerHTML = '%@'; document.head.appendChild(style)";
        NSString *javascriptWithCSSString = [NSString stringWithFormat:javascriptString, cssString];
        [webView stringByEvaluatingJavaScriptFromString:javascriptWithCSSString];
        [self.hud removeFromSuperview];
        self.tabBarController.tabBar.userInteractionEnabled = YES;
    }
}

// WKWebView delegate
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    scanView = NO;
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    [self.hud hide:YES afterDelay:10.0];
    self.hud.mode = MBProgressHUDModeIndeterminate;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    scanView = NO;
    if (!webView.isLoading) {
        [self.hud removeFromSuperview];
        self.tabBarController.tabBar.userInteractionEnabled = YES;
    }
}

- (void)displayQRCodeView {
    if (![self.hud isHidden]) {
        [self.hud removeFromSuperview];
    }
    [self addChildViewController:self.vc];
    [self.view addSubview:self.vc.view];
    [self.vc didMoveToParentViewController:self];
    self.tabBarController.delegate = self;
    scanView = YES;
}

- (void)removeQRCodeView {
    [self.vc willMoveToParentViewController:nil];
    [self.vc.view removeFromSuperview];
    [self.vc removeFromParentViewController];
}

@end

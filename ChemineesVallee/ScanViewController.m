//
//  ScanViewController.m
//  ChemineesVallee
//
//  Created by Vincent Jardel on 19/09/2016.
//  Copyright © 2016 Vincent Jardel. All rights reserved.
//

#import "ScanViewController.h"
#import "Screen.h"

@interface ScanViewController ()
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *scriptString = @"var styleTag = document.createElement(\"style\"); styleTag.textContent = 'div#SITE_HEADER {display:none !important;} div#PAGES_CONTAINER {position: absolute !important; top: 1% !important; left: 0px !important;}'; document.documentElement.appendChild(styleTag);";
    WKUserScript *script = [[WKUserScript alloc] initWithSource:scriptString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addUserScript:script];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;
    
    self.tabBarController.delegate = self;
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
    self.view = self.wkWebView;
    self.wkWebView.UIDelegate = self;
    self.wkWebView.navigationDelegate = self;
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        self.vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Annuler" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
        self.vc.delegate = self;
        __weak typeof(self) weakSelf = self;
        [self.vc setCompletionWithBlock:^(NSString *resultAsString) {
            [weakSelf.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:resultAsString]]];
            if (![weakSelf.hud isHidden]) {
                [weakSelf.hud removeFromSuperview];
            }
            weakSelf.hud = [MBProgressHUD showHUDAddedTo:weakSelf.view animated:YES];
        }];
        
        [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        
        [self displayQRCodeView];
        [self removeButton];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Le lecteur n'est pas supporté par l'appareil" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result {
    [reader stopScanning];
    [self removeQRCodeView];
    [self displayButton];
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader {
    [self.hud removeFromSuperview];
    [self.tabBarController setSelectedIndex:0];
}

// WKWebView delegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [self.hud setProgress:0.0];
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    
    return nil;
}

- (void)displayQRCodeView {
    [self addChildViewController:self.vc];
    CGRect newFrame = self.vc.view.frame;
    newFrame.size.width = [Screen width];
    newFrame.size.height = self.view.frame.size.height;
    [self.vc.view setFrame:newFrame];
    [self.view addSubview:self.vc.view];
    self.view.center = self.view.superview.center;
    [self.vc didMoveToParentViewController:self];
    self.tabBarController.delegate = self;
}

- (void)removeQRCodeView {
    [self.vc willMoveToParentViewController:nil];
    [self.vc.view removeFromSuperview];
    [self.vc removeFromParentViewController];
}

- (IBAction)backButtonPressed:(id)sender {
    [self.hud setProgress:(float)self.wkWebView.estimatedProgress];
    [self.wkWebView goBack];
}

- (void)displayButton {
    [self.backButton setEnabled:YES];
    [self.backButton setTintColor:nil];
    [self.photoButton setEnabled:YES];
}

- (void)removeButton {
    [self.backButton setEnabled:NO];
    [self.backButton setTintColor: [UIColor clearColor]];
    [self.photoButton setEnabled:NO];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (self.wkWebView.estimatedProgress == 1) {
            [self.hud removeFromSuperview];
            self.hud.hidden = YES;
        } else {
            self.hud.hidden = NO;
        }
        
        [self.hud setProgress:(float)self.wkWebView.estimatedProgress];
    }
}

- (IBAction)photoButton:(id)sender {
    [self displayQRCodeView];
    [self removeButton];
}


@end

//
//  ActualitesViewController.m
//  ChemineesVallee
//
//  Created by Vincent Jardel on 21/09/2016.
//  Copyright © 2016 Vincent Jardel. All rights reserved.
//

#import "ActualitesViewController.h"
#import <Parse/Parse.h>
#import "NotificationViewController.h"
#import "LoginViewController.h"

@interface ActualitesViewController ()
@end

@implementation ActualitesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.backButton setEnabled:NO];
    [self.backButton setTintColor: [UIColor clearColor]];
    NSString *scriptString = @"var styleTag = document.createElement(\"style\"); styleTag.textContent = 'div#SITE_HEADER {display:none !important;} div#PAGES_CONTAINER {position: absolute !important; top: 1% !important; left: 0px !important;}'; document.documentElement.appendChild(styleTag);";
    WKUserScript *script = [[WKUserScript alloc] initWithSource:scriptString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addUserScript:script];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;
    
    self.tabBarController.delegate = self;
    
    // If it is present, create a WKWebView. If not, create a UIWebView.
    if (NSClassFromString(@"WKWebView")) {
        self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        self.view = self.wkWebView;
        self.wkWebView.UIDelegate = self;
        self.wkWebView.navigationDelegate = self;
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.chemineesvallee.com/actualites"]]];
    } else {
        self.webView = [[UIWebView alloc] initWithFrame: [self.view bounds]];
        self.webView.delegate = self;
        self.view = self.webView;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.chemineesvallee.com/actualites"]]];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    if (([[PFUser currentUser] objectForKey:@"admin"]) != nil && [[[PFUser currentUser] objectForKey:@"admin"] boolValue] == YES) {
        NSLog(@"%@", [PFUser currentUser]);
    }
}

// UIWebView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.hud hide:YES afterDelay:10.0];
    self.hud.mode = MBProgressHUDModeIndeterminate;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
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
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.hud hide:YES afterDelay:10.0];
    self.hud.mode = MBProgressHUDModeIndeterminate;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (!webView.isLoading) {
        [self.hud removeFromSuperview];
        self.tabBarController.tabBar.userInteractionEnabled = YES;
    }
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    
    return nil;
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if ([navigationAction.request.URL.absoluteString isEqualToString:@"http://www.chemineesvallee.com/actualites"] || [navigationAction.request.URL.absoluteString isEqualToString:@"mailto:info@chemineesvallee.com"] || [navigationAction.request.URL.absoluteString isEqualToString:@"tel:0235983750"] || [navigationAction.request.URL.absoluteString hasPrefix:@"https://wix-pop-up.appspot.com/app"]) {
        [self.backButton setEnabled:NO];
        [self.backButton setTintColor: [UIColor clearColor]];
    } else {
        [self.backButton setEnabled:YES];
        [self.backButton setTintColor:nil];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (IBAction)refreshButton:(id)sender {
    // If it is present, create a WKWebView. If not, create a UIWebView.
    if (![self.hud isHidden]) {
        [self.hud removeFromSuperview];
    }
    if (NSClassFromString(@"WKWebView")) {
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.chemineesvallee.com/actualites"]]];
    } else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.chemineesvallee.com/actualites"]]];
    }
}

- (IBAction)logoTouched:(id)sender {
    if (([[PFUser currentUser] objectForKey:@"admin"]) != nil && [[[PFUser currentUser] objectForKey:@"admin"] boolValue] == YES) {
        NotificationViewController *notificationView = [self.storyboard instantiateViewControllerWithIdentifier:@"NotificationViewController"];
        [self.navigationController pushViewController:notificationView animated:YES];
    } else {
        LoginViewController *loginView = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:loginView animated:YES];
    }
}

- (IBAction)backButton:(id)sender {
    if (![self.hud isHidden]) {
        [self.hud removeFromSuperview];
    }
    [self.wkWebView goBack];
    [self.wkWebView reload];
}

@end

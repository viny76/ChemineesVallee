//
//  EvenementsViewController.m
//  ChemineesVallee
//
//  Created by Vincent Jardel on 21/09/2016.
//  Copyright © 2016 Vincent Jardel. All rights reserved.
//

#import "EvenementsViewController.h"
#import "AppDelegate.h"

@interface EvenementsViewController ()

@end

@implementation EvenementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.delegate = self;
    
    NSString *scriptString = @"var styleTag = document.createElement(\"style\"); styleTag.textContent = 'div#SITE_HEADER {display:none !important;} div#PAGES_CONTAINER {position: absolute !important; top: 1% !important; left: 0px !important;}'; document.documentElement.appendChild(styleTag);";
    WKUserScript *script = [[WKUserScript alloc] initWithSource:scriptString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
    [userContentController addUserScript:script];
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    configuration.userContentController = userContentController;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    
    // If it is present, create a WKWebView. If not, create a UIWebView.
    if (NSClassFromString(@"WKWebView")) {
        self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        self.view = self.wkWebView;
        self.wkWebView.navigationDelegate = self;
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.chemineesvallee.com/evenements"]]];
    } else {
        self.webView = [[UIWebView alloc] initWithFrame: [self.view bounds]];
        self.webView.delegate = self;
        self.view = self.webView;
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.chemineesvallee.com/evenements"]]];
    }
}

// UIWebView delegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.tabBarController.tabBar.userInteractionEnabled = NO;
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    self.hud.mode = MBProgressHUDModeIndeterminate;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if (!webView.isLoading) {
        [self.hud removeFromSuperview];
        self.tabBarController.tabBar.userInteractionEnabled = YES;
    }
}

- (IBAction)refreshButton:(id)sender {
    // If it is present, create a WKWebView. If not, create a UIWebView.
    if (NSClassFromString(@"WKWebView")) {
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.chemineesvallee.com/evenements"]]];
    } else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.chemineesvallee.com/evenements"]]];
    }
}

- (void)tabBarController:(UITabBarController *)theTabBarController didSelectViewController:(UIViewController *)viewController {
    NSLog(@"item: %ld", theTabBarController.selectedIndex);
}

@end

//
//  EvenementsViewController.m
//  ChemineesVallee
//
//  Created by Vincent Jardel on 21/09/2016.
//  Copyright © 2016 Vincent Jardel. All rights reserved.
//

#import "EvenementsViewController.h"

@interface EvenementsViewController ()

@end

@implementation EvenementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.delegate = self;
    
    // If it is present, create a WKWebView. If not, create a UIWebView.
    if (NSClassFromString(@"WKWebView")) {
        WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
        self.wkWebView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:theConfiguration];
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
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (!webView.isLoading) {
        NSString *cssString = @"#SITE_HEADER, #comp-imrw5tvg, #WRchTxt0-16wb, #comp-imrvq5jg, #comp-imrv0zgf, #SITE_FOOTERinlineContent, #SITE_FOOTER { display: none;}";
        NSString *javascriptString = @"var style = document.createElement('style'); style.innerHTML = '%@'; document.head.appendChild(style)";
        NSString *javascriptWithCSSString = [NSString stringWithFormat:javascriptString, cssString];
        [webView stringByEvaluatingJavaScriptFromString:javascriptWithCSSString];
        [self.hud removeFromSuperview];
    }
}

// WKWebView delegate
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.mode = MBProgressHUDModeIndeterminate;
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSString *cssString = @"#SITE_HEADER, #comp-imrw5tvg, #WRchTxt0-16wb, #comp-imrvq5jg, #comp-imrv0zgf, #SITE_FOOTERinlineContent, #SITE_FOOTER { display: none;}";
    NSString *javascriptString = @"var style = document.createElement('style'); style.innerHTML = '%@'; document.head.appendChild(style)";
    NSString *javascriptWithCSSString = [NSString stringWithFormat:javascriptString, cssString];
    [webView evaluateJavaScript:javascriptWithCSSString completionHandler:^(id obj, NSError * _Nullable error) {
        if (!webView.isLoading) {
            [self.hud removeFromSuperview];
        }
    }];
}

- (IBAction)refreshButton:(id)sender {
    // If it is present, create a WKWebView. If not, create a UIWebView.
    if (NSClassFromString(@"WKWebView")) {
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.chemineesvallee.com/evenements"]]];
    } else {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.chemineesvallee.com/evenements"]]];
    }
}

@end

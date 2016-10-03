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
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.chemineesvallee.com/actualites"]]];
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (self.wkWebView.estimatedProgress == 1) {
            self.hud.hidden = YES;
        } else {
            self.hud.hidden = NO;
        }
        
        [self.hud setProgress:(float)self.wkWebView.estimatedProgress];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (IBAction)refreshButton:(id)sender {
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.chemineesvallee.com/actualites"]]];
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
    [self.hud setProgress:(float)self.wkWebView.estimatedProgress];
    [self.wkWebView goBack];
}

@end

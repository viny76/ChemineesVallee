//
//  ActualitesViewController.h
//  ChemineesVallee
//
//  Created by Vincent Jardel on 21/09/2016.
//  Copyright © 2016 Vincent Jardel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"

@interface ActualitesViewController : UIViewController <UITabBarDelegate, UITabBarControllerDelegate, WKNavigationDelegate, WKUIDelegate, MBProgressHUDDelegate>

@property (strong, nonatomic) MBProgressHUD *hud;
@property (retain, nonatomic) WKWebView *wkWebView;
@property (weak, nonatomic) IBOutlet UIButton *logoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;

@end

//
//  EvenementsViewController.h
//  ChemineesVallee
//
//  Created by Vincent Jardel on 21/09/2016.
//  Copyright © 2016 Vincent Jardel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "MBProgressHUD.h"

@interface EvenementsViewController : UIViewController <UITabBarDelegate, UITabBarControllerDelegate, UIWebViewDelegate, WKNavigationDelegate, WKUIDelegate>

@property (strong, nonatomic) MBProgressHUD *hud;

@end

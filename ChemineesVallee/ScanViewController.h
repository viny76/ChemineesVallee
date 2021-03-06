//
//  ScanViewController.h
//  ChemineesVallee
//
//  Created by Vincent Jardel on 19/09/2016.
//  Copyright © 2016 Vincent Jardel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QRCodeReaderDelegate.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"
#import "MBProgressHUD.h"
#import <WebKit/WebKit.h>

@interface ScanViewController : QRCodeReaderViewController <QRCodeReaderDelegate, UITabBarDelegate, UITabBarControllerDelegate, WKNavigationDelegate, WKUIDelegate, MBProgressHUDDelegate>

@property (strong, nonatomic) QRCodeReaderViewController *vc;
@property (retain, nonatomic) WKWebView *wkWebView;
@property (strong, nonatomic) MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *photoButton;

@end


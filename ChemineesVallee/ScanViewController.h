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

@interface ScanViewController : UIViewController <QRCodeReaderDelegate, UIWebViewDelegate, UITabBarDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) QRCodeReaderViewController *vc;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) MBProgressHUD *hud;

@end


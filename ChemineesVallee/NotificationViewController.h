//
//  NotificationViewController.h
//  ChemineesVallee
//
//  Created by Vincent Jardel on 27/09/2016.
//  Copyright © 2016 Vincent Jardel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *notificationText;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

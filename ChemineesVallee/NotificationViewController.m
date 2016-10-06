//
//  NotificationViewController.m
//  ChemineesVallee
//
//  Created by Vincent Jardel on 27/09/2016.
//  Copyright © 2016 Vincent Jardel. All rights reserved.
//

#import "NotificationViewController.h"
#import <Parse/Parse.h>

@interface NotificationViewController ()
@end

@implementation NotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sendButton.layer.cornerRadius = 10;
    self.sendButton.clipsToBounds = YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Prevent crashing undo bug – see note below.
    if (range.length + range.location > textField.text.length) {
        return NO;
    }
    
    NSUInteger newLength = [textField.text length] + [string length] - range.length;
    return newLength <= 25;
}

- (IBAction)sendNotification:(id)sender {
    [self.notificationText endEditing:YES];
    if (self.notificationText.text.length > 0 || self.notificationText.text != nil || ![self.notificationText.text isEqual:@""]) {
        [PFCloud callFunctionInBackground:@"pushMessageNotification" withParameters:@{@"message" : self.notificationText.text} block:^(id object, NSError *error) {
            if (!error) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Succès" message:@"Message envoyé !" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Erreur" message:@"Vérifiez votre connexion" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}

@end

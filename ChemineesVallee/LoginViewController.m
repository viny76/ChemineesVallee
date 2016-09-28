//
//  LoginViewController.m
//  ChemineesVallee
//
//  Created by Vincent Jardel on 20/05/2014.
//  Copyright (c) 2014 Jardel Vincent. All rights reserved.
//

#import "LoginViewController.h"
#import "UIColor+CustomColors.h"
#import <QuartzCore/QuartzCore.h>

@interface LoginViewController ()
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email :" attributes:@{NSForegroundColorAttributeName: [UIColor colorWhite]}];
    self.passwordField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Mot de passe :" attributes:@{NSForegroundColorAttributeName: [UIColor colorWhite]}];
    self.loginButton.layer.cornerRadius = 10;
    self.loginButton.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
//    [self.navigationController.navigationBar setHidden:YES];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)]];
}

- (IBAction)login {
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *user = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([user length] == 0 || [password length] == 0) {
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:@"Erreur"  message:@"Email ou mot de passe vide"  preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        [self.hud removeFromSuperview];
    } else {
        [PFUser logInWithUsernameInBackground:user
                                     password:password block:^(PFUser *user, NSError *error) {
                                         if (error) {
                                             [self.hud removeFromSuperview];
                                             UIAlertView *alertViewSignUp = [[UIAlertView alloc] initWithTitle:@"Erreur !" message:@"Echec de connexion." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                             [alertViewSignUp show];
                                         } else {
                                             //GOOD LOGIN
                                             [self.navigationController popViewControllerAnimated:YES];
                                             [self.hud removeFromSuperview];
                                         }
                                     }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.emailField) {
        [textField resignFirstResponder];
        [self.passwordField becomeFirstResponder];
    }
    else if (textField == self.passwordField) {
        if (self.emailField.text.length != 0 && self.passwordField.text.length != 0) {
            [textField resignFirstResponder];
            [self login];
        } else {
            [textField resignFirstResponder];
        }
    }
    return YES;
}

@end

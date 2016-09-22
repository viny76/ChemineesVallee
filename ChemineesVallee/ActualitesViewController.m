//
//  ActualitesViewController.m
//  ChemineesVallee
//
//  Created by Vincent Jardel on 21/09/2016.
//  Copyright © 2016 Vincent Jardel. All rights reserved.
//

#import "ActualitesViewController.h"
#import <Parse/Parse.h>

@interface ActualitesViewController ()

@end

@implementation ActualitesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    if (([[PFUser currentUser] objectForKey:@"admin"]) != nil && [[[PFUser currentUser] objectForKey:@"admin"] boolValue] == YES) {
        NSLog(@"%@", [PFUser currentUser]);
        NSLog(@"%@", [[PFUser currentUser] objectForKey:@"authData"]);
    }
}

@end

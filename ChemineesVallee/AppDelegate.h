//
//  AppDelegate.h
//  ChemineesVallee
//
//  Created by Vincent Jardel on 19/09/2016.
//  Copyright © 2016 Vincent Jardel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, UITabBarDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;


@end


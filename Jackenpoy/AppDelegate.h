//
//  AppDelegate.h
//  Jackenpoy
//
//  Created by Garri Adrian Nablo on 8/12/13.
//  Copyright (c) 2013 Garri Adrian Nablo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MainViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UINavigationController *viewController;

- (void)showMenuButtons;
- (void)showBackButton;
- (void)hideBackButton;
@end
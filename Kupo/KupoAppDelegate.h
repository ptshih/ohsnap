//
//  KupoAppDelegate.h
//  Kupo
//
//  Created by Peter Shih on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginDelegate.h"
#import "PSDataCenterDelegate.h"

@class Facebook;
@class LoginViewController;
@class EventViewController;

@interface KupoAppDelegate : NSObject <UIApplicationDelegate, LoginDelegate, PSDataCenterDelegate> {
  UIWindow *_window;
  Facebook *_facebook;
  LoginViewController *_loginViewController;
  EventViewController *_eventViewController;
  UINavigationController *_navigationController;
  
  // Session
  NSString *_sessionKey;
}

@property (nonatomic, retain) UIWindow *window;
@property (readonly) Facebook *facebook;
@property (retain) NSString *sessionKey;
@property (nonatomic, retain) UINavigationController *navigationController;

// Private
+ (void)setupDefaults;
- (void)saveContext;
- (void)animateHideLogin;
- (void)startSession;
- (void)startRegister;
- (void)tryLogin;
- (void)resetSessionKey;

@end

//
//  MeViewController.m
//  Moogle
//
//  Created by Peter Shih on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeViewController.h"


@implementation MeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = FB_COLOR_VERY_LIGHT_BLUE;
  
  _navTitleLabel.text = @"Moogle Me";
  
  [self showDismissButton];
}

@end

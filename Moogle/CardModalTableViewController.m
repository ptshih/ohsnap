//
//  CardModalTableViewController.m
//  Moogle
//
//  Created by Peter Shih on 3/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CardModalTableViewController.h"

@implementation CardModalTableViewController

- (id)init {
  self = [super init];
  if (self) {
    _dismissButtonTitle = [NSLocalizedString(@"Cancel", @"Cancel") retain];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
}

- (void)showDismissButton {
  // Dismiss Button
  UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
  self.navigationItem.leftBarButtonItem = dismissButton;
  [dismissButton release];
}

- (void)dismiss {
  [self dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
  RELEASE_SAFELY(_dismissButtonTitle);
  [super dealloc];
}

@end

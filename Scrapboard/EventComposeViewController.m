//
//  EventComposeViewController.m
//  Scrapboard
//
//  Created by Peter Shih on 4/20/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventComposeViewController.h"


@implementation EventComposeViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  
  _navTitleLabel.text = @"New Event";
  
  // Event Tag Field
  _name = [[UITextField alloc] initWithFrame:CGRectMake(7, 5, 306, 24)];
  _name.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  _name.borderStyle = UITextBorderStyleNone;
  _name.placeholder = @"Name Your Event";
  _name.returnKeyType = UIReturnKeyNext;
  _name.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0];
  _name.delegate = self;
  [_composeView addSubview:_name];
  
  UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 34, 320, 1)];
  separator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
  separator.backgroundColor = SEPARATOR_COLOR;
  [_composeView addSubview:separator];
  [separator release];
  
  _message.frame = CGRectMake(0, 35, 320, 121);
  
  [_name becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

- (void)send {
  if ([_name.text length] == 0) {
    UIAlertView *emptyAlert = [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"You must enter an event name!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
    [emptyAlert show];
  } else if (![_message hasText] || [_message.text isEqualToString:_message.placeholder]) {
    if (!_uploadedImage) {
      UIAlertView *emptyAlert = [[[UIAlertView alloc] initWithTitle:@"Whoops!" message:@"You must either upload a photo/video or write a message!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil] autorelease];
      [emptyAlert show];
    }
  } else {
    [[ComposeDataCenter defaultCenter] sendEventComposeWithEventName:_name.text andEventTag:nil andMessage:_message.text andImage:_uploadedImage andVideo:_uploadedVideo];
    [self dismissModalViewControllerAnimated:YES];
  }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [_message becomeFirstResponder];
  return NO;
}

- (void)dealloc {
  RELEASE_SAFELY(_name);
  [super dealloc];
}

@end
//
//  PSTextView.h
//  OhSnap
//
//  Created by Peter Shih on 3/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PSTextView : UITextView {
  NSString *_placeholder;
  UIColor *_placeholderColor;
  
  BOOL _shouldDrawPlaceholder;
}

@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;

@end

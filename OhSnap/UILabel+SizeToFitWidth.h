//
//  UILabel+SizeToFitWidth.h
//  OhSnap
//
//  Created by Peter Shih on 3/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UILabel (SizeToFitWidth)

- (void)sizeToFitFixedWidth:(NSInteger)fixedWidth withLineBreakMode:(UILineBreakMode)lineBreakMode withNumberOfLines:(NSInteger)numberOfLines;


@end
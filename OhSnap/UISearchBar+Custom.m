//
//  UISearchBar+Custom.m
//  OhSnap
//
//  Created by Peter Shih on 5/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UISearchBar+Custom.h"


@implementation UISearchBar (Custom)

- (void)drawRect:(CGRect)rect {
	UIImage *image = [UIImage imageNamed: @"searchbar_bg.png"];
	[image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

@end

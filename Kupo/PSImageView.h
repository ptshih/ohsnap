//
//  PSImageView.h
//  Kupo
//
//  Created by Peter Shih on 3/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LINetworkOperationDelegate.h"
#import "PSImageViewDelegate.h"
#import "Constants.h"

@interface PSImageView : UIImageView <LINetworkOperationDelegate, PSImageViewDelegate> {
  NSString *_urlPath;
  UIActivityIndicatorView *_loadingIndicator;
  UIImage *_placeholderImage;
  
  LINetworkOperation *_op;
  id <PSImageViewDelegate> _delegate;
}

@property (nonatomic, copy) NSString *urlPath;
@property (nonatomic, retain) UIImage *placeholderImage;
@property (nonatomic, assign) id <PSImageViewDelegate> delegate;

- (void)loadImage;
- (void)unloadImage;
- (void)imageDidLoad;

@end
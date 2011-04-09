//
//  KupoCell.h
//  Kupo
//
//  Created by Peter Shih on 3/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PSImageCell.h"
#import "Kupo.h"

@interface KupoCell : PSImageCell {
  Kupo *_kupo;
  PSImageView *_photoImageView; // optional
  BOOL _hasPhoto;
}

- (void)loadPhoto;
@end
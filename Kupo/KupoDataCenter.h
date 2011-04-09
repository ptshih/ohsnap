//
//  KupoDataCenter.h
//  Kupo
//
//  Created by Peter Shih on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PSDataCenter.h"

@interface KupoDataCenter : PSDataCenter {
}

- (void)getKuposForPlaceWithPlaceId:(NSString *)placeId;

- (void)loadKuposFromFixture;

- (void)serializeKuposWithDictionary:(NSDictionary *)dictionary;

/**
 Fetch Requests
 */
- (NSFetchRequest *)getKuposFetchRequestWithPlaceId:(NSString *)placeId;

@end
//
//  PSURLCache.m
//  OhSnap
//
//  Created by Peter Shih on 4/25/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PSURLCache.h"

static PSURLCache *_sharedCache;

@implementation PSURLCache

+ (PSURLCache *)sharedCache {
  if (!_sharedCache) {
    _sharedCache = [[self alloc] init];
  }
  return _sharedCache;
}

// Does not handle errors right now
- (NSDictionary *)cacheResponse:(NSDictionary *)responseDict forURLPath:(NSString *)urlPath shouldMerge:(BOOL)shouldMerge {
  if (shouldMerge) {
    NSDictionary *oldResponse = [self responseForURLPath:urlPath];
    if (oldResponse) {
      responseDict = [self mergeResponse:oldResponse withResponse:responseDict];
    }
  }
  
  NSError *error = nil;
  NSData *responseData = [NSPropertyListSerialization dataWithPropertyList:responseDict format:NSPropertyListBinaryFormat_v1_0 options:0 error:&error];
  
  if (responseData) {
    if (![responseData writeToFile:[[self class] filePathForURLPath:urlPath] atomically:YES]) {
      NSLog(@"Cache writeToFile failed for urlPath: %@", urlPath);
      return nil;
    } else {
      return responseDict;
    }
  } else {
    NSLog(@"Cache serialization failed for urlPath: %@", urlPath);
    return nil;
  }
}

- (NSDictionary *)mergeResponse:(NSDictionary *)oldResponse withResponse:(NSDictionary *)newResponse {
  // Assume standard format
  // hasKey: data -> array
  // hasKey: paging -> dict
  
  NSString *primaryKey = @"id";
  NSString *dataKey = @"data";
//  NSString *pagingKey = @"paging";
//  NSString *sinceKey = @"since";
//  NSString *untilKey = @"until";
  
  // Walk thru both dictionaries and merge/unique based on 'id' primary key
  NSMutableDictionary *mergedDictionary = [NSMutableDictionary dictionary];
  
  NSArray *oldData = [[oldResponse valueForKey:dataKey] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:primaryKey ascending:YES]]];
  NSArray *newData = [[newResponse valueForKey:dataKey] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:primaryKey ascending:YES]]];
  
//  NSArray *oldData = [oldResponse valueForKey:dataKey];
//  NSArray *newData = [newResponse valueForKey:dataKey];
  
  NSMutableArray *mergedData = [NSMutableArray array];
    
  for (int i = 0; i < [oldData count]; i ++) {
    if (i < [newData count] && [[[oldData objectAtIndex:i] valueForKey:primaryKey] isEqual:[[newData objectAtIndex:i] valueForKey:primaryKey]]) {
      [mergedData addObject:[newData objectAtIndex:i]];
    } else {
      [mergedData addObject:[oldData objectAtIndex:i]];
    }
  }
  
//  NSMutableSet *dataSet = [NSMutableSet set];
//  [dataSet addObjectsFromArray:oldData];
//  [dataSet addObjectsFromArray:newData];
  
  
  NSArray *sortedMergedData = [mergedData sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO]]];
                         
  [mergedDictionary setValue:sortedMergedData forKey:dataKey];
  
  // Merge Paging
//  NSMutableDictionary *mergedPaging = [NSMutableDictionary dictionary];
//  
//  NSDictionary *oldPaging = [oldResponse valueForKey:pagingKey];
//  NSDictionary *newPaging = [newResponse valueForKey:pagingKey];
//  
//  if ([newPaging count] > 0) {
//    // Since
//    if ([newPaging valueForKey:sinceKey] > [oldPaging valueForKey:sinceKey]) {
//      [mergedPaging setValue:[newPaging valueForKey:sinceKey] forKey:sinceKey];
//    } else {
//      [mergedPaging setValue:[oldPaging valueForKey:sinceKey] forKey:sinceKey];
//    }
//    
//    // Until
//    if ([newPaging valueForKey:untilKey] < [oldPaging valueForKey:untilKey]) {
//      [mergedPaging setValue:[newPaging valueForKey:untilKey] forKey:untilKey];
//    } else {
//      [mergedPaging setValue:[oldPaging valueForKey:untilKey] forKey:untilKey];
//    }
//    
//    [mergedDictionary setValue:mergedPaging forKey:pagingKey];
//  } else {
//    [mergedDictionary setValue:oldPaging forKey:pagingKey];
//  }
  
  return mergedDictionary;
}

- (NSDictionary *)responseForURLPath:(NSString *)urlPath {
  NSError *error = nil;
  NSData *responseData = [NSData dataWithContentsOfFile:[[self class] filePathForURLPath:urlPath]];
  if (responseData) {
    NSDictionary *responseDict = [NSPropertyListSerialization propertyListWithData:responseData options:0 format:NULL error:&error];
    if (responseDict) {
      return responseDict;
    } else {
      return nil;
    }
  } else {
    return nil;
  }
}

- (NSString *)encodedURLParameterString {
  NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                         (CFStringRef)self,
                                                                         NULL,
                                                                         CFSTR(":/=,!$&'()*+;[]@#?"),
                                                                         kCFStringEncodingUTF8);
  
  return [result autorelease];
}

+ (NSString *)filePathForURLPath:(NSString *)urlPath {
  NSString *encodedURLPath = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)urlPath, NULL, CFSTR(":/=,!$&'()*+;[]@#?"), kCFStringEncodingUTF8) autorelease];
  NSString *filePath = [NSString stringWithFormat:@"%@/%@.plist", [[self class] applicationDocumentsDirectory], encodedURLPath];
  return filePath;
}

+ (NSString *)applicationDocumentsDirectory {
  return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark Memory Management
+ (id)allocWithZone:(NSZone *)zone {
  @synchronized(self) {
    if (_sharedCache == nil) {
      _sharedCache = [super allocWithZone:zone];
      return _sharedCache;
    }
  }
  return nil; // on subsequent allocation attempts return nil
}

- (id)copyWithZone:(NSZone *)zone {
  return self;
}

- (id)retain {
  return self;
}

- (unsigned)retainCount {
  return UINT_MAX;
}

- (void)release {
  // do nothing
}

- (id)autorelease {
  return self;
}

@end
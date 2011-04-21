//
//  PSDataCenter.h
//  Scrapboard
//
//  Created by Peter Shih on 2/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "PSObject.h"
#import "PSDataCenterDelegate.h"
#import "LINetworkOperation.h"
#import "LINetworkQueue.h"
#import "LICoreDataStack.h"
#import "JSON.h"
#import "NetworkConstants.h"

#define SINCE_SAFETY_NET 180

@interface PSDataCenter : PSObject <PSDataCenterDelegate> {
  id <PSDataCenterDelegate> _delegate;
  id _response;
  id _rawResponse;
  LINetworkOperation *_op;
}

@property (nonatomic, assign) id <PSDataCenterDelegate> delegate;
@property (nonatomic, retain) id response;
@property (nonatomic, retain) id rawResponse;
@property (nonatomic, retain) LINetworkOperation *op;


+ (id)defaultCenter;

/**
 Send network operation to server (GET/POST)
 
 By default this will set all required headers
 
 url - required defined in Constants.h
 method - optional (defaults to GET) defined in Constants.h (should be GET or POST)
 headers - optional
 params - optional
 */
- (void)sendOperationWithURL:(NSURL *)url andMethod:(NSString *)method andHeaders:(NSDictionary *)headers andParams:(NSDictionary *)params;

- (void)sendOperationWithURL:(NSURL *)url andMethod:(NSString *)method andHeaders:(NSDictionary *)headers andParams:(NSDictionary *)params andAttachmentType:(NetworkOperationAttachmentType)attachmentType;

// Subclass should Implement AND call super's implementation
- (void)dataCenterFinishedWithOperation:(LINetworkOperation *)operation;
- (void)dataCenterFailedWithOperation:(LINetworkOperation *)operation;

@end
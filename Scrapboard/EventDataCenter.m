//
//  EventDataCenter.m
//  Scrapboard
//
//  Created by Peter Shih on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EventDataCenter.h"
#import "Event.h"
#import "Event+Serialize.h"

static EventDataCenter *_defaultCenter = nil;

@implementation EventDataCenter

@synthesize context = _context;
@synthesize apiEndpoint = _apiEndpoint;
@synthesize fetchTemplate = _fetchTemplate;

#pragma mark -
#pragma mark Shared Instance
+ (id)defaultCenter {
  @synchronized(self) {
    if (_defaultCenter == nil) {
      _defaultCenter = [[self alloc] init];
    }
    return _defaultCenter;
  }
}

- (id)init {
  self = [super init];
  if (self) {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(coreDataDidReset) name:kCoreDataDidReset object:nil];
    self.context = [LICoreDataStack sharedManagedObjectContext];
    _apiEndpoint = [@"users/me/events" retain];
  }
  return self;
}

- (void)coreDataDidReset {
}

- (void)getEventsWithSince:(NSDate *)sinceDate {
  NSURL *eventsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", API_BASE_URL, _apiEndpoint]];
  
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
  // Since
  NSTimeInterval since = [sinceDate timeIntervalSince1970] - SINCE_SAFETY_NET;
  [params setValue:[NSString stringWithFormat:@"%0.0f", since] forKey:@"since"];
  
  [self sendOperationWithURL:eventsUrl andMethod:GET andHeaders:nil andParams:params];
}

- (void)loadMoreEventsWithUntil:(NSDate *)untilDate {
  NSURL *eventsUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", API_BASE_URL, _apiEndpoint]];
  
  NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
  // Until
  [params setValue:[NSString stringWithFormat:@"%0.0f", [untilDate timeIntervalSince1970]] forKey:@"until"];
  
  [self sendOperationWithURL:eventsUrl andMethod:GET andHeaders:nil andParams:params];
}

#pragma mark Fixtures
- (void)loadEventsFromFixture {
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"events" ofType:@"json"];
  NSData *fixtureData = [NSData dataWithContentsOfFile:filePath];
  NSDictionary *fixtureDict = [fixtureData JSONValue];
  [self serializeEventsWithDictionary:fixtureDict];
  
  [super dataCenterFinishedWithOperation:nil];
}

#pragma mark PSDataCenterDelegate
- (void)dataCenterFinishedWithOperation:(LINetworkOperation *)operation {  
  [self serializeEventsWithDictionary:_response];
  [super dataCenterFinishedWithOperation:operation];
}

- (void)dataCenterFailedWithOperation:(LINetworkOperation *)operation {
  [super dataCenterFailedWithOperation:operation];
}

#pragma mark Serialize Response
- (void)serializeEventsWithDictionary:(NSDictionary *)dictionary {
  NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES];
  
  NSArray *sortedEvents = [[dictionary valueForKey:@"data"] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
  
  NSMutableArray *sortedEventIds = [NSMutableArray array];
  for (NSDictionary *eventDict in sortedEvents) {
    [sortedEventIds addObject:[eventDict valueForKey:@"id"]];
  }
    
  NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
  [fetchRequest setEntity:[NSEntityDescription entityForName:@"Event" inManagedObjectContext:self.context]];
  [fetchRequest setPredicate:[NSPredicate predicateWithFormat: @"(id IN %@)", sortedEventIds]];
  [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[[[NSSortDescriptor alloc] initWithKey:@"id" ascending:YES] autorelease]]];
  
  
  NSError *error = nil;
  NSArray *foundEvents = [self.context executeFetchRequest:fetchRequest error:&error];
  
  int i = 0;
  for (NSDictionary *eventDict in sortedEvents) {
    if ([foundEvents count] > 0 && i < [foundEvents count] && [[eventDict valueForKey:@"id"] isEqualToString:[[foundEvents objectAtIndex:i] id]]) {
      DLog(@"found duplicated event with id: %@", [[foundEvents objectAtIndex:i] id]);
      [[foundEvents objectAtIndex:i] updateEventWithDictionary:eventDict];
      i++;
    } else {
      // Insert
      [Event addEventWithDictionary:eventDict inContext:self.context];
    }
  }
  
  // Save to Core Data
  if ([self.context hasChanges]) {
    if (![self.context save:&error]) {
      // CoreData ERROR!
      abort(); // NOTE: DO NOT SHIP
    }
  }
}

#pragma mark Fetch Requests
- (NSFetchRequest *)getEventsFetchRequest { 
  NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO] autorelease];
  NSArray *sortDescriptors = [[[NSArray alloc] initWithObjects:sortDescriptor, nil] autorelease];
  NSFetchRequest * fetchRequest = [[LICoreDataStack managedObjectModel] fetchRequestFromTemplateWithName:_fetchTemplate substitutionVariables:[NSDictionary dictionary]];
  [fetchRequest setSortDescriptors:sortDescriptors];
//  [fetchRequest setFetchLimit:limit];
  return fetchRequest;
}

- (void)dealloc {
  RELEASE_SAFELY(_apiEndpoint);
  RELEASE_SAFELY(_fetchTemplate);
  [super dealloc];
}

@end
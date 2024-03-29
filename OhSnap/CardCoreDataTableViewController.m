    //
//  CardCoreDataTableViewController.m
//  OhSnap
//
//  Created by Peter Shih on 2/16/11.
//  Copyright 2011 LinkedIn. All rights reserved.
//

#import "CardCoreDataTableViewController.h"
#import "LICoreDataStack.h"

@interface CardCoreDataTableViewController (Private)


@end

@implementation CardCoreDataTableViewController

@synthesize context = _context;
@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize sectionNameKeyPathForFetchedResultsController = _sectionNameKeyPathForFetchedResultsController;

- (id)init {
  self = [super init];
  if (self) {
    _context = [LICoreDataStack sharedManagedObjectContext];
    _fetchedResultsController = nil;
    _sectionNameKeyPathForFetchedResultsController = nil;
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextSaveDidNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
}

#pragma mark State Machine
- (BOOL)dataIsAvailable {
  return (_fetchedResultsController && _fetchedResultsController.fetchedObjects.count > 0);
}

- (void)updateState {
  [super updateState];
}

#pragma mark Data Source
- (void)reloadCardController {
  [super reloadCardController];
}

- (void)unloadCardController {
  [super unloadCardController];
}


#pragma mark Core Data
//- (void)managedObjectContextSaveDidNotification:(NSNotification *)notification {
//  [self.context mergeChangesFromContextDidSaveNotification:notification];
//}

- (void)resetFetchedResultsController {
  RELEASE_SAFELY(_fetchedResultsController);
}

- (NSFetchedResultsController*)fetchedResultsController  {
  if (_fetchedResultsController) return _fetchedResultsController;
  
  NSFetchRequest *fetchRequest = [self getFetchRequest];
  if (fetchRequest) {
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.context sectionNameKeyPath:self.sectionNameKeyPathForFetchedResultsController cacheName:nil];
    _fetchedResultsController.delegate = self;
  }
  
  return _fetchedResultsController;
}

- (void)executeFetch {
  NSError *error = nil;
  if ([self.fetchedResultsController performFetch:&error]) {
//    DLog(@"Fetch request succeeded: %@", [self.fetchedResultsController fetchRequest]);
  } else {
    DLog(@"Fetch failed with error: %@", [error localizedDescription]);
  }
}

- (NSFetchRequest *)getFetchRequest {
  // Subclass MUST implement
  return nil;
}

#pragma mark NSFetchedresultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  [_tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {

  switch(type) {
    case NSFetchedResultsChangeInsert:
      [_tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [_tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
  
  UITableView *tableView = _tableView;
  
  DLog(@"type: %d, old indexPath: %@, new indexPath: %@, class: %@", type, indexPath, newIndexPath, NSStringFromClass([self class]));
  
  switch(type) {
      
    case NSFetchedResultsChangeInsert:
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeDelete:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
      
    case NSFetchedResultsChangeUpdate:{
      NSIndexPath *changedIndexPath = newIndexPath ? newIndexPath : indexPath;
      [self tableView:tableView configureCell:[tableView cellForRowAtIndexPath:changedIndexPath] atIndexPath:changedIndexPath];
      break;
    }
    case NSFetchedResultsChangeMove:
      [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
  }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [_tableView endUpdates];
  [self loadImagesForOnScreenRows];
}

#pragma mark UISearchDisplayDelegate
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
  // SUBCLASS MUST IMPLEMENT
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willUnloadSearchResultsTableView:(UITableView *)tableView {
  [self.fetchedResultsController.fetchRequest setPredicate:nil];
  [self executeFetch];
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView configureCell:(id)cell atIndexPath:(NSIndexPath *)indexPath {
  // subclass must implement
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell", [self class]];
  UITableViewCell *cell = nil;
  cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  cell.textLabel.text = @"Oops! Forgot to override this method?";
  cell.detailTextLabel.text = reuseIdentifier;
  return cell;
}

- (void)dealloc {
//  [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextDidSaveNotification object:nil];
  RELEASE_SAFELY (_fetchedResultsController);
  RELEASE_SAFELY (_sectionNameKeyPathForFetchedResultsController);
  [super dealloc];
}

@end

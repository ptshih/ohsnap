//
//  CardCoreDataTableViewController.h
//  Prototype
//
//  Created by Peter Shih on 2/16/11.
//  Copyright 2011 LinkedIn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "CardTableViewController.h"
#import "LICoreDataStack.h"

@interface CardCoreDataTableViewController : CardTableViewController <NSFetchedResultsControllerDelegate> {  
  NSFetchedResultsController * _fetchedResultsController;
  NSString * _sectionNameKeyPathForFetchedResultsController;
  NSPredicate *_cachedPredicate;
}

@property (nonatomic, retain) NSFetchedResultsController * fetchedResultsController;
@property (nonatomic, retain) NSString * sectionNameKeyPathForFetchedResultsController;


- (void)resetFetchedResultsController;
- (void)executeFetchWithPredicate:(NSPredicate *)predicate;
- (NSFetchRequest *)getFetchRequest;

@end

//
//  PlaceViewController.m
//  Moogle
//
//  Created by Peter Shih on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PlaceViewController.h"
#import "PlaceDataCenter.h"
#import "KupoViewController.h"
#import "MeViewController.h"
#import "CheckinViewController.h"
#import "Place.h"
#import "PlaceCell.h"

@implementation PlaceViewController

- (id)init {
  self = [super init];
  if (self) {
    _placeDataCenter = [[PlaceDataCenter alloc] init];
    _placeDataCenter.delegate = self;
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  // Add Profile Button
  UIButton *profile = [UIButton buttonWithType:UIButtonTypeCustom];
  profile.frame = CGRectMake(0, 0, 60, 32);
  [profile setTitle:@"Profile" forState:UIControlStateNormal];
//  [back setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
  [profile setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
  profile.titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
  UIImage *profileImage = [[UIImage imageNamed:@"navigationbar_button_standard.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];  
  [profile setBackgroundImage:profileImage forState:UIControlStateNormal];  
  [profile addTarget:self action:@selector(profile) forControlEvents:UIControlEventTouchUpInside];  
  UIBarButtonItem *profileButton = [[[UIBarButtonItem alloc] initWithCustomView:profile] autorelease];
  self.navigationItem.leftBarButtonItem = profileButton;
  
  // Add Check-In Button
  UIButton *checkin = [UIButton buttonWithType:UIButtonTypeCustom];
  checkin.frame = CGRectMake(0, 0, 60, 32);
  [checkin setTitle:@"Check-In" forState:UIControlStateNormal];
  //  [back setTitleEdgeInsets:UIEdgeInsetsMake(0, 8, 0, 0)];
  [checkin setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
  checkin.titleLabel.font = [UIFont boldSystemFontOfSize:11.0];
  UIImage *checkinImage = [[UIImage imageNamed:@"navigationbar_button_standard.png"] stretchableImageWithLeftCapWidth:10 topCapHeight:10];  
  [checkin setBackgroundImage:checkinImage forState:UIControlStateNormal];  
  [checkin addTarget:self action:@selector(checkin) forControlEvents:UIControlEventTouchUpInside];  
  UIBarButtonItem *checkinButton = [[[UIBarButtonItem alloc] initWithCustomView:checkin] autorelease];
  self.navigationItem.rightBarButtonItem = checkinButton;
  
  // Nav Title
  _navTitleLabel.text = @"Moogle";
  
  // Table
  CGRect tableFrame = CGRectMake(0, 0, CARD_WIDTH, CARD_HEIGHT);
  [self setupTableViewWithFrame:tableFrame andStyle:UITableViewStylePlain andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  
  // Pull Refresh
  [self setupPullRefresh];
  
//  UIBarButtonItem *post = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(post)];
//  self.navigationItem.rightBarButtonItem = post;
//  [post release];
  
  [self reloadCardController];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [_tableView reloadData];
}

- (void)profile {
  MeViewController *mvc = [[MeViewController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mvc];
//  navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self presentModalViewController:navController animated:YES];
  [mvc release];
  [navController release];  
}

- (void)checkin {
  CheckinViewController *mvc = [[CheckinViewController alloc] init];
  UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mvc];
  //  navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
  [self presentModalViewController:navController animated:YES];
  [mvc release];
  [navController release];  
}



#pragma mark -
#pragma mark TableView
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
  return [PlaceCell rowHeightForObject:place];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:YES];
  
  Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  // Mark isRead state
  NSManagedObjectContext *context = [LICoreDataStack managedObjectContext];
  place.isRead = [NSNumber numberWithBool:YES];
  
  NSError *error = nil;
  if ([context hasChanges]) {
    if (![context save:&error]) {
      abort(); // NOTE: DO NOT SHIP
    }
  }
  
  KupoViewController *kvc = [[KupoViewController alloc] init];
  kvc.place = place;
  [self.navigationController pushViewController:kvc animated:YES];
  [kvc release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  PlaceCell *cell = nil;
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell_%d", [self class], indexPath.section];
  
  cell = (PlaceCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if(cell == nil) { 
    cell = [[[PlaceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier] autorelease];
  }
  
  Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
  
  [cell fillCellWithObject:place];
  
  return cell;
}

#pragma mark -
#pragma mark CardViewController
- (void)reloadCardController {
  [super reloadCardController];
  [_placeDataCenter getPlaces];
//  [_placeDataCenter loadPlacesFromFixture];
}

- (void)unloadCardController {
  [super unloadCardController];
}

#pragma mark -
#pragma mark MoogleDataCenterDelegate
- (void)dataCenterDidFinish:(LINetworkOperation *)operation {
  [self resetFetchedResultsController];
  [self.tableView reloadData];
  [self dataSourceDidLoad];
}

- (void)dataCenterDidFail:(LINetworkOperation *)operation {
  [self resetFetchedResultsController];
  [self.tableView reloadData];
  [self dataSourceDidLoad];
}

#pragma mark -
#pragma mark FetchRequest
- (NSFetchRequest *)getFetchRequest {
  return [_placeDataCenter getPlacesFetchRequest];
}

- (void)dealloc {
  RELEASE_SAFELY(_placeDataCenter);
  [super dealloc];
}

@end
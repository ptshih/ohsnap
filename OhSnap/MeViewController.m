//
//  MeViewController.m
//  OhSnap
//
//  Created by Peter Shih on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeViewController.h"
#import "ShareCell.h"

@implementation MeViewController

@synthesize delegate = _delegate;

- (id)init {
  self = [super init];
  if (self) {
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = FB_COLOR_VERY_LIGHT_BLUE;
  
  _navTitleLabel.text = @"Kupo Me";
  
  [self showDismissButton];
  
  // Logout Button
  UIBarButtonItem *logoutButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout", @"Logout") style:UIBarButtonItemStyleBordered target:self action:@selector(logout)];
  self.navigationItem.rightBarButtonItem = logoutButton;
  [logoutButton release];
  
  // Setup Table
  [self setupTableViewWithFrame:self.view.bounds andStyle:UITableViewStyleGrouped andSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
  
  // Setup Header
  [self setupHeader];
  
  // Get the Me data from the server
//  [_meDataCenter requestMe];
  
  [self.items removeAllObjects];
  
  [self.items addObject:[NSArray arrayWithObjects:@"facebook", @"email", @"text", nil]];
  
  [_tableView reloadData];
  [self dataSourceDidLoad];
}

- (void)setupHeader {
  NSString *facebookId = [[NSUserDefaults standardUserDefaults] valueForKey:@"facebookId"];
  NSString *facebookName = [[NSUserDefaults standardUserDefaults] valueForKey:@"facebookName"];
  
  CGFloat top = 10;
  CGFloat left = 10;
  
  UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 60)];
#warning NOT iOS3 COMPATIBLE
  headerView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
//  headerView.backgroundColor = [UIColor colorWithPatternImage:[[UIImage imageNamed:@"row_gradient.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0]];

  // Profile Pic
  PSImageView *profilePicture = [[PSImageView alloc] initWithFrame:CGRectMake(left, top, 40, 40)];
  profilePicture.layer.masksToBounds = YES;
  profilePicture.layer.cornerRadius = 5;
  profilePicture.urlPath = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", facebookId];
  [profilePicture loadImage];
  
  // Name
  UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  nameLabel.backgroundColor = [UIColor clearColor];
  nameLabel.left = profilePicture.right + 10;
  nameLabel.top = top;
  nameLabel.width = 320 - nameLabel.left - 10;
  nameLabel.height = 20;
  nameLabel.text = facebookName;
  nameLabel.font = [UIFont boldSystemFontOfSize:16];
  nameLabel.textColor = FB_COLOR_VERY_LIGHT_BLUE;
  nameLabel.shadowColor = [UIColor blackColor];
  nameLabel.shadowOffset = CGSizeMake(0, 1);
  
  // Stories
  UILabel *placeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
  placeLabel.backgroundColor = [UIColor clearColor];
  placeLabel.left = profilePicture.right + 10;
  placeLabel.top = nameLabel.bottom;
  placeLabel.width = 320 - placeLabel.left - 10;
  placeLabel.height = 20;
  placeLabel.text = @"You contributed to 214 stories.";
  placeLabel.font = [UIFont systemFontOfSize:16];
  placeLabel.textColor = FB_COLOR_VERY_LIGHT_BLUE;
  placeLabel.shadowColor = [UIColor blackColor];
  placeLabel.shadowOffset = CGSizeMake(0, 1);
  
  [headerView addSubview:profilePicture];
  [headerView addSubview:nameLabel];
  [headerView addSubview:placeLabel];
  _tableView.tableHeaderView = headerView;
  
  [placeLabel release];
  [nameLabel release];
  [profilePicture release];
  [headerView release];
}

- (void)logout {
  if (self.delegate && [self.delegate respondsToSelector:@selector(logoutRequested)]) {
    [self.delegate logoutRequested];
  }
  [self dismissModalViewControllerAnimated:YES];
}

#pragma mark TableView Stuff
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//  return [self.sections objectAtIndex:section];
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [super tableView:tableView didSelectRowAtIndexPath:indexPath];

  NSInteger section = indexPath.section;
  NSInteger row = indexPath.row;

  
  if (section == 0 && row == 0) {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   FB_APP_ID, @"app_id",
                                   @"http://www.scrapboard.co", @"link",
                                   @"http://fbrell.com/f8.jpg", @"picture",
                                   @"I'm using OhSnap!", @"name",
                                   @"I'm using Kupo to share stories of places with my friends. Get the FREE iPhone or Android app so you can join too!.", @"description",
                                   nil];
    
    [APP_DELEGATE.facebook dialog:@"feed" andParams:params andDelegate:self];
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  NSString *reuseIdentifier = [NSString stringWithFormat:@"%@_TableViewCell", [self class]];
  ShareCell *cell = nil;
  cell = (ShareCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
  if (cell == nil) {
    cell = [[[ShareCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier] autorelease];
  }
  id item = [[self.items objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
  [cell fillCellWithObject:item];
  return cell;
}

- (void)dealloc {
  [super dealloc];
}

@end

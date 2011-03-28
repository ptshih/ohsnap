//
//  CardTableViewController.h
//  Prototype
//
//  Created by Peter Shih on 2/14/11.
//  Copyright 2011 LinkedIn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardViewController.h"
#import "HeaderTabView.h"
#import "EGORefreshTableHeaderView.h"
#import "HeaderTabViewDelegate.h"
#import "KupoComposeViewController.h"
#import "KupoComposeDelegate.h"

@interface CardTableViewController : CardViewController <UITableViewDelegate, UITableViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate, EGORefreshTableHeaderDelegate, HeaderTabViewDelegate, UIGestureRecognizerDelegate> {
  UITableView *_tableView;
  NSMutableArray *_sections;
  NSMutableArray *_items;
  NSMutableArray *_searchItems;

  UISearchBar *_searchBar;
  HeaderTabView *_headerTabView;
  EGORefreshTableHeaderView *_refreshHeaderView;
  UIView *_footerView;
  KupoComposeViewController *_kupoComposeViewController;
  BOOL _reloading;
  UITapGestureRecognizer *_dismissKupoGesture;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableArray *items;
@property (nonatomic, retain) NSMutableArray *searchItems;

@property (nonatomic, retain) HeaderTabView *headerTabView;

- (void)setupTableViewWithFrame:(CGRect)frame andStyle:(UITableViewStyle)style andSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle;
- (void)setupPullRefresh;
- (void)setupHeaderTabView;
- (void)setupFooterView;
- (void)setupSearchDisplayController;

// Private
- (void)dismissKupoCompose;

@end

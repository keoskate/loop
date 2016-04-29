//
//  KMATapSearchViewController.h
//  knnct
//
//  Created by Keion Anvaripour on 11/4/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "KMAAcceptPopUpView.h"

@interface KMATapSearchViewController : UIViewController
<
UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource,
UISearchBarDelegate
>
{BOOL isSearching;}

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableViewController *searchResultsController;

@property (weak, nonatomic) IBOutlet UISegmentedControl *searchSegmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (nonatomic,strong) NSArray *foundUser;
@end

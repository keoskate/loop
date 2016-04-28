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

@interface KMATapSearchViewController : UIViewController <UITextFieldDelegate ,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
{BOOL isSearching;}
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableViewController *searchResultsController;

@property (weak, nonatomic) IBOutlet UISegmentedControl *searchSegmentedControl;
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *foundUser;
@end

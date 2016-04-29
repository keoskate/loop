//
//  KMAHomeViewController.h
//  connectapp
//
//  Created by Keion Anvaripour on 9/13/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "KMAAcceptPopUpView.h"

@interface KMAHomeViewController : UIViewController
<
UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource
>{ BOOL isSearching; }

@property (weak, nonatomic) IBOutlet UITextField *userSearchField;
@property (weak, nonatomic) IBOutlet UILabel *resultText;
@property (weak, nonatomic) IBOutlet UILabel *userNameFound;
@property (weak, nonatomic) IBOutlet UISwitch *numberToggle;
@property (weak, nonatomic) IBOutlet UISwitch *emailToggle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *searchToggle;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic, strong) UISearchController *searchController;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *foundUser;

- (IBAction)requestWithPopover:(id)sender;

- (IBAction)connectWithUser:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)goBack:(id)sender;

-(void)requestFriendship:(PFUser *)user;

@end

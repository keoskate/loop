//
//  KMAContactViewController.h
//  connectapp
//
//  Created by Keion Anvaripour on 9/13/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface KMAContactViewController : UITableViewController

@property (nonatomic,strong) PFRelation *friendsRelation;
@property (nonatomic,strong) NSArray *friends;
//@property (atomic,strong) NSMutableArray *allUsers;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
- (IBAction)reloadFriendsAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end

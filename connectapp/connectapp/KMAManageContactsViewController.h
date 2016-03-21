//
//  KMAManageContactsViewController.h
//  connectapp
//
//  Created by Keion Anvaripour on 9/13/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface KMAManageContactsViewController : UITableViewController

@property(nonatomic,strong) NSArray *allUsers;
@property(nonatomic,strong) PFUser *currentUser;
@property(nonatomic,strong) NSMutableArray *friends;

-(BOOL)isFriend:(PFUser *)user;

@end

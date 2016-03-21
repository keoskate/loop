//
//  KMARequestsTableViewController.h
//  knnct
//
//  Created by Keion Anvaripour on 9/24/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface KMARequestsTableViewController : UITableViewController

@property (nonatomic,strong) PFRelation *friendsRelation;
@property (nonatomic,strong) NSArray *requests;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (weak, nonatomic) IBOutlet UIView *acceptPopUpView;

@end

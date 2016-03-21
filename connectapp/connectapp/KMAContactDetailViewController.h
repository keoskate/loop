//
//  KMAContactDetailViewController.h
//  connectapp
//
//  Created by Keion Anvaripour on 9/13/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "KMAContactViewController.h"

@interface KMAContactDetailViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *userUsername;
@property (weak, nonatomic) IBOutlet UILabel *userEmail;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet PFImageView *thumbNailImageView;

@property (weak, nonatomic) UIImage *myUserPic;
@property (weak, nonatomic) PFFile *myUserPicFile;
@property (weak, nonatomic) NSString *myUserEmail;
@property (weak, nonatomic) NSString *myUserUsername;
@property (weak, nonatomic) NSString *myUserLastName;
@property (weak, nonatomic) NSString *myUserFirstName;
@property (weak, nonatomic) NSString *myUserPhone;

@property (weak, nonatomic) IBOutlet UITableViewCell *FacebookCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *SnapchatCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *InstagramCell;


- (IBAction)addContactToAddressBook:(id)sender;

@end

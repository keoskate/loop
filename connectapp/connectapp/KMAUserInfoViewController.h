//
//  KMAUserInfoViewController.h
//  connectapp
//
//  Created by Keion Anvaripour on 9/13/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface KMAUserInfoViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UILabel *userKnnctID;
@property (strong, nonatomic) IBOutlet UILabel *userFirstName;
@property (strong, nonatomic) IBOutlet UILabel *userLastName;
@property (strong, nonatomic) IBOutlet UILabel *userEmail;
@property (strong, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic)   IBOutlet PFImageView *userPicture;

- (IBAction)logout:(id)sender;

@end

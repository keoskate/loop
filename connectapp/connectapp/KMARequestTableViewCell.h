//
//  KMARequestTableViewCell.h
//  knnct
//
//  Created by Keion Anvaripour on 9/24/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "KMAAddContactController.h"
#import "KMAAcceptPopUpView.h"
//#import "FPPopoverController.h"
//#import <ParseUI/ParseUI.h>

@interface KMARequestTableViewCell : UITableViewCell <UITableViewDelegate, UITableViewDataSource, UIPopoverPresentationControllerDelegate>

@property (nonatomic,strong) PFUser *requestedUser;

@property (weak, nonatomic) IBOutlet PFImageView *userPic;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userID;

@property (weak, nonatomic) UIImage *requestedUserPic;
@property (weak, nonatomic) PFFile *requestedUserPicFile;
@property (weak, nonatomic) NSString *requestedUserID;
@property (weak, nonatomic) NSString *requestedUserName;
@property (weak, nonatomic) IBOutlet UIButton *viewButton;
@property (nonatomic, retain) KMAAcceptPopUpView *popover;

-(IBAction)acceptWithPopover;
-(IBAction)declineRequest:(id)sender;



@end

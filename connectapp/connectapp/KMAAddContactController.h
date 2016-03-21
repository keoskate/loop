//
//  KMAAddContactController.h
//  knnct
//
//  Created by Keion Anvaripour on 10/29/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface KMAAddContactController : UITableViewController

@property (weak, nonatomic) IBOutlet PFImageView *searchImage;
@property (weak, nonatomic) IBOutlet UILabel *searchName; //attributed First+Last
@property (weak, nonatomic) IBOutlet UILabel *searchID;
@property (weak, nonatomic) IBOutlet UILabel *myEmail;
@property (weak, nonatomic) IBOutlet UILabel *myFacebook;
@property (weak, nonatomic) IBOutlet UILabel *myInstagram;
@property (weak, nonatomic) IBOutlet UIButton *gmailCheckButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookCheckButton;

- (IBAction)connectWithUser:(id)sender;
@property (weak, nonatomic) UIImage *searchedUserPic;
@property (weak, nonatomic) PFFile *searchedUserPicFile;
@property (weak, nonatomic) NSString *searchedUserID;
@property (weak, nonatomic) NSString *searchedUserName;

@end

//
//  KMAAddContactController.h
//  knnct
//
//  Created by Keion Anvaripour on 10/29/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "KLCPopup.h"
#import <ParseUI/ParseUI.h>

@interface KMAAddContactController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet PFImageView *searchImage;
@property (weak, nonatomic) IBOutlet UILabel *searchName; //attributed First+Last
@property (weak, nonatomic) IBOutlet UILabel *searchID;


@property (weak, nonatomic) IBOutlet UIButton *gmailCheckButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookCheckButton;


- (IBAction)connectWithUser:(id)sender;
@property (weak, nonatomic) UIImage *searchedUserPic;
@property (weak, nonatomic) PFFile *searchedUserPicFile;
@property (weak, nonatomic) NSString *searchedUserID;
@property (weak, nonatomic) NSString *searchedUserName;


@property (nonatomic, strong) NSMutableArray *shareOptions;
@property (nonatomic, strong) NSMutableArray *checkedData;
@property (retain, nonatomic) IBOutlet UITableView *tableView;


@property (weak, nonatomic) NSString *requestedUserID;
@property (weak, nonatomic) IBOutlet UILabel *topContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestName;
@property (weak, nonatomic) IBOutlet UILabel *requestID;
@property (weak, nonatomic) IBOutlet UILabel *myConnLabel;
@property (weak, nonatomic) IBOutlet PFImageView *requestImage;
@property (weak, nonatomic) IBOutlet PFImageView *userImage;
-(void)onCheck:(id)sender;
@end

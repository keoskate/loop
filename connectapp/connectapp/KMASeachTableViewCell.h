//
//  KMASeachTableViewCell.h
//  Loop
//
//  Created by Keion Anvaripour on 4/11/16.
//  Copyright © 2016 Keion Anvaripour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KMAAcceptPopUpView.h"
#import "KMAAddContactController.h"

@interface KMASeachTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *connectButton;
@property (nonatomic, retain) KMAAddContactController *popover;

@property (weak, nonatomic) IBOutlet PFImageView *userPic;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userID;

@property (weak, nonatomic) UIImage *requestedUserPic;
@property (weak, nonatomic) PFFile *requestedUserPicFile;
@property (weak, nonatomic) NSString *requestedUserID;
@property (weak, nonatomic) NSString *requestedUserName;
@end

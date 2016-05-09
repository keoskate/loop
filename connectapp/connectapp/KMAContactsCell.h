//
//  KMAContactsCell.h
//  knnct
//
//  Created by Keion Anvaripour on 11/5/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface KMAContactsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *contactPic;
@property (weak, nonatomic) IBOutlet UILabel *contactName;
@property (weak, nonatomic) IBOutlet UILabel *contactID;

@property (weak, nonatomic) UIImage *contactUserPic;
@property (weak, nonatomic) PFFile *contactUserPicFile;
@property (weak, nonatomic) NSString *contactUserID;
@property (weak, nonatomic) NSString *contactUserName;

@property (weak, nonatomic) NSMutableArray *miniIcons; 
@end

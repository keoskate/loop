//
//  KMAAcceptPopUpView.h
//  knnct
//
//  Created by Keion Anvaripour on 11/7/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "KLCPopup.h"


@interface KMAAcceptPopUpView : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *shareOptions;
@property (retain, nonatomic) IBOutlet UITableView *selectionTableView;

@property (weak, nonatomic) NSString *requestedUserID;
@property (weak, nonatomic) IBOutlet UILabel *topContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *requestName;
@property (weak, nonatomic) IBOutlet UILabel *requestID;
@property (weak, nonatomic) IBOutlet UILabel *myConnLabel;
@property (weak, nonatomic) IBOutlet PFImageView *requestImage;
@property (weak, nonatomic) IBOutlet PFImageView *userImage;

-(IBAction)connectRequest:(id)sender;
-(IBAction)denyRequest:(id)sender;

@end

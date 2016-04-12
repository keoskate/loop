//
//  KMARequestTableViewCell.m
//  knnct
//
//  Created by Keion Anvaripour on 9/24/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import "KMARequestTableViewCell.h"
#import "KMARequestsTableViewController.h"

@implementation KMARequestTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    //    KMARequestTableViewCell *requestCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    //cell.detailTextLabel.text = @"hi";
    cell.textLabel.text = @"Text";
    
    return cell;
}

#pragma mark - Accept/Decline
-(IBAction)declineRequest:(id)sender{
    
    PFQuery * query = [PFQuery queryWithClassName:@"FriendRequest"];
    [query whereKey:@"toUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"fromUser" equalTo:self.requestedUserID];
    [query whereKey:@"status" equalTo:@"requested"];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            //Adding contact to friend relations
            //PFUser *user = [(PFUser *)object objectForKey:@"fromUser"];  //searched user (toUser)
            
            [object setObject:@"rejected" forKey:@"status"];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"%@", error);
                }
            }];
        }
        else {
            NSLog(@"Error: %@", error);//, [error userInfo]);
        }
    }];
    
}


-(IBAction)acceptWithPopover{
    //init popover view
    self.popover = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"popoverController"];
    
    //popover UI setup
    self.popover.view.frame = CGRectMake(self.popover.view.frame.origin.x, self.popover.view.frame.origin.y, self.popover.view.frame.size.width-25, self.popover.view.frame.size.height-50);
    self.popover.view.alpha = 1;
    //popover.selectionTableView.bounces = NO;
    //popover.selectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //Set data
    self.popover.requestName.text = [NSString stringWithFormat:@"%s/%@/%s", "What networks would you like to share with ", self.userName.text, "?"]; //;
    self.popover.requestID.text = self.userID.text;
    self.popover.requestedUserID = self.requestedUserID;

    //User image
    self.popover.requestImage.file = self.userPic.file;
    self.popover.requestImage.image = [UIImage imageNamed:@"placeholder.png"];
    [self.popover.requestImage loadInBackground];
    
    //User image 2
    PFUser *currentUser = [PFUser currentUser];
    self.popover.userImage.file = [currentUser objectForKey:@"displayPicture"];
    self.popover.userImage.image = [UIImage imageNamed:@"placeholder.png"];
    [self.popover.userImage loadInBackground];
    
    //API
    KLCPopupLayout layout = KLCPopupLayoutMake(KLCPopupHorizontalLayoutCustom,
                                               KLCPopupVerticalLayoutCustom);
    
    KLCPopup* popup = [KLCPopup popupWithContentView:self.popover.view
                                            showType:KLCPopupShowTypeBounceInFromTop
                                         dismissType:KLCPopupDismissTypeShrinkOut
                                            maskType:KLCPopupMaskTypeDimmed
                            dismissOnBackgroundTouch:KLCPopupDismissTypeBounceOut
                               dismissOnContentTouch:NO];
    
    popup.dimmedMaskAlpha = 0.75;
    [popup showWithLayout:layout];
}

@end

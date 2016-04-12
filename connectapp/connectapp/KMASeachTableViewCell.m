//
//  KMASeachTableViewCell.m
//  Loop
//
//  Created by Keion Anvaripour on 4/11/16.
//  Copyright © 2016 Keion Anvaripour. All rights reserved.
//

#import "KMASeachTableViewCell.h"

@implementation KMASeachTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(IBAction)acceptWithPopover{
    //init popover view
    self.popover = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"popoverController1"];
    
    //popover UI setup
    self.popover.view.frame = CGRectMake(self.popover.view.frame.origin.x, self.popover.view.frame.origin.y, self.popover.view.frame.size.width-25, self.popover.view.frame.size.height-50);
    self.popover.view.alpha = 1;
    
    //popover.selectionTableView.bounces = NO;
    //popover.selectionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //Set data
    self.popover.requestName.text = [NSString stringWithFormat:@"%s/%@/%s", "What networks would you like to share with ", self.userName.text, "?"]; //;
    self.popover.requestID.text = self.userID.text;
    self.popover.requestedUserID = self.requestedUserID;
    

    //Freebee info - anyone accepted get it
    self.popover.searchedUserName = [NSString stringWithFormat:@"%s/%@/%s", "What networks would you like to share with ", self.userName.text, "?"];
    self.popover.searchedUserID = self.requestedUserID;
    
    
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

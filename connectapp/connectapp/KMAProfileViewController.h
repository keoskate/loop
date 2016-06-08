//
//  KMAProfileViewController.h
//  Loop
//
//  Created by Keion Anvaripour on 4/25/16.
//  Copyright © 2016 Keion Anvaripour. All rights reserved.
//

#import <ParseUI/ParseUI.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface KMAProfileViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet PFImageView *photoField;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *loopidLabel;

@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *facebookField;
@property (weak, nonatomic) IBOutlet UITextField *linkedinField;
@property (weak, nonatomic) IBOutlet UITextField *instagramField;
@property (weak, nonatomic) IBOutlet UITextField *snapchatField;


- (IBAction)saveButtonPressed:(id)sender;


@end

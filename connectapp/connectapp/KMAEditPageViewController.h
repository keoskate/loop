//
//  KMAEditPageViewController.h
//  Loop
//
//  Created by Keion Anvaripour on 3/27/16.
//  Copyright © 2016 Keion Anvaripour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface KMAEditPageViewController : UITableViewController

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

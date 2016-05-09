//
//  KMAEditPageViewController.h
//  Loop
//
//  Created by Keion Anvaripour on 3/27/16.
//  Copyright © 2016 Keion Anvaripour. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface KMAEditPageViewController : UITableViewController
<
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UILabel *backgroundColor;

@property (weak, nonatomic) IBOutlet PFImageView *photoField;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundBlur;

@property (nonatomic, weak) UIImage *pickedImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *loopidLabel;


// Cells
@property (weak, nonatomic) IBOutlet UITableViewCell *fbTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *liTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *igTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *scTableViewCell;

//Text Fields
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;
@property (weak, nonatomic) IBOutlet UITextField *facebookField;
@property (weak, nonatomic) IBOutlet UITextField *linkedinField;
@property (weak, nonatomic) IBOutlet UITextField *instagramField;
@property (weak, nonatomic) IBOutlet UITextField *snapchatField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;

// Add buttons
@property (weak, nonatomic) IBOutlet UIButton *fbConnectButton;
@property (weak, nonatomic) IBOutlet UIButton *liConnectButton;
@property (weak, nonatomic) IBOutlet UIButton *instaConnectButton;
@property (weak, nonatomic) IBOutlet UIButton *snapConnectButton;

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fb;


- (IBAction)imageSelectionButtonWasPressed:(id)sender;

- (IBAction)saveButtonPressed:(id)sender;

@end

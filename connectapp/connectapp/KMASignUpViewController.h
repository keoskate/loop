//
//  KMASignUpViewController.h
//  connectapp
//
//  Created by Keion Anvaripour on 9/13/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#include <stdlib.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface KMASignUpViewController : UITableViewController
<
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *fb;
//@property (weak, nonatomic) IBOutlet UIButton *joinWithFacebookButton;

- (IBAction)joinWithFacebook:(id)sender;
- (IBAction)createAccount:(id)sender;
- (IBAction)continueAction:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *knnctIDField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberField;

@property (weak, nonatomic) IBOutlet UITextField *textField1;
@property (weak, nonatomic) IBOutlet UITextField *textField2;
@property (weak, nonatomic) IBOutlet UITextField *textField3;
@property (weak, nonatomic) IBOutlet UITextField *textField4;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *skipButton;

@property (weak, nonatomic) IBOutlet UITextField *snapchatField;
@property (weak, nonatomic) IBOutlet UITextField *instagramField;


- (IBAction)imageSelectionButtonWasPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet PFImageView *thumbnailPic;

@property (weak, nonatomic) IBOutlet UIImageView *fbPic;

@property (nonatomic, strong) UIImage *pickedImage;
@property (nonatomic, strong) NSString *knnctID;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *fbID;
@property (nonatomic, strong) NSString *liID;
@property (nonatomic, strong) NSString *twitterID;
@property (nonatomic, strong) NSString *snapID;
@property (nonatomic, strong) NSString *instaID;

@property (weak, nonatomic) IBOutlet UITableViewCell *fbTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *liTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *snapTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *instaTableViewCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *twitterTableViewCell;
@property (weak, nonatomic) IBOutlet UIButton *fbAddButton;
@property (weak, nonatomic) IBOutlet UIButton *liAddButton;
@property (weak, nonatomic) IBOutlet UIButton *snapAddButton;
@property (weak, nonatomic) IBOutlet UIButton *instaAddButton;
@property (weak, nonatomic) IBOutlet UIButton *twitterAddButton;


- (IBAction)skipPage:(id)sender;
- (IBAction)nextPage:(id)sender;


- (IBAction)signup:(id)sender;

@end

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


@property (strong, nonatomic) IBOutlet UITextField *knnctIDField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *firstNameField;
@property (strong, nonatomic) IBOutlet UITextField *lastNameField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberField;

- (IBAction)imageSelectionButtonWasPressed:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *imageButton;
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailPic;

@property (weak, nonatomic) IBOutlet UIImageView *fbPic;

@property (nonatomic, strong) UIImage *pickedImage;
@property (nonatomic, strong) NSString *knnctID;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *fbID;


- (IBAction)skipPage:(id)sender;
- (IBAction)nextPage:(id)sender;


- (IBAction)signup:(id)sender;

@end

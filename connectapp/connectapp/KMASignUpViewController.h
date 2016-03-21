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

@interface KMASignUpViewController : UITableViewController
<
UIActionSheetDelegate,
UINavigationControllerDelegate,
UIImagePickerControllerDelegate,
UITextFieldDelegate,
UITableViewDelegate,
UITableViewDataSource
>

@property (weak, nonatomic) IBOutlet UITextField *knnctIDField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberField;

- (IBAction)imageSelectionButtonWasPressed:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property (weak, nonatomic) IBOutlet UIImageView *thumbnailPic;

@property (nonatomic, strong) UIImage *pickedImage;
@property (nonatomic, strong) NSString *knnctID;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *phoneNumber;


- (IBAction)skipPage:(id)sender;
- (IBAction)nextPage:(id)sender;


- (IBAction)signup:(id)sender;

@end

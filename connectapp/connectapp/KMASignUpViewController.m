//
//  KMASignUpViewController.m
//  connectapp
//
//  Created by Keion Anvaripour on 9/13/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import "KMASignUpViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface KMASignUpViewController ()<FBSDKLoginButtonDelegate>

@end

@implementation KMASignUpViewController
@synthesize pickedImage = _pickedImage;
@synthesize knnctID = _knnctID;
@synthesize password = _password;
@synthesize email = _email;
@synthesize firstName = _firstName;
@synthesize lastName = _lastName;
@synthesize phoneNumber = _phoneNumber;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = YES;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    //self.tableView.autoresizesSubviews = true;
    //self.tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin;
    //self.tableView.estimatedRowHeight = 80;
    //self.tableView.rowHeight = UITableViewAutomaticDimension;
    /*
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    loginButton.readPermissions =
    @[@"public_profile", @"email", @"user_friends"];
    */
    self.fb.readPermissions = @[@"public_profile", @"email"];

    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    // NSString *accessToken = (NSString*)[FBSDKAccessToken currentAccessToken];
   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeTokenChange:) name:FBSDKAccessTokenDidChangeNotification object:nil];
    /*
    if ([FBSDKAccessToken currentAccessToken]) {
        
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"me"
                                      parameters:@{@"fields":  @"id, first_name, last_name, picture.type(large), email"}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
             NSLog(@"email is %@", [result objectForKey:@"user_id"]);
            self.firstNameField.text = [result objectForKey:@"first_name"];
            self.lastNameField.text = [result objectForKey:@"last_name"];
            
        }];
       
        
        // User is logged in, do work such as go to next view controller.
    }*/
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signup:(id)sender
{
    
    _knnctID = [self.knnctIDField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([_knnctID length] == 0 || [_password length] == 0 ) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Oops!"
                                  message: @"Make sure you enter Username/Password/Email/Phone"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    else if ([_knnctID length] != 4){
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Oops!"
                                  message: @"Knnct ID must be 4 letters and/or numbers"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];

    }
    else {
//        UIGraphicsBeginImageContext(CGSizeMake(640, 960));
//        [_pickedImage drawInRect: CGRectMake(0, 0, 640, 960)];
//        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
        
        
        
        
        NSData *imageData = UIImagePNGRepresentation(_pickedImage);
        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];

        [_knnctID lowercaseString];
        [_email lowercaseString];
        PFUser *newUser = [PFUser user];
        newUser.username = [_knnctID lowercaseString];
        newUser.password = _password;
        newUser.email = _email;
        [newUser setObject:_firstName forKey:@"firstName"];
        [newUser setObject:_lastName forKey:@"lastName"];
        [newUser setObject:_phoneNumber forKey:@"phoneNumber"];
        [newUser setObject:imageFile forKey:@"displayPicture"];
        [newUser setObject:_fbID forKey:@"facebookURL"];

        //happens in background without annoying users - block - events that happen asynchronously
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error) {
                //[HUD hide:YES];
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Sorry!"
                                          message:[error.userInfo
                                                   objectForKey:@"error"]
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
            else {

                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
         }];

        // more synchronous code here
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

//Keyboard up

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 80; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}


//- (void)textFieldDidBeginEditing:(UITextView *)textView {
//    self.currentResponder = textView;
//}
//- (void)textFieldDidEndEditing:(UITextView *)textView
//{
//    self.currentResponder = nil;
//}


- (void)promptForSource {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Image Source" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Camera", @"Photo Roll", nil];
    
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex == actionSheet.firstOtherButtonIndex) {
            [self promptForCamera];
        } else {
            [self promptForPhotoRoll];
        }
    }
}

- (void)promptForCamera {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypeCamera;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)promptForPhotoRoll {
    UIImagePickerController *controller = [[UIImagePickerController alloc] init];
    controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.pickedImage = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setPickedImage:(UIImage *)pickedImage {
   
    _pickedImage = pickedImage;
    
    if (pickedImage == nil) {
        
        [self.imageButton setImage:[UIImage imageNamed:@"icn_noimage"] forState:UIControlStateNormal];
        
    } else {
        //[self.imageButton setImage:pickedImage forState:UIControlStateNormal];
        self.thumbnailPic.image = pickedImage;
    }
}

- (IBAction)imageSelectionButtonWasPressed:(id)sender {
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self promptForSource];
    } else {
        [self promptForPhotoRoll];
    }
}


- (IBAction)skipPage:(id)sender {
    [self performSegueWithIdentifier:@"skip" sender:self];
}

- (IBAction)nextPage:(id)sender {
    
    _email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _firstName =
    [self.firstNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _lastName = [self.lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _phoneNumber = [self.phoneNumberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([_firstName length] == 0 || [_lastName length] == 0 || [_email length] == 0 || [_phoneNumber length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Oops!"
                                  message: @"Make sure you fill out all fields."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [self performSegueWithIdentifier:@"part2" sender:self];
    }
    
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"part2"]) {
        //[segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        KMASignUpViewController *suvc = [segue destinationViewController];
        
        suvc.email = self.emailField.text;
        suvc.firstName = self.firstNameField.text;
        suvc.lastName = self.lastNameField.text;
        suvc.phoneNumber = self.phoneNumberField.text;
        suvc.pickedImage = _pickedImage;
        suvc.fbID = _fbID;
        
    }
    if ([segue.identifier isEqualToString:@"skip"]) {
        //[segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        KMASignUpViewController *suvc = [segue destinationViewController];
        
        //suvc.facebook = _facebook;
        suvc.pickedImage = _pickedImage;
        suvc.email = _email;
        suvc.firstName = _firstName;
        suvc.lastName = _lastName;
        suvc.phoneNumber = _phoneNumber;
        suvc.fbID = _fbID;
        
    }
    if ([segue.identifier isEqualToString:@"basic"]) {
        //[segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        KMASignUpViewController *suvc = [segue destinationViewController];
        
        //suvc.facebook = _facebook;
        suvc.pickedImage = _pickedImage;
        suvc.emailField.text = _email;
        suvc.firstNameField.text = @"hello world";
        suvc.lastNameField.text = _lastName;
        
        suvc.thumbnailPic.image = _pickedImage;
        suvc.email = _email;
        suvc.firstName = _firstName;
        suvc.lastName = _lastName;
        suvc.phoneNumber = _phoneNumber;
        suvc.fbID = _fbID;
        NSLog(@"LAST NAME: %@", _lastName);
        
        
    }

}

- (void) hideKeyboard {
    [_knnctIDField resignFirstResponder];
    [_emailField resignFirstResponder];
    [_firstNameField resignFirstResponder];
    [_lastNameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}


- (void)observeTokenChange:(NSNotification *)notfication {
 
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"me"
                                      parameters:@{@"fields":  @"id, first_name, last_name, picture.type(normal), email"}
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            NSLog(@"picture is %@", [result objectForKey:@"id"]);
            NSLog(@"email: %@", _email);
            
//            self.firstNameField.text = [result objectForKey:@"first_name"];
//            self.lastNameField.text = [result objectForKey:@"last_name"];
//            self.emailField.text = [result objectForKey:@"email"];
            
            
            
            NSURL *pictureURL = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
            _pickedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
            _firstName =[result objectForKey:@"first_name"];
            _lastName = [result objectForKey:@"last_name"];
            _email =[result objectForKey:@"email"];
            _fbID =[result objectForKey:@"id"];

            self.thumbnailPic.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
   
            self.emailField.text = _email;
            self.firstNameField.text = _firstName;
            self.lastNameField.text = _lastName;
            
            //[self performSegueWithIdentifier:@"basic" sender:self];
            
//            KMASignUpViewController *signUpView = [[self storyboard] instantiateViewControllerWithIdentifier:@"showBasic"];
//            signUpView.lastNameField.text = [result objectForKey:@"last_name"];
//            signUpView.emailField.text = [result objectForKey:@"email"];
//            
//             [self.navigationController pushViewController:signUpView animated:YES];
            
        }];
        
       
    }

}


@end

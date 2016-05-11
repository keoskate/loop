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
#import <linkedin-sdk/LISDK.h>
#import <TwitterKit/TwitterKit.h>
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

    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.09 green:0.73 blue:0.98 alpha:1.0]];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //fix weird choppy bug
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = YES;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    
    self.thumbnailPic.image = self.pickedImage;
    if (!self.thumbnailPic.image) {
        self.thumbnailPic.image = [UIImage imageNamed:@"placeholder.png"];
    }
    self.emailField.text = self.email;
    self.firstNameField.text = self.firstName;
    self.lastNameField.text = self.lastName;
    
    [self.thumbnailPic loadInBackground];
    
    self.thumbnailPic.layer.borderWidth = 2;
    self.thumbnailPic.layer.borderColor = [UIColor whiteColor].CGColor;
    self.thumbnailPic.layer.cornerRadius = 130/2;
    self.thumbnailPic.clipsToBounds = YES;
    
    [self.textField1 becomeFirstResponder];
    
    [self.fbAddButton addTarget:self
                         action:@selector(addFBActionSU)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.liAddButton addTarget:self
                         action:@selector(addLIActionSU)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.instaAddButton addTarget:self
                         action:@selector(addInstaActionSU)
               forControlEvents:UIControlEventTouchUpInside];
    [self.snapAddButton addTarget:self
                         action:@selector(addSnapActionSU)
               forControlEvents:UIControlEventTouchUpInside];
    [self.twitterAddButton addTarget:self
                           action:@selector(addTwitterActionSU)
                 forControlEvents:UIControlEventTouchUpInside];
    
    [self setUpUI];
    
    self.fb.readPermissions = @[@"public_profile", @"email"];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
}

-(void)setUpUI {
    if (![_fbID isEqualToString:@""] && _fbID != nil) {
        self.fbTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.fbAddButton.hidden = true;
    }else{
        self.fbAddButton.hidden = false;
    }
    if (![_liID isEqualToString:@""] && _liID != nil) {
        self.liTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.liAddButton.hidden = true;
    }else{
        self.liAddButton.hidden = false;
    }
    
    if (![_twitterID isEqualToString:@""] && _twitterID != nil) {
        self.twitterTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.twitterAddButton.hidden = true;
    }else{
        self.twitterAddButton.hidden = false;
    }
    
    if (![_instaID isEqualToString:@""] && _instaID != nil) {
        self.instaTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.instaAddButton.hidden = true;
    }else{
        self.instaAddButton.hidden = false;
    }
    
    if (![_snapID isEqualToString:@""] && _snapID != nil) {
        self.snapTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.snapAddButton.hidden = true;
    }else{
        self.snapAddButton.hidden = false;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signup:(id)sender
{
    self.doneButton.enabled = NO;
    self.doneButton.titleLabel.text = @"Waiting...";
    self.skipButton.enabled = NO;
    
//    _knnctID = [self.knnctIDField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    _password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    if ([_knnctID length] == 0 || [_password length] == 0 ) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Oops!"
                                  message: @"Make sure you enter all required fields."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    else if ([_knnctID length] != 4){
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Oops!"
                                  message: @"Loop ID must be 4 letters and/or numbers"
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];

    }
    else {
#warning - flip captured photo before saving
        //NSData *imageData = UIImagePNGRepresentation(_pickedImage);
        NSData *imageData = UIImageJPEGRepresentation(_pickedImage, 0.05f);
        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];

        _knnctID = [_knnctID lowercaseString]; //make sure LOWERCASE
        
        PFUser *newUser = [PFUser user];
        newUser.username = [_knnctID lowercaseString];
        newUser.password = _password;
        newUser.email = [_email lowercaseString];
#pragma mark - set first/last to captilized string
        [newUser setObject:[_firstName capitalizedString] forKey:@"firstName"];
        [newUser setObject:[_lastName capitalizedString] forKey:@"lastName"];
        [newUser setObject:_phoneNumber forKey:@"phoneNumber"];
        
        if (_pickedImage != nil) {
            [newUser setObject:imageFile forKey:@"displayPicture"];
        }
        
        if (![_fbID isEqualToString:@""] && _fbID != nil) {
            [newUser setObject:_fbID forKey:@"facebookURL"];
        }
        if (![_liID isEqualToString:@""] && _liID != nil) {
            [newUser setObject:_liID forKey:@"linkedinURL"];
        }

        if (![self.snapID isEqualToString:@""] && self.snapID != nil) {
            [newUser setObject:[self.snapID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"snapchatURL"];
        }
        if (![self.instaID  isEqualToString: @""] && self.instaID != nil) {
            [newUser setObject:[self.instaID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"instagramURL"];
        }
        if (![self.twitterID  isEqualToString: @""] && self.twitterID != nil) {
            [newUser setObject:[self.twitterID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"twitterURL"];
        }
        
        [newUser setObject:[NSNumber numberWithInt:0] forKey:@"score"];
        
        
#warning add more API URLs
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
                self.doneButton.enabled = YES;
                self.doneButton.titleLabel.text = @"Done";
                self.skipButton.enabled = YES;
            }
            else {
                [self.navigationController setNavigationBarHidden:YES animated:YES];
                [self.navigationController popToRootViewControllerAnimated:YES];
                
                UIViewController * target = [[self.tabBarController viewControllers] objectAtIndex:1];
                [target.navigationController popToRootViewControllerAnimated: NO];
                [self.tabBarController setSelectedIndex:2];
                
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

#pragma mark - IBActions
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
    
//    _email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
    _firstName =
    [self.firstNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
    _lastName = [self.lastNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
   
    _phoneNumber = [self.phoneNumberField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([_firstName length] == 0 || [_lastName length] == 0 || [self.passwordField.text length] == 0 || [_phoneNumber length] == 0 || [_email length] == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Oops!"
                                  message: @"Make sure you fill out all fields."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    else {
    
        
        [self performSegueWithIdentifier:@"create3" sender:self];
    }
    
}

- (IBAction)createAccount:(id)sender {
    
    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", emailRegEx];

    _email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([_email length] == 0  || ![emailTest evaluateWithObject:_email]) {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Oops!"
                                  message: @"Make sure you entered a valid email."
                                  delegate:nil
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    else {
        
//        KMASignUpViewController *signUpView = [[self storyboard] instantiateViewControllerWithIdentifier:@"create2"];
//        signUpView.email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//         [self.navigationController pushViewController:signUpView animated:YES];
        
        [self performSegueWithIdentifier:@"create1" sender:self];
        
    }
}

- (IBAction)continueAction:(id)sender {
    
   
    NSString *c1 = [self.textField1.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *c2 = [self.textField2.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *c3 = [self.textField3.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *c4 = [self.textField4.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSMutableString *loopID = [NSMutableString stringWithString:c1];
    [loopID appendString:c2];
    [loopID appendString:c3];
    [loopID appendString:c4];
    loopID = [loopID lowercaseString];
    [loopID stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    self.knnctID = loopID;
    NSLog(@"LoopID: %@", loopID);
    
   
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:loopID];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Oops!"
                                      message: @"That username is already taken."
                                      delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            self.textField1.text = @"";
            self.textField2.text = @"";
            self.textField3.text = @"";
            self.textField4.text = @"";
            [loopID setString:@""];
            [self.textField1 becomeFirstResponder];
            
        }else {
            if ([loopID length] != 4 ) {
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Oops!"
                                          message: @"Your Loop ID must be 4 characters long."
                                          delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
            else {
                [self performSegueWithIdentifier:@"create2" sender:self];
            }
            
        }

    }];
}

#pragma mark - text field
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL shouldProcess = NO; //default to reject
    BOOL shouldMoveToNextField = NO; //default to remaining on the current field
    
    int insertStringLength = [string length];
    NSString *resultString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    BOOL isPressedBackspaceAfterSingleSpaceSymbol = [string isEqualToString:@""] && [resultString isEqualToString:@""] && range.location == 0 && range.length == 1;
    if (isPressedBackspaceAfterSingleSpaceSymbol) {
        NSInteger nextTag = 0;
        if (textField.tag > 0) {
            nextTag = textField.tag - 1;
        }
        UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
        if (nextResponder)
            [nextResponder becomeFirstResponder];
    }
    if(insertStringLength == 0){ //backspace
        shouldProcess = YES; //Process if the backspace character was pressed
        
    } else {
        if([[textField text] length] == 0) {
            shouldProcess = YES; //Process if there is only 1 character right now
        }
    }
    
    //here we deal with the UITextField on our own
    if(shouldProcess){
        //grab a mutable copy of what's currently in the UITextField
        NSMutableString* mstring = [[textField text] mutableCopy];
        if([mstring length] == 0){
            //nothing in the field yet so append the replacement string
            [mstring appendString:string];
            
            shouldMoveToNextField = YES;
        }
        else{
            //adding a char or deleting?
            if(insertStringLength > 0){
                [mstring insertString:string atIndex:range.location];
            }
            else {
                //delete case - the length of replacement string is zero for a delete
                [mstring deleteCharactersInRange:range];
            }
        }
        
        //set the text now
        [textField setText:mstring];
        
        if (shouldMoveToNextField) {
            //
            //MOVE TO NEXT INPUT FIELD HERE
            //
            NSInteger nextTag = textField.tag + 1;
            // Try to find next responder
            UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
//            if (! nextResponder)
//                nextResponder = [textField.superview viewWithTag:1];
            
            if (nextResponder)
                // Found next responder, so set it.
                [nextResponder becomeFirstResponder];

        }
    }
    
    //always return no since we are manually changing the text field
    return NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"create1"]) {

        KMASignUpViewController *suvc = [segue destinationViewController];
        suvc.email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
    }
    if ([segue.identifier isEqualToString:@"create2"]) {
        
        KMASignUpViewController *suvc = [segue destinationViewController];
        suvc.pickedImage =  self.pickedImage;
        suvc.firstName = self.firstName;
        suvc.lastName = self.lastName;
        suvc.email = self.email;
        suvc.fbID = self.fbID;
        suvc.knnctID = self.knnctID;
    }
    
    if ([segue.identifier isEqualToString:@"create3"]) {
        
        KMASignUpViewController *suvc = [segue destinationViewController];
        suvc.pickedImage =  self.pickedImage;
        suvc.firstName = self.firstName;
        suvc.lastName = self.lastName;
        suvc.phoneNumber = self.phoneNumber;
        suvc.email = self.email;
        suvc.fbID = self.fbID;
        suvc.knnctID = self.knnctID;
        
        suvc.password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
}

- (void) hideKeyboard {
    [_knnctIDField resignFirstResponder];
    [_emailField resignFirstResponder];
    [_firstNameField resignFirstResponder];
    [_lastNameField resignFirstResponder];
    [_passwordField resignFirstResponder];
    [_instagramField resignFirstResponder];
    [_snapchatField resignFirstResponder];
}

- (IBAction)joinWithFacebook:(id)sender {
    NSLog(@"joining with facebook ...");
    
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
            NSLog(@"error %@", error);
        } else if (result.isCancelled) {
            // Handle cancellations
            NSLog(@"Cancelled");
        } else {
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                [self fetchUserInfo];
            }
        }
    }];
}

-(void)fetchUserInfo {
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        NSLog(@"Token is available");
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":  @"id, first_name, last_name, picture.type(large), email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"Fetched User Information:%@", result);
                 
                 NSLog(@"picture is %@", [result objectForKey:@"id"]);
                 
                 NSURL *pictureURL = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                 
                 KMASignUpViewController *signUpView = [[self storyboard] instantiateViewControllerWithIdentifier:@"create2"];
                 signUpView.pickedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:pictureURL]];
                 signUpView.firstName =[result objectForKey:@"first_name"];
                 signUpView.lastName = [result objectForKey:@"last_name"];
                 signUpView.email =[result objectForKey:@"email"];
                 signUpView.fbID =[result objectForKey:@"id"];
                 
                 [self.navigationController pushViewController:signUpView animated:YES];
                 
             }
             else {
                 NSLog(@"Error %@",error);
             }
         }];
        
    } else {
        NSLog(@"User is not Logged in");
    }
}


-(void)addFBActionSU {
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logInWithReadPermissions:@[@"email"] handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error) {
            // Process error
            NSLog(@"error %@", error);
        } else if (result.isCancelled) {
            // Handle cancellations
            NSLog(@"Cancelled");
        } else {
            if ([result.grantedPermissions containsObject:@"email"]) {
                // Do work
                if ([FBSDKAccessToken currentAccessToken]) {
                    
                    NSLog(@"Token is available");
                    
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":  @"id, first_name, last_name, picture.type(large), email"}]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         if (!error) {
                             NSLog(@"Fetched User Information:%@", result);

                             self.fbID = [result objectForKey:@"id"];
                             
                         }
                         else {
                             NSLog(@"Error %@",error);
                         }
                     }];
                    
                } else {
                    NSLog(@"User is not Logged in");
                }

            }
        }
    }];
    [self setUpUI];
}

- (void)addLIActionSU {
    //Sync
    [LISDKSessionManager createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, nil]
                                         state:nil
                        showGoToAppStoreDialog:YES
                                  successBlock:^(NSString *returnState) {
                                      
                      LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
                      
                      //Execute
                      [[LISDKAPIHelper sharedInstance] apiRequest:@"https://www.linkedin.com/v1/people/~"
                                                           method:@"GET"
                                                             body:nil
                                                          success:^(LISDKAPIResponse *response) {
                              
                              //Read data response
                              NSData *jsonData = [response.data dataUsingEncoding:NSUTF8StringEncoding];
                              NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error:nil];
                              
                              self.liID = [JSON objectForKey:@"id"];
                              self.liTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
                              self.liAddButton.hidden = true;
                            
                              
                              
                          }error:^(LISDKAPIError *apiError) {
                                NSLog(@"LI error called %@", apiError.description);
                                
                          }];

                  }errorBlock:^(NSError *error) {
                        NSLog(@"%s %@","LI error called! ", [error description]);
                  }
     ];
    [self setUpUI];
    
}

- (void)addTwitterActionSU {
    // Objective-C
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {

            self.twitterID = [session userName];
            
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
    [self setUpUI];
}


- (void)addInstaActionSU {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Instgram" message:@"Enter your instagram username" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Connect" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        self.instaID = alert.textFields.firstObject.text;
        [self setUpUI];
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"@username";
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)addSnapActionSU {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Snapchat" message:@"Enter your snapchat username" preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

        self.snapID = alert.textFields.firstObject.text;

        [self setUpUI];
        
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"@username";
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}
@end

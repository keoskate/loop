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
   // self.navigationController.navigationBarHidden = NO;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
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
    
    CALayer *imageLayer = self.thumbnailPic.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:4];
    [imageLayer setBorderColor:[UIColor whiteColor].CGColor];
    [imageLayer setMasksToBounds:YES];
    [self.thumbnailPic.layer setCornerRadius:self.thumbnailPic.frame.size.width/7];
    [self.thumbnailPic.layer setMasksToBounds:YES];
    
    [self.thumbnailPic loadInBackground];
    
    [self.textField1 becomeFirstResponder];
    
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
    
    /*
     
     // NSString *accessToken = (NSString*)[FBSDKAccessToken currentAccessToken];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeTokenChange:) name:FBSDKAccessTokenDidChangeNotification object:nil];
     
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
    self.doneButton.enabled = NO;
    self.doneButton.titleLabel.text = @"Waiting...";
    self.skipButton.enabled = NO;
    
//    _knnctID = [self.knnctIDField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//   
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
//        UIGraphicsBeginImageContext(CGSizeMake(640, 960));
//        [_pickedImage drawInRect: CGRectMake(0, 0, 640, 960)];
//        UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        NSData *imageData = UIImageJPEGRepresentation(smallImage, 0.05f);
        
        NSData *imageData = UIImagePNGRepresentation(_pickedImage);
        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];

        _knnctID = [_knnctID lowercaseString]; //make sure LOWERCASE
        
        PFUser *newUser = [PFUser user];
        newUser.username = [_knnctID lowercaseString];
        newUser.password = _password;
        newUser.email = [_email lowercaseString];
        [newUser setObject:_firstName forKey:@"firstName"];
        [newUser setObject:_lastName forKey:@"lastName"];
        [newUser setObject:_phoneNumber forKey:@"phoneNumber"];
        [newUser setObject:imageFile forKey:@"displayPicture"];
        [newUser setObject:_fbID forKey:@"facebookURL"];
        
        if ([self.snapchatField.text isEqualToString:@""]) {
            [newUser setObject:[self.snapchatField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"snapchatURL"];
        }
        if (![self.instagramField.text  isEqualToString: @""]) {
            [newUser setObject:[self.instagramField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] forKey:@"instagramURL"];
        }
        
        
        
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
    if(insertStringLength == 0){ //backspace
        shouldProcess = YES; //Process if the backspace character was pressed
    }
    else {
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

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
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

/*
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
            
            [self performSegueWithIdentifier:@"basic" sender:self];
            
//            KMASignUpViewController *signUpView = [[self storyboard] instantiateViewControllerWithIdentifier:@"showBasic"];
//            signUpView.lastNameField.text = [result objectForKey:@"last_name"];
//            signUpView.emailField.text = [result objectForKey:@"email"];
//            
//             [self.navigationController pushViewController:signUpView animated:YES];
            
        }];
        
       
    }

}
*/

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
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":  @"id, first_name, last_name, picture.type(normal), email"}]
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
@end

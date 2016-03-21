//
//  KMASignUpViewController.m
//  connectapp
//
//  Created by Keion Anvaripour on 9/13/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import "KMASignUpViewController.h"

@interface KMASignUpViewController ()

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
        newUser.username = _knnctID;
        newUser.password = _password;
        newUser.email = _email;
        [newUser setObject:_firstName forKey:@"firstName"];
        [newUser setObject:_lastName forKey:@"lastName"];
        [newUser setObject:_phoneNumber forKey:@"phoneNumber"];
        [newUser setObject:imageFile forKey:@"displayPicture"];

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
        
    }

}

- (void) hideKeyboard {
    [_knnctIDField resignFirstResponder];
    [_emailField resignFirstResponder];
    [_firstNameField resignFirstResponder];
    [_lastNameField resignFirstResponder];
    [_passwordField resignFirstResponder];
}

@end

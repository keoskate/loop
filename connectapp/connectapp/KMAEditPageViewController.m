//
//  KMAEditPageViewController.m
//  Loop
//
//  Created by Keion Anvaripour on 3/27/16.
//  Copyright © 2016 Keion Anvaripour. All rights reserved.
//

#import "KMAEditPageViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <linkedin-sdk/LISDK.h>
#import <TwitterKit/TwitterKit.h>

@interface KMAEditPageViewController ()

@end

@implementation KMAEditPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView reloadData];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    //[self.backgroundColor setBackgroundColor: [UIColor colorWithRed:0.09 green:0.73 blue:0.98 alpha:1.0]];
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = YES;
    [self.tableView addGestureRecognizer:gestureRecognizer];

    [self.fbConnectButton addTarget:self
                         action:@selector(addFBAction)
               forControlEvents:UIControlEventTouchUpInside];
    
    [self.liConnectButton addTarget:self
                             action:@selector(addLIAction)
                   forControlEvents:UIControlEventTouchUpInside];
    
    [self.twitterConnectButton addTarget:self
                             action:@selector(addTwitterAction)
                   forControlEvents:UIControlEventTouchUpInside];
    
    [self.instaConnectButton addTarget:self
                                  action:@selector(addInstaAction)
                        forControlEvents:UIControlEventTouchUpInside];
    
    [self.snapConnectButton addTarget:self
                                  action:@selector(addSnapAction)
                        forControlEvents:UIControlEventTouchUpInside];
    
    [self setUpView];
 
    self.fb.readPermissions = @[@"public_profile", @"email"];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
}

-(void)setUpView{
    PFUser *currentUser = [PFUser currentUser];
    
    
    self.nameField.placeholder = [NSString stringWithFormat:@"%@ %@", currentUser[@"firstName"], currentUser[@"lastName"]];
    
    self.emailField.placeholder = currentUser.email;
    self.phoneField.placeholder = currentUser[@"phoneNumber"];
    self.instagramField.placeholder = currentUser[@"instagramURL"];
    self.snapchatField.placeholder = currentUser[@"snapchatURL"];
    self.linkedinField.placeholder = currentUser[@"linkedinURL"];
    self.facebookField.placeholder = currentUser[@"facebookURL"];
    self.twitterField.placeholder = currentUser[@"twitterURL"];
    
    self.photoField.file = [currentUser objectForKey:@"displayPicture"];
    self.photoField.image = [UIImage imageNamed:@"placeholder.png"];
    //[self.photoField loadInBackground];
    [self.photoField loadInBackground:^(UIImage *image, NSError *error) {
        if (!error) {
            /* Blur effect */
            CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
            [gaussianBlurFilter setDefaults];
            CIImage *inputImage = [CIImage imageWithCGImage:[image CGImage]];
            [gaussianBlurFilter setValue:inputImage forKey:kCIInputImageKey];
            [gaussianBlurFilter setValue:@20 forKey:kCIInputRadiusKey];
            
            CIImage *outputImage = [gaussianBlurFilter outputImage];
            CIContext *context   = [CIContext contextWithOptions:nil];
            CGImageRef cgimg     = [context createCGImage:outputImage fromRect:[inputImage extent]];  // note, use input image extent if you want it the same size, the output image extent is larger
            self.backgroundBlur.image       = [UIImage imageWithCGImage:cgimg];
            
        }
    }];
    
    self.photoField.layer.borderWidth = 2;
    self.photoField.layer.borderColor = [UIColor whiteColor].CGColor;
    self.photoField.layer.cornerRadius = 130/2;
    self.photoField.clipsToBounds = YES;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", currentUser[@"firstName"], currentUser[@"lastName"]];
    self.loopidLabel.text = [NSString stringWithFormat:@"%@ %@ %@%@", [currentUser.username uppercaseString], @"|", currentUser[@"score"], @"pts" ];
  
    if (![[currentUser objectForKey:@"facebookURL"] isEqualToString:@""] && [currentUser objectForKey:@"facebookURL"] != nil) {
        self.fbTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.fbConnectButton.hidden = true;
    }else{
        self.fbConnectButton.hidden = false;
        self.fbTableViewCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (![[currentUser objectForKey:@"linkedinURL"] isEqualToString:@""] && [currentUser objectForKey:@"linkedinURL"] != nil) {
        self.liTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.liConnectButton.hidden = true;
    }else{
        self.liConnectButton.hidden = false;
        self.liTableViewCell.accessoryType = UITableViewCellAccessoryNone;
    }
   
    if (![[currentUser objectForKey:@"instagramURL"] isEqualToString:@""] && [currentUser objectForKey:@"instagramURL"] != nil) {
        self.igTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.instaConnectButton.hidden = true;
    }else{
        self.instaConnectButton.hidden = false;
        self.igTableViewCell.accessoryType = UITableViewCellAccessoryNone;

    }

    if (![[currentUser objectForKey:@"snapchatURL"] isEqualToString:@""] && [currentUser objectForKey:@"snapchatURL"] != nil) {
        self.scTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.snapConnectButton.hidden = true;
    }else{
        self.snapConnectButton.hidden = false;
        self.scTableViewCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (![[currentUser objectForKey:@"twitterURL"] isEqualToString:@""] && [currentUser objectForKey:@"twitterURL"] != nil) {
        self.twTableViewCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.twitterConnectButton.hidden = true;
    }else{
        self.twitterConnectButton.hidden = false;
        self.twTableViewCell.accessoryType = UITableViewCellAccessoryNone;
    }
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpView];
    [self.tableView reloadData];
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(ctx, rect);
    CGContextSetFillColor(ctx, CGColorGetComponents([[UIColor blueColor] CGColor]));
    CGContextFillPath(ctx);
}

- (void) hideKeyboard {
    [_facebookField resignFirstResponder];
    [_emailField resignFirstResponder];
    [_phoneField resignFirstResponder];
    [_linkedinField resignFirstResponder];
    [_snapchatField resignFirstResponder];
    [_instagramField resignFirstResponder];
    [_twitterField resignFirstResponder];
    [_nameField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//function added by kay
-(void) saveSuccessAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Information Saved!"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
// enables save button again when a textfield change is detected
-(void) textFieldDidChange:(UITextField *)textField{
    [self.saveButton setEnabled:YES];
    [self.saveButton setTintColor:nil];
}

- (IBAction)saveButtonPressed:(id)sender{
    
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (self.emailField.text.length > 0) {
        currentUser.email = self. emailField.text;
        self.emailField.placeholder = self.emailField.text;
        self.emailField.text = @"";
    }
    if (self.phoneField.text.length > 0) {
        currentUser[@"phoneNumber"] = self.phoneField.text;
        self.phoneField.placeholder = self.phoneField.text;
        self.phoneField.text = @"";
    }
    if (self.instagramField.text.length > 0) {
        currentUser[@"instagramURL"] = self.instagramField.text;
        self.instagramField.placeholder = self.instagramField.text;
        self.instagramField.text = @"";
        self.liTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    if (self.snapchatField.text.length > 0) {
        currentUser[@"snapchatURL"] = self.snapchatField.text;
        self.snapchatField.placeholder = self.snapchatField.text;
        self.snapchatField.text = @"";
    }
    if (self.nameField.text.length > 0) {
        NSArray *wordsAndEmptyStrings = [[self.nameField.text lowercaseString] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *words = [wordsAndEmptyStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
   
        currentUser[@"firstName"] = [words[0] capitalizedString];
        currentUser[@"lastName"] = [words[1] capitalizedString];
        self.nameField.placeholder = self.nameField.text;
        self.nameField.text = @"";
    }
    
    if (self.pickedImage != nil) {
        NSData *imageData = UIImageJPEGRepresentation(_pickedImage, 0.05f);
        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
        [currentUser setObject:imageFile forKey:@"displayPicture"];
    }
    
    NSLog(@"Saving...");
    [currentUser saveInBackground];
    [self saveSuccessAlert];
    [self viewDidAppear:YES];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
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
        
        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields":  @"id, first_name, last_name, picture.type(square), email"}]
         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
             if (!error) {
                 NSLog(@"Fetched User Information:%@", result);
                 
                 PFUser *currentUser = [PFUser currentUser];
                 currentUser[@"facebookURL"] = [result objectForKey:@"id"];
                 [currentUser saveInBackground];
                 self.fbTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
                 self.fbConnectButton.hidden = true;
                 
             }
             else {
                 NSLog(@"Error %@",error);
             }
         }];
        
    } else {
        NSLog(@"User is not Logged in");
    }
}

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
        
//        [self.imageButton setImage:[UIImage imageNamed:@"icn_noimage"] forState:UIControlStateNormal];
        
    } else {
        //[self.imageButton setImage:pickedImage forState:UIControlStateNormal];
        self.photoField.image = pickedImage;
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

-(void)addFBAction{
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
                             PFUser *currentUser = [PFUser currentUser];
                             currentUser[@"facebookURL"] = [result objectForKey:@"id"];
                             [currentUser saveInBackground];
                             [self setUpView];
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
}


#pragma mark - LinkedIn Functionality
- (void)addLIAction {
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
                                                                              PFUser *currentUser = [PFUser currentUser];
                                                                              currentUser[@"linkedinURL"] = [JSON objectForKey:@"id"];
                                                                              [currentUser saveInBackground];

                                                                              [self setUpView];
                                                                              
                                                                          }
                                                                            error:^(LISDKAPIError *apiError) {
                                                                                NSLog(@"LI error called %@", apiError.description);
                                                                                
                                                                            }];
                                      
                                  }
                                    errorBlock:^(NSError *error) {
                                        NSLog(@"%s %@","LI error called! ", [error description]);
                                    }
     ];
    
}

-(void)syncLinkedInSession{
    [LISDKSessionManager createSessionWithAuth:[NSArray arrayWithObjects:LISDK_BASIC_PROFILE_PERMISSION, nil]
                                         state:@"some state"
                        showGoToAppStoreDialog:YES
                                  successBlock:^(NSString *returnState) {
                                      
                                      LISDKSession *session = [[LISDKSessionManager sharedInstance] session];
                                      NSLog(@"%s","Sync success!");
                                      
                                  }
                                    errorBlock:^(NSError *error) {
                                        NSLog(@"%s %@","error called! ", [error description]);
                                    }
     ];
    
}

-(void)LIDeeplinkProfile{
    //deeplink
    NSLog(@"LI deeplink");
    
    DeeplinkSuccessBlock success = ^(NSString *returnState) {
        NSLog(@"Success with returned state: %@",returnState);
    };
    DeeplinkErrorBlock error = ^(NSError *error, NSString *returnState) {
        NSLog(@"Error with returned state: %@", returnState);
        NSLog(@"Error %@", error);
    };
    
    PFUser *currentUser = [PFUser currentUser];
    NSString *memberId = currentUser[@"linkedinURL"];
    NSLog(@"id: %@", memberId);
    
    [[LISDKDeeplinkHelper sharedInstance] viewOtherProfile:memberId withState:@"viewOtherProfileButton" showGoToAppStoreDialog:YES success:success error:error];
    
}
-(void)viewLinkedInProfile:(id)sender{
    
    if ([LISDKSessionManager hasValidSession] == YES) {
        [self LIDeeplinkProfile];
    }else{
        [self syncLinkedInSession];
        [self LIDeeplinkProfile];
    }
}

#pragma mark - twitter
- (void)addTwitterAction {
    // Objective-C
    [[Twitter sharedInstance] logInWithCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            NSLog(@"signed in as %@", [session userName]);
            NSLog(@"USER ID::: %@", [session userID]);
            PFUser *currentUser = [PFUser currentUser];
            currentUser[@"twitterURL"] = [session userName];
            [currentUser saveInBackground];
            [self setUpView];
        } else {
            NSLog(@"error: %@", [error localizedDescription]);
        }
    }];
}


- (void)addInstaAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Instgram" message:@"Enter your instagram username" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Connect" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        PFUser *currentUser = [PFUser currentUser];
        currentUser[@"instagramURL"] = alert.textFields.firstObject.text;
        [currentUser saveInBackground];
        [self setUpView];
        
    }];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"@username";
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)addSnapAction {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Snapchat" message:@"Enter your snapchat username" preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
    }];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Add" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        PFUser *currentUser = [PFUser currentUser];
        currentUser[@"snapchatURL"] = alert.textFields.firstObject.text;
        [currentUser saveInBackground];
        [self setUpView];

        
    }];
    [alert addAction:cancelAction];
    [alert addAction:defaultAction];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"@username";
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end

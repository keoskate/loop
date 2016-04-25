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
@interface KMAEditPageViewController ()

@end

@implementation KMAEditPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = YES;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    //kay's changes
    //disable save button initially
    [self.saveButton setEnabled:NO];
    [self.saveButton setTintColor: [UIColor clearColor]];
    
    //enable save button again if any text fields not empty (textfield listener)
    [_emailField addTarget:self
                    action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
    [_phoneField addTarget:self
                    action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
    [_facebookField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    [_linkedinField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    [_instagramField addTarget:self
                        action:@selector(textFieldDidChange:)
              forControlEvents:UIControlEventEditingChanged];
    [_snapchatField addTarget:self
                       action:@selector(textFieldDidChange:)
             forControlEvents:UIControlEventEditingChanged];
    // end kay's changes

    
    PFUser *currentUser = [PFUser currentUser];
    
    self.photoField.file = [currentUser objectForKey:@"displayPicture"];
    self.photoField.image = [UIImage imageNamed:@"placeholder.png"];
    
   // CALayer *imageLayer = self.photoField.layer;
//    [imageLayer setBorderWidth:2];
//    [imageLayer setBorderColor:[UIColor whiteColor].CGColor];
//    [self.photoField.layer setCornerRadius:self.photoField.frame.size.height/2];
//    [self.photoField.layer setMasksToBounds:YES];
    
    [self.photoField loadInBackground];
    self.photoField.layer.borderWidth = 2;
    self.photoField.layer.borderColor = [UIColor whiteColor].CGColor;
    self.photoField.layer.cornerRadius = 130/2;
    self.photoField.clipsToBounds = YES;
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", currentUser[@"firstName"], currentUser[@"lastName"]];
    self.loopidLabel.text = [currentUser.username uppercaseString];
    
    self.phoneField.placeholder = [currentUser objectForKey:@"phoneNumber"];
    self.emailField.placeholder  = currentUser.email;
    
    if (![[currentUser objectForKey:@"facebookURL"] isEqualToString:@""]) {
        self.fbTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.fbConnectButton.hidden = true;
    }
    if (![[currentUser objectForKey:@"linkedinURL"] isEqualToString:@""]) {
        self.liTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
         self.fbConnectButton.hidden = true;
    }
    if (![[currentUser objectForKey:@"instagramURL"] isEqualToString:@""]) {
        self.igTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.instagramField.placeholder = [currentUser objectForKey:@"instagramURL"];
    }
    if (![[currentUser objectForKey:@"snapchatURL"] isEqualToString:@""]) {
        self.scTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.snapchatField.placeholder = [currentUser objectForKey:@"snapchatURL"];
    }
 
    self.fb.readPermissions = @[@"public_profile", @"email"];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeTokenChange:) name:FBSDKAccessTokenDidChangeNotification object:nil];

    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//function added by kay
-(void) saveSuccessAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saving Information"
                                                    message:@"Information Saved!"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert show];
    
}
// enables save button again when a textfield change is detected
-(void) textFieldDidChange:(UITextField *)textField{
    [self.saveButton setEnabled:YES];
    [self.saveButton setTintColor:nil];
}

//end kay


- (IBAction)saveButtonPressed:(id)sender{
    
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (self.emailField.text.length > 0) {
        currentUser.email = self. emailField.text;
        [self saveSuccessAlert];
    }
    if (self.phoneField.text.length > 0) {
        currentUser[@"phoneNumber"] = self.phoneField.text;
        [self saveSuccessAlert];
    }
    if (self.facebookField.text.length > 0) {
        currentUser[@"facebookURL"] = self.facebookField.text;
        [self saveSuccessAlert];
    }
    if (self.linkedinField.text.length > 0) {
        currentUser[@"linkedinURL"] = self.linkedinField.text;
        [self saveSuccessAlert];
    }
    if (self.instagramField.text.length > 0) {
        currentUser[@"instagramURL"] = self.instagramField.text;
        [self saveSuccessAlert];
    }
    if (self.snapchatField.text.length > 0) {
        currentUser[@"snapchatURL"] = self.snapchatField.text;
        [self saveSuccessAlert];
    }
    

    NSLog(@"Saving...");
    [currentUser saveInBackground];
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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

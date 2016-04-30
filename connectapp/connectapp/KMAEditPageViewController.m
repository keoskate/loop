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
    [self.tableView reloadData];
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
    [self.photoField loadInBackground:^(UIImage *image, NSError *error) {
        if (!error) {
            /* Blur effect */
            CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
            [gaussianBlurFilter setDefaults];
            CIImage *inputImage = [CIImage imageWithCGImage:[image CGImage]];
            [gaussianBlurFilter setValue:inputImage forKey:kCIInputImageKey];
            [gaussianBlurFilter setValue:@10 forKey:kCIInputRadiusKey];
            
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
    self.loopidLabel.text = [currentUser.username uppercaseString];
    
    self.phoneField.placeholder = [currentUser objectForKey:@"phoneNumber"];
    self.emailField.placeholder  = currentUser.email;
    
    if (![[currentUser objectForKey:@"facebookURL"] isEqualToString:@""] && [currentUser objectForKey:@"facebookURL"] != nil) {
        self.fbTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.fbConnectButton.hidden = true;
        self.fbLabel.text = @"Facebook";
        //self.fbTableViewCell.textLabel.text = @"               Facebook";
    }else{
        self.fbConnectButton.hidden = false;
        self.fbLabel.text = @"";
    }
    
    if (![[currentUser objectForKey:@"linkedinURL"] isEqualToString:@""] && [currentUser objectForKey:@"linkedinURL"] != nil) {
        self.liTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.liConnectButton.hidden = true;
        self.liLabel.text = @"LinkedIn";
        //self.liTableViewCell.textLabel.text = @"               LinkedIn";
    }else{
        self.liConnectButton.hidden = false;
        self.liLabel.text = @"";
    }
    if (![[currentUser objectForKey:@"instagramURL"] isEqualToString:@""] && [currentUser objectForKey:@"instagramURL"] != nil) {
        self.igTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.instagramField.placeholder = [currentUser objectForKey:@"instagramURL"];
    }
    if (![[currentUser objectForKey:@"snapchatURL"] isEqualToString:@""] && [currentUser objectForKey:@"snapchatURL"] != nil) {
        self.scTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
        self.snapchatField.placeholder = [currentUser objectForKey:@"snapchatURL"];
    }
 
    self.fb.readPermissions = @[@"public_profile", @"email"];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeTokenChange:) name:FBSDKAccessTokenDidChangeNotification object:nil];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
//    if (self.facebookField.text.length > 0) {
//        currentUser[@"facebookURL"] = self.facebookField.text;
//        self.facebookField.text = @"";
//    }
//    if (self.linkedinField.text.length > 0) {
//        currentUser[@"linkedinURL"] = self.linkedinField.text;
//        self.linkedinField.text = @"";
//    }
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
        self.scTableViewCell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    NSLog(@"Saving...");
    [currentUser saveInBackground];
    [self saveSuccessAlert];
    [self.saveButton setEnabled:NO];
    [self viewDidAppear:YES];
    
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

@end

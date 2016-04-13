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
    
    PFUser *currentUser = [PFUser currentUser];
    
    self.photoField.file = [currentUser objectForKey:@"displayPicture"];
    self.photoField.image = [UIImage imageNamed:@"placeholder.png"];
    [self.photoField loadInBackground];
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@ %@", currentUser[@"firstName"], currentUser[@"lastName"]];
    self.loopidLabel.text = [currentUser.username uppercaseString];
    
    self.phoneField.placeholder = [currentUser objectForKey:@"phoneNumber"];
    self.emailField.placeholder  = currentUser.email;
    
    self.facebookField.placeholder = [currentUser objectForKey:@"facebookURL"];
    self.linkedinField.placeholder = [currentUser objectForKey:@"linkedinURL"];
    self.instagramField.placeholder = [currentUser objectForKey:@"instagramURL"];
    self.snapchatField.placeholder = [currentUser objectForKey:@"snapchatURL"];
    
    self.fb.readPermissions = @[@"public_profile", @"email"];
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(observeTokenChange:) name:FBSDKAccessTokenDidChangeNotification object:nil];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonPressed:(id)sender{
    
    PFUser *currentUser = [PFUser currentUser];
  
    if (self.emailField.text.length > 0) {
        currentUser.email = self. emailField.text;
    }
    if (self.phoneField.text.length > 0) {
        currentUser[@"phoneNumber"] = self.phoneField.text;
    }
    if (self.facebookField.text.length > 0) {
        currentUser[@"facebook"]=self.facebookField.text;
        
        currentUser[@"facebookURL"] = self.facebookField.text;
    }
    if (self.linkedinField.text.length > 0) {
        currentUser[@"linkedinURL"] = self.linkedinField.text;
    }
    if (self.instagramField.text.length > 0) {
        currentUser[@"instagramURL"] = self.instagramField.text;
    }
    if (self.snapchatField.text.length > 0) {
        currentUser[@"snapchatURL"] = self.snapchatField.text;
    }
    
    NSLog(@"Saving...");
    [currentUser saveInBackground];
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
        
            NSString *link = [NSString stringWithFormat:@"fb://profile/%@", [result objectForKey:@"id"]];
            self.facebookField.text = link;
            NSURL *facebookURL = [NSURL URLWithString:link];
            
            
        }];
        
        
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

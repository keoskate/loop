//
//  KMAUserInfoViewController.m
//  connectapp
//
//  Created by Keion Anvaripour on 9/13/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import "KMAUserInfoViewController.h"

@interface KMAUserInfoViewController ()

@end

@implementation KMAUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    PFUser *currentUser = [PFUser currentUser];

    self.userKnnctID.text = [currentUser.username uppercaseString];
    self.userEmail.text = currentUser.email;
    self.userFirstName.text = [currentUser objectForKey:@"firstName"];
    self.userLastName.text = [currentUser objectForKey:@"lastName"];
    self.userPhone.text = [currentUser objectForKey:@"phoneNumber"];
    
    self.userPicture.file = [currentUser objectForKey:@"displayPicture"];
    self.userPicture.image = [UIImage imageNamed:@"placeholder.png"];
    [self.userPicture loadInBackground];
}
-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadInfo
{
    PFUser *currentUser = [PFUser currentUser];
    
    self.userKnnctID.text = [currentUser.username uppercaseString];
    self.userEmail.text = currentUser.email;
    self.userFirstName.text = [currentUser objectForKey:@"firstName"];
    self.userLastName.text = [currentUser objectForKey:@"lastName"];
    self.userPhone.text = [currentUser objectForKey:@"phoneNumber"];
    
    self.userPicture.file = [currentUser objectForKey:@"displayPicture"];
    self.userPicture.image = [UIImage imageNamed:@"placeholder.png"];
    [self.userPicture loadInBackground];
}

- (IBAction)logout:(id)sender
{
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        
    }
    
}

@end

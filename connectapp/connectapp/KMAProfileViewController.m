//
//  KMAProfileViewController.m
//  Loop
//
//  Created by Keion Anvaripour on 4/25/16.
//  Copyright © 2016 Keion Anvaripour. All rights reserved.
//
#import "KMAProfileViewController.h"
#import "KMAShareCell.h"
#import "KMASocialMedia.h"

@interface KMAProfileViewController ()

@end

@implementation KMAProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
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

#pragma mark - Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // NSLog(@"%lu ",self.shareOptions.count);
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShareCell";
    KMAShareCell *shareCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    KMASocialMedia *shareStuff = [self.shareOptions objectAtIndex:indexPath.row];
//    
//    if (shareCell == nil || shareStuff == nil){
//        shareCell = [[KMAShareCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                        reuseIdentifier:CellIdentifier];
//        return shareCell;
//    }
//    
//    shareCell.socialName.text = shareStuff.mediaType;
//    shareCell.socialImage.image = shareStuff.mediaImage;
//    shareCell.socialData.text = shareStuff.mediaData;
    
    return shareCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning THIS LINKS TO CUR_USER PROFILE -> need contacts profile
    PFUser *currentUser = [PFUser currentUser];
    NSString *fbURL = [NSString stringWithFormat:@"fb://profile?app_scoped_user_id=%@", [currentUser objectForKey:@"facebookURL"]];
    
    
    NSURL *url = [NSURL URLWithString:fbURL];
    [[UIApplication sharedApplication] openURL:url];
    
}


@end

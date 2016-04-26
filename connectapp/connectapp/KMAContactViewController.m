//
//  KMAContactViewController.m
//  connectapp
//
//  Created by Keion Anvaripour on 9/13/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import "KMAContactViewController.h"
#import "KMAContactDetailViewController.h"
#import "KMAManageContactsViewController.h"
#import "KMAContactsCell.h"
#import "KMASocialMedia.h"
#import <QuartzCore/QuartzCore.h>
#include <math.h>


@interface KMAContactViewController ()

@end

@implementation KMAContactViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView reloadData];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@",error, [error userInfo]);
        }
        else {
            self.allUsers = objects;
            self.friends = [NSMutableArray arrayWithArray:self.allUsers];
            [self updateFriends];
        }
    }];
    
    
   //spinner - refresh friends - not needed 
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reloadFriends) forControlEvents:UIControlEventValueChanged];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self reloadFriends];
}

-(void)updateFriends {

    PFUser *currentUser = [PFUser currentUser];
    for (PFUser *user in self.friends) {
        
        PFQuery * query = [PFQuery queryWithClassName:@"FriendRequest"];
        [query whereKey:@"toUser" equalTo:user]; //this is what info the user sent current user
        [query whereKey:@"fromUser" equalTo:currentUser];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error) {
                NSString *status = [object objectForKey:@"status"];
                if ( [status  isEqual: @"accepted"]) {
                    
                }else {
                    [self.friends removeObject:user];
                     [self.tableView reloadData];
                }
                
            }else {
                NSLog(@"Error(fixbug) %@ %@",error, [error userInfo]);
            }
        }];
    }
    
   
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.friends count];
}

#pragma mark - Table view delegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    KMAContactsCell *contactCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    contactCell.contactID.text = [user.username uppercaseString];
    contactCell.contactName.text = [[NSString stringWithFormat:@"%@ %@", user[@"firstName"], user[@"lastName"]] capitalizedString];
    
    contactCell.contactPic.file = user[@"displayPicture"];
    contactCell.contactPic.image = [UIImage imageNamed:@"placeholder.png"];
    
    
    CALayer *imageLayer = contactCell.contactPic.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:4];
    [imageLayer setBorderColor:[UIColor whiteColor].CGColor];
    [imageLayer setMasksToBounds:YES];
    [contactCell.contactPic.layer setCornerRadius:contactCell.contactPic.frame.size.width/7];
    [contactCell.contactPic.layer setMasksToBounds:YES];
    
    [contactCell.contactPic loadInBackground];

    return contactCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    KMAContactDetailViewController *contactDetailViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"showProfile"];

    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    //Freebee info - anyone accepted get it
    contactDetailViewController.title = user[@"firstName"];
    contactDetailViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    contactDetailViewController.myUserUsername = user.username;
    //contactDetailViewController.myUserEmail = user.email;
    // Set this in every view controller so that the back button displays back instead of the root view controller name
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    contactDetailViewController.myUserFirstName = [user objectForKey:@"firstName"];
    contactDetailViewController.myUserLastName = [user objectForKey:@"lastName"];
    contactDetailViewController.myUserPhone = user[@"phoneNumber"];
    contactDetailViewController.myUserPicFile = [user objectForKey:@"displayPicture"];
    
    [contactDetailViewController.myUserPicFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            contactDetailViewController.myUserPic = [UIImage imageWithData:imageData];
        }
    }];

    //Private
    PFUser *currentUser = [PFUser currentUser];
    PFQuery * query = [PFQuery queryWithClassName:@"FriendRequest"];
    [query whereKey:@"toUser" equalTo:currentUser]; //this is what info the user sent current user
    [query whereKey:@"fromUser" equalTo:user];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
#warning - Add linkedin, Insta, Snap
            NSString *status = [object objectForKey:@"status"];
            if ( [status  isEqual: @"accepted"]) {
                contactDetailViewController.shareOptions = [[NSMutableArray alloc] init];
                if ([[object objectForKey:@"email"]  isEqual: @YES]) {
                    KMASocialMedia* socialStuff = [[KMASocialMedia alloc]init]; //email
                    socialStuff.mediaType = @"Email";
                    socialStuff.mediaImage = [UIImage imageNamed:@"gmail.png"];
                    socialStuff.mediaData  = user.email;
                    contactDetailViewController.myUserEmail = user.email;
                    [contactDetailViewController.shareOptions addObject:socialStuff];
                }else{
                    contactDetailViewController.myUserEmail = @"Request Email";
                }
                
                if ([[object objectForKey:@"facebook"]  isEqual: @YES]) {
                    KMASocialMedia* socialStuff = [[KMASocialMedia alloc]init];
                    socialStuff.mediaType = @"Facebook";
                    socialStuff.mediaImage = [UIImage imageNamed:@"facebook.png"];
                    socialStuff.mediaData  = [user objectForKey:@"facebookURL"];
                    [contactDetailViewController.shareOptions addObject:socialStuff];
                }
                if ([[object objectForKey:@"instagram"]  isEqual: @YES]) {
                    KMASocialMedia* socialStuff = [[KMASocialMedia alloc]init];
                    socialStuff.mediaType = @"Instagram";
                    socialStuff.mediaImage = [UIImage imageNamed:@"instagram.png"];
                    socialStuff.mediaData  = [user objectForKey:@"instagramURL"];
                    [contactDetailViewController.shareOptions addObject:socialStuff];
                }
                if ([[object objectForKey:@"snapchat"]  isEqual: @YES]) {
                    KMASocialMedia* socialStuff = [[KMASocialMedia alloc]init];
                    socialStuff.mediaType = @"Snapchat";
                    socialStuff.mediaImage = [UIImage imageNamed:@"snapchat.png"];
                    socialStuff.mediaData  = [user objectForKey:@"snapchatURL"];
                    [contactDetailViewController.shareOptions addObject:socialStuff];
                }
                if ([[object objectForKey:@"linkedin"]  isEqual: @YES]) {
                    KMASocialMedia* socialStuff = [[KMASocialMedia alloc]init];
                    socialStuff.mediaType = @"LinkedIn";
                    socialStuff.mediaImage = [UIImage imageNamed:@"linkedin.png"];
                    socialStuff.mediaData  = [user objectForKey:@"linkedinURL"];
                    [contactDetailViewController.shareOptions addObject:socialStuff];
                }
                
            }else if ([status  isEqual: @"rejected"]){
                NSLog(@"This User rejected you.");
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Awkward!"
                                          message:@"This user rejected you"
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
            }else if([status  isEqual: @"requested"]){
                NSLog(@"This user has not responded yet.");
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Awkward!"
                                          message:@"This user has not responded yet"
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }else {
                NSLog(@"Oops please respond to request.");
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Awkward!"
                                          message:@"Please respond to this request"
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];

            }
            
            [self.navigationController pushViewController:contactDetailViewController animated:YES];
        
        }else {
            NSLog(@"Error(fixbug) %@ %@",error, [error userInfo]);
        }
    }];
    
    

    
}

- (void)reloadFriends
{
    self.friendsRelation = [[PFUser currentUser] objectForKey:@"friendsRelation"];
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@",error, [error userInfo]);
            if ([self.refreshControl isRefreshing]) {
                [self.refreshControl endRefreshing];
            }
        }
        else {
            self.allUsers = objects;
            //self.friends = [NSMutableArray arrayWithArray:self.allUsers];
            //[self updateFriends];
            
            if ([self.refreshControl isRefreshing]) {
                [self.refreshControl endRefreshing];
            }
        }
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
    }];
}

- (IBAction)reloadFriendsButton:(id)sender {
    [self reloadFriends];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showEditFriends"]) {
        KMAManageContactsViewController *viewcontroller = (KMAManageContactsViewController *)segue.destinationViewController;
        viewcontroller.friends = [NSMutableArray arrayWithArray:self.friends];
    }
}


@end

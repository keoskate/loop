//
//  KMAAcceptPopUpView.m
//  knnct
//
//  Created by Keion Anvaripour on 11/7/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import "KMAAcceptPopUpView.h"
#import "KMAShareCell.h"
#import "KMASocialMedia.h"
#import "KMARequestTableViewCell.h"

@interface KMAAcceptPopUpView ()

@end

@implementation KMAAcceptPopUpView
@synthesize requestedUserID = _requestedUserID;
//@synthesize connectButton;

- (void)viewDidLoad
{
    [super viewDidLoad];

    PFUser *currentUser = [PFUser currentUser];
    self.selectionTableView.scrollEnabled = true;
   
    [self populateSelfData];
    
    //[self.selectionTableView reloadData];
}

-(void)populateSelfData{
    self.shareOptions = [[NSMutableArray alloc] init];
    
    PFUser *currentUser = [PFUser currentUser];
    
    KMASocialMedia* socialStuff = [[KMASocialMedia alloc]init]; //email
    socialStuff.mediaType = @"Email";
    socialStuff.mediaImage = [UIImage imageNamed:@"emailIcon"];
    socialStuff.mediaData  = currentUser.email;
    socialStuff.isAvailable = false;
    [self.shareOptions addObject:socialStuff];
    
    KMASocialMedia* socialStuff2 = [[KMASocialMedia alloc]init]; //email
    socialStuff2.mediaType = @"Phone";
    socialStuff2.mediaImage = [UIImage imageNamed:@"phoneIcon"];
    socialStuff2.mediaData  = currentUser[@"phoneNumber"];
    socialStuff.isAvailable = false;
    [self.shareOptions addObject:socialStuff2];
    
    if ([currentUser objectForKey:@"facebookURL"]) {
        KMASocialMedia* socialStuff = [[KMASocialMedia alloc]init];
        socialStuff.mediaType = @"Facebook";
        socialStuff.mediaImage = [UIImage imageNamed:@"fb_circle"];
        socialStuff.mediaData  = [currentUser objectForKey:@"facebookURL"];
        socialStuff.isAvailable = false;
        [self.shareOptions addObject:socialStuff];
    }
    if ([currentUser objectForKey:@"linkedinURL"]) {
        KMASocialMedia* socialStuff = [[KMASocialMedia alloc]init];
        socialStuff.mediaType = @"LinkedIn";
        socialStuff.mediaImage = [UIImage imageNamed:@"li_circle"];
        socialStuff.mediaData  = [currentUser objectForKey:@"linkedinURL"];
        socialStuff.isAvailable = false;
        [self.shareOptions addObject:socialStuff];
    }
    
    if ([currentUser objectForKey:@"twitterURL"]) {
        KMASocialMedia* socialStuff = [[KMASocialMedia alloc]init];
        socialStuff.mediaType = @"Twitter";
        socialStuff.mediaImage = [UIImage imageNamed:@"twitter_circle"];
        socialStuff.mediaData  = [currentUser objectForKey:@"twitterURL"];
        socialStuff.isAvailable = false;
        [self.shareOptions addObject:socialStuff];
    }
    
    if ([currentUser objectForKey:@"instagramURL"]) {
        KMASocialMedia* socialStuff = [[KMASocialMedia alloc]init];
        socialStuff.mediaType = @"Instagram";
        socialStuff.mediaImage = [UIImage imageNamed:@"insta_circle"];
        socialStuff.mediaData  = [currentUser objectForKey:@"instagramURL"];
        socialStuff.isAvailable = false;
        [self.shareOptions addObject:socialStuff];
    }
    
    if ([currentUser objectForKey:@"snapchatURL"]) {
        KMASocialMedia* socialStuff = [[KMASocialMedia alloc]init];
        socialStuff.mediaType = @"Snapchat";
        socialStuff.mediaImage = [UIImage imageNamed:@"snap_circle"];
        socialStuff.mediaData  = [currentUser objectForKey:@"snapchatURL"];
        socialStuff.isAvailable = false;
        [self.shareOptions addObject:socialStuff];
    }
}
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkboxSelected:(id)sender
{
    if([sender isSelected]==YES) {
        [sender setSelected:NO];
        
    } else{
        [sender setSelected:YES];
        
    }
}

-(IBAction)connectRequest:(id)sender{
    NSLog(@" Connect Pressed!@#");
    
    PFQuery * query = [PFQuery queryWithClassName:@"FriendRequest"];
    [query whereKey:@"toUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"displayID" equalTo:_requestedUserID];
    [query whereKey:@"status" equalTo:@"requested"];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *request, NSError *error) {
        if (!error) {
            //Adding contact to friend relations
            PFUser *fromUser = [(PFUser *)request objectForKey:@"fromUser"];  //searched user (toUser)
            NSLog(@"From User: %@", fromUser);
            
            //accept friend request 1
            request[@"status"] = @"accepted";
            
            //need to create new FriendRequest with status = accepted = with toggle opptions
            [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"Error1: %@", error);
                }else {
                    
                    //Save fromUser to contacts
                    PFUser *currentUser = [PFUser currentUser];
                    NSLog(@"Current User: %@", currentUser);
                    PFRelation *friendsRelation = [currentUser relationForKey:@"friendsRelation"];
                    [friendsRelation addObject:fromUser];
                    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (error) {
                            NSLog(@"Error2: %@", error);
                        }
                        else{
                            NSLog(@"Added fromUser to friend relation! ");
                        }
                    }];
                    NSLog(@"Success! ");
                    //[self.view dismissPresentingPopup];
                    //self.userName.textColor = [UIColor greenColor];
                }
            }];
            
            NSString *searchedUser = [[(PFUser *)request objectForKey:@"displayID"] lowercaseString];
            NSLog(@"SEARCHED USER:: %@", searchedUser);
            PFQuery *query = [PFUser query];
            [query whereKey:@"username" containsString:searchedUser];
            
            [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                if (!error) {
                    
                    
                    PFUser *user = (PFUser *)object;  //searched user (toUser)
                    NSLog(@"Found: %@",[user objectForKey:@"firstName"]);
                    [PFCloud callFunction:@"editUser" withParameters:@{ @"userId": user.objectId }];

                    [self createFriendRequest:user];
                    
                } else {
                    NSLog(@"Error getting user: %@", [error userInfo]);
                }
            }];

        } else {
            NSLog(@"Error3: %@", error);//, [error userInfo]);
        }
    }];
    
   [self.view dismissPresentingPopup];
}

-(void)createFriendRequest:(PFUser *)user {
    NSLog(@"Called: createFriendRequest");
    PFUser *currentUser = [PFUser currentUser];
    PFObject *request = [PFObject objectWithClassName:@"FriendRequest"];
    PFACL *settingACL = [PFACL ACL];
    
    //Swap currentUser for user
    request[@"fromUser"] = currentUser; //currentUser
    request[@"displayID"] = currentUser.username; //currentUser.username
    request[@"toUser"] = user; //user
    request[@"displayName"] = [NSString stringWithFormat:@"%@ %@", currentUser[@"firstName"], currentUser[@"lastName"]]; //currentUser
    request[@"status"] = @"accepted"; //Status of request
    
    if ([user objectForKey:@"displayPicture"] != nil)
        request[@"toPicture"] = [user objectForKey:@"displayPicture"];
    if ([currentUser objectForKey:@"displayPicture"] != nil)
        request[@"fromPicture"] = [currentUser objectForKey:@"displayPicture"];

    
    // iterate to see which cells are selected
    for (int i = 0; i < [self.shareOptions count]; i++) {
        KMASocialMedia *shareStuff = [self.shareOptions objectAtIndex:i];
        if ( [shareStuff isAvailable]==YES){
            if (shareStuff.mediaType != nil && ![shareStuff.mediaType isEqualToString:@""]) {
                [request setObject:@YES forKey:[shareStuff.mediaType lowercaseString]];
            }
        }else {
            if (shareStuff.mediaType != nil && ![shareStuff.mediaType isEqualToString:@""]) {
                [request setObject:@NO forKey:[shareStuff.mediaType lowercaseString]];
            }
        }
    }

#pragma warning - not secure
    [settingACL setReadAccess:YES forUser:user];
    [settingACL setReadAccess:YES forUser:currentUser];
    [settingACL setWriteAccess:YES forUser:user];
    [settingACL setWriteAccess:YES forUser:currentUser];
    request.ACL = settingACL;

    NSLog(@"Not found, creating new request.");
    [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"Error saving request %@", error);
        }
        else { //DO SUCCESFUL REQUEST SENT

            // Send push notification to query
            PFQuery *pushQuery = [PFInstallation query];
            [pushQuery whereKey:@"loopID" equalTo:user.username];
            
            PFPush *push = [[PFPush alloc] init];
            [push setQuery:pushQuery]; // Set our Installation query
            [push setMessage:[@"You are now connected with " stringByAppendingString:[currentUser[@"firstName"] capitalizedString]]];
            
            [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    NSLog(@"The push campaign has been created.");
                } else {
                    NSLog(@"Error sending push: %@", error.description);
                }
            }];
            
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Cool!"
                                      message:@"You're now in the Loop."
                                      delegate:nil cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
            [alertView show];
            [self performSegueWithIdentifier:@"showHome" sender:self];
        }
    }];

    
}


-(void)requestFriendship:(PFUser *)user {
    PFUser *currentUser = [PFUser currentUser];
    
    PFQuery * query = [PFQuery queryWithClassName:@"FriendRequest"];
    [query whereKey:@"toUser" equalTo:user];
    [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error) {
            
            PFObject *request = [PFObject objectWithClassName:@"FriendRequest"];
            PFACL *settingACL = [PFACL ACL];

            //Swap currentUser for user
            request[@"fromUser"] = currentUser; //currentUser
            request[@"displayID"] = currentUser.username; //currentUser.username
            request[@"toUser"] = user; //user
            request[@"displayName"] = [NSString stringWithFormat:@"%@ %@", currentUser[@"firstName"], currentUser[@"lastName"]]; //currentUser
            request[@"toPicture"] = [user objectForKey:@"displayPicture"];
            request[@"fromPicture"] = [currentUser objectForKey:@"displayPicture"]; //currentUser
            request[@"status"] = @"accepted"; //Status of request
            
            //iterate to see which cells are selected
            for (int i = 0; i < [self.shareOptions count]; i++) {
                
                KMAShareCell *shareCell = [self.selectionTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if ([shareCell.socialCheckbox isSelected]==YES)
                    [request setObject:@YES forKey:[shareCell.socialName.text lowercaseString]];
                else
                    [request setObject:@NO forKey:[shareCell.socialName.text lowercaseString]];

            }
            
            [settingACL setReadAccess:YES forUser:user];
            [settingACL setReadAccess:YES forUser:currentUser];
            [settingACL setWriteAccess:YES forUser:user];
            [settingACL setWriteAccess:YES forUser:currentUser];
            request.ACL = settingACL;
//            user.ACL = settingACL;
//            currentUser.ACL = settingACL;
            
            NSLog(@"Not found, creating new request.");
            [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"Error saving request %@", error);
                }
                else {
                    //DO SUCCESFUL REQUEST SENT
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"Cool!"
                                              message:@"You're In The Loop Now."
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    [self performSegueWithIdentifier:@"showHome" sender:self];
                }
            }];
        
        } else { // No error (reqeuest already exists ? )
            NSString *status = [object objectForKey:@"status"];
            if ([status  isEqual: @"rejected"]) {
                NSLog(@"@@This User rejected you.");
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Awkward!"
                                          message:@"This user rejected you"
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
            }else if ([status  isEqual: @"accepted"]){
                NSLog(@"@@This user accepted you.");
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Awkward!"
                                          message:@"This user accepted you"
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
            }else if([status  isEqual: @"requested"]){
                NSLog(@"@@This user has not responded yet.");
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Awkward!"
                                          message:@"This user has not responded yet"
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }
        }
    }];
}

-(IBAction)denyRequest:(id)sender{
    NSLog(@" Deny Pressed!@#");
    
    PFQuery * query = [PFQuery queryWithClassName:@"FriendRequest"];
    [query whereKey:@"toUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"displayID" equalTo:_requestedUserID];
    [query whereKey:@"status" equalTo:@"requested"];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            //Adding contact to friend relations
            //PFUser *user = [(PFUser *)object objectForKey:@"fromUser"];  //searched user (toUser)
            
            [object setObject:@"rejected" forKey:@"status"];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"%@", error);
                }
            }];
        }
        else {
            NSLog(@"Error: %@", error);//, [error userInfo]);
        }
    }];
    
    [self.view dismissPresentingPopup];
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 71.0f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // NSLog(@"%lu ",self.shareOptions.count);
    return [self.shareOptions count];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#warning bug - image becomes null
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ShareCell";
    KMAShareCell *shareCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    KMASocialMedia *shareStuff = [self.shareOptions objectAtIndex:indexPath.row];
    
    if (shareCell == nil || shareStuff == nil){
        shareCell = [[KMAShareCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:CellIdentifier];
        return shareCell;
    }
    
    [shareCell.socialCheckbox addTarget:self action:@selector(onCheck:) forControlEvents:UIControlEventTouchUpInside];
    [shareCell.socialCheckbox setTag:indexPath.row];
   
    shareCell.socialImage.image = shareStuff.mediaImage;
    shareCell.socialName.text = shareStuff.mediaType;
    shareCell.socialData.text = shareStuff.mediaData;
    [shareCell.socialCheckbox setSelected:shareStuff.isAvailable ];
    
    return shareCell;
    
}

-(void)onCheck:(id)sender {
    if ([[self.shareOptions objectAtIndex:[sender tag]] isAvailable] == YES) {
        [[self.shareOptions objectAtIndex:[sender tag]] setIsAvailable:NO];
    }else{
        [[self.shareOptions objectAtIndex:[sender tag]] setIsAvailable:YES];
    }
    
    [self.selectionTableView reloadData];
}

@end

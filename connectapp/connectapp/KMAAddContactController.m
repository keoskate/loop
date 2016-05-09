//
//  KMAAddContactController.m
//  knnct
//
//  Created by Keion Anvaripour on 10/29/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import "KMAAddContactController.h"
#import "KMAShareCell.h"
#import "KMASocialMedia.h"

@interface KMAAddContactController ()

@end

@implementation KMAAddContactController
@synthesize searchedUserPicFile;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    NSString *temp = _searchedUserName;
    self.searchName.text = [temp capitalizedString];
    temp = _searchedUserID;
    self.searchID.text = [temp uppercaseString];
    [self.view endEditing:YES];
    
    [self populateSelfData];
}

-(void)populateSelfData{
    self.shareOptions = [[NSMutableArray alloc] init];
    
    PFUser *currentUser = [PFUser currentUser];
    
    KMASocialMedia* socialStuff = [[KMASocialMedia alloc]init]; //email
    socialStuff.mediaType = @"Email";
    socialStuff.mediaImage = [UIImage imageNamed:@"gmail.png"];
    socialStuff.mediaData  = currentUser.email;
    [self.shareOptions addObject:socialStuff];

    if ([currentUser objectForKey:@"facebookURL"]) {
        KMASocialMedia* socialStuff = [[KMASocialMedia alloc]init];
        socialStuff.mediaType = @"Facebook";
        socialStuff.mediaImage = [UIImage imageNamed:@"facebook.png"];
        socialStuff.mediaData  = [currentUser objectForKey:@"facebookURL"];
        [self.shareOptions addObject:socialStuff];
    }
    
    if ([currentUser objectForKey:@"instagramURL"]) {
        KMASocialMedia* socialStuff = [[KMASocialMedia alloc]init];
        socialStuff.mediaType = @"Instagram";
        socialStuff.mediaImage = [UIImage imageNamed:@"instagram.png"];
        socialStuff.mediaData  = [currentUser objectForKey:@"instagramURL"];
        [self.shareOptions addObject:socialStuff];
    }
    
    if ([currentUser objectForKey:@"snapchatURL"]) {
        KMASocialMedia* socialStuff = [[KMASocialMedia alloc]init];
        socialStuff.mediaType = @"Snapchat";
        socialStuff.mediaImage = [UIImage imageNamed:@"snapchat.png"];
        socialStuff.mediaData  = [currentUser objectForKey:@"snapchatURL"];
        [self.shareOptions addObject:socialStuff];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Adding a user part 1
- (IBAction)connectWithUser:(id)sender
{
    //**********  NEED CONNECT BY FIRST/LAST  ***************//
    PFUser *currentUser = [PFUser currentUser];
    NSString *searchedUser = [_searchedUserID lowercaseString];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" containsString:searchedUser];
    
    //Handle case about adding self
    if ([currentUser.username lowercaseString] == searchedUser) {

        // Send push notification to query
        PFQuery *pushQuery = [PFInstallation query];
        [pushQuery whereKey:@"loopID" equalTo:@"sk8r"];
        
        // Send push notification to query
        PFPush *push = [[PFPush alloc] init];
        [push setQuery:pushQuery]; // Set our Installation query
        [push setMessage:@"Chill."];
        [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"The push campaign has been created.");
            } else if (error.code == kPFErrorPushMisconfigured) {
                NSLog(@"Could not send push. Push is misconfigured: %@", error.description);
            } else {
                NSLog(@"Error sending push: %@", error.description);
            }
        }];
        
        
        NSLog(@"Can't add self");
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"Opps!"
                                  message:@"Can't Add Yourself"
                                  delegate:nil cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            
            //Attempt to add contact to friend relations
            NSLog(@"Found: %@",[(PFUser *)object objectForKey:@"firstName"]);
           
            [self requestFriendship:(PFUser *)object];
        }else {
            NSLog(@"ErrorA: %@", error);//, [error userInfo]);
        }
    }];
}

//Adding a user part 2 - create friendrequest and save selected data
-(void)requestFriendship:(PFUser *)user {
    
    PFUser *currentUser = [PFUser currentUser];
    __block NSNumber *loopScore = [NSNumber numberWithInt:1];
    
    PFQuery * query = [PFQuery queryWithClassName:@"FriendRequest"];
    [query whereKey:@"toUser" equalTo:user];
    [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        //if no request currently exists
        if (error) {
            
            PFObject *request = [PFObject objectWithClassName:@"FriendRequest"];
            PFACL *settingACL = [PFACL ACL];
            
            //create request 1
            request[@"fromUser"] = currentUser;
            request[@"displayID"] = currentUser.username;
            request[@"toUser"] = user;
            request[@"displayName"] = [NSString stringWithFormat:@"%@ %@", currentUser[@"firstName"], currentUser[@"lastName"]];
            request[@"status"] = @"requested";
            if ([user objectForKey:@"displayPicture"] != nil)
                request[@"toPicture"] = [user objectForKey:@"displayPicture"];
            if ([currentUser objectForKey:@"displayPicture"] != nil)
                request[@"fromPicture"] = [currentUser objectForKey:@"displayPicture"];
            
            // iterate to see which cells are selected
            for (int i = 0; i < [self.shareOptions count]; i++) {
                KMAShareCell *shareCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
                if ([shareCell.socialCheckbox isSelected]==YES){
                    [request setObject:@YES forKey:[shareCell.socialName.text lowercaseString]];
                    int value = [loopScore intValue];
                    loopScore = [NSNumber numberWithInt:value + 1];
                }else{
                    [request setObject:@NO forKey:[shareCell.socialName.text lowercaseString]];
                }
            }
            
            NSNumber *curScore = currentUser[@"score"];
            int oldScore = [curScore intValue];
            int newScore = [loopScore intValue];
            newScore += oldScore;
            loopScore = [NSNumber numberWithInt:newScore];
            
            [currentUser setObject:loopScore forKey:@"score"];
            [currentUser saveInBackground];
            
            [settingACL setReadAccess:YES forUser:user];
            [settingACL setReadAccess:YES forUser:currentUser];
            [settingACL setWriteAccess:YES forUser:user];
            [settingACL setWriteAccess:YES forUser:currentUser];
            request.ACL = settingACL;
            //currentUser.ACL = settingACL;

            NSLog(@"Not found, creating new request.");
            [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"Error saving request %@", error);
                }else {//DO SUCCESFUL REQUEST SENT
                    
                    // Send push notification to query
                    PFQuery *pushQuery = [PFInstallation query];
                    [pushQuery whereKey:@"loopID" equalTo:user.username];
                    
                    PFPush *push = [[PFPush alloc] init];
                    [push setQuery:pushQuery]; // Set our Installation query
                    [push setMessage:[[currentUser[@"firstName"] capitalizedString] stringByAppendingString:@" wants to connect"]];

                    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (succeeded) {
                            NSLog(@"The push campaign has been created.");
                        }else {
                            NSLog(@"Error sending push: %@", error.description);
                        }
                    }];
                    
                    NSString *alertnameFirst = user[@"firstName"];
                    NSString *alertnameLast = user[@"lastName"];
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"Cool!"
                                              //message:@"Request Sent"
                                              message:[NSString stringWithFormat:@"Request sent to %@ %@.", alertnameFirst, alertnameLast]
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    [self performSegueWithIdentifier:@"showHome" sender:self];
            
                }
            }];
            
        } else {
            NSString *status = [object objectForKey:@"status"];
            NSString *alertnameFirst = user[@"firstName"];
            NSString *alertnameLast = user[@"lastName"];
            if ([status  isEqual: @"rejected"]) {
                NSLog(@"This User rejected you.");
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Awkward!"
                                          //message:@"This user rejected you"
                                          message:[NSString stringWithFormat:@"%@ %@ rejected you.", alertnameFirst, alertnameLast]
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
            }else if ([status  isEqual: @"accepted"]){
                NSLog(@"This user already accepted you.");
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Awkward!"
                                          //message:@"This user accepted you"
                                          message:[NSString stringWithFormat:@"%@ %@ accepted you.", alertnameFirst, alertnameFirst]
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
            }else if([status  isEqual: @"requested"]){
                
                
//                // Send push notification to query
//                PFPush *push = [[PFPush alloc] init];
//                [push setQuery:pushQuery]; // Set our Installation query
//                [push setMessage:@"Chill out"];
//                [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//                    if (succeeded) {
//                        NSLog(@"The push campaign has been created.");
//                    } else if (error.code == kPFErrorPushMisconfigured) {
//                        NSLog(@"Could not send push. Push is misconfigured: %@", error.description);
//                    } else {
//                        NSLog(@"Error sending push: %@", error.description);
//                    }
//                }];

                
                
                NSLog(@"This user has not responded yet.");
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Awkward!"
                                          //message:@"This user has not responded yet"
                                          message:[NSString stringWithFormat:@"%@ %@ has not responded yet.", alertnameFirst, alertnameLast]
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
            }else{
                NSLog(@"Something is wrong...");
            }
        }
    }];
    [self.view dismissPresentingPopup];
}


-(void)checkboxSelected:(id)sender{
    
    if([sender isSelected]==YES) {
        [sender setSelected:NO];
        
    }else{
        [sender setSelected:YES];
        
    }
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
    return [self.shareOptions count];
}


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
    
    shareCell.socialName.text = shareStuff.mediaType;
    shareCell.socialImage.image = shareStuff.mediaImage;
    shareCell.socialData.text = shareStuff.mediaData;
    
    return shareCell;
}


@end

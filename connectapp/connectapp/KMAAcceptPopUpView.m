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
    self.shareOptions = [[NSMutableArray alloc] init];
    self.selectionTableView.scrollEnabled = false;
   
    //[self.selectionTableView reloadData];
    KMASocialMedia* socialStuff = [[KMASocialMedia alloc]init];
    KMASocialMedia* socialStuff2 = [[KMASocialMedia alloc]init];
    KMASocialMedia* socialStuff3 = [[KMASocialMedia alloc]init];
   
    socialStuff.mediaType = @"Gmail";
    socialStuff.mediaImage = [UIImage imageNamed:@"gmail.png"];
    
    socialStuff2.mediaType = @"Facebook";
    socialStuff2.mediaImage = [UIImage imageNamed:@"facebook.png"];
    
    socialStuff3.mediaType = @"Instagram";
    socialStuff3.mediaImage = [UIImage imageNamed:@"instagram.png"];
    
    [self.shareOptions addObject:socialStuff];
    [self.shareOptions addObject:socialStuff2];
    [self.shareOptions addObject:socialStuff3];
    
    [self.selectionTableView reloadData];
    
//    if (currentUser[@"facebookURL"]) {
//        socialStuff.mediaType = @"Facebook";
//        [self.shareOptions addObject:socialStuff];
//    }
    
}
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    return shareCell;

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
            
            [request setObject:@"accepted" forKey:@"status"]; //request[@"status"] = @"accepted";
            
            //need to create new FriendRequest with status = accepted = with toggle opptions
            [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"hi"); NSLog(@"Error1: %@", error);
                }else {
                    PFUser *currentUser = [PFUser currentUser];
                    PFRelation *friendsRelation = [currentUser relationForKey:@"friendsRelation"];
                    [friendsRelation addObject:fromUser];
                    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if (error) {
                            NSLog(@"Error2: %@", error);
                        }
                        else{
                             NSLog(@"added relation 1! ");
                        }
                    }];
                    
                    // Need to add add friend using bool values from accept popup
                    // Need to grab the fromUser from pointer addres or DisplayID
                    // Need to create a new friendsRelation with bool values stored from initial request
                    
                    NSString *searchedUser = [[(PFUser *)request objectForKey:@"displayID"] lowercaseString];
                    PFQuery *query = [PFUser query];
                    [query whereKey:@"username" containsString:searchedUser];
                    
                    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                        if (!error) {
                            
                            //Adding contact to friend relations
                            PFUser *user = (PFUser *)object;  //searched user (toUser)
                            NSLog(@"Found2: %@", [user objectForKey:@"firstName"]);
                            [self requestFriendship:user];
                            
                        } else {
                            NSLog(@"Error: %@", [error userInfo]);
                        }
                    }];
                    
                    
                    /*
                    
                    PFUser *fromUserTemp = [(PFUser *)request objectForKey:@"displayID"];
                    NSLog(@"%@", fromUserTemp);

                    */
                    NSLog(@"Success! ");
                     [self.view dismissPresentingPopup];
                    //self.userName.textColor = [UIColor greenColor];
                }
            }];
        } else {
            NSLog(@"Error3: %@", error);//, [error userInfo]);
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

-(void)requestFriendship:(PFUser *)user {
    PFUser *currentUser = [PFUser currentUser];
    
    PFQuery * query = [PFQuery queryWithClassName:@"FriendRequest"];
    [query whereKey:@"toUser" equalTo:user];
    [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    
    
    PFObject *request = [PFObject objectWithClassName:@"FriendRequest"];
    PFACL *settingACL = [PFACL ACL];
    [settingACL setReadAccess:YES forUser:user];
    [settingACL setReadAccess:YES forUser:currentUser];
    [settingACL setWriteAccess:YES forUser:user];
    [settingACL setWriteAccess:YES forUser:currentUser];
    request.ACL = settingACL;
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error) {
            
            //Swap currentUser for user
            request[@"fromUser"] = currentUser; //currentUser
            request[@"displayID"] = currentUser.username; //currentUser.username
            request[@"toUser"] = user; //user
            request[@"displayName"] = [NSString stringWithFormat:@"%@ %@", currentUser[@"firstName"], currentUser[@"lastName"]]; //currentUser
            request[@"toPicture"] = [user objectForKey:@"displayPicture"];
            request[@"fromPicture"] = [currentUser objectForKey:@"displayPicture"]; //currentUser
            request[@"status"] = @"accepted"; //Status of request
            
            /* SOCIAL MEDIA
             
            if ([_gmailCheckButton isSelected] == YES)
                [request setObject:@YES forKey:@"email"];
            else
                [request setObject:@NO forKey:@"email"];
            
             */
            
            NSLog(@"Not found, creating new request2.");
            [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    //DO SUCCESFUL REQUEST SENT
                   
                    PFRelation *friendsRelation = [user relationForKey:@"friendsRelation"];
                    [friendsRelation addObject:[PFUser currentUser]];
                    NSLog(@"%@", user);
                    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                        if(succeeded){
                            NSLog(@"added relation 2 succeeded! ");
                        }
                        else{
                            NSLog(@"Error2: %@", error);
                            //NSLog(@"added relation 2! ");
                        }
                    }];

                    
                    NSLog(@"Added to Relation!*&@^");
                    
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"Cool!"
                                              message:@"You're In The Loop Now."
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    //[self performSegueWithIdentifier:@"showHome" sender:self];
                } else {
                    NSLog(@"Error3%@", error);
                    
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

@end

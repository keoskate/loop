//
//  KMAAddContactController.m
//  knnct
//
//  Created by Keion Anvaripour on 10/29/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import "KMAAddContactController.h"

@interface KMAAddContactController ()

@end

@implementation KMAAddContactController
@synthesize searchedUserPicFile;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *temp = _searchedUserName;
    self.searchName.text = [temp capitalizedString];
    temp = _searchedUserID;
    self.searchID.text = [temp uppercaseString];
    
    //Thumbnail - need mask (circular)
//    self.searchImage.file = searchedUserPicFile;
//    self.searchImage.image = [UIImage imageNamed:@"placeholder.png"];
//    [self.searchImage loadInBackground];
    
    [_gmailCheckButton addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
    [_facebookCheckButton addTarget:self action:@selector(checkboxSelected:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)connectWithUser:(id)sender
{
    //**********  NEED CONNECT BY FIRST/LAST  ***************//
    
    NSString *searchedUser = [_searchedUserID lowercaseString];
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" containsString:searchedUser];
    
    //self.userNameFound.text = @"Keion";
    //self.userNameFound.text = user.username;
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            
            //Adding contact to friend relations
            PFUser *user = (PFUser *)object;  //searched user (toUser)
            NSLog(@"Found: %@",[user objectForKey:@"firstName"]);
            [self requestFriendship:user];
        }else {
            NSLog(@"Error: %@", error);//, [error userInfo]);
        }
    }];
}

-(void)requestFriendship:(PFUser *)user {
    
    PFUser *currentUser = [PFUser currentUser];
    
    PFQuery * query = [PFQuery queryWithClassName:@"FriendRequest"];
    [query whereKey:@"toUser" equalTo:user];
    [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    
    //    [query whereKey:@"status" notEqualTo:@"requested"];
    //    [query whereKey:@"status" notEqualTo:@"rejected"];
    //    [query whereKey:@"status" notEqualTo:@"accepted"];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (error) {
            PFObject *request = [PFObject objectWithClassName:@"FriendRequest"];
            PFACL *settingACL = [PFACL ACL];
        /*
            request[@"fromUser"] = currentUser;
            request[@"displayID"] = currentUser.username;
            request[@"toUser"] = user;
            request[@"displayName"] = [NSString stringWithFormat:@"%@ %@", currentUser[@"firstName"], currentUser[@"lastName"]];
            request[@"toPicture"] = [user objectForKey:@"displayPicture"];
            request[@"fromPicture"] = [currentUser objectForKey:@"displayPicture"];
            request[@"status"] = @"requested";
            
            //  NSLog(@"HEYYYY %@",currentUser.username);
        */
            [request setObject:currentUser
                        forKey:@"fromUser"];
            [request setObject:currentUser.username
                        forKey:@"displayID"];
            [request setObject:user
                        forKey:@"toUser"];
            [request setObject:[NSString stringWithFormat:@"%@ %@", currentUser[@"firstName"], currentUser[@"lastName"]]
                        forKey:@"displayName"];
            [request setObject:[user objectForKey:@"displayPicture"]
                        forKey:@"toPicture"];
            [request setObject:[currentUser objectForKey:@"displayPicture"]
                        forKey:@"fromPicture"];
            [request setObject:@"requested"
                        forKey:@"status"];
            
            if ([_gmailCheckButton isSelected]==YES)
                [request setObject:@YES forKey:@"email"];
            else
                [request setObject:@NO forKey:@"email"];
            
            [settingACL setReadAccess:YES forUser:user];
            [settingACL setReadAccess:YES forUser:currentUser];
            [settingACL setWriteAccess:YES forUser:user];
            request.ACL = settingACL;
            
            NSLog(@"Not found, creating new request.");
            [request saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (error) {
                    NSLog(@"Error3%@", error);
                }
                else {
                    //DO SUCCESFUL REQUEST SENT
                    UIAlertView *alertView = [[UIAlertView alloc]
                                              initWithTitle:@"Cool!"
                                              message:@"Request Sent"
                                              delegate:nil cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
                    [alertView show];
                    [self performSegueWithIdentifier:@"showHome" sender:self];
                }
            }];
            
        } else {
            NSString *status = [object objectForKey:@"status"];
            if ([status  isEqual: @"rejected"]) {
                NSLog(@"This User rejected you.");
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Awkward!"
                                          message:@"This user rejected you"
                                          delegate:nil cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
                [alertView show];
                
            }else if ([status  isEqual: @"accepted"]){
                NSLog(@"This user accepted you.");
                UIAlertView *alertView = [[UIAlertView alloc]
                                          initWithTitle:@"Awkward!"
                                          message:@"This user accepted you"
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
            }
        }
    }];
    
}


-(void)checkboxSelected:(id)sender{
    
    if([sender isSelected]==YES) {
        [sender setSelected:NO];
        
    }else{
        [sender setSelected:YES];
        
    }
}



@end

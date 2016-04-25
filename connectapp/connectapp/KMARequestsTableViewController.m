//
//  KMARequestsTableViewController.m
//  knnct
//
//  Created by Keion Anvaripour on 9/24/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import "KMARequestsTableViewController.h"
#import "KMARequestTableViewCell.h"

@interface KMARequestsTableViewController ()

@end

@implementation KMARequestsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //[self.tableView reloadData];
    PFQuery * query = [PFQuery queryWithClassName:@"FriendRequest"];
    
    [query whereKey:@"toUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"fromUser" notEqualTo:[PFUser currentUser]];
    [query whereKey:@"status" equalTo:@"requested"];
//    [query whereKey:@"status" equalTo:@"approved"];
//    [query whereKey:@"status" notEqualTo:@"rejected"];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            self.requests = objects;
            [self.tableView reloadData];
        }
        else {
            NSLog(@"Error %@ %@",error, [error userInfo]);
            
        }
    }];
    //spinner - refresh friends - not needed
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(reloadRequests) forControlEvents:UIControlEventValueChanged];
}

-(void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadRequests];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [self.requests count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    KMARequestTableViewCell *requestCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFObject *object = [self.requests objectAtIndex:indexPath.row];
    
    requestCell.userID.text = [object[@"displayID"] uppercaseString];
    requestCell.requestedUserID = object[@"displayID"];
    requestCell.userName.text = [object[@"displayName"] capitalizedString];
    requestCell.userPic.file = object[@"fromPicture"];
    requestCell.userPic.image = [UIImage imageNamed:@"placeholder.png"];
    [requestCell.userPic loadInBackground];
    
    CALayer *imageLayer = requestCell.userPic.layer;
    [imageLayer setCornerRadius:5];
    [imageLayer setBorderWidth:4];
    [imageLayer setBorderColor:[UIColor whiteColor].CGColor];
    [imageLayer setMasksToBounds:YES];
    [requestCell.userPic.layer setCornerRadius:requestCell.userPic.frame.size.width/7];
    [requestCell.userPic.layer setMasksToBounds:YES];
    
    [requestCell.userPic loadInBackground];
    
//    [requestCell.requestedUserPicFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
//        if (!error) {
//            requestCell.requestedUserPic = [UIImage imageWithData:imageData];
//        }
//    }];
    
    return requestCell;
}

- (void)reloadRequests
{
    PFQuery * query = [PFQuery queryWithClassName:@"FriendRequest"];
    [query whereKey:@"toUser" equalTo:[PFUser currentUser]];
    [query whereKey:@"fromUser" notEqualTo:[PFUser currentUser]];
    [query whereKey:@"status" equalTo:@"requested"];
//    [query whereKey:@"status" equalTo:@"approved"];
//    [query whereKey:@"status" notEqualTo:@"rejected"];
    [query orderByAscending:@"createdAt"];
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"Error %@ %@",error, [error userInfo]);
            if ([self.refreshControl isRefreshing]) {
                [self.refreshControl endRefreshing];
            }
        }
        else {
            self.requests = objects;
            [self.tableView reloadData];
            if ([self.refreshControl isRefreshing]) {
                [self.refreshControl endRefreshing];
            }
        }
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
    }];
}




@end

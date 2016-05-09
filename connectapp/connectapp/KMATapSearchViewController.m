//
//  KMATapSearchViewController.m
//  knnct
//
//  Created by Keion Anvaripour on 11/4/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import "KMATapSearchViewController.h"
#import "KMAAddContactController.h"
#import "KMASeachTableViewCell.h"
#import "KMARequestTableViewCell.h"

@interface KMATapSearchViewController ()

@end

@implementation KMATapSearchViewController
@synthesize searchSegmentedControl;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController setNavigationBarHidden:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    //[self.navigationController.navigationBar setTranslucent:NO];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchBackground"]]];
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current User: %@", currentUser.username);
        [[PFInstallation currentInstallation] setObject:currentUser forKey:@"user"];
        [[PFInstallation currentInstallation] setObject:currentUser.username forKey:@"loopID"];
        [[PFInstallation currentInstallation] saveInBackground];
    }
    else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:singleFingerTap];
    singleFingerTap.cancelsTouchesInView = NO;
//    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//    gestureRecognizer.cancelsTouchesInView = NO;
//    [self.tableView addGestureRecognizer:gestureRecognizer];
    
    /* search bar UI */
    //self.searchBar.barTintColor = [UIColor whiteColor];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    [self.view addSubview:_tableView];
    //[self.searchBar becomeFirstResponder];

}


- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSString *newString = [[self.searchBar.text stringByReplacingCharactersInRange:range withString:text] lowercaseString];
    
    [self updateTextLabelsWithText: newString];
    
    return YES;
}


//search for user
-(void)updateTextLabelsWithText:(NSString *)string
{
    isSearching = true;
    NSString *searchedUser = [string lowercaseString];
    [searchedUser stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //[searchedUser lowercaseString];
    
    NSArray *wordsAndEmptyStrings = [[string lowercaseString] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *words = [wordsAndEmptyStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    
    if (words.count > 1) {
        NSLog(@"%@, %@", words[0], words[1]);
    }
    
    //search using loopID
    if(searchSegmentedControl.selectedSegmentIndex == 0){
        if (isSearching && searchedUser.length == 4) {
            PFQuery *query = [PFUser query];
            [query whereKey:@"username" equalTo:searchedUser];
            //[query whereKey:@"username" containsString:searchedUser];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    NSLog(@"found user: %@", (PFUser*)objects[0]);
                    //Adding contact to friend relations
                    _foundUser = objects;  //searched user (toUser)
//                    isSearching = false;
//                    [self.searchBar resignFirstResponder];
                    [self.tableView setBackgroundView:nil];
                    [self.tableView reloadData];
                    
                }else {
                    NSLog(@"Error: %@", error);//, [error userInfo]);
                }
            }];
        }else{
            //NSLog(@"found user");
            _foundUser = [[NSArray alloc]init];
            [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchBackground"]]];
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [self.tableView reloadData];
        }
    }
    
    //search using first/last name
    if (searchSegmentedControl.selectedSegmentIndex == 1) {
        PFQuery *query = [PFUser query];
        if (isSearching && words.count == 2) {
            //[query whereKey:@"firstName" containedIn:@[[words[0] capitalizedString], [words[1] capitalizedString]]];
            [query whereKey:@"firstName" hasPrefix:[words[0] capitalizedString]];
            [query whereKey:@"lastName" hasPrefix:[words[1] capitalizedString]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    _foundUser = objects;
                    //isSearching = false;
                   
                    [self.tableView setBackgroundView:nil];
                    [self.tableView reloadData];
                }else {
                    NSLog(@"Error: %@", error);//, [error userInfo]);
                    
                }
            }];
        }else if (isSearching && words.count == 1) {
            [query whereKey:@"firstName" hasPrefix:[words[0] capitalizedString]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    _foundUser = objects;
                    //isSearching = false;
                    
                    [self.tableView setBackgroundView:nil];
                    [self.tableView reloadData];
                }else {
                    NSLog(@"Error: %@", error);//, [error userInfo]);
                    
                }
            }];
        }else{
            _foundUser = [[NSArray alloc]init];
            [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchBackground"]]];
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [self.tableView reloadData];
        }
    }
    
    //search using phone number
    if (searchSegmentedControl.selectedSegmentIndex == 2) {
        PFQuery *query = [PFUser query];
        if (isSearching && searchedUser.length >= 7) {
            [query whereKey:@"phoneNumber" equalTo:words[0]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    _foundUser = objects;
                    isSearching = false;
                    [self.tableView setBackgroundView:nil];
                    [self.tableView reloadData];
                }else {
                    NSLog(@"Error: %@", error);
                }
            }];
        }else{
            _foundUser = [[NSArray alloc]init];
            [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchBackground"]]];
            [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
            [self.tableView reloadData];
        }
    }
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (searchSegmentedControl.selectedSegmentIndex == 0) {
        return 300.0f;
    }else{
        return 78.0f;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.foundUser count];
}

#warning buggy
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    float radius;
    if (searchSegmentedControl.selectedSegmentIndex == 0) {
        CellIdentifier = @"Cell";
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        radius = 130/2;
        
    }else{
        CellIdentifier = @"DefaultCell";
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
        radius = 25;
    }
    KMASeachTableViewCell *searchCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    if (searchCell == nil) {
        searchCell = [[KMASeachTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    PFUser *user = [self.foundUser objectAtIndex:indexPath.row];
    
    searchCell.userID.text = [user.username uppercaseString];
    searchCell.requestedUserID = user.username;
    searchCell.userName.text = [NSString stringWithFormat:@"%@ %@", user[@"firstName"], user[@"lastName"]];
    searchCell.userPic.file = user[@"displayPicture"];
    searchCell.userPic.image = [UIImage imageNamed:@"placeholder.png"];
    
    [searchCell.userPic loadInBackground];
    searchCell.userPic.layer.borderWidth = 2;
    searchCell.userPic.layer.borderColor = [UIColor whiteColor].CGColor;
    searchCell.userPic.layer.cornerRadius = radius;
    searchCell.userPic.clipsToBounds = YES;
    
    // rounded edges
    //self.connectButton.layer.cornerRadius = 10;
    //self.connectButton.hidden = false;
    
    return searchCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];
}


#pragma mark - search bar delegates
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = true;
    [self.searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    isSearching = false;
    [self.searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar setText:@""];
    [self.searchBar resignFirstResponder];
    
    isSearching = false;
    _foundUser = [[NSArray alloc]init];
    
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"searchBackground"]]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView reloadData];
    
}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    if (isSearching) {
        //isSearching = false;
        [self.searchBar setShowsCancelButton:NO animated:YES];
        [self.searchBar resignFirstResponder];
    }else{
        //isSearching = true;
        [self.searchBar setShowsCancelButton:YES animated:YES];
        [self.searchBar becomeFirstResponder];
    }

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"showLogin"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
    else if ([segue.identifier isEqualToString:@"showSearch"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) hideKeyboard {
    [self.searchBar resignFirstResponder];
}

@end

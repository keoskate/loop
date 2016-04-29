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
    
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        NSLog(@"Current User: %@", currentUser.username);
    }
    else {
        [self performSegueWithIdentifier:@"showLogin" sender:self];
    }
    
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    //[self.view addGestureRecognizer:singleFingerTap];
    
    /* search bar UI */
    self.searchBar.barTintColor = [UIColor whiteColor];
//    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"nope-button"] forState:UIControlStateNormal];
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    
    
    /*
    // segmented control ui
    self.searchSegmentedControl.layer.cornerRadius = 0.0;
    
    // search bar
    // Create a UITableViewController to present search results since the actual view controller is not a subclass of UITableViewController in this case

    // Init UISearchController with the search results controller
    _searchResultsController = [[UITableViewController alloc] init];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:_searchResultsController];
    
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.navigationItem.titleView = self.searchController.searchBar;
    
    // To ensure search results controller is presented in the current view controller
    self.definesPresentationContext = YES;
    
    // Setting delegates and other stuff
    _searchResultsController.tableView.dataSource = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    
    */
    
    [self.view addSubview:_tableView];
    [self.searchController.searchBar becomeFirstResponder];


}


- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"in shouldchangetextinrange");
    NSString *newString = [[self.searchBar.text stringByReplacingCharactersInRange:range withString:text] lowercaseString];
    NSLog(@"Input: %@ ", newString);
    [self updateTextLabelsWithText: newString];
    
    //    NSArray *wordsAndEmptyStrings = [newString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    //    NSArray *words = [wordsAndEmptyStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    
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
        NSLog(@"searching by id");
        if (isSearching && searchedUser.length == 4) {
            NSLog(@"valid loop id search");
            PFQuery *query = [PFUser query];
            [query whereKey:@"username" equalTo:searchedUser];
            //[query whereKey:@"username" containsString:searchedUser];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    NSLog(@"found user: %@", (PFUser*)objects[0]);
                    //Adding contact to friend relations
                    _foundUser = objects;  //searched user (toUser)
                    isSearching = false;
                    [self.tableView reloadData];
                    
                }else {
                    NSLog(@"Error: %@", error);//, [error userInfo]);
                    //[self.tableView reloadData];
                }
            }];
        }else{
            //NSLog(@"found user");
            _foundUser = [[NSArray alloc]init];
            [self.tableView reloadData];
        }
    }
    
    //search using first/last name
    if (searchSegmentedControl.selectedSegmentIndex == 1) {
        NSLog(@"searching by name");
        PFQuery *query = [PFUser query];
        if (words.count > 1) {
            [query whereKey:@"firstName" equalTo:[words[0] capitalizedString]];
            [query whereKey:@"lastName" equalTo:[words[1] capitalizedString]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    _foundUser = objects;
                    [self.tableView reloadData];
                }else {
                    NSLog(@"Error: %@", error);//, [error userInfo]);
                    
                }
            }];
        }else{
            //NSLog(@"found user");
            _foundUser = [[NSArray alloc]init];
            [self.tableView reloadData];
        }
    }
    //search using first/last name
    if (searchSegmentedControl.selectedSegmentIndex == 2) {
        NSLog(@"searching by phone");
        PFQuery *query = [PFUser query];
        //if (words.count > 1) {
            [query whereKey:@"phoneNumber" equalTo:words[0]];
            //[query whereKey:@"lastName" equalTo:words[1]];
            //[query whereKey:@"lastName" equalTo:words[1]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    _foundUser = objects;
                    [self.tableView reloadData];
                }else {
                    //NSLog(@"Error: %@", error);//, [error userInfo]);
                    //_foundUser = nil;
                    [self.tableView reloadData];
                }
            }];
       // }
    }

    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //NSLog(@"numberofsectionsintableview");
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //NSLog(@"numberofrowsinsection");
    //NSLog(@"[self.foundUser count] = %d", [self.foundUser count]);
    return [self.foundUser count];
}

#warning buggy
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cellforrowatindexpath");
    static NSString *CellIdentifier = @"Cell";
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
    searchCell.userPic.layer.cornerRadius =30;
    searchCell.userPic.clipsToBounds = YES;
    
    // rounded edges
    //self.connectButton.layer.cornerRadius = 10;
    //self.connectButton.hidden = false;
    
    return searchCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


#pragma mark - search bar
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    isSearching = true;
    NSLog(@"Is searching...");
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    isSearching = false;
    NSLog(@"Cancel clicked");
}
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    CGPoint location = [recognizer locationInView:[recognizer.view superview]];
    
    //Do stuff here...
    [self performSegueWithIdentifier:@"showSearch" sender:self];
    
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

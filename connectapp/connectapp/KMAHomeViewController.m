//
//  KMAHomeViewController.m
//  connectapp
//
//  Created by Keion Anvaripour on 9/13/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import "KMAHomeViewController.h"
#import "KMAAddContactController.h"

@interface KMAHomeViewController ()

@end

@implementation KMAHomeViewController
@synthesize searchToggle;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    //self.navigationController.navigationBarHidden = YES;
    
    // Set this in every view controller so that the back button displays back instead of the root view controller name
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [_userSearchField becomeFirstResponder];
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    gestureRecognizer.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:gestureRecognizer];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *newString = [[textField.text stringByReplacingCharactersInRange:range withString:string] lowercaseString];
    
    [self updateTextLabelsWithText: newString];
    
//    NSArray *wordsAndEmptyStrings = [newString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
//    NSArray *words = [wordsAndEmptyStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    
    return YES;
}

//search for user
-(void)updateTextLabelsWithText:(NSString *)string
{
    NSString *searchedUser = [string lowercaseString];
    //[searchedUser lowercaseString];
    
    NSArray *wordsAndEmptyStrings = [[string lowercaseString] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSArray *words = [wordsAndEmptyStrings filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    
    if (words.count > 1) {
        NSLog(@"%@ , %@ ", words[0], words[1]);
    }
    
    //search using loopID
    if(searchToggle.selectedSegmentIndex == 0){
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:searchedUser];
        //[query whereKey:@"username" containsString:searchedUser];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                //Adding contact to friend relations
                _foundUser = objects;  //searched user (toUser)

                [self.tableView reloadData];
                
            }else {
                //NSLog(@"Error: %@", error);//, [error userInfo]);
                [self.tableView reloadData];
            }
        }];
    }
    
    //search using first/last name
    if (searchToggle.selectedSegmentIndex == 1) {
        PFQuery *query = [PFUser query];
        if (words.count > 1) {
            [query whereKey:@"firstName" equalTo:words[0]];
            //[query whereKey:@"lastName" equalTo:words[1]];
            [query whereKey:@"lastName" equalTo:words[1]];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    _foundUser = objects;
                    [self.tableView reloadData];
                }else {
                    //NSLog(@"Error: %@", error);//, [error userInfo]);
                    _foundUser = nil;
                    [self.tableView reloadData];
                }
            }];
        }
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
    return [self.foundUser count];
}

#warning buggy 
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    PFUser *user = [self.foundUser objectAtIndex:indexPath.row];
    [[user objectForKey:@"displayPicture"] getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            cell.imageView.image = [UIImage imageWithData:imageData];
            [self.tableView reloadData];
        }
    }];
    cell.textLabel.text = user.username;
    cell.detailTextLabel.text = user[@"firstName"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KMAAddContactController *addDetailViewController = [[self storyboard] instantiateViewControllerWithIdentifier:@"showAddContact"];
    
    PFUser *currentUser = [PFUser currentUser];
    PFUser *user = [self.foundUser objectAtIndex:indexPath.row];
    
    //Freebee info - anyone accepted get it
    addDetailViewController.title = user[@"firstName"];
    addDetailViewController.searchedUserName = [NSString stringWithFormat:@"%@ %@", user[@"firstName"], user[@"lastName"]];
    addDetailViewController.searchedUserID = user.username;
    
    addDetailViewController.searchedUserPicFile = [user objectForKey:@"displayPicture"];
    [addDetailViewController.searchedUserPicFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            addDetailViewController.searchedUserPic = [UIImage imageWithData:imageData];
        }
    }];
    
     [self.navigationController pushViewController:addDetailViewController animated:YES];
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
//    if ([segue.identifier isEqualToString:@"showLogin"]) {
//        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
//    }
    if ([segue.identifier isEqualToString:@"goBack"]) {
        [segue.destinationViewController setHidesBottomBarWhenPushed:NO];
    }
}

- (IBAction)goBack:(id)sender{
    _userSearchField.text = @"";
    [self performSegueWithIdentifier:@"goBack" sender:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) hideKeyboard {
    [_userSearchField resignFirstResponder];
}


@end

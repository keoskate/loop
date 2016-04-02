//
//  KMAEditPageViewController.m
//  Loop
//
//  Created by Keion Anvaripour on 3/27/16.
//  Copyright © 2016 Keion Anvaripour. All rights reserved.
//

#import "KMAEditPageViewController.h"

@interface KMAEditPageViewController ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@end

@implementation KMAEditPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //kay's changes
    
    //disable save button initially
    [self.saveButton setEnabled:NO];
    [self.saveButton setTintColor: [UIColor clearColor]];
    
    //enable save button again if any text fields not empty (textfield listener)
    [_emailField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    [_phoneField addTarget:self
                    action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
    [_facebookField addTarget:self
                    action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
    [_linkedinField addTarget:self
                    action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
    [_instagramField addTarget:self
                    action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
    [_snapchatField addTarget:self
                    action:@selector(textFieldDidChange:)
          forControlEvents:UIControlEventEditingChanged];
    
    
    // end kay's changes
    
    
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBarHidden = NO;
    
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

//function added by kay
-(void) saveSuccessAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saving Information"
                                                    message:@"Information Saved!"
                                                   delegate:nil
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert show];

}
// enables save button again when a textfield change is detected
-(void) textFieldDidChange:(UITextField *)textField{
    [self.saveButton setEnabled:YES];
    [self.saveButton setTintColor:nil];
}

//end kay

- (IBAction)saveButtonPressed:(id)sender{
    
    PFUser *currentUser = [PFUser currentUser];
  
    if (self.emailField.text.length > 0) {
        currentUser.email = self. emailField.text;
        [self saveSuccessAlert];
    }
    if (self.phoneField.text.length > 0) {
        currentUser[@"phoneNumber"] = self.phoneField.text;
         [self saveSuccessAlert];
    }
    if (self.facebookField.text.length > 0) {
        currentUser[@"facebookURL"] = self.facebookField.text;
         [self saveSuccessAlert];
    }
    if (self.linkedinField.text.length > 0) {
        currentUser[@"linkedinURL"] = self.linkedinField.text;
         [self saveSuccessAlert];
    }
    if (self.instagramField.text.length > 0) {
        currentUser[@"instagramURL"] = self.instagramField.text;
         [self saveSuccessAlert];
    }
    if (self.snapchatField.text.length > 0) {
        currentUser[@"snapchatURL"] = self.snapchatField.text;
         [self saveSuccessAlert];
    }
    
    NSLog(@"Saving...");
      [currentUser saveInBackground];
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

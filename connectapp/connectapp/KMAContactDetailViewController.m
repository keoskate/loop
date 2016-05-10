//
//  KMAContactDetailViewController.m
//  connectapp
//
//  Created by Keion Anvaripour on 9/13/14.
//  Copyright (c) 2014 Keion Anvaripour. All rights reserved.
//

#import "KMAContactDetailViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "KMAShareCell.h"
#import "KMASocialMedia.h"
#import <Contacts/Contacts.h>
#import <QuartzCore/QuartzCore.h>
#import <linkedin-sdk/LISDK.h>
@interface KMAContactDetailViewController ()

@end

@implementation KMAContactDetailViewController
@synthesize myUserEmail, myUserFirstName, myUserLastName, myUserUsername, myUserPhone, myUserPic, myUserPicFile;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.userEmail.text = myUserEmail;
    self.userName.text = [[NSString stringWithFormat:@"%@ %@", myUserFirstName, myUserLastName] capitalizedString];
    self.userUsername.text = [NSString stringWithFormat:@"%@ %@ %@%@", [myUserUsername uppercaseString], @"|", _myUserScore, @"pts" ];
    self.userPhone.text = myUserPhone;
    self.thumbNailImageView.file = myUserPicFile;
    self.thumbNailImageView.image = [UIImage imageNamed:@"placeholder.png"];
    //[self.backgroundColor setBackgroundColor:[UIColor colorWithRed:0.09 green:0.73 blue:0.98 alpha:1.0]];
    
    [self.thumbNailImageView loadInBackground:^(UIImage *image, NSError *error) {
        if (!error) {
            /* Blur effect */
            CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
            [gaussianBlurFilter setDefaults];
            CIImage *inputImage;
            if (image == nil) {
                inputImage = [CIImage imageWithCGImage:[[UIImage imageNamed:@"placeholder.png"] CGImage]];
            }else{
                inputImage = [CIImage imageWithCGImage:[image CGImage]];
            }
            
            [gaussianBlurFilter setValue:inputImage forKey:kCIInputImageKey];
            [gaussianBlurFilter setValue:@15 forKey:kCIInputRadiusKey];
            
            CIImage *outputImage = [gaussianBlurFilter outputImage];
            CIContext *context   = [CIContext contextWithOptions:nil];
            CGImageRef cgimg     = [context createCGImage:outputImage fromRect:[inputImage extent]];  // note, use input image extent if you want it the same size, the output image extent is larger
            self.backgroundBlur.image       = [UIImage imageWithCGImage:cgimg];
            
        }
    }];
    
    self.thumbNailImageView.layer.borderWidth = 2;
    self.thumbNailImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.thumbNailImageView.layer.cornerRadius = 130/2;
    self.thumbNailImageView.clipsToBounds = YES;
}

#pragma mark - Adding to Native Contact Book
- (void)addToContacts { //: (UIButton *) socialAppButton {
    NSString *contactFirstName;
    NSString *contactLastName;
    NSString *contactPhoneNumber;
    NSString *contactEmail;
    NSData *contactImageData;

    contactFirstName = myUserFirstName;
    contactLastName = myUserLastName;
    contactPhoneNumber = myUserPhone;
    contactEmail = myUserEmail;
    if (myUserPic) {
         contactImageData = UIImageJPEGRepresentation(myUserPic, 0.7f);
    }
   
    
    CNContactStore* addressBook = [[CNContactStore alloc]init];
    CNMutableContact *contact = [[CNMutableContact alloc]init];
    
    contact.givenName = contactFirstName;
    contact.familyName = contactLastName;
    [myUserPicFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            contact.imageData = imageData;
        }
    }];
    if (myUserPhone != nil && ![myUserPhone isEqualToString:@""]) {
         contact.phoneNumbers = @[ [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:contactPhoneNumber]] ];
    }
    if (myUserEmail != nil && ![myUserEmail isEqualToString:@""]) {
        contact.emailAddresses = @[ [CNLabeledValue labeledValueWithLabel:CNLabelEmailiCloud value:contactEmail] ];

    }
    
    
    
    NSError* contactError;
    CNContactStore* allContacts = [[CNContactStore alloc]init];

//    [allContacts containersMatchingPredicate:[CNContainer predicateForContainersWithIdentifiers: @[allContacts.defaultContainerIdentifier]] error:&contactError];
//    NSArray * keysToFetch =@[CNContactEmailAddressesKey, CNContactPhoneNumbersKey, CNContactFamilyNameKey, CNContactGivenNameKey];
//    CNContactFetchRequest * request = [[CNContactFetchRequest alloc]initWithKeysToFetch:keysToFetch];
//    BOOL success = [allContacts enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop){
//       // [self parseContactWithContact:contact];
//        NSLog(@"hey");
//    }];
    if ([contact isKeyAvailable:CNContactPhoneNumbersKey]) {
        CNSaveRequest *saveRequest = [[CNSaveRequest alloc]init];
        [saveRequest addContact:contact toContainerWithIdentifier:nil];
        
        if ([addressBook executeSaveRequest:saveRequest error:nil]) {
            UIAlertView *contactAddedAlert = [[UIAlertView alloc]initWithTitle:@"Contact Added" message:nil delegate:nil
                                                             cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [contactAddedAlert show];
        }else{
            UIAlertView *contactFailedAlert = [[UIAlertView alloc]initWithTitle:@"Contact Failed To Add" message:nil delegate:nil
                                                              cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [contactFailedAlert show];
            
        }

    }
    else{
        //The contact already exists!
        UIAlertView *contactExistsAlert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Sorry, %@ Already Exists!", contactFirstName]
                                                                    message:nil delegate:nil cancelButtonTitle:@"OK"
                                                          otherButtonTitles: nil];
        [contactExistsAlert show];
        return;
    }
    
}
- (void)parseContactWithContact :(CNContact* )contact
{
    NSString * firstName =  contact.givenName;
    NSString * lastName =  contact.familyName;
    NSString * phone = [[contact.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"];
    NSString * email = [contact.emailAddresses valueForKey:@"value"];
    NSArray * addrArr = [self parseAddressWithContac:contact];
}

- (NSMutableArray *)parseAddressWithContac: (CNContact *)contact
{
    NSMutableArray * addrArr = [[NSMutableArray alloc]init];
    CNPostalAddressFormatter * formatter = [[CNPostalAddressFormatter alloc]init];
    NSArray * addresses = (NSArray*)[contact.postalAddresses valueForKey:@"value"];
    if (addresses.count > 0) {
        for (CNPostalAddress* address in addresses) {
            [addrArr addObject:[formatter stringFromPostalAddress:address]];
        }
    }
    return addrArr;
}

- (IBAction)addContactToAddressBook:(id)sender
{
//        
    CNEntityType entityType = CNEntityTypeContacts;
    if( [CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusDenied ||
        [CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusRestricted){
        //1
        UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Cannot Add Contact"
                                                                      message: @"You must give the app permission to add the contact first."
                                                                     delegate:nil cancelButtonTitle: @"OK"
                                                            otherButtonTitles: nil];
        [cantAddContactAlert show];
        NSLog(@"Denied");
    } else if ([CNContactStore authorizationStatusForEntityType:entityType] == CNAuthorizationStatusAuthorized ){
        //2
        [self addToContacts];
        NSLog(@"Authorized");
    } else{
        //3
        CNContactStore * contactStore = [[CNContactStore alloc] init];
        [contactStore requestAccessForEntityType:entityType completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!granted){
                UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Cannot Add Contact"
                                                                              message: @"You must give the app permission to add the contact first."
                                                                             delegate:nil cancelButtonTitle: @"OK"
                                                                    otherButtonTitles: nil];
                [cantAddContactAlert show];
                NSLog(@"Just denied");
                return;
            }
            //5
            [self addToContacts];
            NSLog(@"Just authorized");
        }];
    }
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
    KMASocialMedia *shareStuff = [self.shareOptions objectAtIndex:indexPath.row];
    

    if ([shareStuff.mediaType isEqualToString:@"Facebook"]) {
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:[myUserUsername lowercaseString]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *user, NSError *error) {
            if (!error) {
                NSLog(@"UserID: %@", [user objectForKey:@"facebookURL"]);
                //Facebook
                NSURL *facebookURL = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile?app_scoped_user_id=%@", [user objectForKey:@"facebookURL"]]];
                if ([[UIApplication sharedApplication] canOpenURL:facebookURL]){
                    [[UIApplication sharedApplication] openURL:facebookURL];
                    return;
                }else{
                    // --- Fallback: Mobile Facebook in Safari
                    NSURL *safariURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://facebook.com/%@", [user objectForKey:@"facebookURL"]]];
                    [[UIApplication sharedApplication] openURL:safariURL];
                    return;
                }
                
//                NSString *fbURL = [NSString stringWithFormat:@"fb://profile?app_scoped_user_id=%@", [user objectForKey:@"facebookURL"]];
//                NSURL *url = [NSURL URLWithString:fbURL];
//                [[UIApplication sharedApplication] openURL:url];
                
            }
        }];
    }else if ([shareStuff.mediaType isEqualToString:@"Instagram"]){
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:[myUserUsername lowercaseString]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *user, NSError *error) {
            if (!error) {
                /*
                NSURL *instagramURL = [NSURL URLWithString:[NSString stringWithFormat:@"instagram://user?username=%@", [user objectForKey:@"instagramURL"]]];
                if ([[UIApplication sharedApplication] canOpenURL:instagramURL]){
                    [[UIApplication sharedApplication] openURL:instagramURL];
                    return;
                }else{
                    // --- Fallback: Mobile Facebook in Safari
                    NSURL *safariURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://instagram.com/%@", [user objectForKey:@"instagramURL"]]];
                    [[UIApplication sharedApplication] openURL:safariURL];
                    return;
                }
                */
                NSString *fbURL = [NSString stringWithFormat:@"instagram://user?username=%@", [user objectForKey:@"instagramURL"]];
                NSURL *url = [NSURL URLWithString:fbURL];
                [[UIApplication sharedApplication] openURL:url];
                
            }
        }];
    }else if ([shareStuff.mediaType isEqualToString:@"Contact"]){
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"Contact %@", myUserFirstName]
                                                                       message:nil
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        if (myUserEmail != nil && ![myUserEmail isEqualToString:@""]) {
            UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Email"
                                                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                      NSString *emailURL = [NSString stringWithFormat:@"mailto:%@", myUserEmail];
                                                                      NSURL *url = [NSURL URLWithString:emailURL];
                                                                      [[UIApplication sharedApplication] openURL:url];
                                                                  }]; 
            
            [alert addAction:firstAction];
        }
        
        if (myUserPhone != nil && ![myUserPhone isEqualToString:@""]) {
            UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Text"
                                                                   style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                       NSString *phoneURL = [NSString stringWithFormat:@"sms:%@", myUserPhone];
                                                                       NSURL *url = [NSURL URLWithString:phoneURL];
                                                                       [[UIApplication sharedApplication] openURL:url];
                                                                   }]; // 3
            UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Call"
                                                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                      NSString *phoneURL = [NSString stringWithFormat:@"tel://%@", myUserPhone];
                                                                      NSURL *url = [NSURL URLWithString:phoneURL];
                                                                      [[UIApplication sharedApplication] openURL:url];
                                                                  }];
            [alert addAction:secondAction];
            [alert addAction:thirdAction];
        }

        
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            //enter hanndler
        }]; 
        
        [alert addAction:defaultAction];
        
        [self presentViewController:alert animated:YES completion:nil];

    }else if ([shareStuff.mediaType isEqualToString:@"Snapchat"]){
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:[myUserUsername lowercaseString]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *user, NSError *error) {
            if (!error) {
               // NSString *snapURL = [NSString stringWithFormat:@"http://www.snapchat.com/add/%@", [user objectForKey:@"snapchatURL"]];
                NSString *snapURL = [NSString stringWithFormat:@"snapchat://add/%@", [user objectForKey:@"snapchatURL"]];
                NSURL *url = [NSURL URLWithString:snapURL];
                [[UIApplication sharedApplication] openURL:url];
                
            }
        }];
    }else if ([shareStuff.mediaType isEqualToString:@"Twitter"]){
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:[myUserUsername lowercaseString]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *user, NSError *error) {
            if (!error) {
                
                NSString *twitterURL = [NSString stringWithFormat:@"twitter://user?screen_name=%@", [user objectForKey:@"twitterURL"]];
                NSURL *url = [NSURL URLWithString:twitterURL];
                [[UIApplication sharedApplication] openURL:url];
                
            }
        }];
    }else if ([shareStuff.mediaType isEqualToString:@"LinkedIn"]){
        NSLog(@"here");
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:[myUserUsername lowercaseString]];
        [query getFirstObjectInBackgroundWithBlock:^(PFObject *user, NSError *error) {
            if (!error) {
                
                DeeplinkSuccessBlock success = ^(NSString *returnState) {
                    NSLog(@"Success with returned state: %@",returnState);
                };
                DeeplinkErrorBlock error = ^(NSError *error, NSString *returnState) {
                    NSLog(@"Error with returned state: %@", returnState);
                    NSLog(@"Error %@", error);
                };
                
                NSString *memberId = user[@"linkedinURL"];
                NSLog(@"id: %@", memberId);
                
                [[LISDKDeeplinkHelper sharedInstance] viewOtherProfile:memberId withState:@"viewOtherProfileButton" showGoToAppStoreDialog:YES success:success error:error];
                
//                NSString *liURL = [NSString stringWithFormat:@"linkedin://profile?id=%@", [user objectForKey:@"linkedinURL"]];
//                NSURL *url = [NSURL URLWithString:liURL];
//                [[UIApplication sharedApplication] openURL:url];
            }
        }];
    }
    
}
-(void)actionSheetPressed{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"My Alert"
                                                                   message:@"This is an action sheet."
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1   //OR preferredStyle:UIAlertControllerStyleAlert
    UIAlertAction *firstAction = [UIAlertAction actionWithTitle:@"Email"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              NSLog(@"Email");
                                                          }]; // 2
    UIAlertAction *secondAction = [UIAlertAction actionWithTitle:@"Call"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               NSLog(@"Call");
                                                           }]; // 3
    UIAlertAction *thirdAction = [UIAlertAction actionWithTitle:@"Text"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               NSLog(@"Text");
                                                           }];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            NSLog(@"You pressed button Cancel");
    }]; // 8
    
    [alert addAction:firstAction]; // 4
    [alert addAction:secondAction]; // 5
    [alert addAction:thirdAction];
    
//    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//        textField.placeholder = @"Input data...";
//    }]; // 10
    
     [alert addAction:defaultAction]; // 9
    
    [self presentViewController:alert animated:YES completion:nil]; // 6
}

-(void)LIDeeplinkProfile{

    
}

@end

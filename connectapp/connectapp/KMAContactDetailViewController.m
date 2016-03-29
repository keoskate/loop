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

@interface KMAContactDetailViewController ()

@end

@implementation KMAContactDetailViewController
@synthesize myUserEmail, myUserFirstName, myUserLastName, myUserUsername, myUserPhone, myUserPic, myUserPicFile;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.userEmail.text = myUserEmail;
    self.userName.text = [[NSString stringWithFormat:@"%@ %@", myUserFirstName, myUserLastName] capitalizedString];
    self.userUsername.text = [myUserUsername uppercaseString];
    self.userPhone.text = myUserPhone;
    self.thumbNailImageView.file = myUserPicFile;
    self.thumbNailImageView.image = [UIImage imageNamed:@"placeholder.png"];
    
    //test cell bool
    //if get snapchat availability; YES, NO
    //self.SnapchatCell.userInteractionEnabled = NO;
    
    
    //[self populateSelfData];
    
    [self.thumbNailImageView loadInBackground];
}

-(void)populateSelfData{
    self.shareOptions = [[NSMutableArray alloc] init];
    
    PFUser *currentUser = [PFUser currentUser];
    
    
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" containsString:[myUserUsername lowercaseString]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            //get the User object
            PFUser *user = (PFUser *)object;  //searched user (toUser)
            
            PFQuery * friendRequest = [PFQuery queryWithClassName:@"FriendRequest"];
            [friendRequest whereKey:@"toUser" equalTo:user];
            [friendRequest whereKey:@"fromUser" equalTo:[PFUser currentUser]];
            
            [friendRequest getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
                //if no request currently exists
                if (!error) {
                    NSString *status = [object objectForKey:@"status"];
                    if ( [status  isEqual: @"accepted"]) {
                        if ([[object objectForKey:@"email"]  isEqual: @YES]) {
                            KMASocialMedia* socialStuff = [[KMASocialMedia alloc]init]; //email
                            socialStuff.mediaType = @"Email";
                            socialStuff.mediaImage = [UIImage imageNamed:@"gmail.png"];
                            socialStuff.mediaData  = user.email;
                            self.userEmail.text = user.email;
                            [self.shareOptions addObject:socialStuff];
                        }else{
                            self.userEmail.text = @"request email";
                        }
                        
                        if ([[object objectForKey:@"facebook"]  isEqual: @YES]) {
                            KMASocialMedia* socialStuff = [[KMASocialMedia alloc]init];
                            socialStuff.mediaType = @"Facebook";
                            socialStuff.mediaImage = [UIImage imageNamed:@"facebook.png"];
                            socialStuff.mediaData  = [user objectForKey:@"facebookURL"];
                            [self.shareOptions addObject:socialStuff];
                        }
                        
                        
                    }else if ([status  isEqual: @"rejected"]){
                        NSLog(@"This User rejected you.");
                        UIAlertView *alertView = [[UIAlertView alloc]
                                                  initWithTitle:@"Awkward!"
                                                  message:@"This user rejected you"
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

                    
                    
                } else {
                   NSLog(@"Relation not found error: : %@", error);
                }

            }];
            
        }else {
            NSLog(@"Error: %@", error);//, [error userInfo]);
        }
    }];

    /*
    
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
        socialStuff.mediaType = @"Instagram";
        socialStuff.mediaImage = [UIImage imageNamed:@"instagram.png"];
        socialStuff.mediaData  = [currentUser objectForKey:@"instagramURL"];
        [self.shareOptions addObject:socialStuff];
    }
     */
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

    contact.emailAddresses = @[ [CNLabeledValue labeledValueWithLabel:CNLabelEmailiCloud value:contactEmail] ];
    contact.phoneNumbers = @[ [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:contactPhoneNumber]] ];
    
    
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
    
    
    
/*
//    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
//    ABRecordRef contact = ABPersonCreate();

    //info
//    ABRecordSetValue(contact, kABPersonFirstNameProperty, (__bridge CFStringRef)contactFirstName, nil);
//    ABRecordSetValue(contact, kABPersonLastNameProperty, (__bridge CFStringRef)contactLastName, nil);

    //numbers
    
  //  CNLabeledValue
//    ABMutableMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABMultiStringPropertyType);
//    ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFStringRef)contactPhoneNumber, kABPersonPhoneMainLabel, NULL);
//    ABRecordSetValue(contact, kABPersonPhoneProperty, phoneNumbers, nil);

    //Check to see if already in contacts
 
    
    NSArray *allContacts = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    for (id record in allContacts){
        ABRecordRef thisContact = (__bridge ABRecordRef)record;
        if (!ABRecordCopyCompositeName(thisContact)) { // BUG - this returns null, crashes when trying to add
            return;
        }else if (CFStringCompare(ABRecordCopyCompositeName(thisContact),
                            ABRecordCopyCompositeName(contact), 0) == kCFCompareEqualTo){
            //The contact already exists!
            UIAlertView *contactExistsAlert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Sorry, %@ Already Exists!", contactFirstName]
                                                                        message:nil delegate:nil cancelButtonTitle:@"OK"
                                                              otherButtonTitles: nil];
            [contactExistsAlert show];
            return;
        }
    }
    
    //pic
    ABPersonSetImageData(contact, (__bridge CFDataRef)contactImageData, nil);
    
    //add/save
    ABAddressBookAddRecord(addressBookRef, contact, nil);
    ABAddressBookSave(addressBookRef, nil);

    UIAlertView *contactAddedAlert = [[UIAlertView alloc]initWithTitle:@"Contact Added" message:nil delegate:nil
                                                     cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [contactAddedAlert show];
 
 */
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
//    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
//        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
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
    } else{ //ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
        //3
//        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
//            dispatch_async(dispatch_get_main_queue(), ^{
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

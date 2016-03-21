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
    self.SnapchatCell.userInteractionEnabled = NO;
    
    
    [self.thumbNailImageView loadInBackground];
}

#pragma mark - Adding to Native Contact Book
- (void)addToContacts { //: (UIButton *) socialAppButton {
    NSString *contactFirstName;
    NSString *contactLastName;
    NSString *contactPhoneNumber;
    //NSString *contactEmail;
    NSData *contactImageData;

    contactFirstName = myUserFirstName;
    contactLastName = myUserLastName;
    contactPhoneNumber = myUserPhone;
    //contactEmail = myUserEmail;
    if (myUserPic) {
         contactImageData = UIImageJPEGRepresentation(myUserPic, 0.7f);
    }
   

    /*
    if (socialAppButton.tag == 1){
        //open up facebook
    } else if (socialAppButton.tag == 2){
        //open up twitter
    }
    else if (socialAppButton.tag == 3){
        //open up instagram
    }
    */

    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, nil);
    ABRecordRef contact = ABPersonCreate();

    //info
    ABRecordSetValue(contact, kABPersonFirstNameProperty, (__bridge CFStringRef)contactFirstName, nil);
    ABRecordSetValue(contact, kABPersonLastNameProperty, (__bridge CFStringRef)contactLastName, nil);

    //numbers
    ABMutableMultiValueRef phoneNumbers = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(phoneNumbers, (__bridge CFStringRef)contactPhoneNumber, kABPersonPhoneMainLabel, NULL);
    ABRecordSetValue(contact, kABPersonPhoneProperty, phoneNumbers, nil);

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
}


- (IBAction)addContactToAddressBook:(id)sender
{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusDenied ||
        ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusRestricted){
        //1
        UIAlertView *cantAddContactAlert = [[UIAlertView alloc] initWithTitle: @"Cannot Add Contact"
                                                                      message: @"You must give the app permission to add the contact first."
                                                                     delegate:nil cancelButtonTitle: @"OK"
                                                            otherButtonTitles: nil];
        [cantAddContactAlert show];
        NSLog(@"Denied");
    } else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized){
        //2
        [self addToContacts];
        NSLog(@"Authorized");
    } else{ //ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined
        //3
        ABAddressBookRequestAccessWithCompletion(ABAddressBookCreateWithOptions(NULL, nil), ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
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
            });
        NSLog(@"Not determined");
        });
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  HWMainViewController.m
//  IDDCaller
//
//  Created by Hai Hw on 30/4/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import "HWMainViewController.h"
#import <AddressBookUI/AddressBookUI.h>
@interface HWMainViewController () <ABPeoplePickerNavigationControllerDelegate, UITextFieldDelegate>
{
}
@end

@implementation HWMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)showAddressBook
{
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark showAddresBook
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
    return YES;
}
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
    NSString* name = (__bridge_transfer NSString*)ABRecordCopyValue(person,
                                                                    kABPersonFirstNameProperty);
    _name.text = name;
    if (property == kABPersonPhoneProperty)
    {
        NSString* phone = nil;
        ABMultiValueRef phoneNumbers = ABRecordCopyValue(person,
                                                         kABPersonPhoneProperty);
        if (ABMultiValueGetCount(phoneNumbers) > identifier) {
            phone = (__bridge_transfer NSString*)
            ABMultiValueCopyValueAtIndex(phoneNumbers, identifier);
        } else {
            phone = @"[None]";
        }
        if ([phone characterAtIndex:0] == '+')
        {
            _countryCode.enabled = NO;
            _countryCode.text = @"";
        } else
        {
            _countryCode.enabled = YES;
            _countryCode.text = @"84";
        }
        _number.text = [self strimNumber:phone];
        CFRelease(phoneNumbers);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    return NO;
}

#pragma mark textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (NSString *) strimNumber: (NSString *)number
{
    NSString *newNumber = [number stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    while ([newNumber characterAtIndex:0] == '0'){
        newNumber = [number substringFromIndex:1];
    }

    return newNumber;
}
- (IBAction)btnCallTapped:(id)sender {
    NSString *number = [NSString stringWithFormat:@"%@%@%@", _prefix.text, _countryCode.text, _number.text];
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:[number stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (IBAction)btnOtherTapped:(id)sender {
    [self showAddressBook];
}

- (IBAction)btnCountryCodeTouchDown:(id)sender {
}

- (IBAction)btnIddTouchDown:(id)sender {
}
@end

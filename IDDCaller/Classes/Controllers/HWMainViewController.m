//
//  HWMainViewController.m
//  IDDCaller
//
//  Created by Hai Hw on 30/4/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import "HWMainViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import "HWCountryCodeViewController.h"
#import "HWIDDViewController.h"
#import "HWHistoryTableViewCell.h"
#import "CallHistory.h"
@interface HWMainViewController () <ABPeoplePickerNavigationControllerDelegate, UITextFieldDelegate, HWCountryCodeViewControllerDelegate, HWIDDViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray *phoneHistories;
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
    [self initData];
}
- (void)initData
{
    NSString *iddCode = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyIDDPrefix];
    NSString *countryCode = [[NSUserDefaults standardUserDefaults] objectForKey:kKeyCountryCode];
    
    _prefix.text = iddCode;
    _countryCode.text = countryCode;
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"history.db"];
    phoneHistories = [[CallHistory MR_findAllSortedBy:@"callTime" ascending:NO] mutableCopy];
    [_tableHistory reloadData];
}
- (void)saveContext {
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"You successfully saved your context.");
        } else if (error) {
            NSLog(@"Error saving context: %@", error.description);
        }
    }];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_tableHistory reloadData];
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
    picker.predicateForSelectionOfPerson = [NSPredicate predicateWithValue: NO];
    picker.predicateForSelectionOfProperty = [NSPredicate predicateWithValue: YES];
    [self presentViewController:picker animated:YES completion:nil];
}
#pragma mark showAddresBook
//ios 8
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person
{
}
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
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
        NSRange vnCodeRange = [phone rangeOfString:@"+84"];
        if (vnCodeRange.location != NSNotFound)
        {
            phone = [phone substringFromIndex:vnCodeRange.location + vnCodeRange.length];
        }
        _countryCode.text = @"84";
        _number.text = [self formatIdentificationNumber:phone];
        CFRelease(phoneNumbers);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//ios 7
//- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
//{
//    return YES;
//}
//- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
//{
//
//    return NO;
//}
//
#pragma mark textfield
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    _name.text = @"";
    NSCharacterSet * invalidNumberSet = [NSCharacterSet characterSetWithCharactersInString: kInvalideNumberCharacters];

    if ([string rangeOfCharacterFromSet:invalidNumberSet].location != NSNotFound)
    {
        return NO;
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(NSString *) formatIdentificationNumber:(NSString *)string
{
    NSString *newString = [[string componentsSeparatedByCharactersInSet:
                            [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                           componentsJoinedByString:@""];
    return newString;
}
- (void)callNumber:(NSString *)number
{
    //save history
    CallHistory *history = [CallHistory MR_createEntity];
    history.contactName = _name.text ?: @"";
    history.phoneNumber = number;
    history.callTime = [NSDate date];
    [self saveContext];

    [phoneHistories insertObject:history atIndex:0];
    [self.tableHistory reloadData];
    
    //call api
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:[number stringByReplacingOccurrencesOfString:@" " withString:@""]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    
}
- (IBAction)btnCallTapped:(id)sender {
    NSString *number = [NSString stringWithFormat:@"%@%@%@", _prefix.text, _countryCode.text, _number.text];
    [self callNumber:number];
}

- (IBAction)btnOtherTapped:(id)sender {
    [self showAddressBook];
}

- (IBAction)btnCountryCodeTouchDown:(id)sender {
    HWCountryCodeViewController *countryCodeVc = [HWCountryCodeViewController sharedInstance];
    countryCodeVc.delegate = self;
    [self presentViewController:countryCodeVc animated:YES completion:nil];
}

- (IBAction)btnIddTouchDown:(id)sender {
    HWIDDViewController *iddVc = [[HWIDDViewController alloc] init];
    iddVc.delegate = self;
    [self presentViewController:iddVc animated:YES completion:nil];

}

#pragma mark - country code delegate
- (void)countryCodeController:(HWCountryCodeViewController *)controller didSelectCode:(NSString *)countryCode
{
    _countryCode.text = [self formatIdentificationNumber:countryCode];
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSUserDefaults standardUserDefaults] setObject:_countryCode.text forKey:kKeyCountryCode];
}
- (void)iddViewController:(HWIDDViewController *)controller didSelectIDD:(NSString *)iddNumber
{
    _prefix.text = iddNumber;
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSUserDefaults standardUserDefaults] setObject:_prefix.text forKey:kKeyIDDPrefix];
}

#pragma mark TableView
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"History";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return phoneHistories.count;
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"HistoryCell%d", (int)indexPath.row];
    HWHistoryTableViewCell *cell;
    cell = [[HWHistoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    CallHistory *historyElement = phoneHistories[indexPath.row];

    NSString *name = historyElement.contactName;
    cell.lbName.text = name.length > 0 ? name : @"unknown";
    cell.lbNumber.text = historyElement.phoneNumber;
    NSDate *date = historyElement.callTime;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"dd/MM/yyy hh:mm:ss";
    cell.lbTime.text = [formatter stringFromDate:date];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CallHistory *historyElement = phoneHistories[indexPath.row];
    NSString *number = historyElement.phoneNumber;
    _name.text =  historyElement.contactName;
    _number.text = @"";
    if (number.length > 0)
        [self callNumber:number];
}
@end

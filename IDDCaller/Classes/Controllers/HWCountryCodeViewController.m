//
//  HWCountryCodeViewController.m
//  IDDCaller
//
//  Created by Hai Hw on 15/5/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import "HWCountryCodeViewController.h"
#import "HWCountryTableViewCell.h"
@interface HWCountryCodeViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray *allCountries;
    NSArray *displayCountries;
}
@end

@implementation HWCountryCodeViewController
- (IBAction)btnCancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static HWCountryCodeViewController *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[HWCountryCodeViewController alloc] init];
    });
    return shared;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setUpCountryCodes];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setUpCountryCodes
{
    NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    allCountries = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    displayCountries = [NSArray arrayWithArray:allCountries];
    
}

#pragma mark - Search
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchText.length < 1)
    {
        displayCountries = allCountries;
        [_tableView reloadData];
        return;
    }
    NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
    displayCountries = [allCountries filteredArrayUsingPredicate:predicate];
    [_tableView reloadData];
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return displayCountries.count;
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"CountryCell_%d", indexPath.row];
    HWCountryTableViewCell *cell;
    cell = [[HWCountryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    cell.countryName.text = [displayCountries[indexPath.row] valueForKey:@"name"];
    cell.countryCode.text = [displayCountries[indexPath.row] valueForKey:@"dial_code"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWCountryTableViewCell *cell = (HWCountryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(countryCodeController:didSelectCode:)])
    {
        [_delegate countryCodeController:self didSelectCode:cell.countryCode.text];
    }
}
@end

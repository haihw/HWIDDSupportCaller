//
//  HWIDDViewController.m
//  IDDCaller
//
//  Created by Hai Hw on 15/5/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import "HWIDDViewController.h"
#import "HWCountryTableViewCell.h"
@interface HWIDDViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
{
    NSArray *allCountries;
    NSArray *displayCountries;
}
@end

@implementation HWIDDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSData *jsonData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
        allCountries = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] 'singapore'"];
        displayCountries = [allCountries filteredArrayUsingPredicate:predicate];

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnCancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Search
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
//    if (searchText.length < 1)
//    {
//        displayCountries = allCountries;
//        [_tableView reloadData];
//        return;
//    }
//    NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
//    displayCountries = [allCountries filteredArrayUsingPredicate:predicate];
//    [_tableView reloadData];
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *country = [displayCountries firstObject];
    NSArray *idds = [country objectForKey:@"IDDs"];
    return idds.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Singapore";
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"CountryCell_%d", indexPath.row];
    HWCountryTableViewCell *cell;
    cell = [[HWCountryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    NSDictionary *country = [displayCountries firstObject];
    NSArray *idds = [country objectForKey:@"IDDs"];
    cell.countryName.text = [idds[indexPath.row] valueForKey:@"operator"];
    cell.countryCode.text = [idds[indexPath.row] valueForKey:@"idd_code"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HWCountryTableViewCell *cell = (HWCountryTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_delegate && [_delegate respondsToSelector:@selector(iddViewController:didSelectIDD:)])
    {
        [_delegate iddViewController:self didSelectIDD: cell.countryCode.text];
    }
}
@end

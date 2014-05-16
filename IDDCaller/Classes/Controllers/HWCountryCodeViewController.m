//
//  HWCountryCodeViewController.m
//  IDDCaller
//
//  Created by Hai Hw on 15/5/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import "HWCountryCodeViewController.h"

@interface HWCountryCodeViewController () <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    NSArray *allCountries;
    NSArray *displayCountries;
}
@end

@implementation HWCountryCodeViewController
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
    
}

#pragma mark - Search
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSPredicate *predicate  = [NSPredicate predicateWithFormat:@"name contains '%@'", searchText];
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
    static NSString *identifier = @"CountryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end

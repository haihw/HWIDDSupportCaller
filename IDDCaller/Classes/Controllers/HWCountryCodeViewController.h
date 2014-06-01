//
//  HWCountryCodeViewController.h
//  IDDCaller
//
//  Created by Hai Hw on 15/5/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HWCountryCodeViewControllerDelegate;
@interface HWCountryCodeViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) id <HWCountryCodeViewControllerDelegate> delegate;
- (IBAction)btnCancelTapped:(id)sender;
+(id)sharedInstance;
@end

@protocol HWCountryCodeViewControllerDelegate <NSObject>

- (void)countryCodeController :(HWCountryCodeViewController *)controller didSelectCode:(NSString *)countryCode;

@end

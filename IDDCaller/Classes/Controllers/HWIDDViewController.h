//
//  HWIDDViewController.h
//  IDDCaller
//
//  Created by Hai Hw on 15/5/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HWIDDViewControllerDelegate;
@interface HWIDDViewController : UIViewController
@property (nonatomic, weak) id <HWIDDViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)btnCancelTapped:(id)sender;

@end
@protocol HWIDDViewControllerDelegate <NSObject>

- (void)iddViewController:(HWIDDViewController *)controller didSelectIDD:(NSString*)iddNumber;

@end
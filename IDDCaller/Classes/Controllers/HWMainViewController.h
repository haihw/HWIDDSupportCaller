//
//  HWMainViewController.h
//  IDDCaller
//
//  Created by Hai Hw on 30/4/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWMainViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *prefix;
@property (strong, nonatomic) IBOutlet UITextField *number;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UITextField *countryCode;

- (IBAction)btnCallTapped:(id)sender;
- (IBAction)btnOtherTapped:(id)sender;

@end

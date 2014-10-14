//
//  Contact.h
//  IDDCaller
//
//  Created by Hai Hw on 14/10/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Contact : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * homePhone;
@property (nonatomic, retain) NSString * officePhone;
@property (nonatomic, retain) NSString * mobilePhone;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * company;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSString * note;

@end

//
//  Country.h
//  IDDCaller
//
//  Created by Hai Hw on 14/10/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Country : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * dialCode;
@property (nonatomic, retain) NSString * code;
@property (nonatomic, retain) NSManagedObject *idd;

@end

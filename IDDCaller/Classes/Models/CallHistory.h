//
//  CallHistory.h
//  IDDCaller
//
//  Created by Hai Hw on 14/10/14.
//  Copyright (c) 2014 Hai Hw. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CallHistory : NSManagedObject

@property (nonatomic, retain) NSString * contactName;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSDate * callTime;
@property (nonatomic, retain) NSNumber * callDuration;

@end

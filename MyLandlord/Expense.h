//
//  Expense.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/1/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Properties.h"

@class Properties;

@interface Expense : Properties

@property (nonatomic, retain) NSNumber * expAmount;
@property (nonatomic, retain) NSString * expPropertyId;
@property (nonatomic, retain) NSString * expDescription;
@property (nonatomic, retain) NSString * expCategory;
@property (nonatomic, retain) NSDate * expDate;
@property (nonatomic, retain) Properties *property;

@end

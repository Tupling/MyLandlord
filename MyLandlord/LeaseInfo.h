//
//  LeaseInfo.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/1/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Tenants.h"

@class Tenants;

@interface LeaseInfo : Tenants

@property (nonatomic, retain) NSDate * leaseBegin;
@property (nonatomic, retain) NSNumber * rentAmount;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSDate * leaseEnd;
@property (nonatomic, retain) NSString * pTenantId;
@property (nonatomic, retain) Tenants *tenant;

@end

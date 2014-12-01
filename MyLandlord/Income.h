//
//  Income.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/1/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Tenants.h"

@class Tenants;

@interface Income : Tenants

@property (nonatomic, retain) NSNumber * incAmount;
@property (nonatomic, retain) NSString * incTenantId;
@property (nonatomic, retain) NSString * incType;
@property (nonatomic, retain) Tenants *tenant;

@end

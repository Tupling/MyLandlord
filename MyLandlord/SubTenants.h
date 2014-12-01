//
//  SubTenants.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/1/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Tenants.h"

@class Tenants;

@interface SubTenants : Tenants

@property (nonatomic, retain) NSString * sEmail;
@property (nonatomic, retain) NSString * sPhoneNumber;
@property (nonatomic, retain) NSString * sLastName;
@property (nonatomic, retain) NSString * sFirstName;
@property (nonatomic, retain) NSString * pTenantId;
@property (nonatomic, retain) Tenants *tenant;

@end

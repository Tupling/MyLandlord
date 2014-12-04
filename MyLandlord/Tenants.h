//
//  Tenants.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/1/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Properties;

@interface Tenants : NSManagedObject

@property (nonatomic, retain) NSString *tenantId;

//Primary Tenant
@property (nonatomic, retain) NSString * pEmail;
@property (nonatomic, retain) NSString * pFirstName;
@property (nonatomic, retain) NSString * pLastName;
@property (nonatomic, retain) NSString * pPhoneNumber;

//Secondary Tenant
@property (nonatomic) BOOL secondTenant;
@property (nonatomic, retain) NSString * sEmail;
@property (nonatomic, retain) NSString * sFirstName;
@property (nonatomic, retain) NSString * sLastName;
@property (nonatomic, retain) NSString * sPhoneNumber;

//Lease Information
@property (nonatomic, retain) NSDate   * leaseStart;
@property (nonatomic, retain) NSDate   * leaseEnd;
@property (nonatomic, retain) NSNumber * rentAmount;
@property (nonatomic, retain) NSNumber * dueDay;

//Property Variable
@property (nonatomic, retain) NSString * propertyId;



@end


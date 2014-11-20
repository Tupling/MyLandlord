//
//  Tenants.h
//  MyLandlord
//
//  Created by Dale Tupling on 11/20/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Properties;

@interface Tenants : NSManagedObject

@property (nonatomic, retain) NSString * pFirstName;
@property (nonatomic, retain) NSString * pEmail;
@property (nonatomic, retain) NSString * pLastName;
@property (nonatomic, retain) NSString * pPhoneNumber;
@property (nonatomic, retain) NSString * sFirstName;
@property (nonatomic, retain) NSString * sLastName;
@property (nonatomic, retain) NSString * sPhoneNumber;
@property (nonatomic, retain) NSString * sEmail;
@property (nonatomic, retain) Properties *property;

@end

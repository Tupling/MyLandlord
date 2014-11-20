//
//  Properties.h
//  MyLandlord
//
//  Created by Dale Tupling on 11/20/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tenants;

@interface Properties : NSManagedObject

@property (nonatomic, retain) NSString * propName;
@property (nonatomic, retain) NSString *propState;
@property (nonatomic, retain) NSString *propAddress;
@property (nonatomic, retain) NSString *propCity;
@property (nonatomic, retain) NSString *propZip;
@property (nonatomic, retain) Tenants *tenants;

@end

//
//  Properties.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/1/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tenants;

@interface Properties : NSManagedObject

@property (nonatomic, retain) NSString * propAddress;
@property (nonatomic, retain) NSString * propCity;
@property (nonatomic, retain) NSString * propName;
@property (nonatomic, retain) NSString * propState;
@property (nonatomic, retain) NSString * propZip;
@property (nonatomic, retain) NSString * propertyId;
@property (nonatomic, retain) NSNumber * unitCount;
@property (nonatomic, retain) NSSet *tenant;
@property (nonatomic, retain) NSSet *expense;
@end

@interface Properties (CoreDataGeneratedAccessors)

- (void)addTenantObject:(Tenants *)value;
- (void)removeTenantObject:(Tenants *)value;
- (void)addTenant:(NSSet *)values;
- (void)removeTenant:(NSSet *)values;

- (void)addExpenseObject:(NSManagedObject *)value;
- (void)removeExpenseObject:(NSManagedObject *)value;
- (void)addExpense:(NSSet *)values;
- (void)removeExpense:(NSSet *)values;

@end

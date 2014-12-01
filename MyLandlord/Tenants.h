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

@property (nonatomic, retain) NSString * pEmail;
@property (nonatomic, retain) NSString * pFirstName;
@property (nonatomic, retain) NSString * pLastName;
@property (nonatomic, retain) NSString * pPhoneNumber;
@property (nonatomic, retain) NSSet *property;
@property (nonatomic, retain) NSSet *income;
@property (nonatomic, retain) NSSet *subtenant;
@property (nonatomic, retain) NSManagedObject *lease;
@end

@interface Tenants (CoreDataGeneratedAccessors)

- (void)addPropertyObject:(Properties *)value;
- (void)removePropertyObject:(Properties *)value;
- (void)addProperty:(NSSet *)values;
- (void)removeProperty:(NSSet *)values;

- (void)addIncomeObject:(NSManagedObject *)value;
- (void)removeIncomeObject:(NSManagedObject *)value;
- (void)addIncome:(NSSet *)values;
- (void)removeIncome:(NSSet *)values;

- (void)addSubtenantObject:(NSManagedObject *)value;
- (void)removeSubtenantObject:(NSManagedObject *)value;
- (void)addSubtenant:(NSSet *)values;
- (void)removeSubtenant:(NSSet *)values;

@end

//
//  AppDelegate.h
//  MyLandlord
//
//  Created by Dale Tupling on 11/17/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import <CoreData/CoreData.h>

#define ApplicationDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property(nonatomic)NSUInteger totalProperties;

@property(nonatomic)BOOL dataNeedsUpdated;


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) NSManagedObjectContext *backgroundManagedObjectContext;

//Database Item Arrays
@property (nonatomic, retain) NSArray *propertyDataArray;
@property (nonatomic, retain) NSMutableArray *propertyArray;
@property (nonatomic, retain) NSArray *tenantDataArray;
@property (nonatomic, retain) NSMutableArray *tenantsArray;
@property (nonatomic, retain) NSMutableArray *financesArray;

@property(strong, nonatomic) NSUserDefaults *storedData;

@property(strong, nonatomic) Reachability *networkStatus;


- (void)saveContext;


//Load Data Methods
- (void)loadProperties;
- (void)loadTenants;
- (void)loadFinances;



@end


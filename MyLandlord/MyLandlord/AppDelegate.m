//
//  AppDelegate.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/17/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>
#import <DropboxSDK/DropboxSDK.h>

#import "MLHomeViewController.h"
#import "MLPropertyDetails.h"
#import "MLPropertiesViewController.h"
#import "Tenants.h"
#import "Tasks.h"
#import "SubUnit.h"
#import "Financials.h"

@interface AppDelegate ()
{
    UINavigationBar *navBar;
    UINavigationItem *navItem;
    
    
}

@end

@implementation AppDelegate


@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark
#pragma mark - Launching Methods
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    
    //Parse Setup information
    [Parse setApplicationId:@"JaDJYpRJTZR9QV7OooDivH9uSRlTNYL8mH7AcUbe" clientKey:@"MyEtePxKqaKi2mXL9SALjECDTVL9WN3uqbQ4OWKd"];
    //Parse analytics
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
 
    //Dropbox Setup Information
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:@"dce7787ko2d4u1o"
                            appSecret:@"9os3cx3aehn2fhe"
                            root:kDBRootAppFolder]; // either kDBRootAppFolder or kDBRootDropbox
    [DBSession setSharedSession:dbSession];
    
    
    //SetTool Bar Tint
    [[UITabBar appearance] setTintColor:[UIColor colorWithRed:0.098 green:0.204 blue:0.255 alpha:1] /*#193441*/];
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithRed:0.09 green:0.18 blue:0.2 alpha:1]];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:0.96 green:0.98 blue:0.99 alpha:1]];
    
    //Check for Network Connection
    self.networkStatus = [Reachability reachabilityForInternetConnection];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self loadInCompleteTasks];
        [self loadProperties];
        [self loadTenants];
        [self loadSubUnits];
        [self loadFinancials];
        [self loadCompletedTasks];
        
    });
    
    
    
    
    [NSThread sleepForTimeInterval:1.0];
    
    return YES;
}

//Check for network Connection
-(BOOL)isConnected
{
    Reachability *connected = [Reachability reachabilityWithHostName:@"www.parse.com"];
    
    NetworkStatus status = [connected currentReachabilityStatus];
    
    return status;
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
    self.completedTasks = nil;
    self.financesArray = nil;
    self.inCompleteTaskArray = nil;
    self.tenantsArray = nil;
    self.propertyArray = nil;
    self.subUnitArray = nil;
    
    //Log User out if Application is Terminated
    [PFUser logOut];
}


#pragma mark
#pragma mark - LOAD DATA METHOD


// Load Property Information
-(void)loadProperties
{
    
    
    [self deletedAllObjects:@"Properties"];
    PFQuery *results = [PFQuery queryWithClassName:@"Properties"];
    [results orderByAscending:@"propName"];
    
    [results findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            for(int i = 0; i <objects.count; i++){
                NSManagedObjectContext *context = [self managedObjectContext];
                
                Properties *propInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Properties" inManagedObjectContext:context];
                propInfo.propertyId = [objects[i] valueForKey:@"objectId"];
                propInfo.propName = [objects[i] valueForKey:@"propName"];
                propInfo.propAddress = [objects[i] valueForKey:@"propAddress"];
                propInfo.propCity = [objects[i] valueForKey:@"propCity"];
                propInfo.propState = [objects[i] valueForKey:@"propState"];
                propInfo.propZip = [objects[i] valueForKey:@"propZip"];
                propInfo.unitCount = [objects[i] valueForKey:@"unitCount"];
                propInfo.multiFamily = [[objects[i] valueForKey:@"isMultiFamily"] boolValue];
                
                
                
                NSLog(@"MultiFamily = %d", propInfo.multiFamily);
                
                NSError * error;
                if(![context save:&error])
                {
                    NSLog(@"Failed to save: %@", [error localizedDescription]);
                }
                
                //Create new Fetch Request
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                
                //Request Entity EventInfo
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Properties" inManagedObjectContext:context];
                
                //Set fetchRequest entity to EventInfo Description
                [fetchRequest setEntity:entity];
                
                //Set events array to data in core data
                self.propertyDataArray = [context executeFetchRequest:fetchRequest error:&error];
                
                self.propertyArray = [[NSMutableArray alloc] initWithArray:self.propertyDataArray];
                
            }
            NSLog(@"PROPERTY ARRAY COUNT %lu:", (unsigned long)self.propertyArray.count);
            
            
            
        }else{
            
            //Why did it fail?
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
            
        }
    }];
    
    
    
    
    
}

//load tenant information

-(void)loadTenants
{
    
    [self deletedAllObjects:@"Tenants"];
    PFQuery *results = [PFQuery queryWithClassName:@"Tenants"];
    //[tenants whereKey:@"createdBy" equalTo:[PFUser currentUser]];
    [results orderByAscending:@"pFirstName"];
    
    [results findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            for(int i = 0; i <objects.count; i++){
                NSManagedObjectContext *context = [ApplicationDelegate managedObjectContext];
                
                Tenants *tenantInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Tenants" inManagedObjectContext:context];
                
                tenantInfo.tenantId = [objects[i] valueForKey:@"objectId"];
                
                tenantInfo.pFirstName = [objects[i] valueForKey:@"pFirstName"];
                tenantInfo.pLastName = [objects[i] valueForKey:@"pLastName"];
                tenantInfo.pEmail = [objects[i] valueForKey:@"pEmail"];
                tenantInfo.pPhoneNumber = [objects[i] valueForKey:@"pPhoneNumber"];
                
                tenantInfo.leaseEnd = [objects[i] valueForKey:@"leaseEnd"];
                tenantInfo.leaseStart = [objects[i] valueForKey:@"leaseStart"];
                tenantInfo.rentAmount = [objects[i] valueForKey:@"rentTotal"];
                tenantInfo.secondTenant = [[objects[i] valueForKey:@"secondTenant"]boolValue];
                tenantInfo.dueDay = [objects[i] valueForKey:@"dueDay"];
                tenantInfo.propertyId = [objects[i] valueForKey:@"assignedPropId"];
                tenantInfo.subUnitId = [objects[i] valueForKey:@"subUnitId"];
                
                if ([objects[i] valueForKey:@"sFirstName"] != nil) {
                    
                    tenantInfo.sFirstName = [objects[i] valueForKey:@"sFirstName"];
                    tenantInfo.sLastName = [objects[i] valueForKey:@"sLastName"];
                    tenantInfo.sEmail = [objects[i] valueForKey:@"sEmail"];
                    tenantInfo.sPhoneNumber = [objects[i] valueForKey:@"sPhoneNumber"];
                    
                }
                
                NSError * error;
                if(![context save:&error])
                {
                    NSLog(@"Failed to save: %@", [error localizedDescription]);
                }
                
                //Create new Fetch Request
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                
                //Request Entity EventInfo
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tenants" inManagedObjectContext:context];
                
                //Set fetchRequest entity to EventInfo Description
                [fetchRequest setEntity:entity];
                
                //Set events array to data in core data
                self.tenantDataArray = [context executeFetchRequest:fetchRequest error:&error];
                
                self.tenantsArray = [[NSMutableArray alloc] initWithArray:self.tenantDataArray];
                
                
            }
            
            
            
        }else{
            
            //Why did it fail?
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
    
}


-(void)loadInCompleteTasks
{
    
    [self deletedAllObjects:@"Tasks"];
    PFQuery *results = [PFQuery queryWithClassName:@"ToDo"];
    [results whereKey:@"isComplete" equalTo:[NSNumber numberWithBool:NO]];
    [results orderByAscending:@"date"];
    
    [results findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            for(int i = 0; i <objects.count; i++){
                NSManagedObjectContext *context = [ApplicationDelegate managedObjectContext];
                
                
                Tasks *taskInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Tasks" inManagedObjectContext:context];
                
                
                
                taskInfo.taskId = [objects[i] valueForKey:@"objectId"];
                
                taskInfo.task = [objects[i] valueForKey:@"task"];
                taskInfo.priority = [objects[i] valueForKey:@"priority"];
                taskInfo.taskDescription = [objects[i] valueForKey:@"taskDesc"];
                taskInfo.dueDate = [objects[i] valueForKey:@"dueDate"];
                
                taskInfo.isComplete = [objects[i] valueForKey:@"isComplete"];
                taskInfo.createdDate = [objects[i] valueForKey:@"createdAt"];
                taskInfo.propId = [objects[i] valueForKey:@"propId"];
                
                
                NSError * error;
                if(![context save:&error])
                {
                    NSLog(@"Failed to save: %@", [error localizedDescription]);
                }
                
                //Create new Fetch Request
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                
                //Request Entity TaskInfo
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tasks" inManagedObjectContext:context];
                
                //Set fetchRequest entity to EventInfo Description
                [fetchRequest setEntity:entity];
                
                //Set events array to data in core data
                self.inCompleteTaskData = [context executeFetchRequest:fetchRequest error:&error];
                
                self.inCompleteTaskArray = [[NSMutableArray alloc] initWithArray:self.inCompleteTaskData];
                
                
            }
            
        }else{
            
            //Why did it fail?
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        
        
    }];
    
    
}

-(void)loadCompletedTasks
{
    [self deletedAllObjects:@"CompletedTasks"];
    PFQuery *results = [PFQuery queryWithClassName:@"ToDo"];
    [results whereKey:@"isComplete" equalTo:[NSNumber numberWithBool:YES]];
    [results orderByAscending:@"date"];
    
    [results findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (objects != nil) {
            
            
            if(!error)
            {
                for(int i = 0; i <objects.count; i++){
                    NSManagedObjectContext *context = [ApplicationDelegate managedObjectContext];
                    
                    
                    Tasks *taskInfo = [NSEntityDescription insertNewObjectForEntityForName:@"CompletedTasks" inManagedObjectContext:context];
                    
                    
                    
                    taskInfo.taskId = [objects[i] valueForKey:@"objectId"];
                    
                    taskInfo.task = [objects[i] valueForKey:@"task"];
                    taskInfo.priority = [objects[i] valueForKey:@"priority"];
                    taskInfo.taskDescription = [objects[i] valueForKey:@"taskDesc"];
                    taskInfo.dueDate = [objects[i] valueForKey:@"dueDate"];
                    
                    taskInfo.isComplete = [objects[i] valueForKey:@"isComplete"];
                    taskInfo.createdDate = [objects[i] valueForKey:@"createdAt"];
                    taskInfo.propId = [objects[i] valueForKey:@"propId"];
                    
                    
                    NSError * error;
                    if(![context save:&error])
                    {
                        NSLog(@"Failed to save: %@", [error localizedDescription]);
                    }
                    
                    //Create new Fetch Request
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                    
                    //Request Entity TaskInfo
                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CompletedTasks" inManagedObjectContext:context];
                    
                    //Set fetchRequest entity to EventInfo Description
                    [fetchRequest setEntity:entity];
                    
                    //Set events array to data in core data
                    self.completedTaskDataArray = [context executeFetchRequest:fetchRequest error:&error];
                    
                    self.completedTasks = [[NSMutableArray alloc] initWithArray:self.completedTaskDataArray];
                    
                    
                    
                    
                }
                
            }else{
                
                //Why did it fail?
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            
            
        }else{
            self.completedTasks = [[NSMutableArray alloc] init];
        }
        
    }];
    
}

-(void)loadSubUnits
{
    
    [self deletedAllObjects:@"SubUnit"];
    PFQuery *results = [PFQuery queryWithClassName:@"SubUnits"];
    //[tenants whereKey:@"createdBy" equalTo:[PFUser currentUser]];
    [results orderByAscending:@"unitNumber"];
    
    [results findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            for(int i = 0; i <objects.count; i++){
                NSManagedObjectContext *context = [ApplicationDelegate managedObjectContext];
                
                SubUnit *unitInfo = [NSEntityDescription insertNewObjectForEntityForName:@"SubUnit" inManagedObjectContext:context];
                
                unitInfo.unitObjectId = [objects[i] valueForKey:@"objectId"];
                
                unitInfo.unitNumber = [objects[i] valueForKey:@"unitNumber"];
                unitInfo.parentPropId = [objects[i] valueForKey:@"parentProp"];
                
                NSError * error;
                if(![context save:&error])
                {
                    NSLog(@"Failed to save: %@", [error localizedDescription]);
                }
                
                //Create new Fetch Request
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                
                //Request Entity EventInfo
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"SubUnit" inManagedObjectContext:context];
                
                //Set fetchRequest entity to EventInfo Description
                [fetchRequest setEntity:entity];
                
                //Set events array to data in core data
                self.subUnitDataArray = [context executeFetchRequest:fetchRequest error:&error];
                
                self.subUnitArray = [[NSMutableArray alloc] initWithArray:self.subUnitDataArray];
                
                
            }
            
            
        }else{
            
            //Why did it fail?
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
    }];
    
}

-(void)loadFinancials
{
    
    [self deletedAllObjects:@"Financials"];
    PFQuery *results = [PFQuery queryWithClassName:@"Financials"];
    //[tenants whereKey:@"createdBy" equalTo:[PFUser currentUser]];
    [results orderByDescending:@"date"];
    
    [results findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            for(int i = 0; i <objects.count; i++){
                NSManagedObjectContext *context = [ApplicationDelegate managedObjectContext];
                
                
                Financials *financial = [NSEntityDescription insertNewObjectForEntityForName:@"Financials" inManagedObjectContext:context];
                
                
                financial.itemName = [objects[i] valueForKey:@"itemName"];
                financial.parentId = [objects[i] valueForKey:@"parentId"];
                financial.type = [objects[i] valueForKey:@"type"];
                financial.date = [objects[i] valueForKey:@"date"];
                financial.fAmount = [[objects[i] valueForKey:@"amount"] floatValue];
                financial.category = [objects[i] valueForKey:@"category"];
                financial.fDescription = [objects[i] valueForKey:@"expDescription"];
                financial.finObjectId = [objects[i] valueForKey:@"objectId"];
                
                
                
                NSError * error;
                if(![context save:&error])
                {
                    NSLog(@"Failed to save: %@", [error localizedDescription]);
                }
                
                //Create new Fetch Request
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                
                //Request Entity TaskInfo
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Financials" inManagedObjectContext:context];
                
                //Set fetchRequest entity to EventInfo Description
                [fetchRequest setEntity:entity];
                
                //Set events array to data in core data
                self.financesDataArray = [context executeFetchRequest:fetchRequest error:&error];
                
                self.financesArray = [[NSMutableArray alloc] initWithArray:self.financesDataArray];
                
                
                
                NSLog(@"Financial Data == %@", self.financesArray.description);
            }
            
        }else{
            
            //Why did it fail?
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        
        
        
    }];
    
    
    
}

#pragma mark
#pragma mark - Delete Core Data

//Delete Property Objects before Loading New
-(void)deletedAllObjects: (NSString*) entityDescription{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:self.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *objectItems = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in objectItems) {
        
        [self.managedObjectContext deleteObject:managedObject];
        
        NSLog(@"%@ object deleted", entityDescription);
        
    }
    if (![self.managedObjectContext save:&error]) {
        NSLog(@"Error Deleting object %@ - Error %@", entityDescription, error);
    }
}

#pragma mark
#pragma mark - Save Context
//CoreData save method
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


#pragma mark
#pragma mark - DrobBox Methods

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            
            UIAlertView *linkedAlert = [[UIAlertView alloc] initWithTitle:@"Dropbox Linked!" message:@"You Dropbox has been linked with MyLandlord." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstLaunch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [linkedAlert show];
        } else {
            NSLog(@"Dropbox Login Cancelled!");
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}

#pragma mark
#pragma mark - Core Data stack
// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_managedObjectContext performBlockAndWait:^{
            [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        }];
        
    }
    return _managedObjectContext;
}

// Return the NSManagedObjectContext to be used in the background during sync
- (NSManagedObjectContext *)backgroundManagedObjectContext {
    if (_backgroundManagedObjectContext != nil) {
        return _backgroundManagedObjectContext;
    }
    
    NSManagedObjectContext *managedContext = [self managedObjectContext];
    if (managedContext != nil) {
        _backgroundManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [_backgroundManagedObjectContext performBlockAndWait:^{
            [_backgroundManagedObjectContext setParentContext:managedContext];
        }];
    }
    
    return _backgroundManagedObjectContext;
}


// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"MyLandlord" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MyLandlordData3.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

//
//  MLTenantsViewController.h
//  MyLandlord
//
//  Created by Dale Tupling on 11/17/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Tenants.h"

@interface MLTenantsViewController : UIViewController <UITableViewDataSource>


@property(nonatomic, strong)Tenants *aTenantsInfo;
@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;

@end

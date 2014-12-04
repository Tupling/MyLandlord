//
//  SecondViewController.h
//  MyLandlord
//
//  Created by Dale Tupling on 11/17/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Properties.h"
#import "Tenants.h"
#import "AppDelegate.h"


@interface MLPropertiesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property(nonatomic, strong) IBOutlet UITableView *tableView;

@property(nonatomic, strong)NSMutableArray *properties;
@property(nonatomic, strong)Properties *propInfo;
@property(nonatomic, strong)Tenants *tenantInfo;

@end


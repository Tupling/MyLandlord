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
#import "Properties.h"

@interface MLTenantsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UILabel *tenantName;
    IBOutlet UILabel *tenantNumber;
    IBOutlet UILabel *propAddress;
    IBOutlet UILabel *propName;
}


@property(nonatomic, strong)Tenants *aTenantsInfo;

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) NSArray *tenants;


@end

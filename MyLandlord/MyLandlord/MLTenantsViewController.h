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

@interface MLTenantsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UILabel *pName;
    IBOutlet UILabel *pNumber;
    IBOutlet UILabel *pAddress;
}


@property(nonatomic, strong)Tenants *aTenantsInfo;

@property(nonatomic, strong) IBOutlet UITableView *tableView;

//Local Methods
-(void)loadData;
@end

//
//  MLPropertyUnits.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/9/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Properties.h"
#import "AppDelegate.h"
#import "SubUnit.h"

@interface MLPropertyUnits : UIViewController

@property(nonatomic, strong)IBOutlet UITableView *tableView;
@property(nonatomic, strong)Properties *propDetails;

@end

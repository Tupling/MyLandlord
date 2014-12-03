//
//  MLPropertyExpenses.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/2/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLPropertyExpenses : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

@property(nonatomic, strong) IBOutlet UITableView *tableView;

@end

//
//  TasksMain.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/5/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "AppDelegate.h"
#import "MLTaskDetails.h"
#import "Properties.h"
#import "Tasks.h"


@interface TasksMain : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UITableView *tableView;

@property(nonatomic, strong)Properties *propInfo;

@property(nonatomic, strong)Tasks *taskInfo;

@end

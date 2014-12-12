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

//Core Data
@property(nonatomic, strong) NSManagedObjectContext *context;
@property(nonatomic, strong) NSFetchRequest *fetchRequest;
@property(nonatomic, strong) NSEntityDescription *taskEntity;
@property(nonatomic, strong) NSPredicate *predicate;


//UI Elements
@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet UISegmentedControl *taskSelection;


//Classes
@property(nonatomic, strong)Properties *propInfo;
@property(nonatomic, strong)Tasks *taskInfo;


//Data elements
@property (nonatomic, retain) NSMutableArray *inCompleteTasks;
@property (nonatomic, retain) NSMutableArray *completedTasks;


//Methods

-(IBAction)indexChanged:(UISegmentedControl *)segmentedControl;

@end

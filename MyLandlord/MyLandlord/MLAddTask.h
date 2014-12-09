//
//  MLAddTask.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/5/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "Properties.h"

@interface MLAddTask : UIViewController


@property (nonatomic, retain) IBOutlet UITextField *taskName;
@property (nonatomic, retain) IBOutlet UITextField *taskPriority;
@property (nonatomic, strong) IBOutlet UITextField *dueDateTF;
@property (nonatomic, strong) IBOutlet UITextField *taskDesc;

@property (nonatomic, strong) IBOutlet UITextField *assignProperty;
@property (nonatomic, strong) IBOutlet UIDatePicker *dueDatePicker;
@property (nonatomic, strong) IBOutlet UIPickerView *priorityPicker;
@property (nonatomic, strong) IBOutlet UIPickerView *propertyPicker;

@property(nonatomic, strong) IBOutlet UIButton *saveTask;

@end

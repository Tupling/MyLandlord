//
//  MLTaskDetails.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/10/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Properties.h"
#import "Tasks.h"

@interface MLTaskDetails : UIViewController

@property(nonatomic, strong) IBOutlet UILabel *taskNameLbl;
@property(nonatomic, strong) IBOutlet UILabel *taskDueDateLbl;
@property(nonatomic, strong) IBOutlet UILabel *assignedPropertyLbl;
@property(nonatomic, strong) IBOutlet UILabel *taskPriorityLbl;

@property(nonatomic, strong) IBOutlet UITextView *taskDescriptionTv;

@property(nonatomic, strong) IBOutlet UIButton *checkComplete;

@property(nonatomic, strong)Tasks *taskDetails;
@property(nonatomic, strong)Properties *propDetails;

@end

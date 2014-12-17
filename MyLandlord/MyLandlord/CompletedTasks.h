//
//  CompletedTasks.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/17/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CompletedTasks : NSManagedObject

@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * dueDate;
@property (nonatomic, retain) NSNumber * isComplete;
@property (nonatomic, retain) NSString * priority;
@property (nonatomic, retain) NSString * propId;
@property (nonatomic, retain) NSString * task;
@property (nonatomic, retain) NSString * taskDescription;
@property (nonatomic, retain) NSString * taskId;

@end

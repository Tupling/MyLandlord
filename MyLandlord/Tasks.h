//
//  Tasks.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/5/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Tasks : NSManagedObject

@property (nonatomic, retain) NSString * taskId;
@property (nonatomic, retain) NSString * task;
@property (nonatomic, retain) NSNumber * isComplete;
@property (nonatomic, retain) NSString * priority;
@property (nonatomic, retain) NSString * taskDescription;
@property (nonatomic, retain) NSDate * createdDate;
@property (nonatomic, retain) NSDate * dueDate;

@end

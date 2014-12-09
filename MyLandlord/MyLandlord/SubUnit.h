//
//  SubUnit.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/9/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface SubUnit : NSManagedObject

@property (nonatomic, retain) NSString * unitObjectId;
@property (nonatomic, retain) NSString * parentPropId;
@property (nonatomic, retain) NSString * unitNumber;

@end

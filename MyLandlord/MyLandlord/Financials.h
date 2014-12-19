//
//  Financials.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/14/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Financials : NSManagedObject

@property (nonatomic, retain) NSString * parentId;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic) float  fAmount;
@property (nonatomic, retain) NSString * category;
@property (nonatomic, retain) NSString * fDescription;
@property (nonatomic, retain) NSString * itemName;
@property (nonatomic, retain) NSString * finObjectId;


@end

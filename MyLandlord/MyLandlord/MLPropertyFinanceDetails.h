//
//  MLPropertyFinanceDetails.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/18/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Financials.h"
#import "Properties.h"
#import "SubUnit.h"

@interface MLPropertyFinanceDetails : UIViewController

@property (nonatomic, strong) IBOutlet UILabel *finNameHeader;

@property (nonatomic, strong) IBOutlet UILabel *propertyName;
@property (nonatomic, strong) IBOutlet UILabel *finDate;
@property (nonatomic, strong) IBOutlet UILabel *finAmount;
@property (nonatomic, strong) IBOutlet UILabel *finCategory;
@property (nonatomic, strong) IBOutlet UILabel *finDescription;



@property(nonatomic)Financials *finDetails;
@property(nonatomic)Properties *propDetails;
@property(nonatomic)SubUnit *subDetails;
@end

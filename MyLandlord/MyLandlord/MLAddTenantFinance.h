//
//  MLAddTenantFinance.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/14/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "Tenants.h"


@interface MLAddTenantFinance : UIViewController

@property(nonatomic, strong)Tenants * details;


@property(nonatomic, strong)IBOutlet UIButton * saveExpense;

@property(nonatomic, strong)IBOutlet UITextField *tenantName;
@property(nonatomic, strong)IBOutlet UITextField *expAmount;
@property(nonatomic, strong)IBOutlet UITextField *expDate;
@property(nonatomic, strong)IBOutlet UITextField *expCategory;
@property(nonatomic, strong)IBOutlet UITextField *expDescription;
@property(nonatomic, strong)IBOutlet UITextField *itemName;

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;




@end

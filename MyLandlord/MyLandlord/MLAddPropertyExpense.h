//
//  MLAddPropertyExpense.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/11/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Properties.h"
#import "SubUnit.h"

@interface MLAddPropertyExpense : UIViewController

@property(nonatomic, strong)Properties * details;

@property(nonatomic, strong)SubUnit * subUnitDetails;

@property(nonatomic, strong)IBOutlet UIButton * saveExpense;

@property(nonatomic, strong)IBOutlet UITextField *propertyName;
@property(nonatomic, strong)IBOutlet UITextField *expAmount;
@property(nonatomic, strong)IBOutlet UITextField *expDate;
@property(nonatomic, strong)IBOutlet UITextField *expCategory;
@property(nonatomic, strong)IBOutlet UITextField *expDescription;

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, strong) IBOutlet UIPickerView *catPicker;

@property (nonatomic, strong) NSString * parentPropId;

@end

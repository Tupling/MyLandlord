//
//  MLAddTenantViewController.h
//  MyLandlord
//
//  Created by Dale Tupling on 11/19/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"
#import "Tenants.h"

@interface MLAddTenantViewController : UIViewController
{
    IBOutlet UITextField *pFirstName;
    IBOutlet UITextField *pLastName;
    IBOutlet UITextField *pEmail;
    IBOutlet UITextField *pPhoneNumber;
    
    IBOutlet UITextField *sFirstName;
    IBOutlet UITextField *sLastName;
    IBOutlet UITextField *sEmail;
    IBOutlet UITextField *sPhoneNumber;
    
}

//Tenant Information
@property (nonatomic, retain) IBOutlet UITextField *pFirstName;
@property (nonatomic, retain) IBOutlet UITextField *pLastName;
@property (nonatomic, strong) IBOutlet UITextField *pEmail;
@property (nonatomic, strong) IBOutlet UITextField *pPhoneNumber;

//Lease Information
@property (nonatomic, retain) IBOutlet UITextField *leaseStartTF;
@property (nonatomic, retain) IBOutlet UITextField *leaseEndTF;
@property (nonatomic, strong) IBOutlet UITextField *rentDueTF;
@property (nonatomic, strong) IBOutlet UITextField *rentTotalTF;

@property (nonatomic, retain) IBOutlet UIButton *addTenant;
@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, strong) IBOutlet UITextField *assignProperty;
@property (nonatomic, strong) IBOutlet UIPickerView *assignPropPicker;
@property (nonatomic, strong) IBOutlet UIPickerView *dueDayPicker;


@property (nonatomic, retain) NSArray *dayArray;

@property (nonatomic, strong)Tenants *details;




-(IBAction)saveTenant:(id)sender;



@end

//
//  MLAddTenantViewController.h
//  MyLandlord
//
//  Created by Dale Tupling on 11/19/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

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


@property (nonatomic, retain) IBOutlet UITextField *pFirstName;
@property (nonatomic, retain) IBOutlet UITextField *pLastName;
@property (nonatomic, strong) IBOutlet UITextField *pEmail;
@property (nonatomic, strong) IBOutlet UITextField *pPhoneNumber;

@property (nonatomic, retain) IBOutlet UITextField *sFirstName;
@property (nonatomic, retain) IBOutlet UITextField *sLastName;
@property (nonatomic, strong) IBOutlet UITextField *sEmail;
@property (nonatomic, strong) IBOutlet UITextField *sPhoneNumber;

@property (nonatomic, retain) IBOutlet UIButton *addTenant;


-(IBAction)cancel:(id)sender;

-(IBAction)saveTenant:(id)sender;

@end

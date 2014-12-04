//
//  MLAddSecondTenantInfo.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/3/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "Tenants.h"
#import "AppDelegate.h"

@interface MLAddSecondTenantInfo : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *firstName;
@property (nonatomic, retain) IBOutlet UITextField *lastName;
@property (nonatomic, strong) IBOutlet UITextField *email;
@property (nonatomic, strong) IBOutlet UITextField *phoneNumber;

@property (nonatomic, retain) IBOutlet UIButton *saveInfo;

@property (nonatomic, strong)Tenants *details;

-(IBAction)saveInformation:(id)sender;

@end

//
//  MLTenantDetailsViewController.h
//  MyLandlord
//
//  Created by Dale Tupling on 11/21/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Tenants.h"


@interface MLTenantDetailsViewController : UIViewController
{
    IBOutlet UILabel *pTenantName;
    IBOutlet UILabel *pTenantPhone;
    IBOutlet UILabel *pTenantEmail;
    IBOutlet UILabel *sTenantName;
    IBOutlet UILabel *sTenantEmailButton;
    IBOutlet UILabel *sTenantphoneButton;
    IBOutlet UILabel *sTenantHeaderLabel;
    IBOutlet UILabel *leaseStartLabel;
    IBOutlet UILabel *leaseEndLabel;
    IBOutlet UILabel *rentDueLabel;

}

-(IBAction)closeView:(id)sender;

@property (nonatomic, strong)Tenants *details;
@property(nonatomic, strong) IBOutlet UIButton *viewDocs;
@property(nonatomic, strong) IBOutlet UIButton *viewFinance;

@property(nonatomic, strong) IBOutlet UIButton *addSecondTenant;

@property(nonatomic, strong) IBOutlet UIButton *phoneButton;
@property(nonatomic, strong) IBOutlet UIButton *emailButton;

@property(nonatomic, strong) IBOutlet UIButton *editPrimaryInfo;
@property(nonatomic, strong) IBOutlet UIButton *editSecondayInfo;

@property(nonatomic, strong) IBOutlet UIButton *sTenantphoneButton;
@property(nonatomic, strong) IBOutlet UIButton *sTenantEmailButton;

-(IBAction)makeCall:(id)sender;
-(IBAction)sendEmail:(id)sender;

@end

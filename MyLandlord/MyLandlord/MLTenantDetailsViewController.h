//
//  MLTenantDetailsViewController.h
//  MyLandlord
//
//  Created by Dale Tupling on 11/21/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

#import "Tenants.h"


@interface MLTenantDetailsViewController : UIViewController
{
    
    //Primary Tenant UI Items
    IBOutlet UILabel *pTenantName;
    IBOutlet UILabel *pTenantPhone;
    IBOutlet UILabel *pTenantEmail;
    
    //Secondary Tenant UI Items
    IBOutlet UILabel *sTenantName;
    IBOutlet UIButton *sTenantEmailButton;
    IBOutlet UIButton *sTenantphoneButton;
    IBOutlet UILabel *sTenantEmailHeader;
    IBOutlet UILabel *sTenantPhoneHeader;
    IBOutlet UILabel *sTenantHeaderLabel;
    
    //Lease UI Items
    IBOutlet UILabel *leaseStartLabel;
    IBOutlet UILabel *leaseEndLabel;
    IBOutlet UILabel *rentDueLabel;
    


}

//Properties

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

@property(nonatomic, strong) IBOutlet UILabel *sTenantPhoneHeader;
@property(nonatomic, strong) IBOutlet UILabel *sTenantEmailHeader;


//Methods
-(IBAction)makeCall:(id)sender;
-(IBAction)sendEmail:(id)sender;

-(IBAction)viewDocuments:(id)sender;
-(IBAction)editDetails:(id)sender;

@end

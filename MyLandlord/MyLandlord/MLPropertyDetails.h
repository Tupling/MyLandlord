//
//  MLPropertyDetails.h
//  MyLandlord
//
//  Created by Dale Tupling on 11/21/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Properties.h"
#import "Tenants.h"
#import "SubUnit.h"

@interface MLPropertyDetails : UIViewController
{
    IBOutlet UILabel *propAddress;
    IBOutlet UILabel *tenantInfo;
    IBOutlet UILabel *leaseInfo;
    IBOutlet UILabel *rentStatus;
}

-(IBAction)editDetails:(id)sender;

@property (nonatomic, strong)Properties *details;
@property (nonatomic, strong)Tenants    *tenantDetails;
@property (nonatomic, strong)SubUnit    *subUnitDetails;




@end

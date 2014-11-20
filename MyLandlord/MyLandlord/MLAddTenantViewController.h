//
//  MLAddTenantViewController.h
//  MyLandlord
//
//  Created by Dale Tupling on 11/19/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>

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

-(IBAction)cancel:(id)sender;

@end

//
//  MLAddTenantViewController.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/19/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLAddTenantViewController.h"

@interface MLAddTenantViewController () <UIAlertViewDelegate, UITextFieldDelegate>
{
    UIAlertView *savedAlert;
}

@end

@implementation MLAddTenantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //DISMISS KEYBOARD
    //Tap screen to make keyboard disappear
    UITapGestureRecognizer *tapOnScreen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDisappear)];
    
    //set to NO, so not all touches are cancelled. If set to YES User will not be able to touch ShowDate or Info Buttons
    tapOnScreen.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapOnScreen];
    
    //TODO Check if user is editing Tenant Information
    
}

//Function for Gesture tapOnScreen
- (void) keyboardDisappear {
    
    [self.view endEditing:YES];
}

// Dismiss Modal View
-(IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//Save Tenant Information to DB
-(IBAction)saveTenant:(id)sender
{
    
    //TODO ADD NETWORK CONNECTION CHECK
    
 
    
    
    
    
    PFObject *tenant = [PFObject objectWithClassName:@"Tenants"];
    
    tenant[@"pFirstName"] = self.pFirstName.text;
    tenant[@"pLastName"] = self.pLastName.text;
    tenant[@"pEmail"] = self.pEmail.text;
    tenant[@"pPhoneNumber"] = self.pPhoneNumber.text;
    
    
    
    //TODO Check if Second Tenant is Present//
    
    
    
    tenant[@"sFirstName"] = self.sFirstName.text;
    tenant[@"sLastName"] = self.sLastName.text;
    tenant[@"sEmail"] = self.sEmail.text;
    tenant[@"sPhoneNumber"] = self.sPhoneNumber.text;
    
    
    //ONLY ALLOW CURRENT USER TO VIEW
    
    //Set Access control to user logged in
    tenant.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    //Set object to current user (makes it easier to get the data for tables)
    [tenant setObject:[PFUser currentUser] forKey:@"createdBy"];
    
    [tenant saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded)
        {
            
            savedAlert = [[UIAlertView alloc] initWithTitle:@"Tenant Saved" message:@"The tenant has been saved to your portfolio!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [savedAlert show];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            

        }
        else
        {
            savedAlert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"There was an error trying to save the tenant information!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [savedAlert show];
            
        }
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

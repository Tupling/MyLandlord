//
//  MLAddSecondTenantInfo.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/3/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLAddSecondTenantInfo.h"
#import "MLTenantsViewController.h"


@interface MLAddSecondTenantInfo () <UIAlertViewDelegate>
{
    UIAlertView *updatedAlert;
}

@end

@implementation MLAddSecondTenantInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set Nav Bar Image
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,45)] ;
    [image setImage:[UIImage imageNamed:@"MyLandlord.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = image;
    
    
   self.saveInfo.layer.cornerRadius = 5;
    
    if (![[self.details valueForKey:@"sFirstName"]  isEqual: @""]) {
        self.firstName.text = _details.sFirstName;
        self.lastName.text = _details.sLastName;
        self.email.text = _details.sEmail;
        self.phoneNumber.text = _details.sPhoneNumber;
    }
    
    //DISMISS KEYBOARD
    //Tap screen to make keyboard disappear
    UITapGestureRecognizer *tapOnScreen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDisappear)];
    
    //set to NO, so not all touches are cancelled. If set to YES User will not be able to touch ShowDate or Info Buttons
    tapOnScreen.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapOnScreen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveInformation:(id)sender
{
    PFQuery *query = [PFQuery queryWithClassName:@"Tenants"];
    
    [query getObjectInBackgroundWithId:_details.tenantId block:^(PFObject *tenant, NSError *error) {
        
        
            tenant[@"sFirstName"] = self.firstName.text;
            tenant[@"sLastName"] = self.lastName.text;
            tenant[@"sEmail"] = self.email.text;
            tenant[@"sPhoneNumber"] = self.phoneNumber.text;
            
        [tenant saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded)
            {
                
                updatedAlert = [[UIAlertView alloc] initWithTitle:@"Tenant Saved" message:@"The tenant information has been saved to your portfolio!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [updatedAlert show];
                
          
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [ApplicationDelegate loadTenants];
                    
                    
                    
                });
             
                
            } else {
                
                updatedAlert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"There was an error trying to save the tenant information!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [updatedAlert show];
                
            }
        }];
  
    }];
}

#pragma mark - AlertView Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if([alertView isEqual:updatedAlert]){
        
        if (buttonIndex == 0) {
            NSLog(@"Closed Warning");
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }
    }
    
}

//Function for Gesture tapOnScreen
- (void) keyboardDisappear {
    
    [self.view endEditing:YES];
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

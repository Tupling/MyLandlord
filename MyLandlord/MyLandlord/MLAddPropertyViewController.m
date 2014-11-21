//
//  MLAddPropertyViewController.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/19/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLAddPropertyViewController.h"

@interface MLAddPropertyViewController () <UIAlertViewDelegate, UITextFieldDelegate>
{
    UIAlertView *savedAlert;
}

@end

@implementation MLAddPropertyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//Dismiss View
-(IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveProp:(id)sender
{
    PFObject *property = [PFObject objectWithClassName:@"Properties"];
    
    property[@"propName"] = self.propName.text;
    property[@"propAddress"] = self.propAddress.text;
    property[@"propCity"] = self.propCity.text;
    property[@"propState"] = self.propState.text;
    property[@"propZip"] = self.propZip.text;
    
    
    
    
    //ONLY ALLOW CURRENT USER TO VIEW
    
    //Set Access control to user logged in
    property.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    //Set object to current user (makes it easier to get the data for tables)
    [property setObject:[PFUser currentUser] forKey:@"createdBy"];
    
    [property saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded)
        {
            
            savedAlert = [[UIAlertView alloc] initWithTitle:@"Property Saved" message:@"Property has been saved to your portfolio!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [savedAlert show];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            
        }
        else
        {
            savedAlert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"There was an error trying to save the property information!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [savedAlert show];
            
        }
    }];

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

//
//  MLAddUnits.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/9/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLAddUnits.h"

@interface MLAddUnits () <DBRestClientDelegate, UIAlertViewDelegate>
{
    UIAlertView *savedAlert;
}

@end

@implementation MLAddUnits

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Set Nav Bar Image
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,45)] ;
    [image setImage:[UIImage imageNamed:@"MyLandlord.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = image;
    
    self.saveUnit.layer.cornerRadius = 5;
    //DropBox
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
    self.propertyName.text = [NSString stringWithFormat:@"Add Unit to %@", self.propDetails.propName];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)saveUnit:(id)sender
{
    if([self validateUnitNumber:self.unitId.text]){
        PFObject *property = [PFObject objectWithClassName:@"SubUnits"];
        
        property[@"parentProp"] = self.propDetails.propertyId;
        property[@"unitNumber"] = self.unitId.text;
        
        
        
        //Set Access control to user logged in
        property.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
        
        //Set object to current user (makes it easier to get the data for tables)
        [property setObject:[PFUser currentUser] forKey:@"createdBy"];
        
        [[self restClient] createFolder:[NSString stringWithFormat:@"/Properties/%@/%@", self.propDetails.propName, self.unitId.text]];
        
        
        [property saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded)
            {
                
                
                
                savedAlert = [[UIAlertView alloc] initWithTitle:@"Unit Saved" message:[NSString stringWithFormat:@"Unit has been saved to %@", self.propDetails.propName] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    [ApplicationDelegate loadSubUnits];
                    
                    
                });
                [savedAlert show];
                
                
            }
            else
            {
                savedAlert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"There was an error trying to save the property information!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [savedAlert show];
                
            }
        }];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Unit Identifier" message:@"Unit identifier cannot be left blank or contain special characters!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}
// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -Validation Methods
-(BOOL)validateUnitNumber:(NSString*)unitNumber
{
    if(unitNumber.length != 0){
        
        NSString *validCharacters = @"^[a-zA-Z0-9]*$";
        NSPredicate *validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validCharacters];
        
        return [validate evaluateWithObject:unitNumber];
    }else {
        

        return NO;
    }
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

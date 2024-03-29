//
//  MLAddPropertyViewController.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/19/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLAddPropertyViewController.h"

@interface MLAddPropertyViewController () <UIAlertViewDelegate, UITextFieldDelegate, DBRestClientDelegate>
{
    UIAlertView *savedAlert;
    
    BOOL multiFamilyState;
    BOOL isMultiFamily;
    
    
}


@end

@implementation MLAddPropertyViewController

@synthesize propZip, propState, propCity, propAddress, propName, addProp;



#pragma mark - View Load Methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //DropBox
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
    //Set Nav Bar Image
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,45)] ;
    [image setImage:[UIImage imageNamed:@"MyLandlord.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = image;
    
    
    self.addProp.layer.cornerRadius = 5;
    
    
    if(self.details !=nil){
        self.propName.text = self.details.propName;
        self.propAddress.text = self.details.propAddress;
        self.propCity.text = self.details.propCity;
        self.propState.text = self.details.propState;
        self.propZip.text = self.details.propZip;
        
        self.multiFamily.enabled = NO;
        
        if (self.details.multiFamily == 1) {
            
            [self.multiFamily setOn:YES animated:NO];
            isMultiFamily = YES;
            self.noLabel.hidden = YES;
            self.yesLabel.hidden = NO;
        }else{
            
            [self.multiFamily setOn:NO animated:YES];
            isMultiFamily = NO;
            self.noLabel.hidden = NO;
            self.yesLabel.hidden = YES;
            
        }
    }
    
    //DISMISS KEYBOARD
    //Tap screen to make keyboard disappear
    UITapGestureRecognizer *tapOnScreen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDisappear)];
    
    //set to NO, so not all touches are cancelled. If set to YES User will not be able to touch ShowDate or Info Buttons
    tapOnScreen.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapOnScreen];
    
}


#pragma mark - Cancel Method

//Dismiss View
-(IBAction)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Sitch Method
//MultiFamily toggle action method
-(IBAction)multFamilyToggle:(id)sender
{
    
    //if toggle is on set to off
    if (self.multiFamily.on) {
        
        isMultiFamily = YES;
        
        self.noLabel.hidden = YES;
        self.yesLabel.hidden = NO;
        
        
        //if toggle is off set to on
    }else {
        
        [self.multiFamily setOn:NO animated:YES];
        
        isMultiFamily = NO;
        self.noLabel.hidden = NO;
        self.yesLabel.hidden = YES;
    }
    
}



#pragma mark - Save Property

//Save property action button
-(IBAction)saveProp:(id)sender
{
    BOOL validInput = [self validateFields];
    if(validInput){
        
        if(self.details != nil){
            
            
            PFQuery *query = [PFQuery queryWithClassName:@"Properties"];
            
            [query getObjectInBackgroundWithId:self.details.propertyId block:^(PFObject *property, NSError *error) {
                
                property[@"propName"] = self.propName.text;
                property[@"propAddress"] = self.propAddress.text;
                property[@"propCity"] = self.propCity.text;
                property[@"propState"] = self.propState.text;
                property[@"propZip"] = self.propZip.text;
                property[@"isMultiFamily"] = [NSNumber numberWithBool:isMultiFamily];
                
                [property saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded)
                    {
                        
                        savedAlert = [[UIAlertView alloc] initWithTitle:@"Property Saved" message:@"Property has been saved to your portfolio!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        
                        
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            
                            [ApplicationDelegate loadProperties];
                            
                            
                            
                        });
                        
                        [savedAlert show];
                        
                        
                    }
                    else
                    {
                        savedAlert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"There was an error trying to save the property information!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        
                        [savedAlert show];
                        
                    }
                }];
                
            }];
            
        } else {
            
            PFObject *property = [PFObject objectWithClassName:@"Properties"];
            
            property[@"propName"] = self.propName.text;
            property[@"propAddress"] = self.propAddress.text;
            property[@"propCity"] = self.propCity.text;
            property[@"propState"] = self.propState.text;
            property[@"propZip"] = self.propZip.text;
            property[@"isMultiFamily"] = [NSNumber numberWithBool:isMultiFamily];
            
            
            //Set Access control to user logged in
            property.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            //Set object to current user (makes it easier to get the data for tables)
            [property setObject:[PFUser currentUser] forKey:@"createdBy"];
            
            [property saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded)
                {
                    
                    [[self restClient] createFolder:[NSString stringWithFormat:@"/Properties/%@", self.propName.text]];
                    
                    
                    
                    savedAlert = [[UIAlertView alloc] initWithTitle:@"Property Saved" message:@"Property has been saved to your portfolio!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        [ApplicationDelegate loadProperties];
                        
                        
                        
                    });
                    
                    [savedAlert show];
                    
                    
                }
                else
                {
                    savedAlert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"There was an error trying to save the property information!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [savedAlert show];
                    
                }
            }];
        }
    }
    
}

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0){
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//Function for Gesture tapOnScreen
- (void) keyboardDisappear {
    
    [self.view endEditing:YES];
}
#pragma mark - Validation Methods
-(BOOL)validatePropName:(NSString*)name
{
    if(name.length != 0){
        
        NSString *validCharacters = @"^[a-zA-Z ]*$";
        NSPredicate *validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validCharacters];
        
        return [validate evaluateWithObject:name];
    } else {
        return NO;
    }
}

-(BOOL)validatePropAddress:(NSString*)address
{
    if(address.length != 0){
        
        NSString *validCharacters = @"^[0-9a-zA-Z. ]*$";
        NSPredicate *validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validCharacters];
        
        return [validate evaluateWithObject:address];
    }else {
        return NO;
    }
}

-(BOOL)validatePropCity:(NSString*)city
{
    if(city.length != 0){
        
        NSString *regExPattern = @"^[a-zA-Z ]*$";
        
        NSPredicate *validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExPattern];
        
        return [validate evaluateWithObject:city];
    }
    else {
        return NO;
    }
}
-(BOOL)validatePropState:(NSString*)state
{
    if(state.length != 0){
        
        NSString *validCharacters = @"^[A-Z]{2}$";
        NSPredicate *validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validCharacters];
        
        return [validate evaluateWithObject:state];
    }else {
        return NO;
    }
}
-(BOOL)validatePropZipCode:(NSString*)zip
{
    if(zip.length != 0){
        
        NSString *validCharacters = @"^[0-9]{5}$";
        NSPredicate *validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validCharacters];
        
        return [validate evaluateWithObject:zip];
    }else {
        return NO;
    }
}

-(BOOL)validateFields{
    
    BOOL nameValid = [self validatePropName:self.propName.text];
    BOOL addressValid = [self validatePropAddress:self.propAddress.text];
    BOOL cityValid = [self validatePropCity:self.propCity.text];
    BOOL stateValid = [self validatePropState:self.propState.text];
    BOOL zipValid = [self validatePropZipCode:self.propZip.text];
    
    
    if(!nameValid){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Property Name" message:@"Property Name cannot be left blank or contain special characters!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    } else if(!addressValid){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Address" message:@"Address cannot be left blank or contain special characters!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    } else if(!cityValid){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid City" message:@"City cannot be left blank or contain special characters!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
        
    }  else if(!stateValid){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid State" message:@"State must be abbreviated and cannot contain special characters!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }else if(!zipValid){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Zip Code" message:@"Zip must be 5 digits and cannot contain special character!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }
    
    else{
        return YES;
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

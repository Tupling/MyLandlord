//
//  MLAddTenantViewController.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/19/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLAddTenantViewController.h"
#import "Properties.h"

@interface MLAddTenantViewController () <UIAlertViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIAlertView *savedAlert;
    NSDate *leaseStart;
    NSDate *leaseEnd;
    
    NSString *assignPropertyID;
    
    BOOL secondTenantState;
    
    NSArray *dueDay;
    NSString *propertyNameString;
    BOOL noProperty;

}

@end

@implementation MLAddTenantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    noProperty = NO;
    
    if (self.details != nil) {
        self.pFirstName.text = _details.pFirstName;
        self.pLastName.text = _details.pLastName;
        self.pEmail.text = _details.pEmail;
        self.pPhoneNumber.text = _details.pPhoneNumber;
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
        
        self.leaseStartTF.text = [dateFormatter stringFromDate:_details.leaseStart];
        self.leaseEndTF.text = [dateFormatter stringFromDate:_details.leaseEnd];
        
        self.rentDueTF.text = [NSString stringWithFormat:@"%@", _details.dueDay];
        self.rentTotalTF.text = [NSString stringWithFormat:@"%@", _details.rentAmount];
        
        leaseEnd = _details.leaseEnd;
        leaseStart = _details.leaseStart;
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"propertyId == %@", _details.propertyId];
        NSArray *predicateResults = [ApplicationDelegate.propertyArray filteredArrayUsingPredicate:predicate];
        
        if (predicateResults.count > 0) {
            Properties *predicateProperty = [predicateResults objectAtIndex:0];
            
            NSLog(@"PREDICATE ARRAY = %@", predicateResults);
            
            propertyNameString = [predicateProperty valueForKey:@"propName"];
            assignPropertyID = [predicateProperty valueForKey:@"propertyId"];
            
            self.assignProperty.text = propertyNameString;
            
        } else {
            
            noProperty = YES;
        }

    
    } else if([[self.details valueForKey:@"pFirstName"]  isEqual: @""]){
    self.rentDueTF.text = @"";
    self.rentTotalTF.text = @"";
    }

    //Set Nav Bar Image
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,45)] ;
    [image setImage:[UIImage imageNamed:@"MyLandlord.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = image;
    
    //Month Day Array
  dueDay = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21,@22,@23,@24,@25,@26,@27,@28,@29,@30,@31];
    
    NSLog(@"DAY ARRAY Count :%lu", (unsigned long)dueDay.count);
    
    //DISMISS KEYBOARD
    //Tap screen to make keyboard disappear
    UITapGestureRecognizer *tapOnScreen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDisappear)];
    
    //set to NO, so not all touches are cancelled. If set to YES User will not be able to touch ShowDate or Info Buttons
    tapOnScreen.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapOnScreen];
    
    self.addTenant.layer.cornerRadius = 5;
    
    //Set textField delegates
    self.leaseStartTF.delegate = self;
    self.leaseEndTF.delegate = self;
    self.rentDueTF.delegate = self;
    self.assignProperty.delegate = self;
    
    self.assignPropPicker = [[UIPickerView alloc] init];
    self.assignPropPicker.delegate = self;
    self.assignPropPicker.dataSource = self;
    
    self.dueDayPicker = [[UIPickerView alloc] init];
    self.dueDayPicker.delegate = self;
    self.dueDayPicker.dataSource = self;
    
    

    

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
    NSLog(@"Tenant ID: %@", _details.tenantId);
    
       if (_details != nil) {
        
        PFQuery *query = [PFQuery queryWithClassName:@"Tenants"];
        
        [query getObjectInBackgroundWithId:_details.tenantId block:^(PFObject *tenant, NSError *error) {
            tenant[@"pFirstName"] = self.pFirstName.text;
            tenant[@"pLastName"] = self.pLastName.text;
            tenant[@"pEmail"] = self.pEmail.text;
            tenant[@"pPhoneNumber"] = self.pPhoneNumber.text;
            
            //Lease Information
            tenant[@"leaseStart"] = leaseStart;
            tenant[@"leaseEnd"] = leaseEnd;
            
            NSInteger rentValue = [self.rentTotalTF.text integerValue];
            
            tenant[@"rentTotal"] = [NSNumber numberWithInteger:rentValue];
            
            NSInteger rentDueDay = [self.rentDueTF.text integerValue];
            
            tenant[@"dueDay"] = [NSNumber numberWithInteger:rentDueDay];
            
            tenant[@"assignedPropId"] = assignPropertyID;
            
            if (secondTenantState) {
                BOOL secondTenantTrue = YES;
                tenant[@"secondTenant"] = [NSNumber numberWithBool:secondTenantTrue];
                
                
            }else{
                BOOL secondTenantTrue = NO;
                tenant[@"secondTenant"] = [NSNumber numberWithBool:secondTenantTrue];
            }
            
            [tenant saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded)
                {
                    
                    savedAlert = [[UIAlertView alloc] initWithTitle:@"Tenant Saved" message:@"The tenant has been saved to your portfolio!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [savedAlert show];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [ApplicationDelegate loadTenants];
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    });
                    
                } else {
                    
                    savedAlert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"There was an error trying to save the tenant information!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [savedAlert show];
                    
                }
            }];

            
        }];
           
       } else {
    
    PFObject *tenant = [PFObject objectWithClassName:@"Tenants"];

    
    tenant[@"pFirstName"] = self.pFirstName.text;
    tenant[@"pLastName"] = self.pLastName.text;
    tenant[@"pEmail"] = self.pEmail.text;
    tenant[@"pPhoneNumber"] = self.pPhoneNumber.text;
    
    //Lease Information
    tenant[@"leaseStart"] = leaseStart;
    tenant[@"leaseEnd"] = leaseEnd;
    
    NSInteger rentValue = [self.rentTotalTF.text integerValue];
    
    tenant[@"rentTotal"] = [NSNumber numberWithInteger:rentValue];
    
    NSInteger rentDueDay = [self.rentDueTF.text integerValue];
    
    tenant[@"dueDay"] = [NSNumber numberWithInteger:rentDueDay];
           
    tenant[@"assignedPropId"] = assignPropertyID;
    
    if (secondTenantState) {
        BOOL secondTenantTrue = YES;
        tenant[@"secondTenant"] = [NSNumber numberWithBool:secondTenantTrue];
        
        
    }else{
        BOOL secondTenantTrue = NO;
        tenant[@"secondTenant"] = [NSNumber numberWithBool:secondTenantTrue];
    }
    
    
    
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
            
            dispatch_async(dispatch_get_main_queue(), ^{
        
                [ApplicationDelegate loadTenants];
        
                    [self.navigationController popViewControllerAnimated:YES];
        
            });

        } else {
            
            savedAlert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"There was an error trying to save the tenant information!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [savedAlert show];
            
        }
    }];

       }
}

-(BOOL)validateInput
{

    
    return true;
}

//TextField BEGIN editing Methods
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.leaseStartTF] || [textField isEqual:self.leaseEndTF]) {
        
        //self.datePicker.hidden = NO;
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        textField.inputView = self.datePicker;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
        
        [self.datePicker addTarget:self action:@selector(addDate:) forControlEvents:UIControlEventValueChanged];
        if([textField isEqual:self.leaseEndTF]){
            leaseEnd = [self.datePicker date];
            self.leaseEndTF.text = [dateFormatter stringFromDate:leaseEnd];
        }else {
            leaseStart = [self.datePicker date];
            self.leaseStartTF.text = [dateFormatter stringFromDate:leaseStart];
        }
        
    }
    
    else if([textField isEqual:self.assignProperty]) {

        textField.inputView = self.assignPropPicker;
        
        if (ApplicationDelegate.propertyArray.count == 1) {
            
            assignPropertyID = [[ApplicationDelegate.propertyArray objectAtIndex:0] valueForKey:@"propertyId"];
            
            [self.assignProperty setText:[self pickerView:self.assignPropPicker titleForRow:[self.assignPropPicker selectedRowInComponent:0] forComponent:0]];
        }
        

        
        
        
    }
    else if([textField isEqual:self.rentDueTF]){
        
        textField.inputView = self.dueDayPicker;
        
    }
}


//DatePicker AddDate Method
-(IBAction)addDate:(UITextField *)textField
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    if (self.leaseStartTF.isEditing) {

        self.leaseStartTF.text = [dateFormatter stringFromDate:[self.datePicker date]];
        
        leaseStart = [self.datePicker date];
        
        NSLog(@"DATE %@", leaseStart);
        
    } else if(self.leaseEndTF.isEditing){
        
        self.leaseEndTF.text = [dateFormatter stringFromDate:[self.datePicker date]];
        
        leaseEnd = [self.datePicker date];
        
    }
}



// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if([pickerView isEqual:self.assignPropPicker]){
        
        return 1;
        
    } else if ([pickerView isEqual:self.dueDayPicker]) {
        
        return 1;
        
    } else {
        
        return 0;
    }
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([pickerView isEqual:self.assignPropPicker]){
        
        return [ApplicationDelegate.propertyArray count];
        
    } else if ([pickerView isEqual:self.dueDayPicker]) {
        
        return dueDay.count ;
        
    } else {
        
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if([pickerView isEqual:self.assignPropPicker]){
        
        Properties *property = [ApplicationDelegate.propertyArray objectAtIndex:row];
        
        [self.assignPropPicker selectedRowInComponent:0];
        
        
        return property.propName;
    
    }else if([pickerView isEqual:self.dueDayPicker]){
        
        NSString *dueDayNumber = [NSString stringWithFormat:@"%@", [dueDay objectAtIndex:row]];
        
        return dueDayNumber;
        
    } else {
        
        return nil;
    }

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([pickerView isEqual:self.assignPropPicker]){
        
        Properties *propertyInfo = [ApplicationDelegate.propertyArray objectAtIndex:row];
        [self.assignPropPicker selectedRowInComponent:0];
   
        
        [self.assignProperty setText:[self pickerView:self.assignPropPicker titleForRow:[self.assignPropPicker selectedRowInComponent:0] forComponent:0]];
        
        assignPropertyID = propertyInfo.propertyId;
        
        NSLog(@"%@", assignPropertyID);
        
    } else if([pickerView isEqual:self.dueDayPicker]){
        
        [self.dueDayPicker selectedRowInComponent:0];
        
        [self.rentDueTF setText:[self pickerView:self.dueDayPicker titleForRow:[self.dueDayPicker selectedRowInComponent:0] forComponent:0]];
        
    }
    

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

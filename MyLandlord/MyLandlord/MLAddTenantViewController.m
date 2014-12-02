//
//  MLAddTenantViewController.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/19/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLAddTenantViewController.h"

@interface MLAddTenantViewController () <UIAlertViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    UIAlertView *savedAlert;
    NSDate *leaseStart;
    NSDate *leaseEnd;
}

@end

@implementation MLAddTenantViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    //Set Nav Bar Image
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,45)] ;
    [image setImage:[UIImage imageNamed:@"MyLandlord.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = image;
    
    //Month Day Array
    self.dayArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31", nil];
    
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
    
    self.rentDuePicker.delegate = self;
    self.rentDuePicker.dataSource = self;
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
    
    //Lease Information
    tenant[@"leaseStart"] = leaseStart;
    tenant[@"leaseEnd"] = leaseEnd;
    
    NSInteger rentValue = [self.rentTotalTF.text integerValue];
    
    tenant[@"rentTotal"] = [NSNumber numberWithInteger:rentValue];
    
    
    

    
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


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.leaseStartTF] || [textField isEqual:self.leaseEndTF]) {
        
        //self.datePicker.hidden = NO;
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        textField.inputView = self.datePicker;
        [self.datePicker addTarget:self action:@selector(addDate:) forControlEvents:UIControlEventValueChanged];
        
        
    }
    else if ([textField isEqual:self.rentDueTF]){
     
        self.rentDuePicker = [[UIPickerView alloc] init];
        textField.inputView = self.rentDuePicker;
        
    }
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dayArray.count;
}


-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.dayArray[row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self.rentDueTF setText:[NSString stringWithFormat:@"%@ of the Motnh",[self pickerView:self.rentDuePicker titleForRow:[self.rentDuePicker selectedRowInComponent:1] forComponent:1]]];
}


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

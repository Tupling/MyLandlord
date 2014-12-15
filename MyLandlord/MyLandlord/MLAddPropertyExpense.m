//
//  MLAddPropertyExpense.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/11/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLAddPropertyExpense.h"

@interface MLAddPropertyExpense () <UIAlertViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIActionSheetDelegate>
{
    NSArray *catArray;
    
    NSDate *expenseDate;
    
    UIAlertView *savedAlert;
    UIAlertView *saveError;
}
@end

@implementation MLAddPropertyExpense

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set Nav Bar Image
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,45)] ;
    [image setImage:[UIImage imageNamed:@"MyLandlord.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = image;
    
    catArray = @[@"", @"Repair", @"Utility"];
    
    //TextField Delegate Declarations
    self.expCategory.delegate = self;
    self.expDate.delegate = self;
    
    
    //Button Radius
    self.saveExpense.layer.cornerRadius = 5;
    
    if(self.subUnitDetails != nil){
        
        self.propertyName.text = [NSString stringWithFormat:@"%@ - Unit %@", self.details.propName, self.subUnitDetails.unitNumber];
        
    } else {
        //Static Textfield Text Delcarations
        self.propertyName.text = self.details.propName;
        
    }
    
    
    //DISMISS KEYBOARD
    //Tap screen to make keyboard disappear
    UITapGestureRecognizer *tapOnScreen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDisappear)];
    
    //set to NO, so not all touches are cancelled. If set to YES User will not be able to touch ShowDate or Info Buttons
    tapOnScreen.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapOnScreen];
    
}

#pragma mark - Textfield Delegate Method
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.expCategory]) {
        
        
        [self.expCategory resignFirstResponder];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Type of Expense" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Repair", @"Utility", @"Cleaning", nil];
        actionSheet.tag = 20;
        [actionSheet showInView:self.view];
        actionSheet = nil;
        
    } else if ([textField isEqual:self.expDate]){
        
        
        self.datePicker = [[UIDatePicker alloc] init];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        textField.inputView = self.datePicker;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
        
        expenseDate = [self.datePicker date];
        
        self.expDate.text = [dateFormatter stringFromDate:expenseDate];
        
        [self.datePicker addTarget:self action:@selector(addDate:) forControlEvents:UIControlEventValueChanged];
    }
    
}


#pragma mark - Date Methods
-(IBAction)addDate:(UITextField *)textField
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    if (self.expDate.isEditing) {
        
        self.expDate.text = [dateFormatter stringFromDate:[self.datePicker date]];
        
        expenseDate = [self.datePicker date];
        
    }
}

#pragma mark - Picker View
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if([pickerView isEqual:self.catPicker]){
        
        return 1;
        
    } else {
        return 0;
    }
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([pickerView isEqual:self.catPicker]){
        
        return [catArray count];
        
    } else {
        
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if([pickerView isEqual:self.catPicker]){
        
        NSString *categoryString = [catArray objectAtIndex:row];
        
        [self.catPicker selectedRowInComponent:0];
        
        return categoryString;
        
    } else {
        
        return nil;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([pickerView isEqual:self.catPicker]){
        
        
        
        [self.catPicker selectedRowInComponent:0];
        
        
        [self.expCategory setText:[self pickerView:self.catPicker titleForRow:[self.catPicker selectedRowInComponent:0] forComponent:0]];
        
        
    }
    
    
}


#pragma mark - ActionSheet Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *selectedValue = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if (![selectedValue.lowercaseString isEqualToString:@"cancel"]) {
        
        
        switch (actionSheet.tag) {
                
            case 20:
                //20 = Category
                self.expCategory.text = selectedValue;
                
                break;
                
            default:
                
                break;
        }
        
    }
}


#pragma mark - Save Expense Method
-(IBAction)saveExpense:(id)sender
{
    
    
    PFObject *expense = [PFObject objectWithClassName:@"Financials"];
    
    float amountFloatValue = [self.expAmount.text floatValue];
    
    NSNumber *amount = [NSNumber numberWithFloat:amountFloatValue];
    
    expense[@"amount"] = amount;
    expense[@"type"] = @"Expense";
    expense[@"date"] = expenseDate;
    expense[@"category"] = self.expCategory.text;
    expense[@"expDescription"] = self.expDescription.text;
    expense[@"itemName"] = self.itemName.text;
    
    
    //Check if Expense is Related to SubUnit
    if(self.subUnitDetails !=nil){
        
    expense[@"parentId"] = self.subUnitDetails.unitObjectId;
        
    } else {
    
    expense[@"parentId"] = self.details.propertyId;
    }
    
    
    //ONLY ALLOW CURRENT USER TO VIEW
    //Set Access control to user logged in
    expense.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    //Set object to current user (makes it easier to get the data for tables)
    [expense setObject:[PFUser currentUser] forKey:@"createdBy"];
    
    
    [expense saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(succeeded)
        {
            
            savedAlert = [[UIAlertView alloc] initWithTitle:@"Expense Saved" message:@"Expense data has been saved!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [savedAlert show];
            
                        dispatch_async(dispatch_get_main_queue(), ^{
            
                            [ApplicationDelegate loadFinancials];
        

                        });
            
        } else {
            
            saveError = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"There was an error trying to save the expense data!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            
            [saveError show];
            
        }
    }];
    
}

#pragma mark - Alertview Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if([alertView isEqual:savedAlert]){
        
        if (buttonIndex == 0) {
            NSLog(@"Closed Warning");
            
            
             [self.navigationController popViewControllerAnimated:YES];
            
            
            
        }
    }
    if([alertView isEqual:savedAlert]){
        
        if (buttonIndex == 0) {
            NSLog(@"Closed Warning");
            
            [saveError dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
    
}

#pragma mark

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

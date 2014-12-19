//
//  MLAddTenantFinance.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/14/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLAddTenantFinance.h"

@interface MLAddTenantFinance ()<UIAlertViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>
{
    NSArray *catArray;
    
    NSDate *expenseDate;
    
    UIAlertView *savedAlert;
    UIAlertView *updateSaved;
    UIAlertView *saveError;
}

@end


@implementation MLAddTenantFinance

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set Nav Bar Image
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,45)] ;
    [image setImage:[UIImage imageNamed:@"MyLandlord.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = image;
    
    
    
    //TextField Delegate Declarations
    self.expCategory.delegate = self;
    self.expDate.delegate = self;
    
    
    //Button Radius
    self.saveExpense.layer.cornerRadius = 5;
    
    if(self.finDetails != nil){
        self.expAmount.text = [NSString stringWithFormat:@"%0.2f", self.finDetails.fAmount];
        self.expCategory.text = self.finDetails.category;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
        self.expDate.text = [dateFormatter stringFromDate:self.finDetails.date];
        expenseDate = self.finDetails.date;
        
        self.expDescription.text = self.finDetails.fDescription;
        self.itemName.text = self.finDetails.itemName;
        
    }
    
    
    self.tenantName.text = [NSString stringWithFormat:@"%@ %@", self.tenDetails.pFirstName, self.tenDetails.pLastName];
    
    
    
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
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Type of Finance" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Rent", @"Deposit", @"Other", nil];
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
    BOOL validInput = [self validateFields];
    
    if (validInput) {
        
        if(self.finDetails != nil){
            
            PFQuery *query = [PFQuery queryWithClassName:@"Financials"];
            
            [query getObjectInBackgroundWithId:self.finDetails.finObjectId block:^(PFObject *expense, NSError *error) {
                
                float amountFloatValue = [self.expAmount.text floatValue];
                
                NSNumber *amount = [NSNumber numberWithFloat:amountFloatValue];
                
                expense[@"amount"] = amount;
                expense[@"type"] = @"Income";
                expense[@"date"] = expenseDate;
                expense[@"category"] = self.expCategory.text;
                expense[@"expDescription"] = self.expDescription.text;
                expense[@"itemName"] = self.itemName.text;
                expense[@"parentId"] = self.tenDetails.tenantId;
                
                
                [expense saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded)
                    {
                        
                        updateSaved = [[UIAlertView alloc] initWithTitle:@"Expense Updated" message:@"Expense data has been updated!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        
                        
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [ApplicationDelegate loadFinancials];
                            
                            
                        });
                        
                        [updateSaved show];
                        
                    } else {
                        
                        saveError = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"There was an error trying to save the expense data!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        
                        [saveError show];
                        
                    }
                }];
                
            }];
            
            
            
        }else {
            
            PFObject *expense = [PFObject objectWithClassName:@"Financials"];
            
            float amountFloatValue = [self.expAmount.text floatValue];
            
            NSNumber *amount = [NSNumber numberWithFloat:amountFloatValue];
            
            expense[@"amount"] = amount;
            expense[@"type"] = @"Income";
            expense[@"date"] = expenseDate;
            expense[@"category"] = self.expCategory.text;
            expense[@"expDescription"] = self.expDescription.text;
            expense[@"itemName"] = self.itemName.text;
            expense[@"parentId"] = self.tenDetails.tenantId;
            
            
            
            //ONLY ALLOW CURRENT USER TO VIEW
            //Set Access control to user logged in
            expense.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
            
            //Set object to current user (makes it easier to get the data for tables)
            [expense setObject:[PFUser currentUser] forKey:@"createdBy"];
            
            
            [expense saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if(succeeded)
                {
                    
                    savedAlert = [[UIAlertView alloc] initWithTitle:@"Expense Saved" message:@"Expense data has been saved!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [ApplicationDelegate loadFinancials];
                        
                        
                    });
                    
                    [savedAlert show];
                    
                } else {
                    
                    saveError = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"There was an error trying to save the expense data!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [saveError show];
                    
                }
            }];
        }
    }
    
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
    if([alertView isEqual:updateSaved]){
        
        if (buttonIndex == 0) {
            NSLog(@"Closed Warning");
            
            NSArray *viewControllerArray = [self.navigationController viewControllers];
            
            [self.navigationController popToViewController:[viewControllerArray objectAtIndex:2] animated:YES];
            
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

#pragma mark - Validation Methods
-(BOOL)validateName:(NSString*)name
{
    if(name.length != 0){
        
        NSString *validCharacters = @"^[a-zA-Z ]*$";
        NSPredicate *validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validCharacters];
        
        return [validate evaluateWithObject:name];
    } else {
        return NO;
    }
}

-(BOOL)validateAmount:(NSString*)amount
{
    if(amount.length != 0){
        
        NSString *validCharacters = @"^[0-9.]*$";
        NSPredicate *validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", validCharacters];
        
        return [validate evaluateWithObject:amount];
    }else {
        return NO;
    }
}

-(BOOL)validateDescription:(NSString*)description
{
    if(description.length != 0){
        
        NSString *regExPattern = @"^[a-zA-Z. ]*$";
        
        NSPredicate *validate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regExPattern];
        
        return [validate evaluateWithObject:description];
    }
    else {
        return NO;
    }
}


-(BOOL)validateFields{
    
    BOOL nameValid = [self validateName:self.itemName.text];
    BOOL expenseValid = [self validateAmount:self.expAmount.text];
    BOOL descriptionValid = [self validateDescription:self.expDescription.text];
    
    
    
    if(!nameValid){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Finance Name" message:@"Finance Item Name cannot be left blank or contain special characters!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    } else if(!expenseValid){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Expense Amount" message:@"Expense Amount cannot be left blank or contain special characters except a period!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    } else if(!descriptionValid){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Desciprtion" message:@"Description cannot be left blank or contain special characters except a period!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
        
    }  else if(self.expDate.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Due Date" message:@"Due Date cannot be left blank!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        return NO;
    }else if(self.expCategory.text.length == 0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Category" message:@"Category cannot be left blank" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
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

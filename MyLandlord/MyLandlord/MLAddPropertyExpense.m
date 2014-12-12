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
}
@end

@implementation MLAddPropertyExpense

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    catArray = @[@"", @"Repair", @"Utility"];
    
    self.catPicker = [[UIPickerView alloc] init];
    self.catPicker.delegate = self;
    self.catPicker.dataSource = self;
    
    self.expCategory.delegate = self;
    
    self.saveExpense.layer.cornerRadius = 5;
    
    self.propertyName.text = self.details.propName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.expCategory]) {
        
        
        [self.expCategory resignFirstResponder];
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Type of Expense" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Repair", @"Utility", @"Cleaning", nil];
        actionSheet.tag = 20;
        [actionSheet showInView:self.view];
        actionSheet = nil;

    }
    
}

//-(IBAction)addDate:(UITextField *)textField
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
//    
//    if (self.dueDateTF.isEditing) {
//        
//        self.dueDateTF.text = [dateFormatter stringFromDate:[self.dueDatePicker date]];
//        
//        dueDate = [self.dueDatePicker date];
//        
//        // NSLog(@"DATE %@", leaseStart);
//        
//    }
//}

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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

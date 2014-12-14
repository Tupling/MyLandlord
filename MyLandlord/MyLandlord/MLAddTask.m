//
//  MLAddTask.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/5/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLAddTask.h"

@interface MLAddTask () <UIAlertViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

{
    UIAlertView *savedAlert;
    NSArray *priorityArray;
    
    NSString *assignPropertyID;
    
    NSDate *dueDate;
}

@end

@implementation MLAddTask

- (void)viewDidLoad {
    [super viewDidLoad];
    
    priorityArray = @[@"High", @"Medium", @"Low"];
    
    //TextField and UIPicker Delgate/DataSource Declaration
    self.dueDateTF.delegate = self;
    self.taskPriority.delegate = self;
    self.assignProperty.delegate = self;
    
    
    self.dueDatePicker = [[UIDatePicker alloc] init];
    self.dueDatePicker.datePickerMode = UIDatePickerModeDate;
    
    self.priorityPicker = [[UIPickerView alloc] init];
    self.priorityPicker.delegate = self;
    self.priorityPicker.dataSource = self;
    
    self.propertyPicker = [[UIPickerView alloc] init];
    self.propertyPicker.delegate = self;
    self.propertyPicker.dataSource = self;
    
    self.saveTask.layer.cornerRadius = 5;
    
    
    
    //DISMISS KEYBOARD
    //Tap screen to make keyboard disappear
    UITapGestureRecognizer *tapOnScreen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardDisappear)];
    tapOnScreen.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapOnScreen];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    //Set Nav Bar Image
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,45)] ;
    [image setImage:[UIImage imageNamed:@"MyLandlord.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = image;
    
    //[self.tableView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)saveTask:(id)sender
{
    

    
        PFObject *task = [PFObject objectWithClassName:@"ToDo"];
    
        BOOL isComplete = NO;
    
        
        task[@"task"] = self.taskName.text;
        task[@"priority"] = self.taskPriority.text;
        task[@"isComplete"] = [NSNumber numberWithBool:isComplete];
        task[@"dueDate"] = dueDate;
        task[@"taskDesc"] = self.taskDesc.text;
    
        task[@"propId"] = assignPropertyID;
    

        
        //ONLY ALLOW CURRENT USER TO VIEW
        //Set Access control to user logged in
        task.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
        
        //Set object to current user (makes it easier to get the data for tables)
        [task setObject:[PFUser currentUser] forKey:@"createdBy"];
        
        
        [task saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded)
            {
                
                savedAlert = [[UIAlertView alloc] initWithTitle:@"Tenant Saved" message:@"The tenant has been saved to your portfolio!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [savedAlert show];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [ApplicationDelegate loadTasks];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    
                });
                
            } else {
                
                savedAlert = [[UIAlertView alloc] initWithTitle:@"Save Error" message:@"There was an error trying to save the tenant information!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [savedAlert show];
                
            }
        }];
        
    }


-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([textField isEqual:self.assignProperty]) {
        
        textField.inputView = self.propertyPicker;
        
        if (ApplicationDelegate.propertyArray.count == 1) {
            
            assignPropertyID = [[ApplicationDelegate.propertyArray objectAtIndex:0] valueForKey:@"propertyId"];
            
            [self.assignProperty setText:[self pickerView:self.propertyPicker titleForRow:[self.propertyPicker selectedRowInComponent:0] forComponent:0]];
        }

        
    }else if ([textField isEqual:self.taskPriority]){
        
        textField.inputView = self.priorityPicker;
        [self.taskPriority setText:[self pickerView:self.priorityPicker titleForRow:[self.priorityPicker selectedRowInComponent:0] forComponent:0]];
        
        
    }else if ([textField isEqual:self.dueDateTF]){
        
        textField.inputView = self.dueDatePicker;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
        
        dueDate = [self.dueDatePicker date];
        
        self.dueDateTF.text = [dateFormatter stringFromDate:dueDate];
        
        [self.dueDatePicker addTarget:self action:@selector(addDate:) forControlEvents:UIControlEventValueChanged];
    }
}

-(IBAction)addDate:(UITextField *)textField
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    if (self.dueDateTF.isEditing) {
        
        self.dueDateTF.text = [dateFormatter stringFromDate:[self.dueDatePicker date]];
        
        dueDate = [self.dueDatePicker date];
        
       // NSLog(@"DATE %@", leaseStart);
        
    }
}

#pragma mark - Picker View
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if([pickerView isEqual:self.propertyPicker]){
        
        return 1;
        
    } else if ([pickerView isEqual:self.dueDatePicker]) {
        
        return 1;
        
    } else if([pickerView isEqual:self.priorityPicker]) {
        
        return 1;
        
    } else {
        
        return 0;
    }
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if([pickerView isEqual:self.propertyPicker]){
        
        return [ApplicationDelegate.propertyArray count];
        
    } else if ([pickerView isEqual:self.priorityPicker]) {
        
        return priorityArray.count ;
        
    } else {
        
        return 0;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if([pickerView isEqual:self.propertyPicker]){
        
        Properties *property = [ApplicationDelegate.propertyArray objectAtIndex:row];
        
        [self.propertyPicker selectedRowInComponent:0];
        
        return property.propName;
        
    }else if([pickerView isEqual:self.priorityPicker]){
        
        NSString *priorityString = [NSString stringWithFormat:@"%@", [priorityArray objectAtIndex:row]];
        
        return priorityString;
        
    } else {
        
        return nil;
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([pickerView isEqual:self.propertyPicker]){
        
        Properties *propertyInfo = [ApplicationDelegate.propertyArray objectAtIndex:row];
        
        [self.propertyPicker selectedRowInComponent:0];
        
        
        [self.assignProperty setText:[self pickerView:self.propertyPicker titleForRow:[self.propertyPicker selectedRowInComponent:0] forComponent:0]];
        
        assignPropertyID = propertyInfo.propertyId;
        
        NSLog(@"%@", assignPropertyID);
        
    } else if([pickerView isEqual:self.priorityPicker]){
        
        [self.priorityPicker selectedRowInComponent:0];
        
        [self.taskPriority setText:[self pickerView:self.priorityPicker titleForRow:[self.priorityPicker selectedRowInComponent:0] forComponent:0]];
        
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

//Function for Gesture tapOnScreen
- (void) keyboardDisappear {
    
    [self.view endEditing:YES];
}

@end

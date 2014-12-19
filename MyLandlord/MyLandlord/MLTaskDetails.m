//
//  MLTaskDetails.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/10/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLTaskDetails.h"
#import "Tasks.h"

@interface MLTaskDetails () <UIAlertViewDelegate>
{
    UIAlertView * savedAlert;
    UIAlertView * confirmation;
}

@end

@implementation MLTaskDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set Nav Bar Image
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,45)] ;
    [image setImage:[UIImage imageNamed:@"MyLandlord.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = image;
    
    //set label text
    self.taskNameLbl.text = self.taskDetails.task;
    self.taskDescriptionTv.text = self.taskDetails.taskDescription;
    self.taskPriorityLbl.text = self.taskDetails.priority;
    
    BOOL complete = 1;
    
    if ([self.taskDetails.isComplete isEqualToNumber:[NSNumber numberWithBool:complete]]) {
        self.checkComplete.hidden = YES;
    }

    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    self.taskDueDateLbl.text = [dateFormatter stringFromDate:self.taskDetails.dueDate];
    
    self.assignedPropertyLbl.text = self.propDetails.propName;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)taskComplete:(id)sender
{
    
    confirmation = [[UIAlertView alloc] initWithTitle:@"Mark Complete" message:@"Are you sure you would like to mark this task complete?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    
    [confirmation show];
    
}

#pragma mark
#pragma mark - AlertView Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if([alertView isEqual:savedAlert]){
        
        if (buttonIndex == 0) {
            NSLog(@"Closed Warning");
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            });
            
        }
    } else if ([alertView isEqual:confirmation]){
        
        if(buttonIndex == 1)
        {
            
            BOOL isComplete = YES;
            
            PFQuery *query = [PFQuery queryWithClassName:@"ToDo"];
            
            [query getObjectInBackgroundWithId:_taskDetails.taskId block:^(PFObject *task, NSError *error) {
                task[@"task"] = self.taskDetails.task;
                task[@"priority"] = self.taskDetails.priority;
                task[@"isComplete"] = [NSNumber numberWithBool:isComplete];
                task[@"dueDate"] = self.taskDetails.dueDate;
                task[@"taskDesc"] = self.taskDetails.taskDescription;
                
                task[@"propId"] = self.propDetails.propertyId;
                
                [task saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if(succeeded)
                    {
                        
                        savedAlert = [[UIAlertView alloc] initWithTitle:@"Task Updated" message:@"The task has been updated as complete!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [ApplicationDelegate.inCompleteTaskArray removeObjectAtIndex:_indexPath.row];
                            [ApplicationDelegate loadInCompleteTasks];
                            [ApplicationDelegate loadCompletedTasks];
                            
                            
                            
                            
                        });

                        
                        [savedAlert show];
                        
                        
                        
                    } else {
                        
                        savedAlert = [[UIAlertView alloc] initWithTitle:@"Update Error" message:@"There was an error trying to update the task!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        
                        [savedAlert show];
                        
                    }
                }];
                
                
            }];
            
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

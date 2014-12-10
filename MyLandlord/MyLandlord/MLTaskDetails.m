//
//  MLTaskDetails.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/10/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLTaskDetails.h"

@interface MLTaskDetails ()

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
    

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    self.taskDueDateLbl.text = [dateFormatter stringFromDate:self.taskDetails.dueDate];
    
    self.assignedPropertyLbl.text = self.propDetails.propName;
    
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

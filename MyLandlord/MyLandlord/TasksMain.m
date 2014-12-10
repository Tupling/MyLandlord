//
//  TasksMain.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/5/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "TasksMain.h"

@interface TasksMain ()
{
    UILabel *taskName;
    UILabel *propertyName;
    UILabel *dueDate;
    UIImageView *priority;
}

@end

@implementation TasksMain

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    

    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self sortTasks];
    
    [self.tableView reloadData];
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
    
    NSLog(@"Task Array = %lu", (unsigned long)[self.inCompleteTasks count]);
}
-(void)sortTasks
{
    for (int i = 0; i < ApplicationDelegate.tasksArray.count; i ++) {
        
        Tasks *taskInfo = [ApplicationDelegate.tasksArray objectAtIndex:i];
        
        NSLog(@"TASK COMPLETE = %@", taskInfo.isComplete);
        
        if([taskInfo.isComplete isEqualToNumber:[NSNumber numberWithInt:1]]){
            
            [self.completedTasks addObject:taskInfo];
            
        } else {
            
            [self.inCompleteTasks addObject:taskInfo];

        }
    }
    
    [self.tableView reloadData];
    NSLog(@"InComplete Tasks = %lu", (unsigned long)self.inCompleteTasks.count);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ApplicationDelegate.tasksArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        
    }
    
        taskName = (UILabel*)[cell viewWithTag:100];
        dueDate = (UILabel*)[cell viewWithTag:102];
        propertyName = (UILabel*)[cell viewWithTag:101];
        priority = (UIImageView*)[cell viewWithTag:103];

    
    
    
    Tasks *task = [ApplicationDelegate.tasksArray objectAtIndex:indexPath.row];
    //NSLog(@"TENANT ARRAY = %@", ApplicationDelegate.tenantsArray);
    NSLog(@"INDEX PROPERTY ID = %@", task.task);

        //Filter through tenants array to get assigned tenants
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"propertyId == %@", task.propId];
        NSArray *predicateResults = [ApplicationDelegate.propertyArray filteredArrayUsingPredicate:predicate];
        
        if(predicateResults.count > 0){
            
            self.propInfo = [predicateResults objectAtIndex:0];
            NSLog(@"Predicate Results == %@", self.propInfo);
            propertyName.text = [NSString stringWithFormat:@"%@", self.propInfo.propName];
        }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    NSDate *taskDueDate = task.dueDate;

    [taskName setText:task.task];
    taskName.text = task.task;
    dueDate.text = [dateFormatter stringFromDate:taskDueDate];
    
    if ([task.priority isEqualToString:@"High"]) {
        
        
        priority.image = [priority.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [priority setTintColor:[UIColor redColor]];
        
    }else if([task.priority isEqualToString:@"Medium"]){
        
        priority.image = [priority.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [priority setTintColor:[UIColor yellowColor]];
        
    }else if ([task.priority isEqualToString:@"Low"]){
        
        priority.image = [priority.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [priority setTintColor:[UIColor orangeColor]];
    }
    
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    self.taskInfo = [ApplicationDelegate.tasksArray objectAtIndex:indexPath.row];
    
  
    //Filter through properties array to get property for assigned task
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"propertyId == %@", self.taskInfo.propId];
    NSArray *predicateResults = [ApplicationDelegate.propertyArray filteredArrayUsingPredicate:predicate];
    
    if(predicateResults.count > 0){
        
        self.propInfo = [predicateResults objectAtIndex:0];

    } else {
        
        self.propInfo = nil;
    }

    [self performSegueWithIdentifier:@"details" sender:self];
 

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        
//        self.propInfo = [ApplicationDelegate.propertyArray objectAtIndex:indexPath.row];
//        
//        
//        deleteObject = [[UIAlertView alloc] initWithTitle:@"Remove Property" message:@"Are you sure you want to delete this property?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
//        
//        //Set alert tag do index path. Allows me to pass the table index of item being deleted.
//        deleteObject.tag = indexPath.row;
//        
//        [deleteObject show];
//        
//    }
//}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"details"]) {
        MLTaskDetails *taskDetails = segue.destinationViewController;
        
        taskDetails.taskDetails = self.taskInfo;
        taskDetails.propDetails = self.propInfo;
        
        NSLog(@"Property Details == %@", self.propInfo);

    }

}


@end

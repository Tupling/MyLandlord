//
//  SecondViewController.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/17/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLPropertiesViewController.h"
#import "MLPropertyDetails.h"



@interface MLPropertiesViewController () <UIAlertViewDelegate>
{
    UILabel *propName;
    UILabel *propTenant;
    UILabel *propRentStatus;
    
    UIAlertView *deleteObject;
}


@end

@implementation MLPropertiesViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
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

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma TABLEVIEW METHODS

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ApplicationDelegate.propertyArray count];
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
    
    propName = (UILabel*)[cell viewWithTag:100];
    propTenant = (UILabel*)[cell viewWithTag:101];
    propRentStatus = (UILabel*)[cell viewWithTag:102];


    
    Properties *property = [ApplicationDelegate.propertyArray objectAtIndex:indexPath.row];
    //NSLog(@"TENANT ARRAY = %@", ApplicationDelegate.tenantsArray);
    NSLog(@"INDEX PROPERTY ID = %@", property.propertyId);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"propertyId == %@", property.propertyId];
    NSArray *predicateResults = [ApplicationDelegate.tenantsArray filteredArrayUsingPredicate:predicate];
    
    if(predicateResults.count > 0){
        
        self.tenantInfo = [predicateResults objectAtIndex:0];
        NSLog(@"Predicate Results == %@", self.tenantInfo);
        propTenant.text = [NSString stringWithFormat:@"%@ %@", self.tenantInfo.pFirstName, self.tenantInfo.pLastName];
        
    } else {
        propTenant.text = @"No Assigned Tenant";
    }

    propName.text = property.propName;
   
    NSString *rentStatus = @"Past Due";
    propRentStatus.textColor = [UIColor redColor];
    propRentStatus.text = [NSString stringWithFormat:@"Rent: %@", rentStatus];
    
    [cell setNeedsDisplay];

    return cell;


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.propInfo = [ApplicationDelegate.propertyArray objectAtIndex:indexPath.row];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"propertyId == %@", self.propInfo.propertyId];
    NSArray *predicateResults = [ApplicationDelegate.tenantsArray filteredArrayUsingPredicate:predicate];
    
    if(predicateResults.count > 0){
        
        self.tenantInfo = [predicateResults objectAtIndex:0];
        NSLog(@"Predicate Results == %@", self.tenantInfo);
        
    }else {
        //Reset tenantInfo if Predicate results is 0.
        self.tenantInfo = nil;
    }
    
    
    //Push detailsView to the top of the stack
    [self performSegueWithIdentifier:@"details" sender:self];
    
    NSLog(@"%@", [[ApplicationDelegate.propertyArray objectAtIndex:indexPath.row] description]);
    
    //Deselect Item
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.propInfo = [ApplicationDelegate.propertyArray objectAtIndex:indexPath.row];
        
        
        deleteObject = [[UIAlertView alloc] initWithTitle:@"Remove Property" message:@"Are you sure you want to delete this property?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        
        //Set alert tag do index path. Allows me to pass the table index of item being deleted.
        deleteObject.tag = indexPath.row;
        
        [deleteObject show];
        
    }
}

 #pragma mark - Navigation
 
  //In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     if ([[segue identifier] isEqualToString:@"details"]) {
         
         MLPropertyDetails *propDetails = segue.destinationViewController;
         
         propDetails.details = self.propInfo;
         propDetails.tenantDetails = self.tenantInfo;
     }
}


//Alert user of actions
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView == deleteObject){
        
        //If User selected YES to remove tenant
        if (buttonIndex == 1) {
            
            //Get tenant object from Parse
            PFObject *property = [PFObject objectWithoutDataWithClassName:@"Properties" objectId:self.propInfo.propertyId];
            NSUInteger rowIndex = deleteObject.tag;
            
            //Remove this tenant object from tenantsArray
            [ApplicationDelegate.propertyArray removeObjectAtIndex:rowIndex];
            [self.tableView reloadData];
            
            [property deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (succeeded) {
                    UIAlertView *operationDone = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Property Successfully Removed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [operationDone show];
                }
            }];
        }
    }
    
}


@end

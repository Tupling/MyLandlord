//
//  MLTenantsViewController.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/17/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLTenantsViewController.h"
#import "MLTenantDetailsViewController.h"
#import "AppDelegate.h"

@interface MLTenantsViewController () <UIAlertViewDelegate>
{
    UIAlertView *deleteObject;
}

@end

@implementation MLTenantsViewController

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    //Set Nav Bar Image
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,45)] ;
    [image setImage:[UIImage imageNamed:@"MyLandlord.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = image;
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [ApplicationDelegate.tenantsArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
        if(cell == nil)
        {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
            

        }
    
    //Instantiate Cell Labels
    tenantName = (UILabel*)[cell viewWithTag:100];
    tenantNumber = (UILabel*) [cell viewWithTag:101];
    propName = (UILabel*) [cell viewWithTag:102];
    propAddress = (UILabel*) [cell viewWithTag:103];
    
    
    //Gather Data for Cell Content
    Tenants *tenant = [ApplicationDelegate.tenantsArray objectAtIndex:indexPath.row];
    
    //Filter Property Array to get Assigned Property
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"propertyId == %@", tenant.propertyId];
    NSArray *predicateResults = [ApplicationDelegate.propertyArray filteredArrayUsingPredicate:predicate];
    
    if (predicateResults.count > 0) {
        
        Properties *predicateProperty = [predicateResults objectAtIndex:0];
        
        NSString *propNameString = [predicateProperty valueForKey:@"propName"];
        propName.text = propNameString;
        propAddress.text = [NSString stringWithFormat:@"%@ %@, %@ %@", predicateProperty.propAddress, predicateProperty.propCity, predicateProperty.propZip, predicateProperty.propState];
        
    } else {
        propName.text = @"No Assigned Property";
        propAddress.text = @"";
    }


    
    tenantName.text = [NSString stringWithFormat:@"%@ %@", tenant.pFirstName, tenant.pLastName];
    
    if(tenant.pPhoneNumber != nil){
    
    NSMutableString *convertedPhoneString = [NSMutableString stringWithString:tenant.pPhoneNumber];
    
    [convertedPhoneString insertString:@"(" atIndex:0];
    [convertedPhoneString insertString:@")" atIndex:4];
    [convertedPhoneString insertString:@"-" atIndex:5];
    [convertedPhoneString insertString:@"-" atIndex:9];
    
    tenantNumber.text = convertedPhoneString;
    }

    
    return cell;
}
#pragma SEGUE METHODS

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    self.aTenantsInfo = [ApplicationDelegate.tenantsArray objectAtIndex:indexPath.row];
    
    //Push detailsView to the top of the stack
    [self performSegueWithIdentifier:@"details" sender:self];
    
    
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
        _aTenantsInfo = [ApplicationDelegate.tenantsArray objectAtIndex:indexPath.row];
        
        
        deleteObject = [[UIAlertView alloc] initWithTitle:@"Remove Tenant" message:@"Are you sure you want to delete this tenant?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        
        //Set alert tag do index path. Allows me to pass the table index of item being deleted.
        deleteObject.tag = indexPath.row;
        
        [deleteObject show];
        
    }
}


//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"details"]) {
        MLTenantDetailsViewController *tenantDetails = segue.destinationViewController;
        
        tenantDetails.details = _aTenantsInfo;
        
        NSLog(@"Tenant Info: %@", _aTenantsInfo);
    }
    
    
}

//Alert user of actions
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView == deleteObject){
        
        //If User selected YES to remove tenant
        if (buttonIndex == 1) {
            
            //Get tenant object from Parse
            PFObject *tenant = [PFObject objectWithoutDataWithClassName:@"Tenants" objectId:_aTenantsInfo.tenantId];
            NSUInteger rowIndex = deleteObject.tag;
            
                //Remove this tenant object from tenantsArray
                [ApplicationDelegate.tenantsArray removeObjectAtIndex:rowIndex];
                [self.tableView reloadData];
            
                [tenant deleteInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    if (succeeded) {
                        UIAlertView *operationDone = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Tenant Successfully Removed" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                        
                        [operationDone show];
                    }
                }];
        }
    }
    
}

@end

//
//  MLPropertyUnits.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/9/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLPropertyUnits.h"
#import "MLAddUnits.h"
#import "MLPropertyDetails.h"

@interface MLPropertyUnits ()
{
    UILabel *unitName;
    UILabel *assignedTenant;
    NSArray *unitArray;
}

@end

@implementation MLPropertyUnits



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //Filter through unit array to get assigned units the belong to parent property
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parentPropId == %@", self.propDetails.propertyId];
    unitArray = [ApplicationDelegate.subUnitArray filteredArrayUsingPredicate:predicate];

        
        [self.tableView reloadData];
 
    

}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    //Filter through unit array to get assigned units the belong to parent property
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parentPropId == %@", self.propDetails.propertyId];
    unitArray = [ApplicationDelegate.subUnitArray filteredArrayUsingPredicate:predicate];

    
    
    //[self performSelector:@selector(updateUI) withObject:nil afterDelay:0.5];
    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
}


-(void)updateUI
{
        [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Filter through unit array to get assigned units the belong to parent property
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parentPropId == %@", self.propDetails.propertyId];
    unitArray = [ApplicationDelegate.subUnitArray filteredArrayUsingPredicate:predicate];
    
    [self.tableView reloadData];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addUnit:(id)sender{
    
    [self performSegueWithIdentifier:@"addUnit" sender:self];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [unitArray count];
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
    
    unitName = (UILabel*)[cell viewWithTag:101];
    assignedTenant = (UILabel*)[cell viewWithTag:102];


    SubUnit *unit = [unitArray objectAtIndex:indexPath.row];
    //NSLog(@"TENANT ARRAY = %@", ApplicationDelegate.tenantsArray);
    NSLog(@"INDEX PROPERTY ID = %@", unit.unitNumber);
    
    //Filter tenant array for assigned tenant
    NSPredicate *tenantPred = [NSPredicate predicateWithFormat:@"subUnitId == %@", unit.unitObjectId];
    NSArray *localTenantArray =[ApplicationDelegate.tenantsArray filteredArrayUsingPredicate:tenantPred];
    
    if(localTenantArray.count > 0){
        
        self.tenantInfo = [localTenantArray objectAtIndex:0];
       
        assignedTenant.text = [NSString stringWithFormat:@"%@ %@", self.tenantInfo.pFirstName, self.tenantInfo.pLastName];
    
    }else{
        assignedTenant.text = @"No Assigned Tenant";
    }
    
    unitName.text = [NSString stringWithFormat:@"%@ - %@", self.propDetails.propName, unit.unitNumber];
  

    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.subUnitDetails = [unitArray objectAtIndex:indexPath.row];
    //Filter tenant array for assigned tenant
    NSPredicate *tenantPred = [NSPredicate predicateWithFormat:@"subUnitId == %@", self.subUnitDetails.unitObjectId];
    NSArray *localTenantArray =[ApplicationDelegate.tenantsArray filteredArrayUsingPredicate:tenantPred];
    
    if(localTenantArray.count > 0){
        
            self.tenantInfo = [localTenantArray objectAtIndex:0];
        
    } else {
        
        self.tenantInfo = nil;
    }

    
    //Push detailsView to the top of the stack
    [self performSegueWithIdentifier:@"unitDetails" sender:self];

}


//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"addUnit"]) {
        
        MLAddUnits *propDetails = segue.destinationViewController;
        propDetails.propDetails = self.propDetails;
        
    } else if([[segue identifier] isEqualToString:@"unitDetails"]){
        
        MLPropertyDetails *propertyDetails = segue.destinationViewController;
    
        
        propertyDetails.details = self.propDetails;
        propertyDetails.tenantDetails = self.tenantInfo;
        propertyDetails.subUnitDetails = self.subUnitDetails;
        
    }
}

@end

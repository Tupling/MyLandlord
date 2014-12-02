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

@interface MLTenantsViewController ()
{

}

@end

@implementation MLTenantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set Nav Bar Image
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,45)] ;
    [image setImage:[UIImage imageNamed:@"MyLandlord.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = image;
    
    NSManagedObjectContext *context = [ApplicationDelegate managedObjectContext];
    
    //Create new Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Request Entity EventInfo
    NSEntityDescription *eventEntity = [NSEntityDescription entityForName:@"Tenants" inManagedObjectContext:context];
    
    //Set fetchRequest entity to EventInfo Description
    [fetchRequest setEntity:eventEntity];
    
    NSError * error;
    //Set events array to data in core data
    if (eventEntity != nil) {
        self.tenants = [context executeFetchRequest:fetchRequest error:&error];
        if (self.tenants == nil) {
            self.tenants = [NSArray new];
        }
    }
    if (!error) {
        //Check array count,
        //load new Parse data into Core Data
        if ([self.tenants count] == 0) {
            
            [self loadData];
        }
    }


}


-(void)viewWillAppear:(BOOL)animated
{

    //[self.tableView reloadData];
    [self loadData];
    
}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tenants count];
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
        
    
    pName = (UILabel*)[cell viewWithTag:100];
    pNumber = (UILabel*) [cell viewWithTag:101];
    pAddress = (UILabel*) [cell viewWithTag:102];
    
    //NSLog(@"TENANTS ARRAY %@", self.tenants.description);
    
    Tenants *tenant = [self.tenants objectAtIndex:indexPath.row];
    
    //NSLog(@"Tenant First Name = %@", tenant.pFirstName);
    
 
    pName.text = [NSString stringWithFormat:@"%@ %@", tenant.pFirstName, tenant.pLastName];
    pNumber.text = tenant.pPhoneNumber;
    
    pAddress.text = @"2320 Laguna Cout Fairborn Oh 45324";
    
    return cell;
}
//LOAD DATA
-(void)loadData
{
    NSLog(@"Attempting to Load Data from DB");
    [self deletedAllObjects:@"Tenants"];
    PFQuery *results = [PFQuery queryWithClassName:@"Tenants"];
    //[tenants whereKey:@"createdBy" equalTo:[PFUser currentUser]];

    [results findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            for(int i = 0; i <objects.count; i++){
                NSManagedObjectContext *context = [ApplicationDelegate managedObjectContext];
                
                Tenants *tenantInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Tenants" inManagedObjectContext:context];
                
                tenantInfo.pFirstName = [objects[i] valueForKey:@"pFirstName"];
                tenantInfo.pLastName = [objects[i] valueForKey:@"pLastName"];
                tenantInfo.pEmail = [objects[i] valueForKey:@"pEmail"];
                tenantInfo.pPhoneNumber = [objects[i] valueForKey:@"pPhoneNumber"];
                
                tenantInfo.leaseEnd = [objects[i] valueForKey:@"leaseEnd"];
                NSLog(@"Lease End %@", [objects[i] valueForKey:@"leaseEnd"]);
                tenantInfo.leaseStart = [objects[i] valueForKey:@"leaseStart"];
                tenantInfo.rentAmount = [objects[i] valueForKey:@"rentTotal"];
                
                if ([objects[i] valueForKey:@"sFirstName"] != nil) {
                    
                tenantInfo.sFirstName = [objects[i] valueForKey:@"sFirstName"];
                tenantInfo.sLastName = [objects[i] valueForKey:@"sLastName"];
                tenantInfo.sEmail = [objects[i] valueForKey:@"sEmail"];
                tenantInfo.sPhoneNumber = [objects[i] valueForKey:@"sPhoneNumber"];

                }
                
                    NSError * error;
                    if(![context save:&error])
                    {
                        NSLog(@"Failed to save: %@", [error localizedDescription]);
                    }
                    
                    //Create new Fetch Request
                    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                    
                    //Request Entity EventInfo
                    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Tenants" inManagedObjectContext:context];
                    
                    //Set fetchRequest entity to EventInfo Description
                    [fetchRequest setEntity:entity];
                    
                    //Set events array to data in core data
                    self.tenants = [context executeFetchRequest:fetchRequest error:&error];
                    
                }
            }else{
                
                //Why did it fail?
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
            

            
            
            
            [self.tableView reloadData];
            //NSLog(@"EVENTS ARRAY %lu",(unsigned long)_events.count);
            // NSLog(@"OBJECTS ARRAY %@", objects.description);
            
            
        }];

   
}

#pragma SEGUE METHODS

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    self.aTenantsInfo = [self.tenants objectAtIndex:indexPath.row];
    
    //Push detailsView to the top of the stack
    [self performSegueWithIdentifier:@"details" sender:self];
    
    NSLog(@"%@", [[self.tenants objectAtIndex:indexPath.row] description]);
    
    //Deselect Item
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"details"]) {
        MLTenantDetailsViewController *tenantDetails = segue.destinationViewController;
        
        tenantDetails.details = _aTenantsInfo;
    }
    
    
}


-(void)deletedAllObjects: (NSString*) entityDescription{
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription * entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:ApplicationDelegate.managedObjectContext];
    
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *objectItems = [ApplicationDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in objectItems) {
        
        [ApplicationDelegate.managedObjectContext deleteObject:managedObject];
        
        NSLog(@"%@ object deleted", entityDescription);
        
    }
    if (![ApplicationDelegate.managedObjectContext save:&error]) {
        NSLog(@"Error Deleting object %@ - Error %@", entityDescription, error);
    }
}


@end

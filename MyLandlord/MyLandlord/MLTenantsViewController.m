//
//  MLTenantsViewController.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/17/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLTenantsViewController.h"
#import "AppDelegate.h"

@interface MLTenantsViewController ()
{
    NSMutableArray *tenantArray;
}

@end

@implementation MLTenantsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self loadData];
    

}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [_tableView reloadData];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tenantArray count];
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
        
    

    
    NSLog(@"TENANTS ARRAY %@", tenantArray.description);
    
    Tenants *tenant = [tenantArray objectAtIndex:indexPath.row];
    
    NSLog(@"Tenant First Name = %@", tenant.pFirstName);
    
    pName = (UILabel*)[cell viewWithTag:100];
    pNumber = (UILabel*) [cell viewWithTag:101];
    pAddress = (UILabel*) [cell viewWithTag:102];
    

    
    pName.text = tenant.pFirstName;
    pNumber.text = tenant.pPhoneNumber;
    pAddress.text = @"2320 Laguna Cout Fairborn Oh 45324";
    
    return cell;
}
//LOAD DATA
-(void)loadData
{
    
    //Initialize Tenant Array
    tenantArray = [[NSMutableArray alloc] init];

    PFQuery *results = [PFQuery queryWithClassName:@"Tenants"];
    //[tenants whereKey:@"createdBy" equalTo:[PFUser currentUser]];

    
    [results findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            for(int i = 0; i <objects.count; i++){
                NSManagedObjectContext *context = [ApplicationDelegate managedObjectContext];
                
                Tenants *tenantInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Tenants" inManagedObjectContext:context];
                
                //create new instance of Event Info
                //Tenants *tenantInfo = [[Tenants alloc] init];

                
                tenantInfo.pFirstName = [objects[i] valueForKey:@"pFirstName"];
                tenantInfo.pLastName = [objects[i] valueForKey:@"pLastName"];
                tenantInfo.pEmail = [objects[i] valueForKey:@"pEmail"];
                tenantInfo.pPhoneNumber = [objects[i] valueForKey:@"pPhoneNumber"];
                
                if ([objects[i] valueForKey:@"sFirstName"] != nil) {
                    
                tenantInfo.sFirstName = [objects[i] valueForKey:@"sFirstName"];
                tenantInfo.sLastName = [objects[i] valueForKey:@"sLastName"];
                tenantInfo.sEmail = [objects[i] valueForKey:@"sEmail"];
                tenantInfo.sPhoneNumber = [objects[i] valueForKey:@"sPhoneNumber"];
                    
                }

                [tenantArray addObject: tenantInfo];
                
               
                
            }
            [self.tableView reloadData];
        }  else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        NSLog(@"TENANT ARRAY COUNT %lu", (unsigned long)tenantArray.count);

    }];

   
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

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

-(void)viewDidAppear:(BOOL)animated {
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        
    
    pName = (UILabel*)[cell viewWithTag:100];
    pNumber = (UILabel*) [cell viewWithTag:101];
    pAddress = (UILabel*) [cell viewWithTag:102];
    
    Tenants *tenant = [ApplicationDelegate.tenantsArray objectAtIndex:indexPath.row];
    
    pName.text = [NSString stringWithFormat:@"%@ %@", tenant.pFirstName, tenant.pLastName];
    pNumber.text = tenant.pPhoneNumber;
    
    pAddress.text = @"2320 Laguna Cout Fairborn Oh 45324";
    
    return cell;
}
#pragma SEGUE METHODS

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    self.aTenantsInfo = [ApplicationDelegate.tenantsArray objectAtIndex:indexPath.row];
    
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

@end

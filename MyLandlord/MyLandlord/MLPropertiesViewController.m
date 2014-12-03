//
//  SecondViewController.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/17/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLPropertiesViewController.h"
#import "MLPropertyDetails.h"



@interface MLPropertiesViewController ()
{
    UILabel *propName;
    UILabel *propTenant;
    UILabel *propRentStatus;
}


@end

@implementation MLPropertiesViewController

-(void)viewDidAppear:(BOOL)animated {
    
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

        
    propName.text = property.propName;
    propTenant.text = @"Dale Tupling";
    NSString *rentStatus = @"Past Due";
    propRentStatus.textColor = [UIColor redColor];
    propRentStatus.text = [NSString stringWithFormat:@"Rent: %@", rentStatus];
    
    [cell setNeedsDisplay];

    return cell;


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.propInfo = [ApplicationDelegate.propertyArray objectAtIndex:indexPath.row];
    
    //Push detailsView to the top of the stack
    [self performSegueWithIdentifier:@"details" sender:self];
    
    NSLog(@"%@", [[ApplicationDelegate.propertyArray objectAtIndex:indexPath.row] description]);
    
    //Deselect Item
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

 #pragma mark - Navigation
 
  //In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     if ([[segue identifier] isEqualToString:@"details"]) {
         
         MLPropertyDetails *propDetails = segue.destinationViewController;
         
         propDetails.details = self.propInfo;
     }
     


 }
 


@end

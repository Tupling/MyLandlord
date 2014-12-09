//
//  MLPropertyUnits.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/9/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLPropertyUnits.h"
#import "MLAddUnits.h"

@interface MLPropertyUnits ()
{
    UILabel *unitName;
    NSArray *unitArray;
}

@end

@implementation MLPropertyUnits


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //Filter through tenants array to get assigned tenants
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parentPropId == %@", self.propDetails.propertyId];
    unitArray = [ApplicationDelegate.subUnitArray filteredArrayUsingPredicate:predicate];
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


    SubUnit *unit = [unitArray objectAtIndex:indexPath.row];
    //NSLog(@"TENANT ARRAY = %@", ApplicationDelegate.tenantsArray);
    NSLog(@"INDEX PROPERTY ID = %@", unit.unitNumber);
    

    unitName.text = [NSString stringWithFormat:@"%@ - %@", self.propDetails.propName, unit.unitNumber];
  

    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"addUnit"]) {
        
        MLAddUnits *propDetails = segue.destinationViewController;
        propDetails.propDetails = self.propDetails;
        
    } else if([[segue identifier] isEqualToString:@"unitDetails"]){
        
        
    }
}

@end

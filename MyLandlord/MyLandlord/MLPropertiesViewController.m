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



@end

@implementation MLPropertiesViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    //Set Nav Bar Image
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,45)] ;
    [image setImage:[UIImage imageNamed:@"MyLandlord.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = image;
    
    // Do any additional setup after loading the view, typically from a nib.
    [self loadData];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadData
{
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"DataNeedsUpdated"]){
        
    NSLog(@"Attempting to Load Data from DB");
    [self deletedAllObjects:@"Properties"];
    PFQuery *results = [PFQuery queryWithClassName:@"Properties"];
    
    [results findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            for(int i = 0; i <objects.count; i++){
                NSManagedObjectContext *context = [ApplicationDelegate managedObjectContext];
                
                Properties *propInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Properties" inManagedObjectContext:context];
                
                propInfo.propName = [objects[i] valueForKey:@"propName"];
                propInfo.propAddress = [objects[i] valueForKey:@"propAddress"];
                propInfo.propCity = [objects[i] valueForKey:@"propCity"];
                propInfo.propState = [objects[i] valueForKey:@"propState"];
                propInfo.propZip = [objects[i] valueForKey:@"propZip"];
                
                
                
                NSError * error;
                if(![context save:&error])
                {
                    NSLog(@"Failed to save: %@", [error localizedDescription]);
                }
                
                //Create new Fetch Request
                NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
                
                //Request Entity EventInfo
                NSEntityDescription *entity = [NSEntityDescription entityForName:@"Properties" inManagedObjectContext:context];
                
                //Set fetchRequest entity to EventInfo Description
                [fetchRequest setEntity:entity];
                
                //Set events array to data in core data
                self.properties = (NSMutableArray*)[context executeFetchRequest:fetchRequest error:&error];
                
            }

            [self.tableView reloadData];
            
            [[NSUserDefaults standardUserDefaults] setInteger:self.properties.count forKey:@"totalProperties"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else{
            
            //Why did it fail?
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"DataNeedsUpdated"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
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


#pragma TABLEVIEW METHODS

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.properties count];
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
    
    UILabel *propName = (UILabel*)[cell viewWithTag:100];
    UILabel *propTenant = (UILabel*)[cell viewWithTag:101];
    UILabel *propRentStatus = (UILabel*)[cell viewWithTag:102];


    
    Properties *property = [self.properties objectAtIndex:indexPath.row];

        
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
    self.propInfo = [self.properties objectAtIndex:indexPath.row];
    
    //Push detailsView to the top of the stack
    [self performSegueWithIdentifier:@"details" sender:self];
    
    NSLog(@"%@", [[self.properties objectAtIndex:indexPath.row] description]);
    
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

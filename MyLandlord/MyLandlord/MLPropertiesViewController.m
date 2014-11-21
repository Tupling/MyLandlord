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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    NSManagedObjectContext *context = [ApplicationDelegate managedObjectContext];
    
    //Create new Fetch Request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    //Request Entity EventInfo
    NSEntityDescription *eventEntity = [NSEntityDescription entityForName:@"Properties" inManagedObjectContext:context];
    
    //Set fetchRequest entity to EventInfo Description
    [fetchRequest setEntity:eventEntity];
    
    NSError * error;
    //Set events array to data in core data
    if (eventEntity != nil) {
        self.properties = [context executeFetchRequest:fetchRequest error:&error];
        if (self.properties == nil) {
            self.properties = [NSArray new];
        }
    }
    if (!error) {
        //Check array count,
        //load new Parse data into Core Data
        if ([self.properties count] == 0) {
            
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



-(void)loadData
{
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
                self.properties = [context executeFetchRequest:fetchRequest error:&error];
                
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILabel *propAddress = (UILabel*)[cell viewWithTag:100];
    UILabel *propTenant = (UILabel*)[cell viewWithTag:101];
    UILabel *propRentStatus = (UILabel*)[cell viewWithTag:102];


    
    Properties *property = [self.properties objectAtIndex:indexPath.row];
    
    propAddress.text = [NSString stringWithFormat:@"%@ %@ %@ %@",
                        property.propAddress,
                        property.propCity,
                        property.propState,
                        property.propZip];
    
    propTenant.text = @"Dale Tupling";
    NSString *rentDue = @"$(1,420.00)";
    propRentStatus.textColor = [UIColor redColor];
    propRentStatus.text = [NSString stringWithFormat:@"Rent Due: %@", rentDue];
    
    return cell;


}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        //Push detailsView to the top of the stack
    [self performSegueWithIdentifier:@"details" sender:self];
    
    //Deselect Item
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

 #pragma mark - Navigation
 
  //In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

     MLPropertyDetails *propDetails = segue.destinationViewController;
 }
 


@end

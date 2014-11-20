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
    
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 0;
}


//LOAD DATA
-(void)loadData
{
    
    //Initialize Tenant Array
    tenantArray = [[NSMutableArray alloc] init];

    PFQuery *tenants = [PFQuery queryWithClassName:@"Tenants"];
    [tenants whereKey:@"createdBy" equalTo:[PFUser currentUser]];
    
    [tenants findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error)
        {
            for(int i = 0; i <objects.count; i++){
                
                NSManagedObjectContext *context = [ApplicationDelegate managedObjectContext];
                //create new instance of Event Info
                Tenants *tenantInfo = [[Tenants alloc] initWithEntity:@"Tenants" insertIntoManagedObjectContext:context];

                
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
                
                NSLog(@"Tenant Array Count = %lu",(unsigned long)[tenantArray count]);
            }
        }
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

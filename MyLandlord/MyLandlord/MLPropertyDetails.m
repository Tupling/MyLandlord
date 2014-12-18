//
//  MLPropertyDetails.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/21/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLPropertyDetails.h"
#import "MLAddPropertyViewController.h"
#import "MLPropertyExpenses.h"
#import "MLPropDocuments.h"

@interface MLPropertyDetails ()

@end

@implementation MLPropertyDetails

#pragma mark - View Load Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set property Address
    if (self.subUnitDetails != nil) {
        
        propAddress.text = [NSString stringWithFormat:@"%@ - Unit %@\n%@, %@ %@", _details.propAddress, _subUnitDetails.unitNumber, _details.propCity, _details.propState, _details.propZip];
        
    } else {
        
    propAddress.text = [NSString stringWithFormat:@"%@\n%@, %@ %@", _details.propAddress, _details.propCity, _details.propState, _details.propZip];
    
    }
    if(_tenantDetails == nil){
        NSLog(@"Tenant Details Nil");
        
        tenantInfo.text = @"No Assigned Tenant";
        leaseInfo.text = @"No Lease Information Available";
        rentStatus.text = @"N/A";
        
    } else {
        
        NSLog(@"Tenant Details Conatins Data = %@", self.tenantDetails);
        // Do any additional setup after loading the view.
        NSString *tenantName = [NSString stringWithFormat:@"%@ %@", _tenantDetails.pFirstName, _tenantDetails.pLastName];
        NSString *tenantPhone = _tenantDetails.pPhoneNumber;
        NSString *tenantEmail = _tenantDetails.pEmail;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
        
        NSDate *leaseEnd = _tenantDetails.leaseEnd;
        NSDate *leaseStart = _tenantDetails.leaseStart;
        
        
        NSString *leaseAmount = [NSString stringWithFormat:@"%@", _tenantDetails.rentAmount];
        NSString *leaseEndString = [dateFormatter stringFromDate:leaseEnd];
        NSString *leaseStartString = [dateFormatter stringFromDate:leaseStart];
        NSString *dueDateString = [NSString stringWithFormat:@"%@", _tenantDetails.dueDay];
        

        tenantInfo.text = [NSString stringWithFormat:@"%@\n%@\n%@", tenantName,
                           tenantEmail,
                           tenantPhone];
        
        leaseInfo.text = [NSString stringWithFormat:@"Rent Amount: %@\nLease Begin: %@\nLease End: %@\nDue Day: %@th of Every Month",
                          leaseAmount,
                          leaseStartString,
                          leaseEndString,
                          dueDateString];
    }
    
    //Set Nav Bar Image
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,45)] ;
    [image setImage:[UIImage imageNamed:@"MyLandlord.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = image;
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.tenantDetails = nil;
}


#pragma mark -Edit Action Method

-(IBAction)editDetails:(id)sender
{
    [self performSegueWithIdentifier:@"editDetails" sender:self];
}

-(IBAction)viewDocuments:(id)sender
{
    [self performSegueWithIdentifier:@"showDocuments" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"editDetails"]) {
 
            MLAddPropertyViewController *editProperty = segue.destinationViewController;
 
            editProperty.details = _details;
 
    }
    else if ([[segue identifier] isEqualToString:@"showFinances"]) {
        
        MLPropertyExpenses *propertyDetails = segue.destinationViewController;
        
        propertyDetails.details = _details;
        
        if(self.subUnitDetails != nil){
            propertyDetails.subUnitDetails = _subUnitDetails;
        }
        
    }
    else if ([[segue identifier] isEqualToString:@"showDocuments"]) {
        
        MLPropDocuments *propertyDetails = segue.destinationViewController;
        
        propertyDetails.details = _details;
        
        if(self.subUnitDetails != nil){
            
            propertyDetails.subUnitDetails = _subUnitDetails;
        }
        
    }
}

#pragma  mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  MLPropertyDetails.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/21/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLPropertyDetails.h"

@interface MLPropertyDetails ()

@end

@implementation MLPropertyDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Set property Address
    propAddress.text = [NSString stringWithFormat:@"%@\n%@, %@ %@", _details.propAddress, _details.propCity, _details.propState, _details.propZip];
    
    if(_tenantDetails == nil){
        NSLog(@"Tenant Details Nil");
        
        tenantInfo.text = @"No Assigned Tenant";
        leaseInfo.text = @"No Lease Information Available";
        
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
        //NSString *leaseTerm = @"6 Months";
        

        tenantInfo.text = [NSString stringWithFormat:@"%@\n%@\n%@", tenantName, tenantEmail, tenantPhone];
        leaseInfo.text = [NSString stringWithFormat:@"Rent Amount: %@\nDue Date: %@\nLease Begin: %@", leaseAmount, leaseEndString, leaseStartString];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

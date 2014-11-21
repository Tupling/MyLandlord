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
    // Do any additional setup after loading the view.
    NSString *tenantName = @"Dale Tupling";
    NSString *tenantPhone = @"931-302-1108";
    NSString *tenantEmail = @"tuplingd@gmail.com";
    
    NSString *leaseAmount = @"$1,420.00";
    NSString *leaseDue = @"November 4th, 2014";
    NSString *leaseBegin = @"July 6th, 2014";
    NSString *leaseTerm = @"6 Months";
    
    propAddress.text = [NSString stringWithFormat:@"%@\n%@, %@ %@", _details.propAddress, _details.propCity, _details.propState, _details.propZip];
    tenantInfo.text = [NSString stringWithFormat:@"%@\n%@\n%@", tenantName, tenantEmail, tenantPhone];
    leaseInfo.text = [NSString stringWithFormat:@"Rent Amount: %@\nDue Date: %@\nLease Begin: %@\nLease Term: %@", leaseAmount, leaseDue, leaseBegin, leaseTerm];
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

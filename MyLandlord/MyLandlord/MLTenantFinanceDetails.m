//
//  MLTenantFinanceDetails.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/18/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLTenantFinanceDetails.h"
#import "MLAddTenantFinance.h"

@interface MLTenantFinanceDetails ()
{
    
}

@end

@implementation MLTenantFinanceDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tenantName.text = [NSString stringWithFormat:@"%@ %@", self.tenDetails.pFirstName, self.tenDetails.pLastName];
    self.finAmount.text = [NSString stringWithFormat:@"%0.2f", self.finDetails.fAmount];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    self.finDate.text = [dateFormatter stringFromDate:self.finDetails.date];
    
    self.finCategory.text = self.finDetails.category;
    self.finDescription.text = self.finDetails.fDescription;
    
    self.finNameHeader.text = [NSString stringWithFormat:@"%@\nFinance Item Details", self.finDetails.itemName];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)editFinance:(id)sender
{
    [self performSegueWithIdentifier:@"editFinance" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"editFinance"]) {
        MLAddTenantFinance *addFinance = segue.destinationViewController;
        
        addFinance.tenDetails = self.tenDetails;
        addFinance.finDetails = self.finDetails;
        
        NSLog(@"Tenant Info: %@", self.tenDetails);
    }

}

@end

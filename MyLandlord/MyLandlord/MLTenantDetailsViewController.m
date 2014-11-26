//
//  MLTenantDetailsViewController.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/21/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLTenantDetailsViewController.h"
#import "Tenants.h"

@interface MLTenantDetailsViewController ()

@end

@implementation MLTenantDetailsViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"%@", _details.pFirstName);
    
    pTenantName.text = [NSString stringWithFormat:@"%@ %@", _details.pFirstName, _details.pLastName];
    pTenantPhone.text = _details.pPhoneNumber;
    pTenantEmail.text = _details.pEmail;
    
    
    if(![_details.sFirstName isEqual: @""])
    {
     
        sTenantName.text = [NSString stringWithFormat:@"%@ %@", _details.sFirstName, _details.sLastName];
        sTenantPhone.text = _details.sPhoneNumber;
        sTenantEmail.text = _details.sEmail;
    }else{
        sTenantHeaderLabel.hidden = YES;
        sTenantEmail.hidden = YES;
        sTenantName.hidden = YES;
        sTenantPhone.hidden = YES;
    }
    
    
    
    //Modify button appearence
    self.viewDocs.layer.cornerRadius = 5;
    self.viewFinance.layer.cornerRadius = 5;
    
    self.emailButton.layer.borderWidth = 1.0f;
    self.emailButton.layer.cornerRadius = 5;
    self.emailButton.layer.borderColor = [[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1] CGColor];
    [self.emailButton setTitle:_details.pEmail forState:UIControlStateNormal];
    
    
    self.phoneButton.layer.cornerRadius = 5;
    self.phoneButton.layer.borderWidth = 1.0f;
    self.phoneButton.layer.borderColor = [[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1] CGColor];
    
    [self.phoneButton setTitle:_details.pPhoneNumber forState:UIControlStateNormal];
    

    
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

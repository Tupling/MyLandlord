//
//  MLTenantDetailsViewController.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/21/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLTenantDetailsViewController.h"
#import "MLAddSecondTenantInfo.h"
#import "MLTenantsViewController.h"
#import "MLAddTenantViewController.h"

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

    
    //Add radius to button
    self.viewDocs.layer.cornerRadius = 5;
    self.viewFinance.layer.cornerRadius = 5;
    
    
    //Set Nav Bar Image
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,45)] ;
    [image setImage:[UIImage imageNamed:@"MyLandlord.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = image;
    
    NSLog(@"%@", _details.pFirstName);
    
    pTenantName.text = [NSString stringWithFormat:@"%@ %@", _details.pFirstName, _details.pLastName];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    NSDate *leaseEnd = _details.leaseEnd;
    NSDate *leaseStart = _details.leaseStart;
    
    leaseEndLabel.text = [dateFormatter stringFromDate:leaseEnd];
    leaseStartLabel.text = [dateFormatter stringFromDate:leaseStart];
    rentDueLabel.text = [NSString stringWithFormat:@"$%@.00", _details.rentAmount];
    
    if (_details.sFirstName == nil) {
        sTenantHeaderLabel.hidden = YES;
        sTenantName.hidden = YES;
        self.sTenantphoneButton.hidden = YES;
        self.sTenantEmailButton.hidden = YES;

        
    }
    else{
        sTenantName.text = [NSString stringWithFormat:@"%@ %@", _details.sFirstName, _details.sLastName];
    }
    

    
    
    //Modify button appearence
    self.viewDocs.layer.cornerRadius = 5;
    self.viewFinance.layer.cornerRadius = 5;
    self.addSecondTenant.layer.cornerRadius = 5;
    
    
    //Primary Tenant Buttons
    self.emailButton.layer.borderWidth = 1.0f;
    self.emailButton.layer.cornerRadius = 5;
    self.emailButton.layer.borderColor = [[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1] CGColor];
    [self.emailButton setTitle:_details.pEmail forState:UIControlStateNormal];
    
    
    self.phoneButton.layer.cornerRadius = 5;
    self.phoneButton.layer.borderWidth = 1.0f;
    self.phoneButton.layer.borderColor = [[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1] CGColor];
    [self.phoneButton setTitle:_details.pPhoneNumber forState:UIControlStateNormal];
    

    //Secondary Tenant Buttons
    self.sTenantEmailButton.layer.borderWidth = 1.0f;
    self.sTenantEmailButton.layer.cornerRadius = 5;
    self.sTenantEmailButton.layer.borderColor = [[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1] CGColor];
    [self.sTenantEmailButton setTitle:_details.sEmail forState:UIControlStateNormal];
    
    
    self.sTenantphoneButton.layer.cornerRadius = 5;
    self.sTenantphoneButton.layer.borderWidth = 1.0f;
    self.sTenantphoneButton.layer.borderColor = [[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1] CGColor];
    [self.sTenantphoneButton setTitle:_details.sPhoneNumber forState:UIControlStateNormal];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.view setNeedsDisplay];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)closeView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)makeCall:(id)sender
{
    if([sender isEqual:self.phoneButton]){
        
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",_details.pPhoneNumber]]];
        
    }else if([sender isEqual:self.sTenantphoneButton]){
        
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt:%@",_details.sPhoneNumber]]];
    }
    
}

-(IBAction)sendEmail:(id)sender
{
    if([sender isEqual:self.emailButton]){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", _details.pEmail]]];
        
    }else if([sender isEqual:self.sTenantEmailButton]){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto:%@", _details.sEmail]]];
        
    }
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"addSecondTenant"]) {
     
            MLAddSecondTenantInfo *addSecondTenant = segue.destinationViewController;
 
            addSecondTenant.details = _details;
 
            NSLog(@"Tenant Info: %@", _details);
        
    }else if([[segue identifier] isEqualToString:@"editPrimary"]){
        MLAddTenantViewController *editPrimaryInfo = segue.destinationViewController;
        
        editPrimaryInfo.details = _details;
        
        
        
    }else if([[segue identifier] isEqualToString:@"editSecondary"]){
        MLAddSecondTenantInfo *editSecondTenant = segue.destinationViewController;
        
        editSecondTenant.details = _details;
        
    }
}


@end

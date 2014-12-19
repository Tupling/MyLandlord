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
#import "MLTenantDocuments.h"
#import "MLTenantFinances.h"

@interface MLTenantDetailsViewController () <UIActionSheetDelegate>

@end

@implementation MLTenantDetailsViewController

@synthesize sTenantphoneButton, sTenantEmailButton, sTenantEmailHeader, sTenantPhoneHeader;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - View Load Methods
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
    
    [self performSelector:@selector(updateUIElements) withObject:nil];
    
}


#pragma mark - Update UI Elements

-(void)updateUIElements
{
    NSLog(@"%@", _details.pFirstName);
    
    pTenantName.text = [NSString stringWithFormat:@"%@ %@", _details.pFirstName, _details.pLastName];
    
    
    
    //Date Formating and Comparison
    //Below format dates and compare due date with current date to determine status.
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    NSDate *leaseEnd = _details.leaseEnd;
    NSDate *leaseStart = _details.leaseStart;
    
    
    
    
    leaseEndLabel.text = [dateFormatter stringFromDate:leaseEnd];
    leaseStartLabel.text = [dateFormatter stringFromDate:leaseStart];
    rentDueLabel.text = [NSString stringWithFormat:@"$%@.00", _details.rentAmount];
    
    if ([_details.sFirstName isEqualToString:@""] || _details.sFirstName == nil) {
        sTenantHeaderLabel.hidden = YES;
        sTenantName.hidden = YES;
        self.sTenantphoneButton.hidden = YES;
        self.sTenantEmailButton.hidden = YES;
        
        self.sTenantEmailHeader.hidden = YES;
        self.sTenantPhoneHeader.hidden = YES;
        
        
        
    }else{
        
        sTenantName.text = [NSString stringWithFormat:@"%@ %@", _details.sFirstName, _details.sLastName];
    }
    

}

#pragma mark - Action Methods

-(IBAction)editDetails:(id)sender
{
   
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Edit Primary or Secondary Tenant" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit Primary", @"Edit Secondary", nil];
    actionSheet.tag = 10;
    [actionSheet showInView:self.view];
    actionSheet = nil;
    
}


-(IBAction)viewDocuments:(id)sender
{
    [self performSegueWithIdentifier:@"viewDocuments" sender:self];
}


-(IBAction)viewFinances:(id)sender
{
    [self performSegueWithIdentifier:@"viewFinances" sender:self];
}


#pragma mark - ActionSheet Method

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *selectedValue = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if (![selectedValue.lowercaseString isEqualToString:@"cancel"]) {
        
        
        switch (actionSheet.tag) {
                
            case 10:
                
                switch (buttonIndex) {
                    case 0:
                        
                        [self performSegueWithIdentifier:@"editPrimary" sender:self];
                        break;
                    
                    case 1:
                        
                        [self performSegueWithIdentifier:@"editSecondary" sender:self];
                        break;
                        
                    default:
                        
                        break;
                }
                
                break;
                
            default:
                
                break;
        }
        
    }
}



#pragma mark - Tenant Action Methods
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
 
     
        
    }else if([[segue identifier] isEqualToString:@"editPrimary"]){
        MLAddTenantViewController *editPrimaryInfo = segue.destinationViewController;
        
        editPrimaryInfo.details = _details;
        
        
        
    }else if([[segue identifier] isEqualToString:@"editSecondary"]){
        MLAddSecondTenantInfo *editSecondTenant = segue.destinationViewController;
        
        editSecondTenant.details = _details;
        
    }else if ([[segue identifier] isEqualToString:@"viewDocuments"]) {
        MLTenantDocuments *tenantDetails = segue.destinationViewController;
        
        tenantDetails.details = _details;
        
        
    }
    else if ([[segue identifier] isEqualToString:@"viewFinances"]) {
        MLTenantFinances *tenantDetails = segue.destinationViewController;
        
        tenantDetails.tenDetails = _details;
        
        
    }
}

#pragma mark
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

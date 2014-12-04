//
//  FirstViewController.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/17/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLHomeViewController.h"
#import "MLLoginViewController.h"
#import "AppDelegate.h"

@interface MLHomeViewController () <UIAlertViewDelegate>
{
    UIAlertView *logOutAlert;
}

@end

@implementation MLHomeViewController

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
    [self.view setNeedsDisplay];
    
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,45)] ;
    [image setImage:[UIImage imageNamed:@"MyLandlord.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = image;
    
    
    self.propCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)[ApplicationDelegate.propertyArray count]];
    
    //Check for valid Current User
    if ([PFUser currentUser]) {
        
         //Sync data if not initial login
        
    }else{
        
        [self requireLogin];
    }
    //Add radius to profile image
    self.profileImg.layer.cornerRadius = self.profileImg.frame.size.width / 2;
    self.profileImg.clipsToBounds = YES;
    self.profileImg.layer.borderWidth = 1.0f;
    self.profileImg.layer.borderColor = [[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1] CGColor];
    
    //Add radius to button
    self.addProp.layer.cornerRadius = 5;
    self.addTenant.layer.cornerRadius = 5;
    



}

-(void)viewWillAppear:(BOOL)animated
{
    
    self.propCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)[ApplicationDelegate.propertyArray count]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark REQUIRE LOGIN
-(void)requireLogin
{
    MLLoginViewController *login = [[MLLoginViewController alloc] init];
    
    
    //Setup login view
    //PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    login.fields = PFLogInFieldsLogInButton | PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton;
    [login setDelegate:self];
    
    //Setup sign up view
    PFSignUpViewController *signUpView = [[PFSignUpViewController alloc] init];
    [signUpView setDelegate:self];
    
    [login setSignUpController:signUpView];
    
    
    
    [self presentViewController:login animated:YES completion:nil];
}
#pragma SIGNUP
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [[[UIAlertView alloc] initWithTitle:@"User Created" message:@"Your user account has been created!"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark LOGIN
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    
    
    //if (ApplicationDelegate.isConnected == YES) {
        
        // Check if both fields are completed
        if (username && password && username.length && password.length) {
            return YES;
            
        } else if(username.length < 1 && password.length < 1) {
            [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"You did not enter a user name or password!"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
        }else if(username.length < 1) {
            [[[UIAlertView alloc] initWithTitle:@"Missing Username" message:@"You did not enter a username!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
            
        } else if(password.length < 1) {
            [[[UIAlertView alloc] initWithTitle:@"Missing Password" message:@"You did not enter a password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        } else if(username.length < 1 && password.length < 1) {
            [[[UIAlertView alloc] initWithTitle:@"Missing Information" message:@"You did not enter a user name or password!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        }
        
        return NO;
        
    /*}else{
        
        UIAlertView *noConnection = [[UIAlertView alloc] initWithTitle:@"No Connection" message:@"You do not have an active network connect. Please connect to a network and try again" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        
        [noConnection show];
        
    }
    return NO;*/
    
}

#pragma mark LOGIN SUCCESS
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    NSLog(@"%@ Logged In",[[PFUser currentUser] username]);
    
    [ApplicationDelegate loadProperties];
    [ApplicationDelegate loadTenants];
    
    self.propCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)[ApplicationDelegate.propertyArray count]];
   
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark LOGOUT
-(IBAction)logOut:(id)sender
{
    
    
    logOutAlert = [[UIAlertView alloc] initWithTitle:@"Logout User" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    
    [logOutAlert show];
    
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //LogOut AlertView Actions
    if (alertView == logOutAlert) {
        
        //If user selected yes
        if (buttonIndex == 1){
            
            [PFUser logOut];
            
            //Present user with login screen
            [self requireLogin];
            
        }
    }
  
}


@end

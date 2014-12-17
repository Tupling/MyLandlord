//
//  FirstViewController.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/17/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLHomeViewController.h"
#import "MLLoginViewController.h"
#import "MLSignUpViewController.h"
#import "AppDelegate.h"

@interface MLHomeViewController () <UIAlertViewDelegate, DBRestClientDelegate>
{
    UIAlertView *logOutAlert;
    UIAlertView *dropBoxLink;
}

@end

@implementation MLHomeViewController

@synthesize profileImg;


#pragma mark - View Load Methods
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:@"FirstLaunch"]);
    
    //Check for valid Current User
    if ([PFUser currentUser]) {
        
        
        self.viewProperties.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.viewProperties.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.viewProperties.titleLabel.numberOfLines = 0;
        
        self.rentsDueButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.rentsDueButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.rentsDueButton.titleLabel.numberOfLines = 0;
        
        self.tasksButton.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.tasksButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.tasksButton.titleLabel.numberOfLines = 0;
        
        
        [self.viewProperties setTitle:[NSString stringWithFormat:@"Properties\n%lu",(unsigned long)[ApplicationDelegate.propertyArray count]] forState:UIControlStateNormal];
        
        [self.rentsDueButton setTitle:[NSString stringWithFormat:@"Rents Due\n0"] forState:UIControlStateNormal];
        
        [self.tasksButton setTitle:[NSString stringWithFormat:@"Tasks\n%lu", (unsigned long)[ApplicationDelegate.inCompleteTaskArray count]] forState:UIControlStateNormal];
        
        [[[[[self tabBarController] tabBar] items] objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%lu", (unsigned long)[ApplicationDelegate.inCompleteTaskArray count]]];
        
        
        
        
        self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        self.restClient.delegate = self;
        
        
    }else{
        
        [self performSelector:@selector(requireLogin:) withObject:nil afterDelay:0.1];
    }
    
    
    
    
}



- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:YES];
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,45)] ;
    [image setImage:[UIImage imageNamed:@"MyLandlord.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = image;
    
    
    [self.viewProperties setTitle:[NSString stringWithFormat:@"Properties\n%lu",(unsigned long)[ApplicationDelegate.propertyArray count]] forState:UIControlStateNormal];
    
    [self.rentsDueButton setTitle:[NSString stringWithFormat:@"Rents Due\n0"] forState:UIControlStateNormal];
    
    [self.tasksButton setTitle:[NSString stringWithFormat:@"Tasks\n%lu", (unsigned long)[ApplicationDelegate.inCompleteTaskArray count]] forState:UIControlStateNormal];
    
    [[[[[self tabBarController] tabBar] items] objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%lu", (unsigned long)[ApplicationDelegate.inCompleteTaskArray count]]];
    
    
    //Add radius to profile image
    self.profileImg.layer.cornerRadius = self.profileImg.frame.size.width / 2;
    self.profileImg.clipsToBounds = YES;
    self.profileImg.layer.borderWidth = 1.0f;
    self.profileImg.layer.borderColor = [[UIColor colorWithRed:0.941 green:0.941 blue:0.941 alpha:1] CGColor];
    
    //Add radius to button
    self.addProp.layer.cornerRadius = 5;
    self.addTenant.layer.cornerRadius = 5;
    self.addTask.layer.cornerRadius = 5;
    
    
    [self.view setNeedsDisplay];
    
    
    
}
#pragma mark

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction)propertiesClicked:(id)sender
{
    
    [self.tabBarController setSelectedIndex:1];
}

-(IBAction)tasksClicked:(id)sender
{
    [self.tabBarController setSelectedIndex:3];
    
}

#pragma mark
#pragma mark PFLogin/Signup Delegate Methods
-(void)requireLogin:(id)sender
{
    MLLoginViewController *login = [[MLLoginViewController alloc] init];
    
    MLSignUpViewController *signUp = [[MLSignUpViewController alloc] init];
    
    //Setup login view
    //PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    login.fields = PFLogInFieldsLogInButton | PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton;
    [login setDelegate:self];
    
    [signUp setDelegate:self];
    
    [login setSignUpController:signUp];
    
    
    
    [self.tabBarController presentViewController:login animated:YES completion:nil];
    
}



- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    
    
    [[[UIAlertView alloc] initWithTitle:@"User Created" message:@"Your user account has been created!"delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


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


- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    NSLog(@"%@ Logged In",[[PFUser currentUser] username]);
    
    
    
    [ApplicationDelegate loadProperties];
    [ApplicationDelegate loadTenants];
    [ApplicationDelegate loadSubUnits];
    [ApplicationDelegate loadInCompleteTasks];
    [ApplicationDelegate loadCompletedTasks];
    [ApplicationDelegate loadFinancials];
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"FirstLaunch"] == nil)
    {
        
        
        dropBoxLink = [[UIAlertView alloc] initWithTitle:@"Link Dropbox\u00AE" message:@"This application utilizes Dropbox\u00AE in order to store documents. You must link your Dropbox\u00AE in order to utilize the document features. \n\n Would you like to link your account now?"  delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
        
        [dropBoxLink show];
        
        
    }
    
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
    
}



-(IBAction)logOut:(id)sender
{
    
    
    logOutAlert = [[UIAlertView alloc] initWithTitle:@"Logout User" message:@"Are you sure you want to logout?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
    
    [logOutAlert show];
    
    
}


#pragma mark - Alertview Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //LogOut AlertView Actions
    if (alertView == logOutAlert) {
        
        //If user selected yes
        if (buttonIndex == 1){
            
            [PFUser logOut];
            
            //Present user with login screen
            [self performSelector:@selector(requireLogin:) withObject:nil afterDelay:0.0];
            
        }
    } if (alertView == dropBoxLink){
        
        if(buttonIndex == 0){
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"FirstLaunch"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else if(buttonIndex == 1){
            
            if (![[DBSession sharedSession] isLinked]) {
                
                //[[DBSession sharedSession]unlinkAll];
                [[DBSession sharedSession] linkFromController:self];
            }
        }
    }
    
}



@end

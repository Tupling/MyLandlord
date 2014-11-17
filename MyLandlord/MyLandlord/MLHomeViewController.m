//
//  FirstViewController.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/17/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLHomeViewController.h"

@interface MLHomeViewController ()

@end

@implementation MLHomeViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    // Do any additional setup after loading the view, typically from a nib.
    
    //Check for valid Current User
    if ([PFUser currentUser]) {
        
         //Sync data if not initial login
        
    }else{
        
        [self requireLogin];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)requireLogin
{
    //Setup login view
    PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
    logInViewController.fields = PFLogInFieldsLogInButton | PFLogInFieldsUsernameAndPassword | PFLogInFieldsSignUpButton;
    [logInViewController setDelegate:self];
    
    //Setup sign up view
    PFSignUpViewController *signUpView = [[PFSignUpViewController alloc] init];
    [signUpView setDelegate:self];
    
    [logInViewController setSignUpController:signUpView];
    
    
    
    [self presentViewController:logInViewController animated:YES completion:nil];
}

@end

//
//  MLAddPropertyViewController.h
//  MyLandlord
//
//  Created by Dale Tupling on 11/19/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface MLAddPropertyViewController : UIViewController
{
    IBOutlet UITextField *propName;
    IBOutlet UITextField *propAddress;
    IBOutlet UITextField *propCity;
    IBOutlet UITextField *propState;
    IBOutlet UITextField *propZip;
}

@property (nonatomic, retain) IBOutlet UITextField *propName;
@property (nonatomic, retain) IBOutlet UITextField *propAddress;
@property (nonatomic, retain) IBOutlet UITextField *propCity;
@property (nonatomic, retain) IBOutlet UITextField *propState;
@property (nonatomic, retain) IBOutlet UITextField *propZip;

-(IBAction)cancel:(id)sender;

-(IBAction)saveProp:(id)sender;

@end

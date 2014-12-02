//
//  MLAddPropertyViewController.h
//  MyLandlord
//
//  Created by Dale Tupling on 11/19/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "AppDelegate.h"

@interface MLAddPropertyViewController : UIViewController
{
    IBOutlet UITextField *propName;
    IBOutlet UITextField *propAddress;
    IBOutlet UITextField *propCity;
    IBOutlet UITextField *propState;
    IBOutlet UITextField *propZip;
    IBOutlet UIButton *addProp;
}

@property (nonatomic, retain) IBOutlet UITextField *propName;
@property (nonatomic, retain) IBOutlet UITextField *propAddress;
@property (nonatomic, retain) IBOutlet UITextField *propCity;
@property (nonatomic, retain) IBOutlet UITextField *propState;
@property (nonatomic, retain) IBOutlet UITextField *propZip;
@property (nonatomic, retain) IBOutlet UIButton *addProp;

@property (nonatomic, retain) IBOutlet UISwitch *multiFamily;
@property (nonatomic, retain) IBOutlet UIStepper *unitCount;
@property (nonatomic, retain) IBOutlet UILabel *unitCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *noLabel;
@property (nonatomic, retain) IBOutlet UILabel *yesLabel;

-(IBAction)cancel:(id)sender;

-(IBAction)saveProp:(id)sender;

-(IBAction)multFamilyToggle:(id)sender;

-(IBAction)unitCounter:(id)sender;

@end

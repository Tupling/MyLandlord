//
//  FirstViewController.h
//  MyLandlord
//
//  Created by Dale Tupling on 11/17/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@interface MLHomeViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
{
    IBOutlet UIImageView *profileImg;
}

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) IBOutlet UIImageView *profileImg;
@property(nonatomic, strong) IBOutlet UIButton *addProp;
@property(nonatomic, strong) IBOutlet UIButton *addTenant;
@property(nonatomic, retain) IBOutlet UILabel *propCount;
@property(nonatomic, retain) IBOutlet UILabel *toDoCount;

-(IBAction)logOut:(id)sender;

@end


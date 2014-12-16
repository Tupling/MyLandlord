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
#import <DropboxSDK/DropboxSDK.h>
#import "AppDelegate.h"


@interface MLHomeViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
{
    IBOutlet UIImageView *profileImg;
    
    NSArray *taskDueArray;
}

@property(nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property(nonatomic, strong) IBOutlet UIImageView *profileImg;

@property(nonatomic, retain) IBOutlet UILabel *propCount;
@property(nonatomic, retain) IBOutlet UILabel *toDoCount;

@property(nonatomic, strong) IBOutlet UIButton *addProp;
@property(nonatomic, strong) IBOutlet UIButton *addTenant;
@property(nonatomic, strong) IBOutlet UIButton *addTask;
@property(nonatomic, strong) IBOutlet UIButton *viewProperties;
@property(nonatomic, strong) IBOutlet UIButton *rentsDueButton;
@property(nonatomic, strong) IBOutlet UIButton *tasksButton;

//Core Data
@property(nonatomic, strong) NSManagedObjectContext *context;
@property(nonatomic, strong) NSFetchRequest *fetchRequest;
@property(nonatomic, strong) NSEntityDescription *taskEntity;
@property(nonatomic, strong) NSPredicate *predicate;

-(IBAction)logOut:(id)sender;
-(void)requireLogin:(id)sender;


@end


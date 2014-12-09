//
//  MLAddUnits.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/9/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Properties.h"
#import "AppDelegate.h"


@interface MLAddUnits : UIViewController
{

}

@property (nonatomic, strong) IBOutlet UITextField *unitId;
@property (nonatomic, strong) IBOutlet UIButton *saveUnit;
@property (nonatomic, strong) IBOutlet UILabel *propertyName;

@property(nonatomic, strong)Properties *propDetails;


@end

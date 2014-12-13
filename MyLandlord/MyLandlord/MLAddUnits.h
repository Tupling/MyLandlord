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
#import <DropboxSDK/DropboxSDK.h>


@interface MLAddUnits : UIViewController
{

}

@property (nonatomic, strong) IBOutlet UITextField *unitId;
@property (nonatomic, strong) IBOutlet UIButton *saveUnit;
@property (nonatomic, strong) IBOutlet UILabel *propertyName;

@property(nonatomic, strong)Properties *propDetails;

//DropBox RestClient Property
@property (nonatomic, strong) DBRestClient *restClient;


@end

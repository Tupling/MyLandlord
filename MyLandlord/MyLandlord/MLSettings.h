//
//  MLSettings.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/18/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <DropboxSDK/DropboxSDK.h>

@interface MLSettings : UIViewController
{

}

@property (nonatomic, strong) IBOutlet UIButton *linkDropBox;
@property (nonatomic, strong) IBOutlet UILabel *dropBoxStatus;
@end

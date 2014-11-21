//
//  MLPropertyDetails.h
//  MyLandlord
//
//  Created by Dale Tupling on 11/21/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Properties.h"

@interface MLPropertyDetails : UIViewController
{
    IBOutlet UILabel *propAddress;
}


@property (nonatomic, strong)Properties *details;

@end

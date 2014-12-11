//
//  MLPropertyExpenses.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/2/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Properties.h"

@interface MLPropertyExpenses : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>
{
    
}

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet UIButton *exportButton;

@property(nonatomic, strong) Properties *details;


@end

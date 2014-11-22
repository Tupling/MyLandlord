//
//  MLFinancesView.h
//  MyLandlord
//
//  Created by Dale Tupling on 11/21/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLFinancesView : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>

-(IBAction)closeView:(id)sender;
-(IBAction)exportFinance:(id)sender;

@end

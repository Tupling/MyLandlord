//
//  MLTenantFinances.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/14/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>
#import <QuickLook/QuickLook.h>

#import "AppDelegate.h"
#import "Tenants.h"
#import "Financials.h"


@interface MLTenantFinances : UIViewController<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate,QLPreviewControllerDataSource>

{
    NSString *exportFilePath;
}

- (IBAction)exportData:(id)sender;

@property (nonatomic, retain) NSString *exportFilePath;

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property(nonatomic, strong) IBOutlet UIButton *exportButton;

@property (nonatomic, strong)IBOutlet UILabel *category;
@property (nonatomic, strong)IBOutlet UILabel *amount;
@property (nonatomic, strong)IBOutlet UILabel *date;
@property (nonatomic, strong)IBOutlet UILabel *itemName;

@property(nonatomic, strong) Tenants *tenDetails;
@property(nonatomic, strong) Financials *finDetails;


//Core Data
@property(nonatomic, strong) NSManagedObjectContext *context;
@property(nonatomic, strong) NSFetchRequest *fetchRequest;
@property(nonatomic, strong) NSEntityDescription *financeEntity;
@property(nonatomic, strong) NSPredicate *predicate;

@end
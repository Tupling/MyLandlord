//
//  MLPropertyExpenses.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/2/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <QuickLook/QuickLook.h>

#import "Properties.h"
#import "AppDelegate.h"
#import "SubUnit.h"
#import "Financials.h"

@interface MLPropertyExpenses : UIViewController <UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate,QLPreviewControllerDataSource>

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

@property(nonatomic, strong) Properties *propDetails;
@property(nonatomic, strong) SubUnit *subDetails;
@property(nonatomic, strong) Financials *finDetails;

//Core Data
@property(nonatomic, strong) NSManagedObjectContext *context;
@property(nonatomic, strong) NSFetchRequest *fetchRequest;
@property(nonatomic, strong) NSEntityDescription *financeEntity;
@property(nonatomic, strong) NSPredicate *predicate;


@end

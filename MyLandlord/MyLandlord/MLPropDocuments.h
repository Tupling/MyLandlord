//
//  MLPropDocuments.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/13/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Properties.h"
#import <DropboxSDK/DropboxSDK.h>
#import "FileInfo.h"

@interface MLPropDocuments : UIViewController
{
    IBOutlet UILabel *fileNameLabel;
}

-(NSString*)tempFilePath;

@property(nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic) Properties *details;

//DropBox RestClient Property
@property (nonatomic, strong) DBRestClient *restClient;

@property (nonatomic, strong) FileInfo *fileInfo;

@end

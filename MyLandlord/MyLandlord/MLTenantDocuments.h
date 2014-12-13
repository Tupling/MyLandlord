//
//  MLTenantDocuments.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/13/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DropboxSDK/DropboxSDK.h>
#import "MJPPdfViewer.h"

#import "Tenants.h"
#import "FileInfo.h"


@interface MLTenantDocuments : UIViewController
{
     IBOutlet UILabel *fileNameLabel;
}

-(NSString*)tempFilePath;

@property(nonatomic, strong) IBOutlet UITableView *tableView;

@property (nonatomic) Tenants *details;

//DropBox RestClient Property
@property (nonatomic, strong) DBRestClient *restClient;

@property (nonatomic, strong) FileInfo *fileInfo;


@end

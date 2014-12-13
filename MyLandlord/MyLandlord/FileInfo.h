//
//  FileInfo.h
//  MyLandlord
//
//  Created by Dale Tupling on 12/13/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileInfo : NSObject


@property (nonatomic, strong) NSString *filePath;
@property (nonatomic, strong) NSString *fileName;

-(id)initWithFileName:(NSString*)fileName withFilePath:(NSString*)filePath;

@end

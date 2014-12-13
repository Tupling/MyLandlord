//
//  FileInfo.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/13/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "FileInfo.h"

@implementation FileInfo

-(id)initWithFileName:(NSString*)fileName withFilePath:(NSString*)filePath
{
    self = [super init];
    
    self.fileName = fileName;
    self.filePath = filePath;
    
    
    return self;
}

@end

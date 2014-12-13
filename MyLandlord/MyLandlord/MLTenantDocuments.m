//
//  MLTenantDocuments.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/13/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLTenantDocuments.h"


@interface MLTenantDocuments () <UITableViewDataSource, UITableViewDelegate, DBRestClientDelegate>
{
    NSMutableDictionary *fileDictionary;
    NSMutableArray *documentsArray;
}

@end

@implementation MLTenantDocuments

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    fileDictionary = [[NSMutableDictionary alloc] init];
    documentsArray = [[NSMutableArray alloc] init];
    //DropBox
    self.restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
    self.restClient.delegate = self;
    
    
    NSString *folderName = [NSString stringWithFormat:@"/Tenants/%@_%@", self.details.pFirstName, self.details.pLastName];
    
    [self.restClient loadMetadata:folderName];
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)restClient:(DBRestClient *)client loadedMetadata:(DBMetadata *)metadata {
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            
            _fileInfo = [[FileInfo alloc] init];
            
            _fileInfo.fileName = file.filename;
            _fileInfo.filePath = file.path;
            
            NSLog(@"    %@", file.path);
            NSLog(@"	%@", file.filename);
            
            [documentsArray addObject:_fileInfo];
            
        }
        
        
    }
    
    [self.tableView reloadData];
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return documentsArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        
        fileNameLabel = (UILabel*)[cell viewWithTag:101];
        
    }
    
    
    
    
    NSLog(@"%@", [[documentsArray objectAtIndex:indexPath.row] valueForKey:@"fileName"]);
    
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *fileNameString = [[documentsArray objectAtIndex:indexPath.row] valueForKey:@"fileName"];
        
        fileNameLabel = (UILabel*)[cell viewWithTag:101];
        
        [fileNameLabel setText:fileNameString];// Update table UI
    });
    
    
    //self.fileNameLabel = [docFileInto valueForKey:@"fileName"];
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *fileNameString = [[documentsArray objectAtIndex:indexPath.row] valueForKey:@"fileName"];
    NSString *filePathString = [[documentsArray objectAtIndex:indexPath.row] valueForKey:@"filePath"];
    
    [self restClient:self.restClient loadedFile:filePathString];
    
    //Push detailsView to the top of the stack
    //[self performSegueWithIdentifier:@"details" sender:self];
    
    
    //Deselect Item
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath
{
    MJPPdfViewer *pdfViewer = [[MJPPdfViewer alloc] init];
    pdfViewer.fileName = destPath;
    pdfViewer.margin = 10.0;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pdfViewer];
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

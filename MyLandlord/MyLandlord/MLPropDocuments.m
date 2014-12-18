//
//  MLPropDocuments.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/13/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLPropDocuments.h"
#import "MJPPdfViewer.h"

@interface MLPropDocuments () <DBRestClientDelegate>
{
    NSMutableDictionary *fileDictionary;
    NSMutableArray *documentsArray;
    
    UIAlertView *deleteObject;
}
@end

@implementation MLPropDocuments

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
    
    if(self.subUnitDetails != nil){
    
    NSString *folderName = [NSString stringWithFormat:@"/Properties/%@/%@",self.details.propName, self.subUnitDetails.unitNumber];
        [self.restClient loadMetadata:folderName];
    }else {
        
    NSString *folderName = [NSString stringWithFormat:@"/Properties/%@", self.details.propName];
        [self.restClient loadMetadata:folderName];
    }
    
    
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSString *filePathString = [[documentsArray objectAtIndex:indexPath.row] valueForKey:@"filePath"];
    
    
    //Get File from Drobbox
    [self.restClient loadFile:filePathString intoPath:[self tempFilePath]];
    
    
    //Push detailsView to the top of the stack
    //[self performSegueWithIdentifier:@"details" sender:self];
    
    
    //Deselect Item
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        self.fileInfo = [documentsArray objectAtIndex:indexPath.row];
        
        
        deleteObject = [[UIAlertView alloc] initWithTitle:@"Remove Document" message:@"This will remove the document from your Dropbox\u00AE.\nAre you sure you want to delete this document?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        
        //Set alert tag do index path. Allows me to pass the table index of item being deleted.
        deleteObject.tag = indexPath.row;
        
        [deleteObject show];
        

    
        
    }
}

#pragma mark - Alertview Delegate Methods
//Alert user of actions
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(alertView == deleteObject){
        
        //If User selected YES to remove tenant
        if (buttonIndex == 1) {
            
            //Get tenant object from Parse
            NSUInteger rowIndex = deleteObject.tag;
            
            self.fileInfo = [documentsArray objectAtIndex:rowIndex];
            
            
            [self.restClient deletePath:self.fileInfo.filePath];
        }
    }
    
}



#pragma mark - DBRestClient Methods

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


- (void)restClient:(DBRestClient *)client loadedFile:(NSString *)localPath
       contentType:(NSString *)contentType metadata:(DBMetadata *)metadata {
    NSLog(@"File loaded into path: %@", localPath);
    
    MJPPdfViewer *pdfViewer = [[MJPPdfViewer alloc] init];
    pdfViewer.fileName = @"temp.pdf";
    pdfViewer.margin = 10.0;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:pdfViewer];
    [self presentViewController:navigationController animated:YES completion:nil];
    
}

-(void)restClient:(DBRestClient *)client deletedPath:(NSString *)path
{
    
}

- (void)restClient:(DBRestClient*)client loadProgress:(CGFloat)progress forFile:(NSString*)destPath
{
    
}

- (void)restClient:(DBRestClient *)client loadFileFailedWithError:(NSError *)error {
    NSLog(@"There was an error loading the file: %@", error);
}


//Load File into Temp Directory
- (NSString*)tempFilePath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.pdf"];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

//
//  MLTenantFinances.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/14/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLTenantFinances.h"
#import "MLAddTenantFinance.h"
#import "Financials.h"


//Page Dimensions Declarations
#define kDefaultPageHeight 792
#define kDefaultPageWidth  612
#define kMargin 70
#define kColumnMargin 2

@interface MLTenantFinances () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *currentPropFinances;
    
}

@end

@implementation MLTenantFinances

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.context = [ApplicationDelegate managedObjectContext];
    
    //Create new Fetch Request
    self.fetchRequest = [[NSFetchRequest alloc] init];
    
    //Request Entity EventInfo
    self.financeEntity = [NSEntityDescription entityForName:@"Financials" inManagedObjectContext:self.context];
    
    //Set fetchRequest entity to EventInfo Description
    [self.fetchRequest setEntity:self.financeEntity];
    
 
        
        self.predicate = [NSPredicate predicateWithFormat:@"parentId == %@", self.details.tenantId];
        

    
    
    [self.fetchRequest setPredicate:self.predicate];
    
    NSError * error;
    //Set events array to data in core data
    currentPropFinances = (NSMutableArray*)[self.context executeFetchRequest:self.fetchRequest error:&error];
    
    
    
    NSLog(@"%lu", (unsigned long)[currentPropFinances count]);
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.context = [ApplicationDelegate managedObjectContext];
        
        //Create new Fetch Request
        self.fetchRequest = [[NSFetchRequest alloc] init];
        
        //Request Entity EventInfo
        self.financeEntity = [NSEntityDescription entityForName:@"Financials" inManagedObjectContext:self.context];
        
        //Set fetchRequest entity to EventInfo Description
        [self.fetchRequest setEntity:self.financeEntity];
        
        self.predicate = [NSPredicate predicateWithFormat:@"parentId == %@", self.details.tenantId];
        
        
        
        
        
        [self.fetchRequest setPredicate:self.predicate];
        
        NSError * error;
        //Set events array to data in core data
        currentPropFinances = (NSMutableArray*)[self.context executeFetchRequest:self.fetchRequest error:&error];
        
        
        
        NSLog(@"%lu", (unsigned long)[currentPropFinances count]);
        
        
        [self.tableView reloadData];
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.exportButton.layer.cornerRadius = 5;
    
    NSLog(@"Property Details == %@", self.details);
    
    //Set Nav Bar Image
    UIImageView *image =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,45)] ;
    [image setImage:[UIImage imageNamed:@"MyLandlord.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = image;
    
    UIImage *buttonImage = [UIImage imageNamed:@"new.png"];
    UIButton* addNewExpense = [UIButton buttonWithType:UIButtonTypeCustom];
    [addNewExpense setImage:buttonImage forState:UIControlStateNormal];
    
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:addNewExpense];
    [self.navigationController.navigationItem.rightBarButtonItem setTintColor:[UIColor colorWithRed:0.09 green:0.18 blue:0.2 alpha:1]];
    self.navigationController.navigationItem.rightBarButtonItem = rightBarButton;
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addNewExpense:(id)sender
{
    [self performSegueWithIdentifier:@"addNewFinance" sender:self];
}


#pragma mark - Tableview Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [currentPropFinances count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    self.amount = (UILabel*)[cell viewWithTag:3];
    self.category = (UILabel*)[cell viewWithTag:2];
    self.date = (UILabel*)[cell viewWithTag:4];
    self.itemName = (UILabel*)[cell viewWithTag:104];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    
    
    Financials *finance = [currentPropFinances objectAtIndex:indexPath.row];
    
    self.date.text = [dateFormatter stringFromDate:finance.date];
    self.category.text = finance.category;
    self.amount.text = [NSString stringWithFormat:@"$%.02f", finance.fAmount];
    self.itemName.text = finance.itemName;
    
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"addNewFinance"]) {
        
        MLAddTenantFinance *tenantDetails = segue.destinationViewController;
        
        tenantDetails.details = _details;
        
    }
}




#pragma mark - Export Data Method

- (IBAction)exportData:(id)sender {
    
    
    //Create file path to temp directory
    NSString* path = [self tempFilePath];
    
    // get a temprorary filename for this PDF
    path = NSTemporaryDirectory();
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMMM_dd_yyyy"];
    
    NSDate *today = [NSDate date];
    self.exportFilePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_Export_%@.pdf",self.details.pFirstName, self.details.pLastName, [df stringFromDate:today]]];
    
    
    UIGraphicsBeginPDFContextToFile(self.exportFilePath, CGRectZero, nil);
    
    // get the context reference so we can render to it.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    int currentPage = 0;
    
    // maximum height and width of the content on the page
    CGFloat maxWidth = kDefaultPageWidth - kMargin * 2;
    CGFloat maxHeight = kDefaultPageHeight - kMargin * 2;
    
    //Set Property Name Max width
    CGFloat propNameMaxWidth = maxWidth / 3;
    
    //Set Expense Type max width
    CGFloat expenseMaxWidth = (maxWidth / 3) - kColumnMargin;
    
    
    // only create the fonts once since it is a somewhat expensive operation
    UIFont* propertyNameFont = [UIFont boldSystemFontOfSize:17];
    UIFont* expenseFont = [UIFont systemFontOfSize:15];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    
    NSDictionary *attributes = @{ NSFontAttributeName: expenseFont,
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    NSDictionary *headerAttributes = @{ NSFontAttributeName: propertyNameFont, NSParagraphStyleAttributeName: paragraphStyle};
    
    CGFloat currentPageY = 0;
    
    
    //Create Page Begining
    UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kDefaultPageWidth, kDefaultPageHeight), nil);
    currentPageY = kMargin;
    
    //Draw Property Name
    
    NSString *reportTile = [NSString stringWithFormat:@"%@ %@ Finance Report", self.details.pFirstName, self.details.pLastName];
    
    NSString *categoryLabel = @"Category";
    
    NSString *amountLabel = @"Amount";
    
    NSString *dateLabel = @"Date";
    
    CGSize size = [categoryLabel sizeWithFont:propertyNameFont forWidth:maxWidth lineBreakMode:NSLineBreakByWordWrapping];
    
    [reportTile drawInRect:CGRectMake(250, 15, propNameMaxWidth, maxHeight) withAttributes:headerAttributes];
    
    [categoryLabel drawInRect:CGRectMake(kMargin, currentPageY, propNameMaxWidth, maxHeight) withAttributes:attributes];
    
    [amountLabel drawInRect:CGRectMake(kMargin + propNameMaxWidth + kColumnMargin, currentPageY, propNameMaxWidth, maxHeight) withAttributes:attributes];
    
    [dateLabel drawInRect:CGRectMake(kMargin + propNameMaxWidth + kColumnMargin + propNameMaxWidth, currentPageY, propNameMaxWidth, maxHeight) withAttributes:attributes];
    
    currentPageY += size.height;
    
    //Draw header linebreak under Property Name
    CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
    CGContextMoveToPoint(context, kMargin, currentPageY);
    CGContextAddLineToPoint(context, kDefaultPageWidth - kMargin, currentPageY);
    CGContextStrokePath(context);
    
    //Get Current Property Finance Data
    NSArray* expenses = currentPropFinances;
    
    NSLog(@"Expense Array = %@", expenses.description);
    
    //Iterate through property finances
    for(NSObject* data in expenses)
    {
        NSString* expenseType = [data valueForKey:@"category"];
        NSString* amount = [NSString stringWithFormat:@"$ %@",[data valueForKey:@"fAmount"]];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
        
        NSString *dateString = [dateFormatter stringFromDate:[data valueForKey:@"date"]];
        
        // before we render any text to the PDF, we need to measure it, so we'll know where to render the
        // next line.
        size = [expenseType sizeWithFont:expenseFont constrainedToSize:CGSizeMake(expenseMaxWidth, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        //Check page bounds and create new page if text drawn exceeds boundaries
        if (size.height + currentPageY > maxHeight) {
            // create a new page and reset the current page's Y value
            UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kDefaultPageWidth, kDefaultPageHeight), nil);
            currentPageY = kMargin;
        }
        
        
        [expenseType drawInRect:CGRectMake(kMargin, currentPageY, expenseMaxWidth, maxHeight) withAttributes:attributes];
        
        //Put Expense amount next to expenses type
        [amount drawInRect:CGRectMake(kMargin + propNameMaxWidth + kColumnMargin, currentPageY, expenseMaxWidth, maxHeight) withAttributes:attributes];
        
        
        [dateString drawInRect:CGRectMake(kMargin + propNameMaxWidth + kColumnMargin + propNameMaxWidth, currentPageY, propNameMaxWidth, maxHeight) withAttributes:attributes];
        
        currentPageY += size.height;
        
    }
    
    
    // increment the page number.
    currentPage++;
    
    
    // end and save the PDF.
    UIGraphicsEndPDFContext();
    
    // Ask the user if they'd like to see the file or email it.
    UIActionSheet* actionSheet = [[UIActionSheet alloc] initWithTitle:@"Would you like to preview or email this PDF?"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Preview", @"Email", nil];
    [actionSheet showInView:self.view];
    
    
    
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//Load File into Temp Directory
- (NSString*)tempFilePath {
    return [NSTemporaryDirectory() stringByAppendingPathComponent:@"temp.pdf"];
}

#pragma mark - MFMailComposerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"Action Sheet button %ld", (long)buttonIndex);
    
    if (buttonIndex == 0) {
        
        // present a preview of this PDF File.
        QLPreviewController* preview = [[QLPreviewController alloc] init];
        preview.dataSource = self;
        [self presentViewController:preview animated:YES completion:nil];
        
        
        
    }
    else if(buttonIndex == 1)
    {
        // email the PDF File.
        MFMailComposeViewController* mailComposer = [[MFMailComposeViewController alloc] init];
        mailComposer.mailComposeDelegate = self;
        [mailComposer addAttachmentData:[NSData dataWithContentsOfFile:self.exportFilePath]
                               mimeType:@"application/pdf" fileName:@"report.pdf"];
        
        
        [self presentViewController:mailComposer animated:YES completion:nil];
        
    }
    
}

#pragma mark - QLPreviewControllerDataSource
- (NSInteger) numberOfPreviewItemsInPreviewController: (QLPreviewController *) controller
{
    return 1;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index
{
    return [NSURL fileURLWithPath:self.exportFilePath];
}


@end

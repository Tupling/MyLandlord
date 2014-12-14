//
//  MLPropertyExpenses.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/2/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLPropertyExpenses.h"
#import "MLAddPropertyExpense.h"


//Page Dimensions Declarations
#define kDefaultPageHeight 792
#define kDefaultPageWidth  612
#define kMargin 50
#define kColumnMargin 10

@interface MLPropertyExpenses ()

@end

@implementation MLPropertyExpenses

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"addNewFinance"]) {
        
        MLAddPropertyExpense *propertyDetails = segue.destinationViewController;
        
        propertyDetails.details = _details;
        
        if(self.subUnitDetails != nil){
            
        propertyDetails.subUnitDetails = _subUnitDetails;
            
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)pdfPressed:(id)sender {
    
    
    // create some sample data. In a real application, this would come from the database or an API.
    NSString* path = [self tempFilePath];
    //NSArray* students = [data objectForKey:@"Students"];
    
    // get a temprorary filename for this PDF
    path = NSTemporaryDirectory();
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"MMMM dd, yyyy"];
    self.pdfFilePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%f.pdf", [[NSDate date] timeIntervalSince1970] ]];
    
    // Create the PDF context using the default page size of 612 x 792.
    // This default is spelled out in the iOS documentation for UIGraphicsBeginPDFContextToFile
    UIGraphicsBeginPDFContextToFile(self.pdfFilePath, CGRectZero, nil);
    
    // get the context reference so we can render to it.
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    int currentPage = 0;
    
    // maximum height and width of the content on the page, byt taking margins into account.
    CGFloat maxWidth = kDefaultPageWidth - kMargin * 2;
    CGFloat maxHeight = kDefaultPageHeight - kMargin * 2;
    
    // we're going to cap the name of the class to using half of the horizontal page, which is why we're dividing by 2
    CGFloat classNameMaxWidth = maxWidth / 2;
    
    // the max width of the grade is also half, minus the margin
    CGFloat gradeMaxWidth = (maxWidth / 2) - kColumnMargin;
    
    
    // only create the fonts once since it is a somewhat expensive operation
    UIFont* studentNameFont = [UIFont boldSystemFontOfSize:17];
    UIFont* classFont = [UIFont systemFontOfSize:15];
    
    CGFloat currentPageY = 0;
    
    // iterate through out students, adding to the pdf each time.
    for (NSDictionary* student in student)
    {
        // every student gets their own page
        // Mark the beginning of a new page.
        UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kDefaultPageWidth, kDefaultPageHeight), nil);
        currentPageY = kMargin;
        
        // draw the student's name at the top of the page.
        NSString* name = [NSString stringWithFormat:@"%@ %@",
                          [student objectForKey:@"FirstName"],
                          [student objectForKey:@"LastName"]];
        
        CGSize size = [name sizeWithFont:studentNameFont forWidth:maxWidth lineBreakMode:UILineBreakModeWordWrap];
        [name drawAtPoint:CGPointMake(kMargin, currentPageY) forWidth:maxWidth withFont:studentNameFont lineBreakMode:UILineBreakModeWordWrap];
        currentPageY += size.height;
        
        // draw a one pixel line under the student's name
        CGContextSetStrokeColorWithColor(context, [[UIColor blueColor] CGColor]);
        CGContextMoveToPoint(context, kMargin, currentPageY);
        CGContextAddLineToPoint(context, kDefaultPageWidth - kMargin, currentPageY);
        CGContextStrokePath(context);
        
        // iterate through the list of classes and add these to the PDF.
        NSArray* classes = [student objectForKey:@"Classes"];
        for(NSDictionary* class in classes)
        {
            NSString* className = [class objectForKey:@"Name"];
            NSString* grade = [class objectForKey:@"Grade"];
            
            // before we render any text to the PDF, we need to measure it, so we'll know where to render the
            // next line.
            size = [className sizeWithFont:classFont constrainedToSize:CGSizeMake(classNameMaxWidth, MAXFLOAT) lineBreakMode:UILineBreakModeWordWrap];
            
            // if the current text would render beyond the bounds of the page,
            // start a new page and render it there instead
            if (size.height + currentPageY > maxHeight) {
                // create a new page and reset the current page's Y value
                UIGraphicsBeginPDFPageWithInfo(CGRectMake(0, 0, kDefaultPageWidth, kDefaultPageHeight), nil);
                currentPageY = kMargin;
            }
            
            // render the text
            [className drawInRect:CGRectMake(kMargin, currentPageY, classNameMaxWidth, maxHeight) withFont:classFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
            
            // print the grade to the right of the class name
            [grade drawInRect:CGRectMake(kMargin + classNameMaxWidth + kColumnMargin, currentPageY, gradeMaxWidth, maxHeight) withFont:classFont lineBreakMode:UILineBreakModeWordWrap alignment:UITextAlignmentLeft];
            
            currentPageY += size.height;
            
        }
        
        
        // increment the page number.
        currentPage++;
        
    }
    
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
        [mailComposer addAttachmentData:[NSData dataWithContentsOfFile:self.pdfFilePath]
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
    return [NSURL fileURLWithPath:self.pdfFilePath];
}


@end

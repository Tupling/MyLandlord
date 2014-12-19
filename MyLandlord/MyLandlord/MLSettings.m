//
//  MLSettings.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/18/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLSettings.h"

@interface MLSettings () <UIAlertViewDelegate>
{
    NSString *linked;
    UIAlertView *dropBoxUnlinked;
}

@end

@implementation MLSettings

- (void)viewDidLoad {
    [super viewDidLoad];
    //Set Nav Bar Image
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0,0,70,45)] ;
    [image setImage:[UIImage imageNamed:@"MyLandlord.png"]];
    image.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = image;
    
    self.linkDropBox.layer.cornerRadius = 5;
    
    [self updatePageElements];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self performSelectorOnMainThread:@selector(updatePageElements) withObject:nil waitUntilDone:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    [self performSelectorOnMainThread:@selector(updatePageElements) withObject:nil waitUntilDone:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)unLinkDropBox:(id)sender
{
    
    if([[DBSession sharedSession] isLinked]){
        
        dropBoxUnlinked = [[UIAlertView alloc] initWithTitle:@"Unlink Dropbox\u00AE" message:@"Are you sure you want to unlink your Dropbox\u00AE?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        
        [dropBoxUnlinked show];
        
        
    } else {
        
        [[DBSession sharedSession] linkFromController:self];
    }
    
}

-(void)updatePageElements
{
    if([[DBSession sharedSession] isLinked]){
        self.dropBoxStatus.text = @"Dropbox Status: Linked";
        [self.linkDropBox setBackgroundColor:[UIColor redColor]];
        [self.linkDropBox setTitle:@"Unlink Dropbox" forState:UIControlStateNormal];
    } else {
        self.dropBoxStatus.text = @"Dropbox Status: Un-Linked";
        [self.linkDropBox setBackgroundColor:[UIColor greenColor]];
        [self.linkDropBox setTitle:@"Link Dropbox" forState:UIControlStateNormal];
    }
}



// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == dropBoxUnlinked){
        if(buttonIndex == 1)
        {
            [[DBSession sharedSession] unlinkAll];
            
            [self performSelectorOnMainThread:@selector(updatePageElements) withObject:nil waitUntilDone:YES];
        }
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

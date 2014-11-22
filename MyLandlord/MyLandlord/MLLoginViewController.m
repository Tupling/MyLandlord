//
//  MLLoginViewController.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/17/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLLoginViewController.h"
#import <ParseUI/ParseUI.h>
#import <QuartzCore/QuartzCore.h>

@interface MLLoginViewController ()
{
    UIImage *img;
}

@end

@implementation MLLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    img = [UIImage imageNamed:@"MyLandlord"];

    
    
    self.logInView.logo = [[UIImageView alloc] initWithImage:img];

    
    
    
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.logInView.logo setFrame:CGRectMake(self.logInView.logo.frame.origin.x, self.logInView.logo.frame.origin.y-20,img.size.width, img.size.height)];
    [self.logInView.logo setContentMode:UIViewContentModeScaleAspectFit];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

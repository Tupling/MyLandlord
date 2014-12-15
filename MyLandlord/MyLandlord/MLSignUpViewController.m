//
//  MLSignUpViewController.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/15/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLSignUpViewController.h"

@interface MLSignUpViewController ()

{
    UIImage *img;
}


@end

@implementation MLSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    img = [UIImage imageNamed:@"MyLandlord"];
    
    self.signUpView.logo = [[UIImageView alloc] initWithImage:img];
    
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.signUpView.logo setFrame:CGRectMake(self.signUpView.logo.frame.origin.x, self.signUpView.logo.frame.origin.y-20,img.size.width, img.size.height)];
    [self.signUpView.logo setContentMode:UIViewContentModeScaleAspectFit];
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

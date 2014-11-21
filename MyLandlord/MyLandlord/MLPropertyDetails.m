//
//  MLPropertyDetails.m
//  MyLandlord
//
//  Created by Dale Tupling on 11/21/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLPropertyDetails.h"

@interface MLPropertyDetails ()

@end

@implementation MLPropertyDetails

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    propAddress.text = [NSString stringWithFormat:@"%@\n%@, %@ %@", _details.propAddress, _details.propCity, _details.propState, _details.propZip];
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

//
//  MLPropertyUnits.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/9/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLPropertyUnits.h"
#import "MLAddUnits.h"

@interface MLPropertyUnits ()

@end

@implementation MLPropertyUnits

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addUnit:(id)sender{
    
    [self performSegueWithIdentifier:@"addUnit" sender:self];
}

//In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"addUnit"]) {
        
        MLAddUnits *propDetails = segue.destinationViewController;
        propDetails.propDetails = self.propDetails;
        
    } else if([[segue identifier] isEqualToString:@"unitDetails"]){
        
        
    }
}

@end

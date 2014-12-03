//
//  MLPropertyExpenses.m
//  MyLandlord
//
//  Created by Dale Tupling on 12/2/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import "MLPropertyExpenses.h"

@interface MLPropertyExpenses ()

@end

@implementation MLPropertyExpenses

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

-(void)addNewExpense:(id)sender
{
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

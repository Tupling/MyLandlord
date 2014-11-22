//
//  MLDocsViewController.h
//  MyLandlord
//
//  Created by Dale Tupling on 11/17/14.
//  Copyright (c) 2014 Dale Tupling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MLDocsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

{
    IBOutlet UICollectionView *documentCollection;
}


-(IBAction)closeView:(id)sender;

@end

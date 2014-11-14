//
//  FirstViewController.h
//  PhotoShareApp
//
//  Created by Harsh Shah on 10/23/14.
//  Copyright (c) 2014 Harsh Shah. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstViewController : UIViewController <ELCImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>


@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UICollectionView *gridView;

@property (nonatomic, strong) NSMutableArray *chosenImages;

- (IBAction)launchPicker;

@end


//
//  FirstViewController.h
//  PhotoShareApp
//
//  Created by Harsh Shah on 10/23/14.
//  Copyright (c) 2014 Harsh Shah. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface FirstViewController : UIViewController <ELCImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) UITextField               *albumDetailsTextField;
@property Album                                         *currentAlbum;
@property (strong, nonatomic) NSMutableArray            *albumData;
@property (strong, nonatomic) NSMutableArray            *albumTextLabels;
@property (strong, nonatomic) IBOutlet UIScrollView     *scrollView;
@property (strong, nonatomic) IBOutlet UICollectionView *gridView;
@property (strong, nonatomic) IBOutlet UITableView      *albumDescriptionTable;
@property (nonatomic, strong) NSMutableArray            *chosenImages;

- (IBAction)launchPicker;

@end


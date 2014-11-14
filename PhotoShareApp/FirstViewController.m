//
//  FirstViewController.m
//  PhotoShareApp
//
//  Created by Harsh Shah on 10/23/14.
//  Copyright (c) 2014 Harsh Shah. All rights reserved.
//

#import "ELCImagePickerDemoAppDelegate.h"
#import "ELCImagePickerDemoViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "FirstViewController.h"
#import "PatternViewCell.h"

@interface FirstViewController ()

@property (nonatomic, strong) ALAssetsLibrary *specialLibrary;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chosenImages = [NSMutableArray new];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)launchPicker {
    
    ELCImagePickerController *imagePicker = [[ELCImagePickerController alloc] initImagePicker];
    
    imagePicker.maximumImagesCount = 10; //Set the maximum number of images to select to 10
    imagePicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    imagePicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    imagePicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    imagePicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    imagePicker.imagePickerDelegate = self;
    
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    PatternViewCell *cell = [[PatternViewCell alloc]init];
    
    //    for (UIView *v in [_scrollView subviews]) {
    //        [v removeFromSuperview];
    //    }
    
    for (UIView *v in [_gridView subviews]) {
        [v removeFromSuperview];
    }
    
    //CGRect workingFrame = _scrollView.frame;
    CGRect workingFrame = _gridView.frame;
    workingFrame.origin.x = 0;
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [images addObject:image];
                
                // UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
                //                [imageview setContentMode:UIViewContentModeScaleAspectFit];
                //                imageview.frame = workingFrame;
                [cell.patternImageView setContentMode:UIViewContentModeScaleAspectFit];
                cell.patternImageView.frame = workingFrame;
                //[_scrollView addSubview:imageview];
                //[_gridView addSubview:imageview];
                [_gridView addSubview:cell.patternImageView];
                
                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                
                [images addObject:image];
                
                //UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
                
                //[imageview setContentMode:UIViewContentModeScaleAspectFit];
                [cell.patternImageView setContentMode:UIViewContentModeScaleAspectFit];
                //imageview.frame = workingFrame;
                cell.patternImageView.frame = workingFrame;
                
                //                [_scrollView addSubview:imageview];
                //[_gridView addSubview:imageview];
                [_gridView addSubview:cell.patternImageView];
                
                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Unknown asset type");
        }
    }
    
    self.chosenImages = [images mutableCopy];
    
    NSLog(@"Hello: %@", self.chosenImages);
    
    //    [_scrollView setPagingEnabled:YES];
    //    [_scrollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
    
    [_gridView setPagingEnabled:YES];
    [_gridView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
    [self.gridView reloadData];
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark Collection View Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.chosenImages.count;
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    CGRect screenRect = [[UIScreen mainScreen] bounds];
//    CGFloat screenWidth = screenRect.size.width;
//    CGFloat screenHeight = screenRect.size.height;
//    return CGSizeMake(screenWidth/3, screenHeight/3);
//}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"PatternCell";
    PatternViewCell *cell = (PatternViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *) [cell viewWithTag:100];
    //cell.patternImageView.image = [UIImage imageNamed: [self.chosenImages objectAtIndex:indexPath.row]];
    imageView.image = [_chosenImages objectAtIndex:indexPath.row];
    return cell;
}

@end

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
#import "Constants.h"

@interface FirstViewController ()

@property (nonatomic, strong) ALAssetsLibrary *specialLibrary;

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.chosenImages = [NSMutableArray new];
    self.albumData = [NSMutableArray new];
    self.currentAlbum = [Album new];
    
    self.albumTextLabels = [NSMutableArray new];
    [self.albumTextLabels addObject:RPAlbumName];
    [self.albumTextLabels addObject:RPAlbumDescription];
    
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
    
    for (UIView *v in [self.gridView subviews]) {
        [v removeFromSuperview];
    }
    
    CGRect workingFrame = _gridView.frame;
    workingFrame.origin.x = 0;
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                [images addObject:image];
                
                [cell.patternImageView setContentMode:UIViewContentModeScaleAspectFit];
                cell.patternImageView.frame = workingFrame;
                [self.gridView addSubview:cell.patternImageView];
                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                
                [images addObject:image];
                [cell.patternImageView setContentMode:UIViewContentModeScaleAspectFit];
                cell.patternImageView.frame = workingFrame;
                [self.gridView addSubview:cell.patternImageView];
                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Unknown asset type");
        }
    }
    
    self.chosenImages = [images mutableCopy];
    
    [self.gridView setPagingEnabled:YES];
    [self.gridView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
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

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PatternViewCell *cell = (PatternViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:RPPatternCell forIndexPath:indexPath];
    UIImageView *imageView = (UIImageView *) [cell viewWithTag:100];
    
    imageView.image = [self.chosenImages objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark Album Table View

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:RPAlbumDescriptionCell];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:RPAlbumDescriptionCell];
    }
    /////////////////
    self.albumDetailsTextField = [[UITextField alloc] initWithFrame:CGRectMake(110, 10, 185, 30)];
    
    // [self.albumDetailsTextField addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventEditingDidEndOnExit];
    self.albumDetailsTextField.delegate = self;
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    self.albumDetailsTextField.adjustsFontSizeToFitWidth = YES;
    if ([indexPath row] == 0) {
        self.albumDetailsTextField.placeholder = RPAlbumNamePlaceholder;
        self.albumDetailsTextField.keyboardType = UIKeyboardTypeDefault;
        self.albumDetailsTextField.returnKeyType = UIReturnKeyDone;
    }else{
        self.albumDetailsTextField.placeholder = RPAlbumDescriptionPlaceholder;
        self.albumDetailsTextField.keyboardType = UIKeyboardTypeDefault;
        self.albumDetailsTextField.returnKeyType = UIReturnKeyDone;
    }
    
    self.albumDetailsTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.albumDetailsTextField.tag = 0;
    self.albumDetailsTextField.clearButtonMode = UITextFieldViewModeAlways;
    [self.albumDetailsTextField setEnabled:YES];
    
    [cell.contentView addSubview:self.albumDetailsTextField];
    /////////////////
    
    cell.textLabel.text = self.albumTextLabels[indexPath.row];
    
    if ([cell.textLabel.text isEqualToString:RPAlbumName]) {
        cell.detailTextLabel.text = self.currentAlbum.name;
    }
    if ([cell.textLabel.text isEqualToString:RPAlbumDescription]) {
        cell.detailTextLabel.text = self.currentAlbum.albumDescription;
    }
    
    return cell;
}

#pragma mark Touch methods

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.albumDetailsTextField resignFirstResponder];
    [self.view endEditing:YES];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.currentAlbum.name = textField.text;
    [textField resignFirstResponder];
    return YES;
}

@end

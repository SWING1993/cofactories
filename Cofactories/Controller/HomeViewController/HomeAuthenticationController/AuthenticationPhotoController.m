//
//  AuthenticationPhotoController.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "AuthenticationPhotoController.h"


@interface AuthenticationPhotoController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,retain)NSArray*cellArray;

@property (nonatomic, assign) NSInteger imageType;

@property (nonatomic, retain) NSMutableArray*imageArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation AuthenticationPhotoController {
        UIImageView*imageView1;
        UIImageView*imageView2;
        UIImageView*imageView3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatHeaderView];
//    [self creatFootView];
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    self.cellArray = @[@"身份证正面", @"身份证反面", @"营业执照"];
    
    
    imageView1 = [[UIImageView alloc]init];
    //    imageView1.userInteractionEnabled = YES;
    imageView1.image = [UIImage imageNamed:@"添加照片"];
    imageView1.contentMode = UIViewContentModeScaleAspectFill;
    imageView1.clipsToBounds = YES;
    
    
    imageView2 = [[UIImageView alloc]init];
    //    imageView2.userInteractionEnabled = YES;
    imageView2.image = [UIImage imageNamed:@"添加照片"];
    imageView2.contentMode = UIViewContentModeScaleAspectFill;
    imageView2.clipsToBounds = YES;
    
    
    imageView3 = [[UIImageView alloc]init];
    //    imageView3.userInteractionEnabled = YES;
    imageView3.contentMode = UIViewContentModeScaleAspectFill;
    imageView3.image = [UIImage imageNamed:@"添加照片"];
    imageView3.clipsToBounds = YES;

}

- (void)creatHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenW)];
    headerView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, kScreenW - 30, 0.5*kScreenW)];
    imageView.image = [UIImage imageNamed:@"身份证"];
    imageView.layer.cornerRadius = 8;
    imageView.clipsToBounds = YES;
    imageView.layer.borderColor = [UIColor grayColor].CGColor;
    imageView.layer.borderWidth = 0.3;
    [headerView addSubview:imageView];
    
    UIView *photoView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(imageView.frame) + 20, kScreenW - 30, 0.4*kScreenW)];
    photoView.backgroundColor = [UIColor whiteColor];
    photoView.layer.cornerRadius = 8;
    photoView.clipsToBounds = YES;
    photoView.layer.borderColor = [UIColor grayColor].CGColor;
    photoView.layer.borderWidth = 0.3;
    [photoView addSubview:self.collectionView];
    [headerView addSubview:photoView];
    
    
    self.tableView.tableHeaderView = headerView;
}

- (void)creatFootView {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}


#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-80)/3

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView + 40);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 2.0;
        layout.minimumInteritemSpacing = 2.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 30, kSizeThumbnailCollectionView + 40) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    
    UILabel*cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kSizeThumbnailCollectionView + 10, cell.frame.size.width, 20)];
    cellLabel.alpha = 0.8f;
    cellLabel.textAlignment = NSTextAlignmentCenter;
    cellLabel.font = kFont;
    
    switch (indexPath.row) {
        case 0:
        {
            cellLabel.text = self.cellArray[indexPath.row];
            
            imageView1.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height - 40);
            if (self.imageType==1) {
                imageView1.image=[self.imageArray lastObject];
            }
            [cell addSubview:imageView1];
            
        }
            break;
        case 1:
        {
            cellLabel.text = self.cellArray[indexPath.row];
            
            imageView2.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height - 40);
            
            if (self.imageType==2) {
                
                imageView2.image=[self.imageArray lastObject];
            }
            [cell addSubview:imageView2];
            
        }
            break;
        case 2:
        {
            cellLabel.text = self.cellArray[indexPath.row];
            
            imageView3.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height - 40);
            
            if (self.imageType==3) {
                imageView3.image=[self.imageArray lastObject];
            }
            [cell addSubview:imageView3];
            
        }
            break;
            
        default:
            break;
    }
    [cell addSubview:cellLabel];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.imageType = indexPath.row+1;
    DLog(@"self.imageType = %ld",(long)self.imageType);
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
    [actionSheet showInView:self.view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                message:@"Device has no camera"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles: nil];
            
            [alertView show];
        } else {
            UIImagePickerController *imagePickerController = [UIImagePickerController new];
            imagePickerController.delegate = self;
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.allowsEditing = YES;
            imagePickerController.showsCameraControls = YES;
            imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
//            imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
            
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }
        return;
    }
    if (buttonIndex == 1) {
        // 相册
        UIImagePickerController *imagePickerController = [UIImagePickerController new];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
//        imagePickerControllpes = @[(NSString *)kUTTypeImage];
        
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}
#pragma mark <UIImagePickerControllerDelegate>
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage*image;
    image = info[UIImagePickerControllerOriginalImage];
    NSData *imageData = UIImageJPEGRepresentation(image,0.00001);
    UIImage*newImage = [UIImage imageWithData:imageData];
    [self.imageArray addObject:newImage];
    DLog(@"self.imageArray.count%lu",(unsigned long)self.imageArray.count);
    [picker dismissViewControllerAnimated:YES completion:^{
        NSIndexPath *te=[NSIndexPath indexPathForRow:self.imageType-1 inSection:0];
        [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:te,nil] ];
        //         reloadRowsAtIndexPaths:[NSArray arrayWithObjects:te,nil] withRowAnimation:UITableViewRowAnimationNone];
        //        [self.collectionView reloadData];
//        [self updatePortrait];
    }];
}


@end

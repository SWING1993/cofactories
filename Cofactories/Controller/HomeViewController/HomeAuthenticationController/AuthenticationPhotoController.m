//
//  AuthenticationPhotoController.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "AuthenticationPhotoController.h"
#import "AuthenticationController.h"

@interface AuthenticationPhotoController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

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
    self.title = @"上传图片";
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    self.imageArray = [NSMutableArray arrayWithCapacity:0];
    
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 1.4*kScreenW)];
    headerView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
//    headerView.backgroundColor = [UIColor redColor];
    headerView.userInteractionEnabled = YES;
    //事例图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, kScreenW - 30, 0.5*kScreenW)];
    imageView.image = [UIImage imageNamed:@"身份证"];
    imageView.layer.cornerRadius = 8;
    imageView.clipsToBounds = YES;
    imageView.layer.borderColor = [UIColor grayColor].CGColor;
    imageView.layer.borderWidth = 0.3;
    [headerView addSubview:imageView];
    
    //三张认证照片
    UIView *bigPhotoView = [[UIView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(imageView.frame) + 20, kScreenW - 30, 0.4*kScreenW)];
    bigPhotoView.backgroundColor = [UIColor whiteColor];
    bigPhotoView.layer.cornerRadius = 8;
    bigPhotoView.clipsToBounds = YES;
    bigPhotoView.layer.borderColor = [UIColor grayColor].CGColor;
    bigPhotoView.layer.borderWidth = 0.3;
    [bigPhotoView addSubview:self.collectionView];
    NSArray *myArray = @[@"身份证正面", @"身份证反面", @"营业执照"];
    for (int i = 0; i < 3; i++) {
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake((bigPhotoView.frame.size.width/3)*i , CGRectGetMaxY(self.collectionView.frame), bigPhotoView.frame.size.width/3, 20)];
        myLabel.text = myArray[i];
        myLabel.textAlignment = NSTextAlignmentCenter;
        myLabel.font = [UIFont systemFontOfSize:14*kZGY];
        [bigPhotoView addSubview:myLabel];
    }
    [headerView addSubview:bigPhotoView];
    
    //上传说明
    UILabel *explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(bigPhotoView.frame), kScreenW - 30, 30)];
    explainLabel.textAlignment = NSTextAlignmentCenter;
    explainLabel.text = @"身份证照片需与本人身份相符，照片要求无水印";
    explainLabel.numberOfLines = 0;
    explainLabel.font = [UIFont systemFontOfSize:14*kZGY];
    [headerView addSubview:explainLabel];
    
    //确认上传
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(20, CGRectGetMaxY(explainLabel.frame) + 70, kScreenW - 40, 38);
    [doneButton setTitle:@"下一步" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:15.5];
    doneButton.layer.cornerRadius = 4*kZGY;
    doneButton.clipsToBounds = YES;
    doneButton.backgroundColor = [UIColor colorWithRed:30.0f/255.0f green:171.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
    [doneButton addTarget:self action:@selector(actionOfDoneButton) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:doneButton];
    
    UILabel *explainLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, doneButton.frame.origin.y - 25, kScreenW - 40, 20)];
    explainLabel2.font = [UIFont systemFontOfSize:11];
    explainLabel2.textAlignment = NSTextAlignmentCenter;
    explainLabel2.text = @"建议上传图片尽量清晰";
    explainLabel2.textColor = [UIColor lightGrayColor];
    [headerView addSubview:explainLabel2];
    self.tableView.tableHeaderView = headerView;
}



- (void)actionOfDoneButton {
    DLog(@"vkmd;fkvd");
    AuthenticationController *authenticationVC = [[AuthenticationController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:authenticationVC animated:YES];
        if ([self.imageArray count]<3) {
//            [Tools showErrorWithStatus:@"照片信息不完整!"];
            
        }else{
            
//            [HttpClient submitVerifyDetailWithLegalPerson:textField2.text idCard:textField3.text andBlock:^(int statusCode) {
//                DLog(@"%d",statusCode);
//                switch (statusCode) {
//                    case 200:
//                    {
//                        UIAlertView*alertView = [[UIAlertView alloc]initWithTitle:@"认证提交成功" message:nil
//                                                                         delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//                        alertView.tag = 10065;
//                        [alertView show];
//                    }
//                        break;
//                    case 400:
//                    {
//                        [Tools showErrorWithStatus:@"未登录"];
//                    }
//                        break;
//                    case 409:
//                    {
//                        [Tools showShimmeringString:@"已经认证或者正在认证，不能修改。"];
//                    }
//                        break;
//                        
//                        
//                    default:
//                        [Tools showErrorWithStatus:@"提交失败，尝试修改信息重新提交！"];
//                        break;
//                }
//            }];
//        }
    }
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
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}


#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width- 30 - 40)/3

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
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
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenW - 30, kSizeThumbnailCollectionView + 20) collectionViewLayout:layout];
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
    
//    UILabel*cellLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, cell.frame.size.width + 10, cell.frame.size.width, 20)];
//    cellLabel.alpha = 0.8f;
//    cellLabel.textAlignment = NSTextAlignmentCenter;
//    cellLabel.font = kFont;
//    cellLabel.text = self.cellArray[indexPath.row];
    switch (indexPath.row) {
        case 0:
        {
//            cellLabel.text = self.cellArray[indexPath.row];
            
            imageView1.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
            if (self.imageType==1) {
                imageView1.image=[self.imageArray lastObject];
            }
            [cell addSubview:imageView1];
            
        }
            break;
        case 1:
        {
//            cellLabel.text = self.cellArray[indexPath.row];
            
            imageView2.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
            
            if (self.imageType==2) {
                
                imageView2.image=[self.imageArray lastObject];
            }
            [cell addSubview:imageView2];
            
        }
            break;
        case 2:
        {
//            cellLabel.text = self.cellArray[indexPath.row];
            
            imageView3.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
            
            if (self.imageType==3) {
                imageView3.image=[self.imageArray lastObject];
            }
            [cell addSubview:imageView3];
            
        }
            break;
            
        default:
            break;
    }
//    [cell addSubview:cellLabel];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.imageType = indexPath.row + 1;
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
            imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
            
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
        imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
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
        [self updatePortrait];
    }];
}
- (void)updatePortrait {
    switch (self.imageType) {
        case 1:
        {
            DLog(@"license");
//            [HttpClient uploadVerifyImage:[self.imageArray lastObject] type:@"license" andblock:^(NSDictionary *dictionary) {
//                if ([dictionary[@"statusCode"] intValue]==200) {
//                    [Tools showSuccessWithStatus:@"营业执照上传成功"];
//                }else{
//                    [Tools showErrorWithStatus:@"上传失败"];
//                }
//                
//            }];
        }
            break;
            
        case 2:
        {
            DLog(@"idCard");
//            [HttpClient uploadVerifyImage:[self.imageArray lastObject] type:@"idCard" andblock:^(NSDictionary *dictionary) {
//                if ([dictionary[@"statusCode"] intValue]==200) {
//                    [Tools showSuccessWithStatus:@"身份证上传成功"];
//                }else{
//                    [Tools showErrorWithStatus:@"上传失败"];
//                }
//            }];
            
        }
            break;
            
        case 3:
        {
            DLog(@"photo")
//            [HttpClient uploadVerifyImage:[self.imageArray lastObject] type:@"photo" andblock:^(NSDictionary *dictionary) {
//                if ([dictionary[@"statusCode"] intValue]==200) {
//                    [Tools showSuccessWithStatus:@"公司形象上传成功"];
//                }else{
//                    [Tools showErrorWithStatus:@"上传失败"];
//                }
//            }];
        }
            break;
            
        default:
//            [Tools showErrorWithStatus:@"上传类型未知！"];
            break;
    }
}



@end
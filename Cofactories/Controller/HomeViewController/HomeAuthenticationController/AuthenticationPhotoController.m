//
//  AuthenticationPhotoController.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/25.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "AuthenticationPhotoController.h"
#import "AuthenticationController.h"

static NSString * CellIdentifier = @"CellIdentifier";

@interface AuthenticationPhotoController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIActionSheetDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate>

@property (nonatomic, assign) NSInteger imageType;

@property (nonatomic, retain) NSMutableArray *imageArray;

@property (nonatomic, retain) NSMutableArray *idCardImageArray, *idCardBackImageArray, *licenseImageArray;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation AuthenticationPhotoController {
        UIImageView*imageView1;
        UIImageView*imageView2;
        UIImageView*imageView3;
        UIButton *doneButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatHeaderView];
    self.title = @"上传图片";
    self.tableView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    self.imageArray = [NSMutableArray arrayWithCapacity:0];
    self.idCardImageArray = [NSMutableArray arrayWithCapacity:0];
    self.idCardBackImageArray = [NSMutableArray arrayWithCapacity:0];
    self.licenseImageArray = [NSMutableArray arrayWithCapacity:0];
    
    imageView1 = [[UIImageView alloc]init];
    imageView1.image = [UIImage imageNamed:@"添加照片"];
    imageView1.contentMode = UIViewContentModeScaleAspectFill;
    imageView1.clipsToBounds = YES;
    
    imageView2 = [[UIImageView alloc]init];
    imageView2.image = [UIImage imageNamed:@"添加照片"];
    imageView2.contentMode = UIViewContentModeScaleAspectFill;
    imageView2.clipsToBounds = YES;
    
    imageView3 = [[UIImageView alloc]init];
    imageView3.contentMode = UIViewContentModeScaleAspectFill;
    imageView3.image = [UIImage imageNamed:@"添加照片"];
    imageView3.clipsToBounds = YES;
}

- (void)creatHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, kScreenW + (kScreenW - 30)*256/640)];
    headerView.backgroundColor = [UIColor colorWithRed:245.0f/255.0f green:245.0f/255.0f blue:249.0f/255.0f alpha:1.0f];
//    headerView.backgroundColor = [UIColor redColor];
    headerView.userInteractionEnabled = YES;
    //事例图片
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, kScreenW - 30, (kScreenW - 30)*256/640)];
    imageView.image = [UIImage imageNamed:@"Home-身份证"];
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
    UILabel *explainLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, CGRectGetMaxY(bigPhotoView.frame), kScreenW - 30, 50)];
    explainLabel.textAlignment = NSTextAlignmentCenter;
    explainLabel.text = @"身份证照片需与本人身份相符，若无营业执照请上传手持身份证（设计师可选择上传）";
    explainLabel.numberOfLines = 0;
    explainLabel.font = [UIFont systemFontOfSize:14*kZGY];
    [headerView addSubview:explainLabel];
    
    //确认上传
    doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.frame = CGRectMake(20, CGRectGetMaxY(explainLabel.frame) + 70, kScreenW - 40, 38);
    [doneButton setTitle:@"提交认证" forState:UIControlStateNormal];
    doneButton.titleLabel.font = [UIFont systemFontOfSize:15.5];
    doneButton.layer.cornerRadius = 4*kZGY;
    doneButton.clipsToBounds = YES;
    doneButton.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
    [doneButton setTitleColor:[UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
    doneButton.userInteractionEnabled = NO;
    [doneButton addTarget:self action:@selector(actionOfDoneButton:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:doneButton];
    
    UILabel *explainLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, doneButton.frame.origin.y - 25, kScreenW - 40, 20)];
    explainLabel2.font = [UIFont systemFontOfSize:11];
    explainLabel2.textAlignment = NSTextAlignmentCenter;
    explainLabel2.text = @"建议上传图片尽量清晰";
    explainLabel2.textColor = [UIColor lightGrayColor];
    [headerView addSubview:explainLabel2];
    self.tableView.tableHeaderView = headerView;
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
    
    switch (indexPath.row) {
        case 0: {
            imageView1.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
            if (self.imageType==1) {
                imageView1.image=[self.imageArray lastObject];
            }
            [cell addSubview:imageView1];
            
        }
            break;
        case 1: {
            imageView2.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
            if (self.imageType==2) {
                imageView2.image=[self.imageArray lastObject];
            }
            [cell addSubview:imageView2];
        }
            break;
        case 2: {
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
        //打开相机
        [self openCamera];
        return;
    }
    if (buttonIndex == 1) {
        //打开相册
        [self openPictures];
    }
}

//打开相机
- (void)openCamera {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        kTipAlert(@"设备没有摄像头");
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
}

//打开相册
- (void)openPictures {
    UIImagePickerController *imagePickerController = [UIImagePickerController new];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = YES;
    imagePickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage*image = info[UIImagePickerControllerOriginalImage];
//    UIImage*image = info[UIImagePickerControllerEditedImage];//截取图片
//    UIImage *scaleImage = [Tools compressPicturesWithImage:image];
//    NSData *imageData = UIImageJPEGRepresentation(scaleImage,0.5);
//    UIImage*newImage = [UIImage imageWithData:imageData];
    
    [self.imageArray addObject:image];
    if (self.imageType == 1) {
        [self.idCardImageArray addObject:image];
    }
    if (self.imageType == 2) {
        [self.idCardBackImageArray addObject:image];
    }
    if (self.imageType == 3) {
        [self.licenseImageArray addObject:image];
    }

    if (self.idCardImageArray.count == 0 || self.idCardBackImageArray.count == 0 || self.licenseImageArray.count == 0) {
        doneButton.backgroundColor = [UIColor colorWithRed:235.0f/255.0f green:235.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
        [doneButton setTitleColor:[UIColor colorWithRed:210.0f/255.0f green:210.0f/255.0f blue:210.0f/255.0f alpha:1.0f] forState:UIControlStateNormal];
        doneButton.userInteractionEnabled = NO;
    } else {
        doneButton.backgroundColor = kMainLightBlueColor;
        [doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        doneButton.userInteractionEnabled = YES;

    }
    [picker dismissViewControllerAnimated:YES completion:^{
        NSIndexPath *te=[NSIndexPath indexPathForRow:self.imageType-1 inSection:0];
        [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObjects:te,nil] ];
        
    }];
}

// 取消相册
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
#pragma mark - 提交认证

- (void)actionOfDoneButton:(UIButton *)button {
    DLog(@"提交认证");
    doneButton.userInteractionEnabled = NO;
    UIImage *idCardImage = [Tools compressPicturesWithImage:[self.idCardImageArray lastObject]];
    UIImage *idCardBackImage = [Tools compressPicturesWithImage:[self.idCardBackImageArray lastObject]];
    UIImage *licenseImage = [Tools compressPicturesWithImage:[self.licenseImageArray lastObject]];
    [HttpClient postVerifyWithenterpriseName:self.priseName withenterpriseAddress:self.priseAddress withpersonName:self.personName withidCard:self.idCard idCardImage:idCardImage idCardBackImage:idCardBackImage licenseImage:licenseImage andBlock:^(NSInteger statusCode) {
        if (statusCode == 200) {
            doneButton.userInteractionEnabled = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"提交认证成功, 可能需要几分钟的等待上传图片！" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
            [alert show];
//            kTipAlert(@"提交认证成功, 可能需要几分钟的等待上传图片！");
        } else {
            kTipAlert(@"提交认证失败");
            doneButton.userInteractionEnabled = YES;
        }
        DLog(@"%ld", (long)statusCode);
    }];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (self.homeEnter) {
            NSArray *navArray = self.navigationController.viewControllers;
            [self.navigationController popToViewController:navArray[0] animated:YES];
        } else {
            //不是首页进入的
            NSArray *navArray = self.navigationController.viewControllers;
            [self.navigationController popToViewController:navArray[0] animated:YES];
        }
    }
}
@end

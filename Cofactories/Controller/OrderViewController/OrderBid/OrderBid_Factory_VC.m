//
//  OrderBid_Factory_VC.m
//  Cofactories
//
//  Created by GTF on 15/12/1.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "OrderBid_Factory_VC.h"
#import "Comment_TVC.h"
#import "JKPhotoBrowser.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MJPhotoBrowser.h"
#import "UserModel.h"
#import "AuthenticationController.h"
#import "RechargeViewController.h"
@interface OrderBid_Factory_VC ()<JKImagePickerControllerDelegate,UIAlertViewDelegate>{
    UITextView       *_commentTV;
    UIButton         *_addButton;
    NSMutableArray   *_imageViewArray;
    UIScrollView     *_scrollView;
}
@property (nonatomic, strong) JKAssets  *asset;
@property (nonatomic,strong) UserModel *userModel;

@end
static NSString *const reuseIdentifier = @"reuseIdentifier";

@implementation OrderBid_Factory_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"投标";
    self.userModel = [[UserModel alloc] getMyProfile];

    _imageViewArray = [@[] mutableCopy];
    self.tableView.rowHeight = kScreenW/2.f-40;
    [self.tableView registerClass:[Comment_TVC class] forCellReuseIdentifier:reuseIdentifier];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 10)];
    headerView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    self.tableView.tableHeaderView = headerView;
    
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 174)];
    self.tableView.tableFooterView = footerView;
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake((kScreenW-80)/2.0, 30, 80, 80);
    [_addButton setBackgroundImage:[UIImage imageNamed:@"addImageButton.png"] forState:UIControlStateNormal];
    _addButton.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [_addButton addTarget:self action:@selector(addImageClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:_addButton];
    
    
    UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    publishButton.frame = CGRectMake(20, 130, kScreenW-40, 44);
    publishButton.layer.masksToBounds = YES;
    publishButton.layer.cornerRadius = 5;
    publishButton.backgroundColor = MAIN_COLOR;
    [publishButton setTitle:@"确认投标" forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(bidClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:publishButton];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Comment_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    _commentTV = cell.commentTextView;

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)addImageClick{
    if ([_imageViewArray count]== 9) {
        kTipAlert(@"图片最多上传9张");
    }else {
        JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.showsCancelButton = YES;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.minimumNumberOfSelection = 0;
        imagePickerController.maximumNumberOfSelection = 9-[_imageViewArray count];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    
}

- (void)bidClick{
    if (_commentTV.text.length > 0) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认投标订单" delegate:self cancelButtonTitle:@"再看看" otherButtonTitles:@"确认投标", nil];
        alertView.tag = 100;
        [alertView show];
    }else{
        kTipAlert(@"请填写必填信息，再发布订单!");
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            DLog(@"%@",_commentTV.text);
            
            if ([self.orderTypeString isEqualToString:@"FactoryOrder"]) {
                [HttpClient bidFactoryOrderWithDiscription:_commentTV.text orderID:_orderID WithCompletionBlock:^(NSDictionary *dictionary) {
                    DLog(@">>>>>>%@",dictionary);
                    if ([dictionary[@"statusCode"] isEqualToString:@"200"]) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"投标成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                        alertView.tag = 10086;
                        [alertView show];
                        if (_imageViewArray.count>0) {
                            NSString *policyString = dictionary[@"message"][@"data"][@"policy"];
                            NSString *signatureString = dictionary[@"message"][@"data"][@"signature"];
                            UpYun *upYun = [[UpYun alloc] init];
                            upYun.bucket = bucketAPI;//图片测试
                            upYun.expiresIn = 600;// 10分钟
                            DLog(@"%@",_imageViewArray);
                            [_imageViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                UIImage *image = (UIImage *)obj;
                                [upYun uploadImage:image policy:policyString signature:signatureString];
                            }];
                            
                        }else{
                            // 用户未上传图片
                        }
                        
                    }else if ([dictionary[@"statusCode"] isEqualToString:@"404"]) {
                        kTipAlert(@"投标，请重新登录");
                    }else if ([dictionary[@"statusCode"] isEqualToString:@"402"]) {
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"钱包余额小于您设置的保证金额" message:@"请充值" delegate:self cancelButtonTitle:@"暂不充值" otherButtonTitles:@"立即充值", nil];
                        alert.tag = 402;
                        [alert show];
                    }else if ([dictionary[@"statusCode"] isEqualToString:@"403"]) {
                        
                        if ([_userModel.subRole isEqualToString:@"加工厂"]) {
                            if (_userModel.verify_status == 0) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"未认证用户" message:nil delegate:self cancelButtonTitle:@"暂不认证" otherButtonTitles:@"立即认证", nil];
                                alert.tag = 403;
                                [alert show];
                            }else if (_userModel.verify_status == 1){
                                kTipAlert(@"您的认证正在处理，请耐心等待结果!");
                            }

                        }else {
                            kTipAlert(@"您不是加工厂，无法参与担保订单投标!");
                        }
                        
                        
                    }
                    
                }];

            }else if ([self.orderTypeString isEqualToString:@"DesignOrder"]){
                
                [HttpClient bidDesignerOrderWithDiscription:_commentTV.text orderID:_orderID WithCompletionBlock:^(NSDictionary *dictionary) {
                    DLog(@"%@",dictionary);
                    if ([dictionary[@"statusCode"] isEqualToString:@"200"]) {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"投标成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                        alertView.tag = 10086;
                        [alertView show];
                        if (_imageViewArray.count>0) {
                            NSString *policyString = dictionary[@"message"][@"data"][@"policy"];
                            NSString *signatureString = dictionary[@"message"][@"data"][@"signature"];
                            UpYun *upYun = [[UpYun alloc] init];
                            upYun.bucket = bucketAPI;//图片测试
                            upYun.expiresIn = 600;// 10分钟
                            DLog(@"%@",_imageViewArray);
                            [_imageViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                UIImage *image = (UIImage *)obj;
                                [upYun uploadImage:image policy:policyString signature:signatureString];
                            }];
                            
                        }else{
                            // 用户未上传图片
                        }
                        
                    }else if ([dictionary[@"statusCode"] isEqualToString:@"404"]) {
                        kTipAlert(@"发布订单失败，请重新登录");
                    }
                    
                }];
            }
            
           
        }
    }
    
    else if (alertView.tag == 10086) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    else if (alertView.tag == 402) {
        if (buttonIndex == 1) {
            [self.navigationController pushViewController:[RechargeViewController new] animated:YES];
        }
    }
    
    else if (alertView.tag == 403) {
        if (buttonIndex == 1) {
            AuthenticationController *vc = [AuthenticationController new];
            vc.homeEnter = NO;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }

}

- (void)creatScrollView{
    
    if (_scrollView) {
        [_scrollView removeFromSuperview];
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20+80+20, _addButton.frame.origin.y, kScreenW-40-80-20, 80)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self.tableView.tableFooterView addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(90 * _imageViewArray.count, 80);
    for (int i = 0; i < _imageViewArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setBackgroundImage:_imageViewArray[i] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(i * 90, 0, 80, 80)];
        [button addTarget:self action:@selector(MJPhotoBrowserClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [_scrollView addSubview:button];
        
        UIButton*deleteBtn = [[UIButton alloc]init];
        deleteBtn.frame = CGRectMake(button.frame.size.width-25, 0, 25, 25);
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"删除图片"] forState:UIControlStateNormal];
        deleteBtn.tag = i;
        [deleteBtn addTarget:self action:@selector(deleteImageView:) forControlEvents:UIControlEventTouchUpInside];
        [button addSubview:deleteBtn];
    }
    
}

- (void)deleteImageView:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    [_imageViewArray removeObjectAtIndex:button.tag];
    if (_imageViewArray.count > 0) {
        [self creatScrollView];
        
    }else{
        [_scrollView removeFromSuperview];
        _addButton.frame = CGRectMake((kScreenW-80)/2.0, 30, 80, 80);
    }
}

#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
        DLog(@"1");
    }];
}

- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAssets:(NSArray *)assets isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        DLog(@"2");
        
        [assets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            self.asset=assets[idx];
            ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
            [lib assetForURL:_asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
                if (asset) {
                    UIImage*image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                    [_imageViewArray addObject:image];
                    if (idx == [assets count] - 1) {
                        DLog(@"_imageViewArrayCount==%zi",_imageViewArray.count);
                        _addButton.frame = CGRectMake(20, 30, 80, 80);
                        [self creatScrollView];
                    }
                }
            } failureBlock:^(NSError *error) {
                
            }];
            
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        DLog(@"取消");
    }];
}

- (void)MJPhotoBrowserClick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[_imageViewArray count]];
    [_imageViewArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.image = _imageViewArray[idx]; // 图片
        [photos addObject:photo];
    }];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = button.tag;
    browser.photos = photos;
    [browser show];
    
}



@end

//
//  PublishOrder_VC.m
//  Cofactories
//
//  Created by GTF on 15/11/27.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "PublishOrder_Common_VC.h"
#import "Order_Common_TVC.h"
#import "JKPhotoBrowser.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MJPhotoBrowser.h"
@interface PublishOrder_Common_VC ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,JKImagePickerControllerDelegate>{
    UITableView    *_tableView;
    UITextField    *_titleTF;
    UITextField    *_amountTF;
    UITextField    *_unitTF;
    UITextField    *_commentTF;
    BOOL            _isAblePublish;
    UIButton       *_addButton;
    NSMutableArray *_imageViewArray;
    UIScrollView   *_scrollView;
    NSString       *_typeString;
    
}
@property (nonatomic, strong) JKAssets  *asset;

@end
static NSString *const reuseIdentifier = @"reuseIdentifier";

@implementation PublishOrder_Common_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _imageViewArray = [@[] mutableCopy];
    
    switch (self.orderType) {
        case 1:
            self.navigationItem.title = @"求购面料";
            _typeString = @"fabric";
            break;
        case 2:
            self.navigationItem.title = @"求购辅料";
            _typeString = @"accessory";
            break;
        case 3:
            self.navigationItem.title = @"求购机械设备";
            _typeString = @"machine";
            break;
        default:
            break;
    }
    [self initTableView];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:kScreenBounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    [_tableView registerClass:[Order_Common_TVC class] forCellReuseIdentifier:reuseIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44)];
    _tableView.tableHeaderView = headerView;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 20, 25)];
    imageView.image = [UIImage imageNamed:@"dd.png"];
    [headerView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 120, 25)];
    label.textColor = MAIN_COLOR;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"订单信息";
    [headerView addSubview:label];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 174)];
    _tableView.tableFooterView = footerView;
    
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
    [publishButton setTitle:@"发布订单" forState:UIControlStateNormal];
    [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:publishButton];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Order_Common_TVC *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSArray *array = @[@"订单标题",@"订单数量",@"单位",@"备注"];
    [cell returnTextFieldTitleString:array[indexPath.row] indexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            _titleTF = cell.textField;
            break;
        case 1:
            _amountTF = cell.textField;
            break;
        case 2:
            _unitTF = cell.textField;
            break;
        case 3:
            _commentTF = cell.textField;
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else{
        return 100;
    }
}

- (void)publishClick{
    if (_titleTF.text.length > 0 && _amountTF.text.length > 0 && _unitTF.text.length > 0) {
        _isAblePublish = YES;
    }else{
        _isAblePublish = NO;
        kTipAlert(@"请填写必填信息，再发布订单!");
    }
    
    if (_isAblePublish) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认发布订单" delegate:self cancelButtonTitle:@"再看看" otherButtonTitles:@"确认发布", nil];
        alertView.tag = 100;
        [alertView show];
    }
}

//点击发布订单
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            DLog(@"%@,%@,%@,%@,%@",_typeString,_titleTF.text,_amountTF.text,_unitTF.text,_commentTF.text);
            [HttpClient publishSupplierOrderWithType:_typeString name:_titleTF.text amount:_amountTF.text unit:_unitTF.text description:_commentTF.text WithCompletionBlock:^(NSDictionary *dictionary) {
                DLog(@"%@",dictionary);
                if ([dictionary[@"statusCode"] isEqualToString:@"200"]) {
                    kTipAlert(@"发布订单成功");
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

- (void)creatScrollView{
    
    if (_scrollView) {
        [_scrollView removeFromSuperview];
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(20+80+20, _addButton.frame.origin.y, kScreenW-40-80-20, 80)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_tableView.tableFooterView addSubview:_scrollView];
    
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

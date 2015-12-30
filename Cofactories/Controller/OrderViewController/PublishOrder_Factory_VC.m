//
//  PublishOrder_Factory_VC.m
//  Cofactories
//
//  Created by GTF on 15/11/27.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "PublishOrder_Factory_VC.h"
#import "ZFPopupMenu.h"
#import "ZFPopupMenuItem.h"
#import "CustomeView.h"
#import "JKPhotoBrowser.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MJPhotoBrowser.h"

@interface PublishOrder_Factory_VC ()<UITableViewDataSource,UITableViewDelegate,JKImagePickerControllerDelegate,UIAlertViewDelegate>{
    UITableView    *_tableView;
    UILabel        *_typeLabel;
    UITextField    *_amountTF;
    UITextField    *_commentTF;
    CustomeView    *_customeView;
    NSInteger       _timeAmount;
    UIButton       *_addButton;
    NSMutableArray   *_imageViewArray;
    UIScrollView     *_scrollView;
}
@property (nonatomic, strong) JKAssets  *asset;
@end

static NSString *const reuseIdentifier = @"reuseIdentifier";

@implementation PublishOrder_Factory_VC

-(NSArray *)menuItems
{
    ZFPopupMenuItem *item1 = [ZFPopupMenuItem initWithMenuName:@"针织"
                                                         image:nil
                                                        action:@selector(test:)
                                                        target:self];
    item1.tag = 1;
    ZFPopupMenuItem *item2 = [ZFPopupMenuItem initWithMenuName:@"梭织"
                                                         image:nil
                                                        action:@selector(test:)
                                                        target:self];
    item2.tag = 2;
    return @[item1,item2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"寻找加工厂";
    self.view.backgroundColor = [UIColor whiteColor];
    _imageViewArray = [@[] mutableCopy];
    
    [self initTableView];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:kScreenBounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    //_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 44*5)];
    _tableView.tableHeaderView = headerView;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 15, 20)];
    imageView.image = [UIImage imageNamed:@"dd.png"];
    [headerView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(35, 8, 120, 25)];
    label.textColor = MAIN_COLOR;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"订单信息";
    [headerView addSubview:label];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 70, 44)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:titleLabel];
    
    NSString *string = @"* 订单类型";
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedTitle addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
    titleLabel.attributedText = attributedTitle;
    
    
    _typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 45, 100, 44)];
    _typeLabel.font = [UIFont systemFontOfSize:12];
    _typeLabel.textColor = [UIColor grayColor];
    _typeLabel.text = @"针织/梭织";
    _typeLabel.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:_typeLabel];
    
    UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
    selectedButton.frame = CGRectMake(kScreenW-45, 45, 40, 40);
    [selectedButton setBackgroundImage:[UIImage imageNamed:@"三角形.png"] forState:UIControlStateNormal];
    [selectedButton addTarget:self action:@selector(selectedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:selectedButton];
    
    UILabel *amountLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45+44, 100, 44)];
    amountLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:amountLabel];
    
    NSString *string1 = @"* 订单数量(件)";
    NSMutableAttributedString *attributedTitle1 = [[NSMutableAttributedString alloc] initWithString:string1];
    [attributedTitle1 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
    amountLabel.attributedText = attributedTitle1;
    
    _amountTF = [[UITextField alloc] initWithFrame:CGRectMake(115, 45+44+7, kScreenW - 120, 30)];
    _amountTF.font = [UIFont systemFontOfSize:12];
    _amountTF.textColor = [UIColor grayColor];
    _amountTF.keyboardType = UIKeyboardTypeNumberPad;
    _amountTF.placeholder = @"请填写订单数量";
    [headerView addSubview:_amountTF];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 45+44+44, 70, 44)];
    timeLabel.font = [UIFont systemFontOfSize:14];
    [headerView addSubview:timeLabel];
    
    NSString *string2 = @"* 订单期限";
    NSMutableAttributedString *attributedTitle2 = [[NSMutableAttributedString alloc] initWithString:string2];
    [attributedTitle2 addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0,1)];
    timeLabel.attributedText = attributedTitle2;
    
    _customeView = [[CustomeView alloc] initWithFrame:CGRectMake(115, 45+44+44+12, kScreenW-200, (kScreenW-200)/6.f)];
    [headerView addSubview:_customeView];
    
    UILabel *commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 45+44+44+44, 70, 44)];
    commentLabel.font = [UIFont systemFontOfSize:14];
    commentLabel.text = @"备注";
    [headerView addSubview:commentLabel];
    
    _commentTF = [[UITextField alloc] initWithFrame:CGRectMake(115, 45+44+44+44+7, kScreenW - 120, 30)];
    _commentTF.font = [UIFont systemFontOfSize:12];
    _commentTF.placeholder = @"特殊要求填写备注说明";
    [headerView addSubview:_commentTF];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 174)];
    _tableView.tableFooterView = footerView;
    
    _addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _addButton.frame = CGRectMake(20, 30, 80, 80);
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
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (void)selectedButtonClick:(UIButton *)button{
    [ZFPopupMenu setMenuBackgroundColorWithRed:0 green:0 blue:0 aphla:0.2];
    [ZFPopupMenu setTextColorWithRed:1 green:1 blue:1 aphla:1.0];
    ZFPopupMenu *popupMenu = [[ZFPopupMenu alloc] initWithItems:[self menuItems]];
    [popupMenu showInView:self.navigationController.view fromRect:CGRectMake(button.frame.origin.x, button.frame.origin.y+40, 40, 40) layoutType:Vertical];
    [self.navigationController.view addSubview:popupMenu];
    
}

-(void)test:(ZFPopupMenuItem *)item{
    if (item.tag == 1) {
        _typeLabel.text = @"针织";
    }else{
        _typeLabel.text = @"梭织";
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


- (void)publishClick{
    
    if (_typeLabel.text.length != 2 || _amountTF.text.length == 0 || [Tools isBlankString:_amountTF.text] == YES) {
        kTipAlert(@"请填写必填信息，再发布订单!");
    }else{
        if ([_amountTF.text isEqualToString:@"0"]) {
            kTipAlert(@"订单数量不得为0!");
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否确认发布订单" delegate:self cancelButtonTitle:@"再看看" otherButtonTitles:@"确认发布", nil];
            alertView.tag = 100;
            [alertView show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            DLog(@"%@,%@,%ld,%@",_typeLabel.text,_amountTF.text,(long)_customeView.timeAmount,_commentTF.text);
            
            NSString *typeString = @"";
            if ([_typeLabel.text isEqualToString:@"针织"]) {
                typeString = @"knit";
            }else{
                typeString = @"woven";
            }
            
            [HttpClient publishFactoryOrderWithSubrole:@"加工厂"type:typeString amount:_amountTF.text deadline:[NSString stringWithFormat:@"%ld",(long)_customeView.timeAmount] description:_commentTF.text WithCompletionBlock:^(NSDictionary *dictionary) {
                
                DLog(@"%@",dictionary);
                if ([dictionary[@"statusCode"] isEqualToString:@"200"]) {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布订单成功" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles: nil];
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
    
    if (alertView.tag == 10086) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


@end

//
//  MeAddDesign_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/11.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MeAddDesign_VC.h"
#import "MeTextFieldCell.h"
#import "JKPhotoBrowser.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "MeCatergoryCell.h"
#import "PlaceholderTextView.h"
#import "DOPDropDownMenu.h"
static NSString *TFCellIdentifier = @"TFCell";
static NSString *nameTFCellIdentifier = @"nameTFCell";
static NSString *MeCatergoryCellIdentifier = @"MeCatergoryCell";
static NSString * CellIdentifier = @"CellIdentifier";

@interface MeAddDesign_VC ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, JKImagePickerControllerDelegate, UIAlertViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate> {
    UITextField *nameTF, *salePriceTF, *marketPriceTF, *amountTF;
    NSArray *labelArray, *placeHolderArray;
    PlaceholderTextView *descriptionTV;
    
    UIButton * _addImageBtn;
    UILabel *_addImageLabel;
    UIButton * _addCatergoryBtn;
    UILabel *_addCatergoryLabel;
    UILabel  * tiShiYuLabel;
    DOPDropDownMenu *_dropDownMenu;
    NSArray         *allTypeArray;
    NSArray         *manTypeArray;
    NSArray         *womenTypeArray;
    NSArray         *boyTypeArray;
    NSArray         *girlTypeArray;
    NSString *leftTypeString, *rightTypeString;
    
}
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *collectionImage;//上传图片数组
@property (nonatomic, strong) JKAssets  *asset;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *collectionView1;
@property (nonatomic, strong) NSMutableArray *categoryArray;//商品分类

@end

@implementation MeAddDesign_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发布商品";
    
    labelArray = @[@"售价", @"市场标价", @"库存"];
    placeHolderArray = @[@"请输入价格, 小数点后最多两位", @"请输入价格, 小数点后最多两位",  @"请输入库存量"];
    self.collectionImage = [[NSMutableArray alloc]initWithCapacity:9];
    self.categoryArray = [NSMutableArray arrayWithCapacity:0];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(pressRightItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _addImageLabel = [[UILabel alloc] init];
    _addImageLabel.frame = CGRectMake(15, 7, 70, 30);
    _addImageLabel.text = @"商品展示";
    _addImageLabel.font = [UIFont systemFontOfSize:15];
    
    _addImageBtn = [[UIButton alloc]init];
    _addImageBtn.frame=CGRectMake(kScreenW - 115, 7, 100, 30);
    [_addImageBtn setTitle:@"添加图片" forState:UIControlStateNormal];
    [_addImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addImageBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _addImageBtn.layer.masksToBounds = YES;
    _addImageBtn.layer.cornerRadius = 3;
    _addImageBtn.backgroundColor = kMainLightBlueColor;
    [_addImageBtn addTarget:self action:@selector(addImageBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _addCatergoryLabel = [[UILabel alloc] init];
    _addCatergoryLabel.frame = CGRectMake(15, 7, 70, 30);
    _addCatergoryLabel.text = @"商品分类";
    _addCatergoryLabel.font = [UIFont systemFontOfSize:15];
    
    _addCatergoryBtn = [[UIButton alloc]init];
    _addCatergoryBtn.frame=CGRectMake(kScreenW - 115, 7, 100, 30);
    [_addCatergoryBtn setTitle:@"添加分类" forState:UIControlStateNormal];
    [_addCatergoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addCatergoryBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _addCatergoryBtn.layer.masksToBounds = YES;
    _addCatergoryBtn.layer.cornerRadius = 3;
    _addCatergoryBtn.backgroundColor = kMainLightBlueColor;
    [_addCatergoryBtn addTarget:self action:@selector(addCatergoryBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    tiShiYuLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, kScreenW - 30, 40)];
    tiShiYuLabel.numberOfLines = 0;
    tiShiYuLabel.text = @"注：各个商品分类属性20个字以内,可以添加多个分类属性";
    tiShiYuLabel.font = [UIFont systemFontOfSize:14];
    tiShiYuLabel.textColor = [UIColor lightGrayColor];
    
    [self creatTableView];
    
    //选择类型
    allTypeArray = @[@"男装",@"女装",@"男童", @"女童"];
    manTypeArray = @[@"上衣",@"下衣",@"套装"];
    womenTypeArray = @[@"上衣",@"下衣",@"套装"];
    boyTypeArray = @[@"上衣",@"下衣",@"套装"];
    girlTypeArray = @[@"上衣",@"下衣",@"套装"];
    leftTypeString = @"male";
    rightTypeString = nil;
    _dropDownMenu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 64) andHeight:44];
    _dropDownMenu.delegate = self;
    _dropDownMenu.dataSource = self;
    [self.view addSubview:_dropDownMenu];

}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 2.0;
        layout.minimumInteritemSpacing = 2.0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, kScreenW, kScreenW) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.tag = 222;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    }
    return _collectionView;
}
- (UICollectionView *)collectionView1{
    if (!_collectionView1) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 15;
        layout.minimumInteritemSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView1 = [[UICollectionView alloc] initWithFrame:CGRectMake(15, 45, kScreenW - 30, 100) collectionViewLayout:layout];
        _collectionView1.backgroundColor = [UIColor clearColor];
        
        _collectionView1.delegate = self;
        _collectionView1.dataSource = self;
        _collectionView1.tag = 223;
        _collectionView1.showsHorizontalScrollIndicator = NO;
        _collectionView1.showsVerticalScrollIndicator = NO;
        [_collectionView1 registerClass:[MeCatergoryCell class] forCellWithReuseIdentifier:MeCatergoryCellIdentifier];
    }
    return _collectionView1;
}
- (void)creatTableView {
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kScreenW, kScreenH - 44)style:UITableViewStyleGrouped];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.myTableView.backgroundColor = [UIColor colorWithRed:251.0f/255.0f green:251.0f/255.0f blue:251.0f/255.0f alpha:1.0f];
    [self.view addSubview:self.myTableView];
    [self.myTableView registerClass:[MeTextFieldCell class] forCellReuseIdentifier:nameTFCellIdentifier];
    [self.myTableView registerClass:[MeTextFieldCell class] forCellReuseIdentifier:TFCellIdentifier];
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 160)];
    footerView.backgroundColor = [UIColor whiteColor];
    UILabel *myTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenW - 30, 50)];
    myTitleLabel.text = @"商品简介";
    
    [footerView addSubview:myTitleLabel];
    
    
    descriptionTV = [[PlaceholderTextView alloc] initWithFrame:CGRectMake(15, 50, kScreenW - 30, 100)];
    descriptionTV.layer.cornerRadius = 3;
    descriptionTV.clipsToBounds = YES;
    descriptionTV.layer.borderColor = kLineGrayCorlor.CGColor;
    descriptionTV.layer.borderWidth = 0.5;
    descriptionTV.placeholder = @"请输入商品简介";
    descriptionTV.placeholderFont = [UIFont systemFontOfSize:14];
    [footerView addSubview:descriptionTV];
    
    self.myTableView.tableFooterView = footerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 3;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MeTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:nameTFCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.myLabel.text = @"商品名称";
        nameTF = cell.myTextField;
        nameTF.placeholder = @"请输入商品名称";
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            [cell addSubview:_addImageLabel];
            [cell addSubview:_addImageBtn];
            if ([self.collectionImage count]==0) {
                
            }else {
                [cell addSubview:self.collectionView];
            }
        }
        
        return cell;
    } else if (indexPath.section == 2) {
        MeTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:TFCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.myTextField.placeholder = placeHolderArray[indexPath.row];
        cell.myLabel.text = labelArray[indexPath.row];
        switch (indexPath.row) {
            case 0:{
                salePriceTF = cell.myTextField;
                salePriceTF.keyboardType = UIKeyboardTypeDecimalPad;
                
            }
                break;
            case 1:{
                marketPriceTF = cell.myTextField;
                marketPriceTF.keyboardType = UIKeyboardTypeDecimalPad;
            }
                break;
            case 2:{
                amountTF = cell.myTextField;
                amountTF.keyboardType = UIKeyboardTypeNumberPad;
            }
                break;

            default:
                break;
        }
        
        return cell;
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        [cell addSubview:_addCatergoryLabel];
        [cell addSubview:_addCatergoryBtn];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if ([self.categoryArray count]==0) {
            tiShiYuLabel.hidden = NO;
            [cell addSubview:tiShiYuLabel];
        }else {
            tiShiYuLabel.hidden = YES;
            [cell addSubview:self.collectionView1];
        }
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 || indexPath.section == 2) {
        return 40;
    } else if (indexPath.section == 1) {
        if ([self.collectionImage count]==0) {
            return 44;
        }
        if (0<[self.collectionImage count] && [self.collectionImage count]<4) {
            return kScreenW/3+50;
        }
        if (3<[self.collectionImage count] && [self.collectionImage count]<7) {
            return 2*kScreenW/3+50;
        }
        if (6<[self.collectionImage count] && [self.collectionImage count]<10) {
            return kScreenW+50;
        }
        
    } else if (indexPath.section == 3) {
        return 145;
    }
    
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 5.0f;
}

- (void)addImageBtn {
    
    if ([self.collectionImage count]== 9) {
        kTipAlert(@"商品图片最多能上传9张");
    }else {
        JKImagePickerController *imagePickerController = [[JKImagePickerController alloc] init];
        imagePickerController.delegate = self;
        imagePickerController.showsCancelButton = YES;
        imagePickerController.allowsMultipleSelection = YES;
        imagePickerController.minimumNumberOfSelection = 0;
        imagePickerController.maximumNumberOfSelection = 9 - [self.collectionImage count];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
        [self presentViewController:navigationController animated:YES completion:NULL];
    }
}


#pragma mark - JKImagePickerControllerDelegate
- (void)imagePickerController:(JKImagePickerController *)imagePicker didSelectAsset:(JKAssets *)asset isSource:(BOOL)source
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        
        DLog(@"1");
    }];
}

//下一步
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
                    [self.collectionImage addObject:image];
                    if (idx == [assets count] - 1) {
                        [self collectionView];
                        [self.collectionView reloadData];
                        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                        [self.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                        
                        DLog(@"self.collectionImage %lu",(unsigned long)[self.collectionImage count]);
                    }
                }
            } failureBlock:^(NSError *error) {
                
            }];
            
        }];
    }];
    
}

//取消
- (void)imagePickerControllerDidCancel:(JKImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        DLog(@"取消");
    }];
}

#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-8)/3

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 222) {
        return CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
    } else {
        //计算宽度
        CGSize size = [Tools getSize:self.categoryArray[indexPath.row] andFontOfSize:14];
        return CGSizeMake(size.width + 25, 30);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (collectionView.tag == 222) {
        return UIEdgeInsetsMake(2, 2, 2, 2);
    } else {
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 222) {
        return [self.collectionImage count];
    } else {
        return self.categoryArray.count;
    }
    
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 222) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
        UIImageView*imageView = [[UIImageView alloc]init];
        imageView.userInteractionEnabled = YES;
        imageView.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
        imageView.image = self.collectionImage[indexPath.row];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        [cell addSubview:imageView];
        
        UIButton*deleteBtn = [[UIButton alloc]init];
        deleteBtn.frame = CGRectMake(imageView.frame.size.width-25, 0, 25, 25);
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"删除图片"] forState:UIControlStateNormal];
        deleteBtn.tag = indexPath.row;
        [deleteBtn addTarget:self action:@selector(deleteCell:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:deleteBtn];
        return cell;
    } else {
        MeCatergoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:MeCatergoryCellIdentifier forIndexPath:indexPath];
        cell.catergoryLabel.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
        cell.catergoryLabel.text = self.categoryArray[indexPath.row];
        cell.shanChuButton.tag = indexPath.row + 1000;
        [cell.shanChuButton addTarget:self action:@selector(deleteCatergory:) forControlEvents:UIControlEventTouchUpInside];
        cell.deleteImage.frame = CGRectMake(cell.frame.size.width -15, -3, 20, 20);
        cell.shanChuButton.frame = CGRectMake(cell.frame.size.width/2, 0, cell.frame.size.width/2, cell.frame.size.height);
        
        return cell;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 222) {
        NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[self.collectionImage count]];
        [self.collectionImage enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            MJPhoto *photo = [[MJPhoto alloc] init];
            photo.image = self.collectionImage[idx]; // 图片
            [photos addObject:photo];
        }];
        
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = indexPath.row;
        browser.photos = photos;
        [browser show];
    } else {
        
    }
}

- (void)deleteCell:(UIButton*)sender {
    DLog(@"%ld",(long)sender.tag);
    [self.collectionImage removeObjectAtIndex:sender.tag];
    [self.collectionView reloadData];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
    [self.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)deleteCatergory:(UIButton *)button {
    [self.categoryArray removeObjectAtIndex:button.tag - 1000];
    [self.collectionView1 reloadData];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
    [self.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)addCatergoryBtn {
    [nameTF resignFirstResponder];
    [salePriceTF resignFirstResponder];
    [marketPriceTF resignFirstResponder];
    [amountTF resignFirstResponder];
    [descriptionTV resignFirstResponder];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"商品分类" message:@"注：各个商品分类属性20个字以内" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.tag = 555;
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 555) {
        //得到输入框
        UITextField *tf=[alertView textFieldAtIndex:0];
        DLog(@"^^^^^^^^^^^^%@", tf.text);
        if (buttonIndex == 1) {
            BOOL tfFlag = [Tools isBlankString:tf.text];
            if (tfFlag == YES) {
                DLog(@"输入的没有内容");
                kTipAlert(@"输入的内容为空");
            } else {
                NSString *cutString = @"";
                if (tf.text.length > 20) {
                    cutString = [tf.text substringToIndex:20];
                } else {
                    cutString = tf.text;
                }
                [self.categoryArray addObject:cutString];
                DLog(@"%ld", self.categoryArray.count);
                [self.collectionView1 reloadData];
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:3];
                [self.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
        }

    }
    
    if (alertView.tag == 666) {
        if (buttonIndex == 1) {
            [self publishDesignGoods];
        } else {

        }
        
    }
    if (alertView.tag == 777) {
        if (buttonIndex == 0) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - 发表商品
- (void)pressRightItem {
    DLog(@"leftTypeString = %@, rightTypeString = %@, name = %@, photoNumber = %ld, salePrice = %@, marketPrice = %@, amount = %@, categoryCount = %ld, description  = %@",leftTypeString, rightTypeString, nameTF.text, self.collectionImage.count, salePriceTF.text, marketPriceTF.text, amountTF.text, self.categoryArray.count, descriptionTV.text);
    if (rightTypeString.length == 0) {
        kTipAlert(@"请选择上衣、下衣或套装");
    } else {
        if ([Tools isBlankString:nameTF.text] == YES || [Tools isBlankString:salePriceTF.text] == YES || [Tools isBlankString:marketPriceTF.text] == YES || [Tools isBlankString:amountTF.text] == YES || self.categoryArray.count == 0 || [Tools isBlankString:descriptionTV.text] == YES) {
            kTipAlert(@"商品信息填写不完整");
        } else if (self.collectionImage.count == 0 ) {
            kTipAlert(@"请添加图片");
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认发布" message:nil delegate:self cancelButtonTitle:@"放弃" otherButtonTitles:@"确定", nil];
            alert.tag = 666;
            [alert show];
        }
    }
    
    
}

- (void)publishDesignGoods {
    NSString *myAmount = [NSString stringWithFormat:@"%ld", [amountTF.text integerValue]];
    [HttpClient publishDesignWithMarket:@"design" name:nameTF.text type:leftTypeString part:rightTypeString price:salePriceTF.text marketPrice:marketPriceTF.text country:@"cn" amount:myAmount description:descriptionTV.text category:self.categoryArray WithCompletionBlock:^(NSDictionary *dictionary) {
        int statusCode = [dictionary[@"statusCode"] intValue];
        if (statusCode == 200) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发布成功" message:@"可能需要几分钟的等待上传图片！" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            alert.tag = 777;
            [alert show];
            NSDictionary *myDic = dictionary[@"responseObject"];
            NSString *policyString = myDic[@"data"][@"policy"];
            NSString *signatureString = myDic[@"data"][@"signature"];
            UpYun *upYun = [[UpYun alloc] init];
            upYun.bucket = bucketAPI;//图片测试
            upYun.expiresIn = 600;// 10分钟
            
            DLog(@"%@",self.collectionImage);
            [self.collectionImage enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                UIImage *image = (UIImage *)obj;
                [upYun uploadImage:image policy:policyString signature:signatureString];
            }];
            
        } else {
            kTipAlert(@"发布失败 (错误码：%d)", statusCode);
            
        }
        
    }];
}

#pragma mark - dropDownMenu

- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu{
    return 1;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column{
    return allTypeArray.count;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column{
    if (row == 0) {
        return manTypeArray.count;
    }else if (row == 1){
        return womenTypeArray.count;
    }else if (row == 2){
        return boyTypeArray.count;
    } else if (row == 3) {
        return girlTypeArray.count;
    }
    return 0;
}
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath{
    return allTypeArray[indexPath.row];
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return manTypeArray[indexPath.item];
    }else if (indexPath.row == 1){
        return womenTypeArray[indexPath.item];
    }else if (indexPath.row == 2){
        return boyTypeArray[indexPath.item];
    } else if (indexPath.row == 3) {
        return girlTypeArray[indexPath.item];
    }
    return nil;
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            leftTypeString = @"male";
            rightTypeString = nil;
            switch (indexPath.item) {
                case 0:
                    rightTypeString = @"top";
                    break;
                case 1:
                    rightTypeString = @"bottom";
                    break;
                case 2:
                    rightTypeString = @"suit";
                    break;
                
                default:
                    break;
            }
            break;
        case 1:
            leftTypeString = @"female";
            rightTypeString = nil;
            switch (indexPath.item) {
                case 0:
                    rightTypeString = @"top";
                    break;
                case 1:
                    rightTypeString = @"bottom";
                    break;
                case 2:
                    rightTypeString = @"suit";
                    break;
                
                default:
                    break;
            }

            break;
        case 2:
            leftTypeString = @"boy";
            rightTypeString = nil;
            switch (indexPath.item) {
                case 0:
                    rightTypeString = @"top";
                    break;
                case 1:
                    rightTypeString = @"bottom";
                    break;
                case 2:
                    rightTypeString = @"suit";
                    break;
                
                default:
                    break;
            }
            break;
        case 3:
            leftTypeString = @"girl";
            rightTypeString = nil;
            switch (indexPath.item) {
                case 0:
                    rightTypeString = @"top";
                    break;
                case 1:
                    rightTypeString = @"bottom";
                    break;
                case 2:
                    rightTypeString = @"suit";
                    break;
                
                default:
                    break;
            }
            break;

        default:
            break;
    }
    
    DLog(@"leftString = %@, rightString = %@", leftTypeString, rightTypeString);
}


@end

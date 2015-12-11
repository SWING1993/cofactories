//
//  MeAddSupply_VC.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/10.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "MeAddSupply_VC.h"
#import "MeTextFieldCell.h"
#import "JKPhotoBrowser.h"
#import "JKImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "MeCatergoryCell.h"
#import "PlaceholderTextView.h"

static NSString *TFCellIdentifier = @"TFCell";
static NSString *MeCatergoryCellIdentifier = @"MeCatergoryCell";

@interface MeAddSupply_VC ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, JKImagePickerControllerDelegate, UIAlertViewDelegate> {
    UITextField *nameTF, *salePriceTF, *marketPriceTF, *amountTF, *unitTF;
    NSArray *labelArray, *placeHolderArray;
    PlaceholderTextView *descriptionTV;
    
    UIButton * _addImageBtn;
    UIButton * _addCatergoryBtn;
    UILabel  * tiShiYuLabel;
}
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *collectionImage;//上传图片数组
@property (nonatomic, strong) JKAssets  *asset;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionView *collectionView1;
@property (nonatomic, strong) NSMutableArray *categoryArray;//商品分类


@end

@implementation MeAddSupply_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发布商品";
    
    labelArray = @[@"售价", @"市场标价", @"单位", @"库存"];
    placeHolderArray = @[@"请输入价格", @"请输入价格", @"请输入单位", @"请输入库存量"];
    self.collectionImage = [[NSMutableArray alloc]initWithCapacity:9];
    self.categoryArray = [NSMutableArray arrayWithCapacity:0];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"发表" style:UIBarButtonItemStylePlain target:self action:@selector(pressRightItem)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    _addImageBtn = [[UIButton alloc]init];
    _addImageBtn.frame=CGRectMake(30, 7, kScreenW-60, 30);
    [_addImageBtn setTitle:@"添加图片" forState:UIControlStateNormal];
    [_addImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addImageBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _addImageBtn.layer.masksToBounds = YES;
    _addImageBtn.layer.cornerRadius = 3;
    _addImageBtn.backgroundColor = [UIColor colorWithRed:72.0/255.0 green:126.0/255.0 blue:207.0/255.0 alpha:1.0];
    [_addImageBtn addTarget:self action:@selector(addImageBtn) forControlEvents:UIControlEventTouchUpInside];
    
    _addCatergoryBtn = [[UIButton alloc]init];
    _addCatergoryBtn.frame=CGRectMake(30, 7, kScreenW-60, 30);
    [_addCatergoryBtn setTitle:@"添加分类" forState:UIControlStateNormal];
    [_addCatergoryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _addCatergoryBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    _addCatergoryBtn.layer.masksToBounds = YES;
    _addCatergoryBtn.layer.cornerRadius = 3;
    _addCatergoryBtn.backgroundColor = [UIColor colorWithRed:72.0/255.0 green:126.0/255.0 blue:207.0/255.0 alpha:1.0];
    [_addCatergoryBtn addTarget:self action:@selector(addCatergoryBtn) forControlEvents:UIControlEventTouchUpInside];
    
    tiShiYuLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 70, kScreenW - 30, 40)];
    tiShiYuLabel.numberOfLines = 0;
    tiShiYuLabel.text = @"注：各个商品分类属性以空格隔开，单个属性20个字以内";
    tiShiYuLabel.font = [UIFont systemFontOfSize:14];
    tiShiYuLabel.textColor = [UIColor lightGrayColor];
    
    [self creatTableView];
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
        layout.minimumLineSpacing = 5.0;
        layout.minimumInteritemSpacing = 10.0;
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
//    self.myTableView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.myTableView];
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
    descriptionTV.placeholderFont = [UIFont systemFontOfSize:15];
    [footerView addSubview:descriptionTV];
    
    self.myTableView.tableFooterView = footerView;
}





#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return 4;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MeTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:TFCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.myLabel.text = @"商品名称";
        nameTF = cell.myTextField;
        nameTF.placeholder = @"请输入商品名称";
        return cell;
    } else if (indexPath.section == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
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
                unitTF = cell.myTextField;
                unitTF.keyboardType = UIKeyboardTypeDefault;
            }
                break;
            case 3:{
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

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"商品展示";
    } else if (section == 3) {
        return @"商品分类";
    } else {
        return nil;
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
    if (section == 1 || section == 3 ) {
        return 30;
    } else {
        return 0.5;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 0 || section == 2) {
        return 0.5;
    } else {
        return 10;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#define kSizeThumbnailCollectionView  ([UIScreen mainScreen].bounds.size.width-10)/3

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView.tag == 222) {
        return CGSizeMake(kSizeThumbnailCollectionView, kSizeThumbnailCollectionView);
    } else {
        //计算宽度
        CGSize size = [Tools getSize:self.categoryArray[indexPath.row] andFontOfSize:14];
        return CGSizeMake(size.width + 20, 30);
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(2, 2, 2, 2);
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
        cell.deleteImage.frame = CGRectMake(cell.frame.size.width -17, -3, 20, 20);
        cell.shanChuButton.frame = CGRectMake(cell.frame.size.width/2, 0, cell.frame.size.width/2, cell.frame.size.height);
        
        return cell;
    }
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"商品分类" message:@"注：各个商品分类属性以空格隔开，单个属性20个字以内" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //得到输入框
    UITextField *tf=[alertView textFieldAtIndex:0];
    DLog(@"^^^^^^^^^^^^%@", tf.text);
    if (buttonIndex == 1) {
        BOOL tfFlag = [self isBlankString:tf.text];
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

#pragma mark - 发表商品
- (void)pressRightItem {
    DLog(@"name = %@, photoNumber = %ld, salePrice = %@, marketPrice = %@, unit = %@, amount = %@, categoryCount = %ld, description  = %@", nameTF.text, self.collectionImage.count, salePriceTF.text, marketPriceTF.text, unitTF.text, amountTF.text, self.categoryArray.count, descriptionTV.text);
    if ([self isBlankString:nameTF.text] == YES || self.collectionImage.count == 0 || [self isBlankString:salePriceTF.text] == YES || [self isBlankString:marketPriceTF.text] == YES || [self isBlankString:unitTF.text] == YES || [self isBlankString:amountTF.text] == YES || self.categoryArray.count == 0 || [self isBlankString:descriptionTV.text] == YES) {
        kTipAlert(@"商品信息填写不完整！");
    } else {
        
    }
}





//判断是否含有字符
- (BOOL) isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

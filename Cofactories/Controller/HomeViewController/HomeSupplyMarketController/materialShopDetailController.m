//
//  materialShopDetailController.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/4.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "materialShopDetailController.h"
#import "MaterialShopDetailCell.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "MaterialAbstractCell.h"
#import "ZGYSelectNumberView.h"
#import "ColorSelectCell.h"
#import "SelectColorModel.h"
#import "ShopCarController.h"
#import "ShopCarModel.h"
#import "DataBaseHandle.h"
#import "ShoppingOrderController.h"
#import "FabricMarketModel.h"

#define kImageViewHeight kScreenW - 80

static NSString *shopCellIdentifier = @"shopCell";
static NSString *selectCellIdentifier = @"selectCell";
static NSString *abstractCellIdentifier = @"abstractCell";
static NSString *popViewCellIdentifier = @"popViewCell";
@interface materialShopDetailController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    UIScrollView  *_scrollView;
    UIView        *_headView;
    UIPageControl *pageControl;
    UIView        *backGroundView;
    UIView        *popView;
    ZGYSelectNumberView *numberView;
    NSString *selectString;
    NSString *selectColorString;//选择的分类
    NSInteger selectAmount;//选择的数量
    FabricMarketModel *marketDetailModel;
}
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *colorSelectArray;
@end

@implementation materialShopDetailController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.myAmount > 0) {
        selectAmount = self.myAmount;
        selectString = [NSString stringWithFormat:@"已选“颜色：%@” “数量：%ld”", self.myColorString, self.myAmount];
    } else {
        selectAmount = 1;
        selectString = @"请选择颜色分类";
    }
    
    [self creatTableView];
    [self creatGobackButton];
    [self creatBottomView];

}

#pragma mark - 返回键
- (void)creatGobackButton{
    UIImageView *cancleImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 30, 30, 30)];
    cancleImage.image = [UIImage imageNamed:@"goback"];
    [self.view addSubview:cancleImage];
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancleButton.frame = CGRectMake(0, 20, 80, 40);
    [cancleButton addTarget:self action:@selector(pressCancleButton) forControlEvents:UIControlEventTouchUpInside];
    cancleButton.backgroundColor = [UIColor clearColor];
    [self.view addSubview:cancleButton];
}
- (void)pressCancleButton{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)creatTableView {
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, kScreenW, kScreenH - 30)];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    [self.view addSubview:self.myTableView];
    [self.myTableView registerClass:[MaterialShopDetailCell class] forCellReuseIdentifier:shopCellIdentifier];
    [self.myTableView registerClass:[MaterialAbstractCell class] forCellReuseIdentifier:abstractCellIdentifier];
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:selectCellIdentifier];
        
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kImageViewHeight)];
    self.myTableView.tableHeaderView = _headView;
    
    [HttpClient getFabricDetailWithId:self.shopID WithCompletionBlock:^(NSDictionary *dictionary) {
        int statusCode = [dictionary[@"statusCode"] intValue];
        if (statusCode == 200) {
            marketDetailModel = (FabricMarketModel *)dictionary[@"model"];
            if (marketDetailModel.photoArray.count == 0) {
                UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, kImageViewHeight)];
                bgImageView.image = [UIImage imageNamed:@"默认图片"];
                bgImageView.contentMode = UIViewContentModeScaleAspectFill;
                bgImageView.clipsToBounds = YES;                [_headView addSubview:bgImageView];
                
            }else{
                [self creatScrollView];
            }
            
            //选择分类的数组
            self.colorSelectArray = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *myColorArray = [NSMutableArray arrayWithCapacity:0];
            if (marketDetailModel.catrgoryArray.count == 0) {
                myColorArray = [NSMutableArray arrayWithArray:@[@"默认"]];
            } else {
                myColorArray = [NSMutableArray arrayWithArray:marketDetailModel.catrgoryArray];
            }
            for (int i = 0; i < myColorArray.count; i++) {
                SelectColorModel *selectModel = [[SelectColorModel alloc] init];
                selectModel.colorText = myColorArray[i];
                if (self.myColorString.length > 0 && [selectModel.colorText isEqualToString:self.myColorString]) {
                    selectModel.isSelect = YES;
                } else {
                    selectModel.isSelect = NO;
                }
                
                [self.colorSelectArray addObject:selectModel];
            }

            DLog(@"%@", marketDetailModel);
            [self.myTableView reloadData];
        } else {
            kTipAlert(@"该商品已被下架");
        }
    }];
    
}


#pragma mark - 顶部图片
- (void)creatScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kImageViewHeight)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [_headView addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(kScreenW * marketDetailModel.photoArray.count, kImageViewHeight);

    for (int i = 0; i < marketDetailModel.photoArray.count; i++) {
        UIImageView *goodsImage = [[UIImageView alloc] initWithFrame:CGRectMake(i * kScreenW, 0, kScreenW, kImageViewHeight)];
        goodsImage.userInteractionEnabled = YES;
        goodsImage.contentMode = UIViewContentModeScaleAspectFill;
        goodsImage.clipsToBounds = YES;
        goodsImage.tag = 10000 + i;
        NSString* encodedString = [[NSString stringWithFormat:@"%@%@",PhotoAPI,marketDetailModel.photoArray[i]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [goodsImage sd_setImageWithURL:[NSURL URLWithString:encodedString]  placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
        //添加手势
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(MJPhotoBrowserClick:)];
        [goodsImage addGestureRecognizer:tap];
        [_scrollView addSubview:goodsImage];
        
    }
    if (marketDetailModel.photoArray.count > 1) {
        pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_scrollView.frame) - 40, kScreenW - 40, 40)];
        pageControl.numberOfPages = marketDetailModel.photoArray.count;
        [pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
        [_headView addSubview:pageControl];
    }
    
}
//代理要实现的方法: 切换页面后, 下面的页码控制器也跟着变化
- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    pageControl.currentPage = _scrollView.contentOffset.x /kScreenW;
}

- (void)changePage {
    [_scrollView setContentOffset:CGPointMake(pageControl.currentPage * kScreenW, 0) animated:YES];
}

- (void)MJPhotoBrowserClick:(UITapGestureRecognizer *)tap{
    NSInteger number = tap.view.tag - 10000;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[marketDetailModel.photoArray count]];
    [marketDetailModel.photoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        NSString* encodedString = [[NSString stringWithFormat:@"%@%@",PhotoAPI,marketDetailModel.photoArray[idx]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        photo.url = [NSURL URLWithString:encodedString];
        [photos addObject:photo];
    }];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = number;
    browser.photos = photos;
    [browser show];
    
}



#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MaterialShopDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.materialLabel.text = marketDetailModel.name;
        cell.priceLeftLabel.attributedText = [self changeFontAndColorWithString:[NSString stringWithFormat:@"售价￥ %@", marketDetailModel.price] andRange:2];

        cell.marketPriceLeftLabel.text = @"市场价";
        CGSize size = [Tools getSize:[NSString stringWithFormat:@" %@ ", marketDetailModel.marketPrice] andFontOfSize:15];
        cell.marketPriceRightLabel.frame = CGRectMake(CGRectGetMaxX(cell.marketPriceLeftLabel.frame), CGRectGetMaxY(cell.priceLeftLabel.frame), size.width, 30);
        
        cell.marketPriceRightLabel.attributedText = [self underlineWithString:[NSString stringWithFormat:@" %@ ", marketDetailModel.marketPrice]];
        cell.leaveCountLabel.frame = CGRectMake(CGRectGetMaxX(cell.marketPriceRightLabel.frame) + 10, CGRectGetMaxY(cell.priceLeftLabel.frame), kScreenW - 30 - CGRectGetWidth(cell.marketPriceLeftLabel.frame) - CGRectGetWidth(cell.marketPriceRightLabel.frame), 30);
        if ([marketDetailModel.amount isEqualToString:@"库存暂无"]) {
            cell.leaveCountLabel.text = @"库存暂无";
        } else {
            cell.leaveCountLabel.text = [NSString stringWithFormat:@"库存 %@ 件", marketDetailModel.amount];
        }
        
        return cell;
  
    } else if (indexPath.section == 1){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:selectCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.text = selectString;
        cell.textLabel.textColor = [UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    } else {
        MaterialAbstractCell *cell = [tableView dequeueReusableCellWithIdentifier:abstractCellIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.AbstractTitleLabel.text = @"商品简介：";
                CGSize size = [Tools getSize:marketDetailModel.descriptions andFontOfSize:13 andWidthMake:kScreenW - 60];
        cell.AbstractDetailLabel.frame = CGRectMake(30, 45, kScreenW - 60, size.height);
        cell.AbstractDetailLabel.text = marketDetailModel.descriptions;
        return cell;

    }
    
}



#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 110;
    } else if (indexPath.section == 1) {
        return 60;
    } else {
        CGSize size = [Tools getSize:marketDetailModel.descriptions andFontOfSize:13 andWidthMake:kScreenW - 60];
        
        return size.height + 60;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section == 2) {
        return 0.01;
    }
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        backGroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self.view addSubview:backGroundView];
        popView = [[UIView alloc] initWithFrame:CGRectMake(20*kZGY, 200*kZGY, kScreenW - 40*kZGY, 270*kZGY)];
        popView.backgroundColor = [UIColor whiteColor];
        popView.layer.cornerRadius = 8*kZGY;
        popView.clipsToBounds = YES;
        [self.view addSubview:popView];
        //出来时的动画
        CABasicAnimation *basic = [CABasicAnimation animationWithKeyPath:@"bounds"];
        basic.duration = 0.2;
        basic.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 10, 10)];
        [popView.layer addAnimation:basic forKey:@"shuai"];
        [self creatPopView];
        [self creatCollectionView];
    }
}


#pragma mark - 弹出的筛选视图
- (void)creatPopView {
    
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom]
    ;
    cancleButton.frame = CGRectMake(popView.frame.size.width - 30*kZGY, 5*kZGY, 25*kZGY, 25*kZGY);
    cancleButton.tag = 1002;
    [cancleButton addTarget:self action:@selector(actionOfPopBuy:) forControlEvents:UIControlEventTouchUpInside];
    [cancleButton setImage:[UIImage imageNamed:@"Home-叉号"] forState:UIControlStateNormal];
    [popView addSubview:cancleButton];
    
    
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(20*kZGY, 20*kZGY, popView.frame.size.width - 40*kZGY, 25*kZGY)];
    title1.font = [UIFont systemFontOfSize:15*kZGY];
    title1.text = @"颜色分类";
    [popView addSubview:title1];
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(20*kZGY, 150*kZGY, 70*kZGY, 25*kZGY)];
    title2.font = [UIFont systemFontOfSize:15*kZGY];
    title2.text = @"购买数量";
    [popView addSubview:title2];
    
    
    //筛选价格
    numberView = [[ZGYSelectNumberView alloc] initWithFrame:CGRectMake(popView.frame.size.width - 30*kZGY - 125*kZGY, 150*kZGY, 125*kZGY, 25*kZGY)WithAmount:selectAmount];
    [popView addSubview:numberView];
    
    
    NSArray *btnArray = @[@"加入购物车", @"立即购买"];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20*kZGY + i*(20*kZGY + (popView.frame.size.width - 3*20*kZGY)/2), 200*kZGY, (popView.frame.size.width - 3*20*kZGY)/2, 30*kZGY);
        [button setTitle:btnArray[i] forState:UIControlStateNormal];
        button.layer.borderColor = [UIColor colorWithRed:253.0/255.0 green:106.0/255.0 blue:9.0/255.0 alpha:1.0].CGColor;
        button.layer.borderWidth = 0.5;
        button.layer.cornerRadius = 5*kZGY;
        button.clipsToBounds = YES;
        [button setTitleColor:[UIColor colorWithRed:253.0/255.0 green:106.0/255.0 blue:9.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        button.tag = 1000 + i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(actionOfPopBuy:) forControlEvents:UIControlEventTouchUpInside];

        [popView addSubview:button];
    }
}

- (void)actionOfPopBuy:(UIButton *)button {
    DLog(@"%ld", numberView.timeAmount);
    //找出选中的颜色
    BOOL selectFlag = YES;
    for (int i = 0; i < self.colorSelectArray.count; i++) {
        SelectColorModel *selectColor = self.colorSelectArray[i];
        if (selectColor.isSelect == YES) {
            selectColorString = selectColor.colorText;
            selectFlag = NO;
            break;
        }
    }
    DLog(@"选中的颜色%@", selectColorString);

    if (button.tag == 1000) {
        if (selectFlag == YES) {
            DLog(@"请选择颜色");
            kTipAlert(@"请选择颜色");
        } else {
            //加入购物车
            DataBaseHandle *dataBaseHandle = [DataBaseHandle mainDataBaseHandle];
            [dataBaseHandle searchAllShoppingCar];
            BOOL flag = YES;
            for (ShopCarModel *shopCar in dataBaseHandle.shoppingCarArray) {
                if ([shopCar.shoppingID integerValue] == [self.shopID integerValue]) {
                    flag = NO;
                    break;
                }
            }
            if (flag == NO) {
                DLog(@"购物车里已有该商品");
                kTipAlert(@"购物车里已有该商品");
            } else {
                ShopCarModel *shopCarModel = [[ShopCarModel alloc] init];
                shopCarModel.ID = [self.shopID integerValue];
                shopCarModel.shoppingID = self.shopID;
                shopCarModel.shopCarTitle = marketDetailModel.name;
                shopCarModel.shopCarPrice = marketDetailModel.price;
                shopCarModel.shopCarColor = selectColorString;
                shopCarModel.shopCarNumber = [NSString stringWithFormat:@"%ld", numberView.timeAmount];
                if (marketDetailModel.photoArray.count == 0) {
                    shopCarModel.photoUrl = @"默认图片";
                } else {
                    shopCarModel.photoUrl = marketDetailModel.photoArray[0];
                }
                [dataBaseHandle addShoppingCar:shopCarModel];
                selectString = [NSString stringWithFormat:@"已选“颜色：%@” “数量：%ld”", selectColorString, numberView.timeAmount];
                selectAmount = numberView.timeAmount;
                kTipAlert(@"加入购物车成功");
                [backGroundView removeFromSuperview];
                [popView removeFromSuperview];
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                [self.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        }
    } else if (button.tag == 1001) {
        if (selectFlag == YES) {
            DLog(@"请选择颜色");
            kTipAlert(@"请选择颜色");
        } else {
            //立即购买
            DLog(@"^^^^^%@, %@", [NSString stringWithFormat:@"%ld", selectAmount], selectColorString)
            NSDictionary *myDic = @{@"amount":[NSString stringWithFormat:@"%ld", numberView.timeAmount], @"category":selectColorString};
            NSMutableDictionary *buyGoodsDic = [NSMutableDictionary dictionaryWithCapacity:0];
            [buyGoodsDic setObject:myDic forKey:marketDetailModel.ID];
            
            DLog(@"**********%@", buyGoodsDic);
            ShoppingOrderController *shopOrderVC = [[ShoppingOrderController alloc] init];
            shopOrderVC.goodsDic = buyGoodsDic;
            shopOrderVC.goodsID = self.shopID;
            shopOrderVC.goodsNumber = numberView.timeAmount;
            [self.navigationController pushViewController:shopOrderVC animated:YES];

        }
        
    } else if (button.tag == 1002) {
        //关闭弹窗
        if (selectFlag == YES) {
            selectString = [NSString stringWithFormat:@"已选“颜色未选” “数量：%ld”", numberView.timeAmount];
        } else {
            selectString = [NSString stringWithFormat:@"已选“颜色：%@” “数量：%ld”", selectColorString, numberView.timeAmount];
        }
        selectAmount = numberView.timeAmount;
        [backGroundView removeFromSuperview];
        [popView removeFromSuperview];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [self.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)creatCollectionView {
    //创建CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 15*kZGY;
    layout.minimumInteritemSpacing = 5*kZGY;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(20*kZGY, 50*kZGY, popView.frame.size.width - 40*kZGY, 80*kZGY) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [popView addSubview:self.collectionView];
    
    [self.collectionView registerClass:[ColorSelectCell class] forCellWithReuseIdentifier:popViewCellIdentifier];
}
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.colorSelectArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ColorSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:popViewCellIdentifier forIndexPath:indexPath];
    SelectColorModel *selectModel = self.colorSelectArray[indexPath.row];
    cell.colorTitle.text = selectModel.colorText;
    cell.colorTitle.frame = CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height);
    if (selectModel.isSelect == NO) {
        cell.colorTitle.backgroundColor = [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0];
        cell.colorTitle.textColor = [UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
    } else {
        cell.colorTitle.backgroundColor = [UIColor colorWithRed:72.0/255.0 green:126.0/255.0 blue:207.0/255.0 alpha:1.0];
        cell.colorTitle.textColor = [UIColor whiteColor];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectColorModel *selectModel = self.colorSelectArray[indexPath.row];
    CGSize size = [Tools getSize:selectModel.colorText andFontOfSize:12*kZGY];
    return CGSizeMake(size.width + 20*kZGY, 25*kZGY);
}
//分区边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5*kZGY, 0*kZGY, 5*kZGY, 0*kZGY);
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"dicsp^^^^^^^^^^^^");
    SelectColorModel *selectModel = self.colorSelectArray[indexPath.row];
    if (selectModel.isSelect == YES) {
        selectModel.isSelect = NO;
    } else {
        selectModel.isSelect = YES;
    }
    for (int i = 0; i < self.colorSelectArray.count; i++) {
        if (i != indexPath.row) {
            SelectColorModel *select = self.colorSelectArray[i];
            select.isSelect = NO;
        }
    }
    [self.collectionView reloadData];
}

#pragma mark - 底部一栏

- (void)creatBottomView {
    UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - 50, kScreenW, 50)];
    bigView.layer.borderWidth = 0.3;
    bigView.layer.borderColor = kLineGrayCorlor.CGColor;
    bigView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bigView];
    NSArray *titleArray = @[@"加入购物车", @"立即购买"];
    for (int i = 0; i < 2; i++) {
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = CGRectMake(i*kScreenW/2, 0, kScreenW/2, 50);
        myButton.tag = 222 + i;
        [myButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [myButton setTitleColor:[UIColor colorWithRed:253.0/255.0 green:106.0/255.0 blue:9.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [myButton addTarget:self action:@selector(actionOfBuy:) forControlEvents:UIControlEventTouchUpInside];
        [bigView addSubview:myButton];
    }
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(kScreenW/2, 0, 0.3, 50);
    line.backgroundColor = kLineGrayCorlor.CGColor;
    [bigView.layer addSublayer:line];
}


- (void)actionOfBuy:(UIButton *)button {
    BOOL selectFlag = YES;
    for (int i = 0; i < self.colorSelectArray.count; i++) {
        SelectColorModel *selectColor = self.colorSelectArray[i];
        if (selectColor.isSelect == YES) {
            selectColorString = selectColor.colorText;
            selectFlag = NO;
            break;
        }
    }
    if (selectFlag == YES) {
        DLog(@"请选择颜色");
        kTipAlert(@"请选择颜色");
        
    } else {
    if (button.tag == 222) {
        DLog(@"底部 + 加入购物车");
        //加入购物车
        DataBaseHandle *dataBaseHandle = [DataBaseHandle mainDataBaseHandle];
        [dataBaseHandle searchAllShoppingCar];
        BOOL flag = YES;
        for (ShopCarModel *shopCar in dataBaseHandle.shoppingCarArray) {
            if ([shopCar.shoppingID integerValue] == [self.shopID integerValue]) {
                flag = NO;
                break;
            }
        }
        if (flag == NO) {
            DLog(@"购物车里已有该商品");
            kTipAlert(@"购物车里已有该商品");
        } else {
            ShopCarModel *shopCarModel = [[ShopCarModel alloc] init];
            shopCarModel.ID = [self.shopID integerValue];
            shopCarModel.shoppingID = self.shopID;
            shopCarModel.shopCarTitle = marketDetailModel.name;
            shopCarModel.shopCarPrice = marketDetailModel.price;
            if (marketDetailModel.photoArray.count == 0) {
                shopCarModel.photoUrl = @"默认图片";
            } else {
                shopCarModel.photoUrl = marketDetailModel.photoArray[0];
            }

            shopCarModel.shopCarColor = selectColorString;
            shopCarModel.shopCarNumber = [NSString stringWithFormat:@"%ld", numberView.timeAmount];
            DLog(@"^^^^^^^^^^^^%ld", marketDetailModel.photoArray.count);
            
            [dataBaseHandle addShoppingCar:shopCarModel];

            kTipAlert(@"加入购物车成功");
        }

        } else if (button.tag == 223){
        DLog(@"底部 + 立即购买");
            NSDictionary *myDic = @{@"amount":[NSString stringWithFormat:@"%ld", selectAmount], @"category":selectColorString};
            NSMutableDictionary *buyGoodsDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:marketDetailModel.ID, @"address", nil];
            [buyGoodsDic setObject:myDic forKey:marketDetailModel.ID];
            
            DLog(@"**********%@", buyGoodsDic);
            ShoppingOrderController *shopOrderVC = [[ShoppingOrderController alloc] init];
            shopOrderVC.goodsDic = buyGoodsDic;
            shopOrderVC.goodsID = self.shopID;
            shopOrderVC.goodsNumber = selectAmount;
            [self.navigationController pushViewController:shopOrderVC animated:YES];
        }
    }
}
- (NSAttributedString *)changeFontAndColorWithString:(NSString *)myString andRange:(NSInteger)myRange {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:myString];
    //设置颜色
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(myRange, myString.length - myRange)]; // 0为起始位置 length是从起始位置开始 设置指定颜色的长度
    
    //设置尺寸
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18] range:NSMakeRange(myRange + 2, myString.length - 5 - myRange)]; // 0为起始位置 length是从起始位置开始 设置指定字体尺寸的长度
    
    return attributedString;
}
- (NSAttributedString *)underlineWithString:(NSString *)labelStr {
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName :[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:labelStr attributes:attribtDic];
    [attribtStr addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:83.0/255.0 green:83.0/255.0 blue:83.0/255.0 alpha:1.0] range: NSMakeRange(0, labelStr.length)];
    return attribtStr;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

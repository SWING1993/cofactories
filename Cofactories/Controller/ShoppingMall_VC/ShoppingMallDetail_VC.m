//
//  ShoppingMallDetail_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/1/27.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "ShoppingMallDetail_VC.h"
#import "MaterialShopDetailCell.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "MaterialAbstractCell.h"
#import "ZGYSelectNumberView.h"
#import "ColorSelectCell.h"
#import "SelectColorModel.h"
#import "ShopCarModel.h"
#import "ShoppingOrderController.h"
#import "FabricMarketModel.h"
#import "MallSelectAddress_VC.h"

#define kPoptime 0.4f
#define kImageViewHeight 0.94*kScreenW
#define kOrangeColor [UIColor colorWithRed:253.0/255.0 green:106.0/255.0 blue:9.0/255.0 alpha:1.0]

static NSString *shopCellIdentifier = @"shopCell";
static NSString *selectCellIdentifier = @"selectCell";
static NSString *abstractCellIdentifier = @"abstractCell";
static NSString *popViewCellIdentifier = @"popViewCell";
@interface ShoppingMallDetail_VC ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    UIScrollView  *_scrollView;
    UIView        *_headView;
    UIPageControl *pageControl;
    UIView        *backGroundView;
    UIView        *popView;
    ZGYSelectNumberView *numberView;
    NSString *selectString;
    NSString *selectColorString;//选择的分类
    FabricMarketModel *marketDetailModel;
//    NSMutableArray *shoppingCarArray;
}
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *colorSelectArray;

@end

@implementation ShoppingMallDetail_VC
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
        selectString = [NSString stringWithFormat:@"已选“颜色：%@” “数量：%ld”", self.myColorString, self.myAmount];
    } else {
        self.myAmount = 1;
        selectString = @"请选择商品分类";
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

- (void)creatTableView {
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, kScreenW, kScreenH - 30)];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
            [self creatPopSelectView];
            DLog(@"%@", marketDetailModel);
            [self.myTableView reloadData];
        } else {
            kTipAlert(@"该商品已被下架");
        }
    }];
}
#pragma mark - 弹出的筛选视图
- (void)creatPopView {
    UIButton *cancleButton = [UIButton buttonWithType:UIButtonTypeCustom]
    ;
    cancleButton.frame = CGRectMake(popView.frame.size.width - 40*kZGY, 10*kZGY, 30*kZGY, 30*kZGY);
    cancleButton.tag = 1002;
    [cancleButton addTarget:self action:@selector(actionOfPopBuy:) forControlEvents:UIControlEventTouchUpInside];
    [cancleButton setImage:[UIImage imageNamed:@"Home-叉号"] forState:UIControlStateNormal];
    [popView addSubview:cancleButton];
    
    UILabel *title1 = [[UILabel alloc] initWithFrame:CGRectMake(20*kZGY, 20*kZGY, popView.frame.size.width - 40*kZGY, 25*kZGY)];
    title1.font = [UIFont systemFontOfSize:15*kZGY];
    title1.text = @"商品分类";
    [popView addSubview:title1];
    UILabel *title2 = [[UILabel alloc] initWithFrame:CGRectMake(20*kZGY, 150*kZGY, 70*kZGY, 25*kZGY)];
    title2.font = [UIFont systemFontOfSize:15*kZGY];
    title2.text = @"购买数量";
    [popView addSubview:title2];
    
    //筛选价格
    numberView = [[ZGYSelectNumberView alloc] initWithFrame:CGRectMake(popView.frame.size.width - 30*kZGY - 125*kZGY, 150*kZGY, 125*kZGY, 25*kZGY) WithBeginAmount:self.myAmount leaveCount:[marketDetailModel.amount integerValue]];
    
    [popView addSubview:numberView];
    
    NSArray *btnArray = @[@"加入购物车", @"立即拍下"];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(20*kZGY + i*(20*kZGY + (popView.frame.size.width - 3*20*kZGY)/2), 200*kZGY, (popView.frame.size.width - 3*20*kZGY)/2, 35*kZGY);
        [button setTitle:btnArray[i] forState:UIControlStateNormal];
        button.layer.borderColor = kOrangeColor.CGColor;
        button.layer.borderWidth = 0.5;
        button.layer.cornerRadius = 5*kZGY;
        button.clipsToBounds = YES;
        [button setTitleColor:kOrangeColor forState:UIControlStateNormal];
        button.tag = 1000 + i;
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        [button addTarget:self action:@selector(actionOfPopBuy:) forControlEvents:UIControlEventTouchUpInside];
        [popView addSubview:button];
    }
}

#pragma mark - 选择框
- (void)creatPopSelectView {
    backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
    backGroundView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:backGroundView];
    popView = [[UIView alloc] initWithFrame:CGRectMake(20*kZGY, 350*kZGY, kScreenW - 40*kZGY, 270*kZGY)];
    popView.layer.anchorPoint = CGPointMake(0.5, 1);
    popView.backgroundColor = [UIColor whiteColor];
    popView.layer.cornerRadius = 8*kZGY;
    popView.clipsToBounds = YES;
    [self.view addSubview:popView];
    
    [self creatPopView];
    [self creatCollectionView];
    popView.hidden = YES;
    backGroundView.alpha = 0;
}

//选择视图隐藏或出现
- (void)popViewShow:(BOOL)show {
    
    if (show) {
        popView.hidden = NO;
        popView.transform = CGAffineTransformMakeScale(0.1f, 0.01f);
        //设置动画时间为0.25秒,xy方向缩放的最终值为1
        [UIView animateWithDuration:kPoptime animations:^{
            popView.transform=CGAffineTransformMakeScale(1.0f, 1.0f);
            backGroundView.alpha = 0.4;
        }];
        
    } else {
        popView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        //设置动画时间为0.25秒,xy方向缩放的最终值为1
        [UIView animateWithDuration:kPoptime animations:^{
            popView.transform=CGAffineTransformMakeScale(0.00001f, 0.00001f);
            backGroundView.alpha = 0;
        }];
        
    }
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

#pragma mark - 底部一栏

- (void)creatBottomView {
    UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - 50, kScreenW, 50)];
    bigView.layer.borderWidth = 0.3;
    bigView.layer.borderColor = kLineGrayCorlor.CGColor;
    bigView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bigView];
    NSArray *titleArray = @[@"加入购物车", @"立即拍下"];
    for (int i = 0; i < 2; i++) {
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = CGRectMake(i*kScreenW/2, 0, kScreenW/2, 50);
        myButton.tag = 222 + i;
        [myButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [myButton setTitleColor:kOrangeColor forState:UIControlStateNormal];
        [myButton addTarget:self action:@selector(actionOfBuy:) forControlEvents:UIControlEventTouchUpInside];
        [bigView addSubview:myButton];
    }
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(kScreenW/2, 0, 0.3, 50);
    line.backgroundColor = kLineGrayCorlor.CGColor;
    [bigView.layer addSublayer:line];
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
        cell.salePriceLabel.attributedText = [self changeFontAndColorWithString:[NSString stringWithFormat:@"售价￥ %@", marketDetailModel.price] andRange:2];
        
        cell.marketPriceLeftLabel.text = @"市场价";
        CGSize size = [Tools getSize:[NSString stringWithFormat:@" %@ ", marketDetailModel.marketPrice] andFontOfSize:13];
        cell.marketPriceRightLabel.frame = CGRectMake(CGRectGetMaxX(cell.marketPriceLeftLabel.frame), CGRectGetMaxY(cell.salePriceLabel.frame), size.width, 30*kZGY);
        
        cell.marketPriceRightLabel.attributedText = [self underlineWithString:[NSString stringWithFormat:@" %@ ", marketDetailModel.marketPrice]];
        cell.leaveCountLabel.frame = CGRectMake(CGRectGetMaxX(cell.marketPriceRightLabel.frame) + 10*kZGY, CGRectGetMaxY(cell.salePriceLabel.frame), kScreenW - 30*kZGY - CGRectGetWidth(cell.marketPriceLeftLabel.frame) - CGRectGetWidth(cell.marketPriceRightLabel.frame), 30*kZGY);
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
        return 110*kZGY;
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
        return 0;
    }
    return 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        [self popViewShow:YES];
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
        cell.backgroundColor = GRAYCOLOR(242.0);
        cell.colorTitle.textColor = GRAYCOLOR(38.0);
    } else {
        cell.backgroundColor = [UIColor colorWithRed:72.0/255.0 green:126.0/255.0 blue:207.0/255.0 alpha:1.0];
        cell.colorTitle.textColor = [UIColor whiteColor];
    }
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectColorModel *selectModel = self.colorSelectArray[indexPath.row];
    CGSize size = [Tools getSize:selectModel.colorText andFontOfSize:13*kZGY];
    return CGSizeMake(size.width + 20*kZGY, 28*kZGY);
}
//分区边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5*kZGY, 0*kZGY, 5*kZGY, 0*kZGY);
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
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

#pragma mark - Action

//弹窗加入购物车和立即购买
- (void)actionOfPopBuy:(UIButton *)button {
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
    if (button.tag == 1000) {
        if (selectFlag) {
            kTipAlert(@"请选择商品分类");
        } else {
            //加入购物车
            [self storeGoodsToShoppingCar];
            selectString = [NSString stringWithFormat:@"已选“分类：%@” “数量：%ld”", selectColorString, numberView.timeAmount];
            [self popViewShow:NO];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, kPoptime * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
                NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
                [self.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
                kTipAlert(@"加入购物车成功");
            });
        }
    } else if (button.tag == 1001) {
        if (selectFlag) {
            kTipAlert(@"请选择商品分类");
        } else {
            //立即拍下
            selectString = [NSString stringWithFormat:@"已选“分类：%@” “数量：%ld”", selectColorString, numberView.timeAmount];
            [self popViewShow:NO];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [self.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            [self goToBuy];
        }
        
    } else if (button.tag == 1002) {
        //关闭弹窗
        if (selectFlag) {
            selectString = [NSString stringWithFormat:@"已选“分类未选” “数量：%ld”", numberView.timeAmount];
        } else {
            selectString = [NSString stringWithFormat:@"已选“分类：%@” “数量：%ld”", selectColorString, numberView.timeAmount];
        }
        [self popViewShow:NO];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [self.myTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

//底部加入购物车和立即拍下
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
    if (selectFlag) {
        [self popViewShow:YES];
        
    } else {
        if (button.tag == 222) {
            //加入购物车
            [self storeGoodsToShoppingCar];
            kTipAlert(@"加入购物车成功");
            
        } else if (button.tag == 223){
            //立即拍下
            [self goToBuy];
        }
    }
}
- (void)goToBuy {
    //立即拍下
    if ([marketDetailModel.amount integerValue] == 0) {
        kTipAlert(@"商品已售完，暂不能购买");
    } else {
        NSDictionary *myDic = @{@"amount":[NSString stringWithFormat:@"%ld", numberView.timeAmount], @"category":selectColorString};
        NSMutableDictionary *buyGoodsDic = [NSMutableDictionary dictionaryWithCapacity:0];
        [buyGoodsDic setObject:myDic forKey:marketDetailModel.ID];
        
        //    ShoppingOrderController *shopOrderVC = [[ShoppingOrderController alloc] init];
        //    shopOrderVC.goodsDic = buyGoodsDic;
        //    shopOrderVC.goodsID = self.shopID;
        //    shopOrderVC.goodsNumber = numberView.timeAmount;
        //    [self.navigationController pushViewController:shopOrderVC animated:YES];
        MallSelectAddress_VC *selectAddressVC = [[MallSelectAddress_VC alloc] init];
        [self.navigationController pushViewController:selectAddressVC animated:YES];
    }
}

- (void)storeGoodsToShoppingCar {
    //加入购物车
    UserModel * MyProfile = [[UserModel alloc]getMyProfile];
    NSString *storeKey = [NSString stringWithFormat:@"ShoppingCarArray%@", MyProfile.uid];
    //获取已经存储的数据
    NSMutableArray *shoppingCarArray = [NSMutableArray arrayWithCapacity:0];
    if ([[[StoreUserValue sharedInstance] valueWithKey:storeKey] count] > 0) {
        shoppingCarArray = [[StoreUserValue sharedInstance] valueWithKey:storeKey];
    }
    BOOL flag = YES;
    for (ShopCarModel *shopCar in shoppingCarArray) {
        if ([shopCar.shoppingID integerValue] == [self.shopID integerValue]) {
            flag = NO;
            break;
        }
    }
    if (flag) {
        //如果本地没有，则存入本地
        ShopCarModel *shopCarModel = [[ShopCarModel alloc] init];
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
        [shoppingCarArray addObject:shopCarModel];
        [[StoreUserValue sharedInstance] storeValue:shoppingCarArray withKey:storeKey];
    }
}

- (NSAttributedString *)changeFontAndColorWithString:(NSString *)myString andRange:(NSInteger)myRange {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:myString];
    //设置颜色
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:251.0/255.0 green:56.0/255.0 blue:10.0/255.0 alpha:1.0] range:NSMakeRange(myRange, myString.length - myRange)]; // 0为起始位置 length是从起始位置开始 设置指定颜色的长度
    
    //设置尺寸
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(myRange + 2, myString.length - 5 - myRange)]; // 0为起始位置 length是从起始位置开始 设置指定字体尺寸的长度
    return attributedString;
}

- (NSAttributedString *)underlineWithString:(NSString *)labelStr {
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName :[NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:labelStr attributes:attribtDic];
    [attribtStr addAttribute: NSForegroundColorAttributeName value: GRAYCOLOR(135.0) range: NSMakeRange(0, labelStr.length)];
    return attribtStr;
}

- (void)pressCancleButton{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

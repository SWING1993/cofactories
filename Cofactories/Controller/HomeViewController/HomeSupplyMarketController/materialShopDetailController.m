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

static NSString *shopCellIdentifier = @"shopCell";
static NSString *selectCellIdentifier = @"selectCell";
static NSString *abstractCellIdentifier = @"abstractCell";
static NSString *popViewCellIdentifier = @"popViewCell";
@interface materialShopDetailController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    UIScrollView  *_scrollView;
    UIView        *_headView;
    UIPageControl *pageControl;
    NSString      *string;
    UIView        *backGroundView;
    UIView        *popView;
    ZGYSelectNumberView *numberView;
    NSArray *selectArray;
    NSString *selectString;
    NSString *selectColorString;
}
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *photoArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *colorSelectArray;
@end

@implementation materialShopDetailController
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoArray = @[@"男装新潮流", @"服装平台", @"童装设计潮流趋势", @"女装新潮流"];
    selectArray = @[@"蓝色x半米", @"白色x半米", @"棕色x半米", @"绿色x半米", @"黑色x半米"];
    selectString = @"请选择颜色分类";
    self.colorSelectArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < selectArray.count; i++) {
        SelectColorModel *selectModel = [[SelectColorModel alloc] init];
        selectModel.colorText = selectArray[i];
        selectModel.isSelect = NO;
        [self.colorSelectArray addObject:selectModel];
    }
    DLog(@"^^^^^^^^^^^^^^%@", self.colorSelectArray);
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
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 顶部图片
- (void)creatScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH)/2.0-80)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    [_headView addSubview:_scrollView];
    
    _scrollView.contentSize = CGSizeMake(kScreenW * self.photoArray.count, (kScreenH)/2.0-80);
    for (int i = 0; i < self.photoArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,self.photoArray[i]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@""]];
        [button setImage:[UIImage imageNamed:self.photoArray[i]] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(i * kScreenW, 0, kScreenW, (kScreenH)/2.0-80)];
        [button addTarget:self action:@selector(MJPhotoBrowserClick:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [_scrollView addSubview:button];
        
    }
    pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(_scrollView.frame) - 40, kScreenW - 40, 40)];
//    pageControl.backgroundColor = [UIColor blackColor];
    pageControl.numberOfPages = self.photoArray.count;
    [pageControl addTarget:self action:@selector(changePage) forControlEvents:UIControlEventValueChanged];
    [_headView addSubview:pageControl];
}
//代理要实现的方法: 切换页面后, 下面的页码控制器也跟着变化
- (void)scrollViewDidEndDecelerating:(UIScrollView *)aScrollView {
    pageControl.currentPage = _scrollView.contentOffset.x / 375;
}

- (void)changePage {
    [_scrollView setContentOffset:CGPointMake(pageControl.currentPage * 375, 0) animated:YES];
}

- (void)MJPhotoBrowserClick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[self.photoArray count]];
    [self.photoArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,self.photoArray[idx]]];
        [photos addObject:photo];
    }];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = button.tag;
    browser.photos = photos;
    [browser show];
    
}


#pragma mark - 商品详情
- (void)creatTableView {
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, kScreenW, kScreenH - 30)];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    [self.view addSubview:self.myTableView];
    [self.myTableView registerClass:[MaterialShopDetailCell class] forCellReuseIdentifier:shopCellIdentifier];
    [self.myTableView registerClass:[MaterialAbstractCell class] forCellReuseIdentifier:abstractCellIdentifier];
    [self.myTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:selectCellIdentifier];
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH)/2.0-80)];
    self.myTableView.tableHeaderView = _headView;
    
    if (self.photoArray.count == 0) {
        UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:_headView.frame];
        bgImageView.image = [UIImage imageNamed:@"没有上传图片"];
        [_headView addSubview:bgImageView];
        
    }else{
        [self creatScrollView];
    }

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
        cell.materialLabel.text = @"太空棉布料面料";
        cell.priceLeftLabel.text = @"售价 ￥ 39.50";
        cell.priceRightLabel.text = @"￥ 36.5";
        cell.stylePhoto.image = [UIImage imageNamed:@"企业用户"];
        cell.marketPriceLeftLabel.text = @"市场价";
        cell.marketPriceRightLabel.text = @"￥ 69";
        cell.leaveCountLabel.text = @"库存 1000 件";
        
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
        string = @"针织物与梭织物区别 针织物与梭织物由于在编织上方法各异，在加工工艺上，布面结构上，织物特性上，成品用途上，都有自己独特的特色，在此作一些比较。 (一) 织物组织的构成： (1) 针织物：是由纱线顺序弯曲成线圈，而线圈相互串套而形成织物，而纱线形成线圈的过程，可以横向或纵向地进行，横向编织称为纬编织物，而纵向编织称为经编织物。 (2) 梭织物：是由两条或两组以上的相互垂直纱线，以90度角作经纬交织而成织物，纵向的纱线叫经纱，横向的纱线叫纬纱。(二) 织物组织基本单元： (1) 针织物：线圈就是针织物的最小基本单元，而线圈由圈干和延展线呈一空间曲线所组成。 (2) 梭织物：经纱和纬纱之间的每一个相交点称为组织点，是梭织物的最小基本单元。(三) 织物组织特性： (1) 针织物：因线圈是纱线在空间弯曲而成，而每个线圈均由一根纱线组成，当针织物受外来张力，如纵向拉伸时，线圈的弯曲发生变化，而线圈的高度亦增加，同时线圈的宽度却减少，如张力是横向拉伸，情况则相反，线圈的高度和宽度在不同张力条件下，明显是可以互相转换的，因此针织物的延伸性大。 (2) 梭织物：因经纱与纬纱交织的地方有些弯曲，而且袛在垂直于织物平面的方向内弯曲，其弯曲程度和经纬纱之间的相互张力，以及纱线刚度有关，当梭织物受外来张力，如以纵向拉伸时，经纱的张力增加，弯曲则减少，而纬纱的弯曲增加，如纵向拉伸不停，直至经纱完全伸直为止，同时织物呈横向收缩。当梭织物受外来张力以横向拉伸时，纬纱的张力增加，弯曲则减少，而经纱弯曲增加，如横向拉伸不停，直至纬纱完全伸直为止，同时织物呈纵向收缩。而经，纬纱不会发生转换，与针织物不同。(四) 织物组织的特征： (1) 针织物：能在各个方向延伸，弹性好，因针织物是由孔状线圈形成，有较大的透气性能，手感松软。 (2) 梭织物：因梭织物经，纬纱延伸与收缩关系不大，亦不发生转换，因此织物一般比较紧密，挺硬。(五) 织物组织的物理机械性： (1) 针织物：织物的物理机械性，包括纵密、横密、平方米克重、延伸性能、弹性、断裂强度、耐磨性、卷边性、厚度、脱散性、收缩性、覆盖性、体积密度。 (2) 梭织物：梭织物的物理机械性，包括经纱与纬纱的纱线密度、布边、正面和反面、顺逆毛方向、织物覆盖度。";
        CGSize size = [Tools getSize:string andFontOfSize:13 andWidthMake:kScreenW - 60];
        cell.AbstractDetailLabel.frame = CGRectMake(30, 45, kScreenW - 60, size.height);
        cell.AbstractDetailLabel.text = string;
        
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
        CGSize size = [Tools getSize:string andFontOfSize:13 andWidthMake:kScreenW - 60];
        
        return size.height + 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return 0.5;
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
    numberView = [[ZGYSelectNumberView alloc] initWithFrame:CGRectMake(popView.frame.size.width - 30*kZGY - 125*kZGY, 150*kZGY, 125*kZGY, 25*kZGY)];
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
//        if (i == 0) {
//            button.backgroundColor = [UIColor colorWithRed:193.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0];
//        } else {
//            button.backgroundColor = [UIColor colorWithRed:72.0/255.0 green:126.0/255.0 blue:207.0/255.0 alpha:1.0];
//        }
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
            BOOL flag = YES;
            for (ShopCarModel *shopCar in dataBaseHandle.shoppingCarArray) {
                if (shopCar.ID == 22) {
                    flag = NO;
                    break;
                }
            }
            if (flag == NO) {
                DLog(@"购物车里已有该商品");
                kTipAlert(@"购物车里已有该商品");
            } else {
                ShopCarModel *shopCarModel = [[ShopCarModel alloc] init];
                [dataBaseHandle searchAllShoppingCar];
                shopCarModel.ID = 22;
                shopCarModel.shoppingID = @"22";
                shopCarModel.shopCarTitle = @"22棉麻布料";
                shopCarModel.shopCarPrice = @"122";
                shopCarModel.shopCarColor = selectColorString;
                shopCarModel.shopCarNumber = [NSString stringWithFormat:@"%ld", numberView.timeAmount];
                shopCarModel.photoUrl = @"www22";
                [dataBaseHandle addShoppingCar:shopCarModel];
                selectString = [NSString stringWithFormat:@"已选“颜色：%@” “数量：%ld”", selectColorString, numberView.timeAmount];
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
            DLog(@"*********%ld", numberView.timeAmount);
            ShoppingOrderController *shopOrderVC = [[ShoppingOrderController alloc] init];
            [self.navigationController pushViewController:shopOrderVC animated:YES];

        }
        
    } else if (button.tag == 1002) {
        //关闭弹窗
        if (selectFlag == YES) {
            selectString = [NSString stringWithFormat:@"已选“颜色未选” “数量：%ld”", numberView.timeAmount];
        } else {
            selectString = [NSString stringWithFormat:@"已选“颜色：%@” “数量：%ld”", selectColorString, numberView.timeAmount];
        }
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
    layout.minimumInteritemSpacing = 0;
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
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kScreenW/2, 0, 0.3, 50)];
    lineView.backgroundColor = kLineGrayCorlor;
    [bigView addSubview:lineView];
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
        
            ShopCarController *shopCarVC = [[ShopCarController alloc] init];
            [self.navigationController pushViewController:shopCarVC animated:YES];
        } else if (button.tag == 223){
        DLog(@"底部 + 立即购买");
        ShoppingOrderController *shoppingVC = [[ShoppingOrderController alloc] init];
        [self.navigationController pushViewController:shoppingVC animated:YES];
        
    }
    }
    
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

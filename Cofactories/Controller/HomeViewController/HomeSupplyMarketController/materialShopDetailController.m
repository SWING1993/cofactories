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

static NSString *shopCellIdentifier = @"shopCell";
static NSString *abstractCellIdentifier = @"abstractCell";
@interface materialShopDetailController ()<UITableViewDataSource, UITableViewDelegate> {
    UIScrollView  *_scrollView;
    UIView        *_headView;
}
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSArray *photoArray;
@end

@implementation materialShopDetailController
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.photoArray = @[@"男装新潮流", @"服装平台", @"童装设计潮流趋势", @"女装新潮流"];
    [self creatTableView];
    [self creatGobackButton];
    [self creatBottomView];

}

- (void)creatBottomView {
    UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - 44, kScreenW, 44)];
    bigView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bigView];
    NSArray *titleArray = @[@"加入购物车", @"立即购买"];
    for (int i = 0; i < 2; i++) {
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myButton.frame = CGRectMake(i*kScreenW/2, 0, kScreenW/2, 44);
        myButton.tag = 222 + i;
        [myButton setTitle:titleArray[i] forState:UIControlStateNormal];
        [myButton setTitleColor:[UIColor colorWithRed:253.0/255.0 green:106.0/255.0 blue:9.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [myButton addTarget:self action:@selector(actionOfBuy:) forControlEvents:UIControlEventTouchUpInside];
        [bigView addSubview:myButton];
    }
}

- (void)actionOfBuy:(UIButton *)button {
    if (button.tag == 222) {
        DLog(@"加入购物车");
    } else if (button.tag == 223){
        DLog(@"立即购买");
    }
}
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

- (void)creatScrollView{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, (kScreenH)/2.0-80)];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
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

- (void)creatTableView {
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -20, kScreenW, kScreenH + 20)];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
    [self.view addSubview:self.myTableView];
    [self.myTableView registerClass:[MaterialShopDetailCell class] forCellReuseIdentifier:shopCellIdentifier];
    [self.myTableView registerClass:[MaterialAbstractCell class] forCellReuseIdentifier:abstractCellIdentifier];
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
        
        cell.materialLabel.text = @"太空棉布料面料";
        cell.priceLeftLabel.text = @"售价 ￥ 39.50";
        cell.priceRightLabel.text = @"￥ 36.5";
        cell.stylePhoto.image = [UIImage imageNamed:@"企业用户"];
        cell.marketPriceLeftLabel.text = @"市场价";
        cell.marketPriceRightLabel.text = @"￥ 69";
        cell.leaveCountLabel.text = @"库存 1000 件";
        
        return cell;
  
    } else if (indexPath.section == 1){
        UITableViewCell*cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        }
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.text = @"请选择颜色分类";
        cell.textLabel.textColor = [UIColor colorWithRed:38.0/255.0 green:38.0/255.0 blue:38.0/255.0 alpha:1.0];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        return cell;
    } else {
        MaterialAbstractCell *cell = [tableView dequeueReusableCellWithIdentifier:abstractCellIdentifier forIndexPath:indexPath];
        
        cell.AbstractTitleLabel.text = @"商品简介：";
        cell.AbstractDetailLabel.text = @"针织物与梭织物区别 针织物与梭织物由于在编织上方法各异，在加工工艺上，布面结构上，织物特性上，成品用途上，都有自己独特的特色，在此作一些比较。 (一) 织物组织的构成： (1) 针织物：是由纱线顺序弯曲成线圈，而线圈相互串套而形成织物，而纱线形成线圈的过程，可以横向或纵向地进行，横向编织称为纬编织物，而纵向编织称为经编织物。 (2) 梭织物：是由两条或两组以上的相互垂直纱线，以90度角作经纬交织而成织物，纵向的纱线叫经纱，横向的纱线叫纬纱。(二) 织物组织基本单元： (1) 针织物：线圈就是针织物的最小基本单元，而线圈由圈干和延展线呈一空间曲线所组成。 (2) 梭织物：经纱和纬纱之间的每一个相交点称为组织点，是梭织物的最小基本单元。(三) 织物组织特性： (1) 针织物：因线圈是纱线在空间弯曲而成，而每个线圈均由一根纱线组成，当针织物受外来张力，如纵向拉伸时，线圈的弯曲发生变化，而线圈的高度亦增加，同时线圈的宽度却减少，如张力是横向拉伸，情况则相反，线圈的高度和宽度在不同张力条件下，明显是可以互相转换的，因此针织物的延伸性大。 (2) 梭织物：因经纱与纬纱交织的地方有些弯曲，而且袛在垂直于织物平面的方向内弯曲，其弯曲程度和经纬纱之间的相互张力，以及纱线刚度有关，当梭织物受外来张力，如以纵向拉伸时，经纱的张力增加，弯曲则减少，而纬纱的弯曲增加，如纵向拉伸不停，直至经纱完全伸直为止，同时织物呈横向收缩。当梭织物受外来张力以横向拉伸时，纬纱的张力增加，弯曲则减少，而经纱弯曲增加，如横向拉伸不停，直至纬纱完全伸直为止，同时织物呈纵向收缩。而经，纬纱不会发生转换，与针织物不同。(四) 织物组织的特征： (1) 针织物：能在各个方向延伸，弹性好，因针织物是由孔状线圈形成，有较大的透气性能，手感松软。 (2) 梭织物：因梭织物经，纬纱延伸与收缩关系不大，亦不发生转换，因此织物一般比较紧密，挺硬。(五) 织物组织的物理机械性： (1) 针织物：织物的物理机械性，包括纵密、横密、平方米克重、延伸性能、弹性、断裂强度、耐磨性、卷边性、厚度、脱散性、收缩性、覆盖性、体积密度。 (2) 梭织物：梭织物的物理机械性，包括经纱与纬纱的纱线密度、布边、正面和反面、顺逆毛方向、织物覆盖度。";
        
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
        return 550;
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

//
//  materialShopViewController.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/4.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "materialShopViewController.h"
#import "ZGYSelectView.h"
#import "MaterialShopCell.h"
#import "materialShopDetailController.h"

#define kSearchFrameLong CGRectMake(50, 30, kScreenW-50, 25)
#define kSearchFrameShort CGRectMake(50, 30, kScreenW-100, 25)
static NSString *materialCellIdentifier = @"materialCell";
@interface materialShopViewController ()<UISearchBarDelegate, ZGYSelectViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> {
    ZGYSelectView* selectView;
    UISearchBar *_searchBar;
    UIView *bigView;
}
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation materialShopViewController

- (void)viewWillAppear:(BOOL)animated {
    [self creatSearchBar];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:65.0f/255.0f green:145.0f/255.0f blue:228.0f/255.0f alpha:1.0f];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setHidden:NO];
}
-(void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
//    [self creatSearchBar];
    [self creatCancleItem];
    [self creatCollectionView];
    [self creatSelectView];

}

- (void)creatCollectionView {
    //创建CollectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 4;
    layout.minimumInteritemSpacing = 4;
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, kScreenW, kScreenH - 45) collectionViewLayout:layout];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.backgroundColor = kBackgroundColor;
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerClass:[MaterialShopCell class] forCellWithReuseIdentifier:materialCellIdentifier];
}

- (void)creatSelectView {
    
    switch (self.number) {
        case 1: {
            NSArray *levelArray = @[@"全部面料", @"针织", @"梭织", @"特种面料"];
            NSArray *classArray = @[@"不限地区", @"北京", @"上海", @"杭州", @"广州"];
            NSArray *placeArray = @[@"价格不限", @"从高到低", @"从低到高"];
            selectView = [[ZGYSelectView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 45) levelArray:levelArray classArray:classArray addressArray:placeArray title:@"全部面料" isTwo:NO];
        }
            break;
        case 2: {
            NSArray *levelArray = @[@"不限地区", @"北京", @"上海", @"杭州", @"广州"];
            NSArray *classArray = @[@"价格不限", @"从高到低", @"从低到高"];
            selectView = [[ZGYSelectView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 45) levelArray:levelArray classArray:classArray addressArray:nil title:@"不限地区" isTwo:YES];
        }
            break;
        case 3: {
            NSArray *levelArray = @[@"全部设备", @"机器设备", @"配件"];
            NSArray *classArray = @[@"不限地区", @"北京", @"上海", @"杭州", @"广州"];
            NSArray *placeArray = @[@"价格不限", @"从高到低", @"从低到高"];
            selectView = [[ZGYSelectView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 45) levelArray:levelArray classArray:classArray addressArray:placeArray title:@"全部设备" isTwo:NO];
        }
            break;
        default:
            break;
    }
    
    

    
    selectView.backgroundColor = [UIColor colorWithRed:0.973 green:0.973 blue:0.973 alpha:1];
    [[NSUserDefaults standardUserDefaults] setObject:@"全部面料" forKey:@"ZGYLevelType"];
    selectView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    selectView.layer.borderWidth = 0.5;
    selectView.delegate = self;
    [self.view addSubview:selectView];
}
- (void)creatCancleItem {
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"back"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
}
- (void)creatSearchBar{
    
    self.view.backgroundColor = [UIColor whiteColor];
    _searchBar = [[UISearchBar alloc] initWithFrame:kSearchFrameLong];
    _searchBar.delegate = self;
    [self.navigationController.view addSubview:_searchBar];
    [_searchBar setBackgroundImage:[[UIImage alloc] init] ];
    _searchBar.placeholder = @"请输入商品名称";
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 9;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MaterialShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:materialCellIdentifier forIndexPath:indexPath];
    cell.photoView.image = [UIImage imageNamed:@"4.jpg"];
    cell.materialTitle.text = @"纯棉纱布面料 原单特卖 非常好的面料";
    cell.priceLabel.text = @"￥ 59";
    cell.saleLabel.text = @"已售 999 件";
    cell.placeLabel.text = @"杭州";
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self removeSearchBar];
    materialShopDetailController *materialShopVC = [[materialShopDetailController alloc] init];
    [self.navigationController pushViewController:materialShopVC animated:YES];
}


#pragma mark - UICollectionViewDelegateFlowLayout
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(kScreenW/2 - 2 , kScreenW/2 + 100);
}
//分区边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}






#pragma mark - UISearchBarDelegate

//点击搜索框改变seachBar的大小，创建取消按钮，添加一层View
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    if (_searchBar.frame.size.width == kScreenW-50) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancleButtonClick)];
        _searchBar.frame = kSearchFrameShort;
        bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH)];
        bigView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        [self.view addSubview:bigView];
    }
}


//点击搜索出结果
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //搜索完移除view改变searchBar的大小
    [searchBar resignFirstResponder];
    [bigView removeFromSuperview];
    _searchBar.frame = kSearchFrameLong;
    //    self.searchArray = [NSMutableArray arrayWithCapacity:0];
    //    [HttpClient getInfomationWithKind:[NSString stringWithFormat:@"s=%@", searchBar.text] page:1 andBlock:^(NSDictionary *responseDictionary){
    //        NSArray *jsonArray = responseDictionary[@"responseArray"];
    //        for (NSDictionary *dictionary in jsonArray) {
    //            InformationModel *information = [[InformationModel alloc] initModelWith:dictionary];
    //
    //            [self.searchArray addObject:information];
    //        }
    //        if (self.searchArray.count == 0) {
    //            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"搜索结果为空" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    //            [alertView show];
    //
    //        } else {
    //            [self removeSearchBar];
    //            PMSearchViewController *PMSearchVC = [[PMSearchViewController alloc] init];
    //            //            PMSearchVC.searchArray = [NSMutableArray arrayWithArray:self.searchArray];
    //            PMSearchVC.searchText = searchBar.text;
    //            [self.navigationController pushViewController:PMSearchVC animated:YES];
    //        }
    //    }];
}


//点击键盘之外的View移除View
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![_searchBar isExclusiveTouch]) {
        [_searchBar resignFirstResponder];
        [bigView removeFromSuperview];
        _searchBar.frame = kSearchFrameLong;
    }
}

//点击取消收回键盘，移除View，改变seachBar的大小
- (void)cancleButtonClick {
    //收回键盘
    [_searchBar resignFirstResponder];
    [bigView removeFromSuperview];
    _searchBar.frame = kSearchFrameLong;
    
}

//返回时移除searchBar
- (void)back {
    [_searchBar removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}
//同时移除searchBar和View（在当前页面操作）
- (void)removeSearchBar {
    [_searchBar removeFromSuperview];
    [bigView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)selectView:(ZGYSelectView*)selectview selectAreaId:(NSString*)areaid andClassifyId:(NSString*)classifyid andRankId:(NSString*)rankId {
    NSLog(@"**************%@ %@ %@", areaid, classifyid, rankId);
    
}
- (void)selectView:(ZGYSelectView*)selectview selectTitle:(NSString*)currTitle {
    NSLog(@"**************%@", currTitle);
    
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

//
//  SupplyMarketViewController.m
//  Cofactories
//
//  Created by 赵广印 on 15/11/28.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "SupplyMarketViewController.h"
#import "ZGYSupplyMarketView.h"
#import "Business_Supplier_VC.h"
#import "FabricShop_VC.h"//面料商城
#import "AccessoryShop_VC.h"//辅料商城
#import "MachineShop_VC.h"//机械设备商城


@interface SupplyMarketViewController ()<UIScrollViewDelegate, ZGYSupplyMarketViewDelegate> {
    NSMutableArray *btnArray;
    UIView *selectLine;
    UIScrollView *myScrollView;
}

@end

@implementation SupplyMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"供应市场";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *temporaryBarButtonItem = [[UIBarButtonItem alloc] init];
    temporaryBarButtonItem.image = [UIImage imageNamed:@"back"];
    temporaryBarButtonItem.target = self;
    temporaryBarButtonItem.action = @selector(back);
    self.navigationItem.leftBarButtonItem = temporaryBarButtonItem;
    
    [self creatScrollView];
    [self creatSelectView];
}

- (void)creatSelectView {
    UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kScreenW, 44)];
    bigView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bigView];
    
    CALayer *line = [CALayer layer];
    line.frame = CGRectMake(0, 44 - 0.3, kScreenW, 0.3);
    line.backgroundColor = kLineGrayCorlor.CGColor;
    [bigView.layer addSublayer:line];
    
    selectLine = [[UIView alloc] initWithFrame:CGRectMake(kScreenW/8, 44 - 2.5, kScreenW/4, 2.5)];
    selectLine.backgroundColor = [UIColor colorWithRed:48.0f/255.0f green:121.0f/255.0f blue:214.0f/255.0f alpha:1.0f];
    [bigView addSubview:selectLine];
    btnArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *supplyArray = @[@"商家汇总", @"商品购买"];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*kScreenW/2, 0, kScreenW/2, 44);
        button.tag = 222 + i;
        [button setTitle:supplyArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:48.0f/255.0f green:121.0f/255.0f blue:214.0f/255.0f alpha:1.0f] forState:UIControlStateSelected]
        ;
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(actionOfSelect:) forControlEvents:UIControlEventTouchUpInside];
        [bigView addSubview:button];
        [btnArray addObject:button];
        if (button.tag == 222) {
            button.selected = YES;
        }
    }
}

- (void)creatScrollView {
    myScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 44, kScreenW, kScreenH - 64 - 44)];
//    myScrollView.backgroundColor = [UIColor yellowColor];
    myScrollView.contentSize = CGSizeMake(2*kScreenW, kScreenH - 64 - 45);
    myScrollView.pagingEnabled = YES;
    myScrollView.delegate = self;
    [self.view addSubview:myScrollView];
    myScrollView.showsVerticalScrollIndicator = NO;
    myScrollView.showsHorizontalScrollIndicator = NO;
    myScrollView.alwaysBounceVertical = NO;
    myScrollView.alwaysBounceHorizontal = NO;
    myScrollView.bounces = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    myScrollView.backgroundColor = [UIColor colorWithRed:251.0f/255.0f green:252.0f/255.0f blue:253.0f/255.0f alpha:1.0f];
    NSArray *photoArray1 = @[@"Market-面料", @"Market-辅料", @"Market-机械设备"];
    NSArray *titleArray1 = @[@"查找面料商家", @"查找辅料商家", @"查找机械设备商家"];
    NSArray *detailTitleArray1 = @[@"最全面料商家聚集地", @"最全辅料商家聚集地", @"最全机械设备商家聚集地"];
    ZGYSupplyMarketView *supplyMarketView1 = [[ZGYSupplyMarketView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 370) photoArray:photoArray1 titleArray:titleArray1 detailTitleArray:detailTitleArray1];
    supplyMarketView1.tag = 222;
    supplyMarketView1.delegate = self;
    [myScrollView addSubview:supplyMarketView1];
    NSArray *photoArray2 = @[@"Market-面料", @"Market-辅料", @"Market-机械设备"];
    NSArray *titleArray2 = @[@"查找面料商品", @"查找辅料商品", @"查找机械设备商品"];
    NSArray *detailTitleArray2 = @[@"最全面料商品聚集地", @"最全辅料商品聚集地", @"最全机械设备商品聚集地"];
    ZGYSupplyMarketView *supplyMarketView2 = [[ZGYSupplyMarketView alloc] initWithFrame:CGRectMake(kScreenW, 0, kScreenW, 370) photoArray:photoArray2 titleArray:titleArray2 detailTitleArray:detailTitleArray2];
    supplyMarketView2.tag = 223;
    supplyMarketView2.delegate = self;
    [myScrollView addSubview:supplyMarketView2];

}


#pragma mark - 选择切换
- (void)actionOfSelect:(UIButton *)button {
    button.selected = YES;
    for (UIButton *sunbBtn in btnArray) {
        if (sunbBtn != button) {
            sunbBtn.selected = NO;
        }
    }

    [myScrollView setContentOffset:CGPointMake((button.tag - 222) * kScreenW, 0) animated:YES];//有动画效果
    
}

#pragma mark - UIScrollViewDelegate

//代理要实现的方法: 切换页面后, 下面的页码控制器也跟着变化
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
 {
     NSInteger btnTag = 0;
     if (scrollView.contentOffset.x == 0) {
         btnTag = 0;
         UIButton *button = [btnArray objectAtIndex:btnTag];
         button.selected = YES;
         for (UIButton *sunbBtn in btnArray) {
             if (sunbBtn != button) {
                 sunbBtn.selected = NO;
             }
         }

     } else if(scrollView.contentOffset.x == scrollView.frame.size.width){
         btnTag = 1;
         UIButton *button = [btnArray objectAtIndex:btnTag];
         button.selected = YES;
         for (UIButton *sunbBtn in btnArray) {
             if (sunbBtn != button) {
                 sunbBtn.selected = NO;
             }
         }
     }
        [UIView animateWithDuration:0.1 animations:^{
        selectLine.frame = CGRectMake(kScreenW/8+(scrollView.contentOffset.x/scrollView.frame.size.width)*kScreenW/2, 44- 2.5, kScreenW/4, 2.5);
    }];
}


#pragma mark - ZGYSupplyMarketViewDelegate
- (void)supplyMarketView:(ZGYSupplyMarketView *)supplyMarketView supplyMarketButtonTag:(NSInteger)supplyMarketButtonTag {
    if (supplyMarketView.tag == 222) {
        DLog(@"左边第 %ld 个", (long)supplyMarketButtonTag);
        switch (supplyMarketButtonTag) {
            case 0: {
                //面料商家
                Business_Supplier_VC *vc = [[Business_Supplier_VC alloc] initWithSubrole:@"面料商" andSelecteDataDictionary:[Tools returenSelectDataDictionaryWithIndex:3]];
                [self.navigationController pushViewController:vc animated:YES];

            }
                break;
            case 1: {
                //辅料商家
                Business_Supplier_VC *vc = [[Business_Supplier_VC alloc] initWithSubrole:@"辅料商" andSelecteDataDictionary:[Tools returenSelectDataDictionaryWithIndex:3]];
                [self.navigationController pushViewController:vc animated:YES];

            }
                break;
            case 2: {
                //机械设备商家
                Business_Supplier_VC *vc = [[Business_Supplier_VC alloc] initWithSubrole:@"机械设备商" andSelecteDataDictionary:[Tools returenSelectDataDictionaryWithIndex:3]];
                [self.navigationController pushViewController:vc animated:YES];

            }
                break;
            default:
                break;
        }
    } else {
        DLog(@"右边第 %ld 个", (long)supplyMarketButtonTag);
        switch (supplyMarketButtonTag) {
            case 0: {
                //面料商城
                FabricShop_VC *fabricShopVC = [[FabricShop_VC alloc] initWithSubrole:@"" andSelecteDataDictionary:[Tools goodsSelectDataDictionaryWithIndex:1]];
                [self.navigationController pushViewController:fabricShopVC animated:YES];
            }
                
                break;
            case 1: {
                //辅料商城
                AccessoryShop_VC *accessoryVC = [[AccessoryShop_VC alloc] initWithSubrole:@"辅料商城" andSelecteDataDictionary:[Tools goodsSelectDataDictionaryWithIndex:2]];
                [self.navigationController pushViewController:accessoryVC animated:YES];
            }
                
                break;
            case 2: {
                //机械设备商城
                MachineShop_VC *machineVC = [[MachineShop_VC alloc] initWithSubrole:@"机械设备" andSelecteDataDictionary:[Tools goodsSelectDataDictionaryWithIndex:3]];
                [self.navigationController pushViewController:machineVC animated:YES];
            }
                
                break;
            default:
                break;
        }
    }
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
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

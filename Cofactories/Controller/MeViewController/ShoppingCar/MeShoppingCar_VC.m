//
//  MeShoppingCar_VC.m
//  Cofactories
//
//  Created by 赵广印 on 16/1/27.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "MeShoppingCar_VC.h"
#import "ShoppingCarCell.h"
#import "ShopCarModel.h"
#import "ShoppingMallDetail_VC.h"
#import "TableViewHeaderView.h"

static NSString *shopCarCellIdentifier = @"shopCarCell";
@interface MeShoppingCar_VC ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    BOOL isEdit;
    //    BOOL allSelect;
    UIButton *button1, *button2;
    UIImageView *allSelectView;
    UIView *bigView;
    NSString *storeKey;
}
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *shoppingCarArray;

@end

@implementation MeShoppingCar_VC
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"购物车";
    self.view.backgroundColor = [UIColor whiteColor];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(pressItem:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    isEdit = NO;
    button1.selected = NO;
    UserModel * MyProfile = [[UserModel alloc]getMyProfile];
    storeKey = [NSString stringWithFormat:@"ShoppingCarArray%@", MyProfile.uid];
    NSMutableArray *shoppingCarArray = [NSMutableArray arrayWithCapacity:0];
    if ([[[StoreUserValue sharedInstance] valueWithKey:storeKey] count] > 0) {
        shoppingCarArray = [[StoreUserValue sharedInstance] valueWithKey:storeKey];
    }
    self.shoppingCarArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < shoppingCarArray.count; i++) {
        ShopCarModel *selectModel = shoppingCarArray[i];
        selectModel.isSelect = NO;
        [self.shoppingCarArray addObject:selectModel];
    }
    
    [self creatTableView];
    [self creatBottomView];
    if (self.shoppingCarArray.count == 0) {
        bigView.hidden = YES;
        self.navigationItem.rightBarButtonItem = nil;
        self.myTableView.backgroundView = [[TableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 50*kZGY) withImage:@"数据暂无2" withLabelText:@"购物车空空如也"];
    }

}
- (void)pressItem:(UIBarButtonItem *)item {
    if ([item.title isEqualToString:@"编辑"]) {
        item.title = @"完成";
        isEdit = YES;
        button2.hidden = NO;
    } else {
        item.title = @"编辑";
        isEdit = NO;
        button2.hidden = YES;
    }
    
    [self.myTableView reloadData];
}

- (void)creatBottomView {
    bigView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - 50*kZGY, kScreenW, 50*kZGY)];
    bigView.layer.borderColor = kLineGrayCorlor.CGColor;
    bigView.layer.borderWidth = 0.5;
    bigView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bigView];
    NSArray *titleArray = @[@"全选", @"删除"];
    for (int i = 0; i < 2; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(i*2*kScreenW/3, 0, kScreenW/3, 50*kZGY);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(actionOfBottom:) forControlEvents:UIControlEventTouchUpInside];
        if (button.tag == 0) {
            button1 = button;
            [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button1.backgroundColor = [UIColor whiteColor];
            allSelectView = [[UIImageView alloc] initWithFrame:CGRectMake(10*kZGY, 10*kZGY, 30*kZGY, 30*kZGY)];
            allSelectView.image = [UIImage imageNamed:@"MeIsNoSelect"];
            [button1 addSubview:allSelectView];
            
        } else if (button.tag == 1) {
            button2 = button;
            button2.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
            button2.hidden = YES;
        }
        [bigView addSubview:button];
    }
}

- (void)creatTableView {
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 50*kZGY)];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
//    self.myTableView.backgroundColor = [UIColor whiteColor];
    self.myTableView.backgroundColor = [UIColor colorWithRed:251.0/255.0 green:251.0/255.0 blue:251.0/255.0 alpha:1.0];
    self.myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.myTableView];
    [self.myTableView registerClass:[ShoppingCarCell class] forCellReuseIdentifier:shopCarCellIdentifier];
    
}
#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.shoppingCarArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCarCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ShopCarModel *shopCar = self.shoppingCarArray[indexPath.row];
    
    cell.selectButton.tag = 222 + indexPath.row;
    [cell.selectButton addTarget:self action:@selector(actionOfSelect:) forControlEvents:UIControlEventTouchUpInside];
    if (shopCar.isSelect == YES) {
        cell.selectView.image = [UIImage imageNamed:@"MeIsSelect"];
        
    } else {
        cell.selectView.image = [UIImage imageNamed:@"MeIsNoSelect"];
    }
    
    cell.cutButton.tag = 1000 + indexPath.row;
    cell.myTextfield.tag = 2000 + indexPath.row;
    cell.addButton.tag = 3000 + indexPath.row;
    cell.myTextfield.delegate = self;
    
    if (isEdit == YES) {
        cell.cutView.hidden = NO;
        cell.addView.hidden = NO;
        cell.cutButton.hidden = NO;
        cell.myTextfield.hidden = NO;
        cell.addButton.hidden = NO;
        cell.shopCarColor.frame = CGRectMake(135*kZGY, 45*kZGY, kScreenW - 255*kZGY, 25*kZGY);
        cell.shopCarColor.text = [NSString stringWithFormat:@"分类：%@", shopCar.shopCarColor];
        [cell.cutButton addTarget:self action:@selector(actionOfCutNumberSelect:) forControlEvents:UIControlEventTouchUpInside];
        [cell.addButton addTarget:self action:@selector(actionOfAddNumberSelect:) forControlEvents:UIControlEventTouchUpInside];
        cell.myTextfield.text = shopCar.shopCarNumber;
        if ([shopCar.shopCarNumber isEqualToString:@"1"]) {
            cell.cutView.image = [UIImage imageNamed:@"ShopCar-减号灰"];
        } else {
            cell.cutView.image = [UIImage imageNamed:@"ShopCar-减号蓝"];
        }
    } else {
        cell.cutView.hidden = YES;
        cell.addView.hidden = YES;
        cell.cutButton.hidden = YES;
        cell.myTextfield.hidden = YES;
        cell.addButton.hidden = YES;
        cell.shopCarColor.frame = CGRectMake(135*kZGY, 45*kZGY, kScreenW - 155*kZGY, 25*kZGY);
        cell.shopCarColor.text = [NSString stringWithFormat:@"数量：%@ ；分类：%@", shopCar.shopCarNumber, shopCar.shopCarColor];
    }
    if ([shopCar.photoUrl isEqualToString:@"默认图片"]) {
        cell.photoView.image = [UIImage imageNamed:@"默认图片"];
    } else {
        NSString* encodedString = [[NSString stringWithFormat:@"%@%@", PhotoAPI, shopCar.photoUrl] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [cell.photoView sd_setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"默认图片"]];
    }
    cell.shopCarTitle.text = shopCar.shopCarTitle;
    cell.shopCarPrice.text = [NSString stringWithFormat:@"￥ %@", shopCar.shopCarPrice];
    
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105*kZGY;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (isEdit == YES) {
        //编辑状态下不能点进去
    } else {
        ShoppingMallDetail_VC *shopDetailVC = [[ShoppingMallDetail_VC alloc] init];
        ShopCarModel *shopCarModel = self.shoppingCarArray[indexPath.row];
        shopDetailVC.shopID = shopCarModel.shoppingID;
        shopDetailVC.myAmount = [shopCarModel.shopCarNumber integerValue];
        shopDetailVC.myColorString = shopCarModel.shopCarColor;
        [self.navigationController pushViewController:shopDetailVC animated:YES];
    }
}



#pragma mark - 底部按钮
- (void)actionOfBottom:(UIButton *)button {
    if (button.tag == 0) {
        DLog(@"全选");
        if (button.selected == YES) {
            allSelectView.image = [UIImage imageNamed:@"MeIsNoSelect"];
            button.selected = NO;
            for (int i = 0; i < self.shoppingCarArray.count; i++) {
                ShopCarModel *shopCarModel = self.shoppingCarArray[i];
                shopCarModel.isSelect = NO;
                [self.myTableView reloadData];
            }
        } else {
            allSelectView.image = [UIImage imageNamed:@"MeIsSelect"];
            button.selected = YES;
            [Tools showOscillatoryAnimationWithLayer:allSelectView.layer isToBig:YES];
            for (int i = 0; i < self.shoppingCarArray.count; i++) {
                ShopCarModel *shopCarModel = self.shoppingCarArray[i];
                shopCarModel.isSelect = YES;
                [self.myTableView reloadData];
            }
        }
    } else if (button.tag == 1) {
        DLog(@"删除");
        NSMutableArray *myShoppingCarArray = [NSMutableArray arrayWithCapacity:0];
        
        for (int i = 0; i < self.shoppingCarArray.count; i++) {
            ShopCarModel *selectModel = self.shoppingCarArray[i];
            if (selectModel.isSelect == NO) {
                [myShoppingCarArray addObject:selectModel];
            }
        }
        [[StoreUserValue sharedInstance] storeValue:myShoppingCarArray withKey:storeKey];
        self.shoppingCarArray = [NSMutableArray arrayWithArray:myShoppingCarArray];
        if (self.shoppingCarArray.count == 0) {
            bigView.hidden = YES;
            self.navigationItem.rightBarButtonItem = nil;
            self.myTableView.backgroundView = [[TableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 50*kZGY) withImage:@"数据暂无2" withLabelText:@"购物车空空如也"];
            [self.myTableView reloadData];
        } else {
            [self.myTableView reloadData];
        }
    }
}
//点击选中
- (void)actionOfSelect:(UIButton *)button {
    ShopCarModel *shopCarModel = self.shoppingCarArray[button.tag - 222];
    if (shopCarModel.isSelect == NO) {
        shopCarModel.isSelect = YES;
    } else {
        shopCarModel.isSelect = NO;
    }
    
    for (int i = 0; i < self.shoppingCarArray.count; i++) {
        ShopCarModel *shopModel = self.shoppingCarArray[i];
        if (shopModel.isSelect == NO) {
            button1.selected = NO;
            break;
        } else {
            button1.selected = YES;
        }
        
    }
    if (button1.isSelected == YES) {
        allSelectView.image = [UIImage imageNamed:@"MeIsSelect"];
        [Tools showOscillatoryAnimationWithLayer:allSelectView.layer isToBig:YES];
    } else {
        allSelectView.image = [UIImage imageNamed:@"MeIsNoSelect"];
    }
    //    for (int i = 0; i < self.shoppingCarArray.count; i++) {
    //        if (i != button.tag - 222) {
    //            ShopCarModel *shopCar = self.shoppingCarArray[i];
    //            shopCar.isSelect = NO;
    //
    //        }
    //    }
    
    [self.myTableView reloadData];
}

//点击减号
- (void)actionOfCutNumberSelect:(UIButton *)button {
    ShopCarModel *shopCarModel = self.shoppingCarArray[button.tag - 1000];
    NSIndexPath *index = [NSIndexPath indexPathForItem:button.tag - 1000 inSection:0];
    ShoppingCarCell *cell = [self.myTableView cellForRowAtIndexPath:index];
    if ([shopCarModel.shopCarNumber integerValue] == 1) {
        
    } else {
        cell.myTextfield.text = [NSString stringWithFormat:@"%ld", [shopCarModel.shopCarNumber integerValue] - 1];
        shopCarModel.shopCarNumber = cell.myTextfield.text;
        [self.myTableView reloadData];
    }
}
//点击加号
- (void)actionOfAddNumberSelect:(UIButton *)button {
    ShopCarModel *shopCarModel = self.shoppingCarArray[button.tag - 3000];
    NSIndexPath *index = [NSIndexPath indexPathForItem:button.tag - 3000 inSection:0];
    ShoppingCarCell *cell = [self.myTableView cellForRowAtIndexPath:index];
    cell.myTextfield.text = [NSString stringWithFormat:@"%ld", [shopCarModel.shopCarNumber integerValue] + 1];
    shopCarModel.shopCarNumber = cell.myTextfield.text;
    [self.myTableView reloadData];
}
//键盘回收，编辑完成时
- (void)textFieldDidEndEditing:(UITextField *)textField {
    ShopCarModel *shopCarModel = self.shoppingCarArray[textField.tag - 2000];
    if ([textField.text integerValue] == 0 || textField.text == nil) {
        textField.text = @"1";
    }
    shopCarModel.shopCarNumber = textField.text;
    [self.myTableView reloadData];
}


@end

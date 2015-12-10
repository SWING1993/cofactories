//
//  ShopCarController.m
//  Cofactories
//
//  Created by 赵广印 on 15/12/7.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "ShopCarController.h"
#import "ShoppingCarCell.h"
#import "DataBaseHandle.h"
#import "ShopCarModel.h"


static NSString *shopCarCellIdentifier = @"shopCarCell";
@interface ShopCarController ()<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate> {
    BOOL isEdit;
//    BOOL allSelect;
    UIButton *button1, *button2, *button3;
    UIImageView *allSelectView;
}
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, retain) DataBaseHandle *dataBasaHandle;
@property (nonatomic, strong) NSMutableArray *shoppingCarArray;

@end

@implementation ShopCarController

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"购物车";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(pressItem:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    isEdit = NO;
    button1.selected = NO;
    self.dataBasaHandle = [DataBaseHandle mainDataBaseHandle];
    [self.dataBasaHandle searchAllShoppingCar];
    self.shoppingCarArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < self.dataBasaHandle.shoppingCarArray.count; i++) {
        ShopCarModel *selectModel = self.dataBasaHandle.shoppingCarArray[i];
        selectModel.isSelect = NO;
        [self.shoppingCarArray addObject:selectModel];
    }

    [self creatTableView];
    [self creatBottomView];

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
    UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenH - 50*kZGY, kScreenW, 50*kZGY)];
    bigView.layer.borderColor = kLineGrayCorlor.CGColor;
    bigView.layer.borderWidth = 0.3;
    bigView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bigView];
    NSArray *titleArray = @[@"全选", @"删除", @"结算"];
    for (int i = 0; i < 3; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = i;
        button.frame = CGRectMake(i*kScreenW/3, 0, kScreenW/3, 50*kZGY);
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(actionOfBottom:) forControlEvents:UIControlEventTouchUpInside];
        if (button.tag == 0) {
            button1 = button;
            [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button1.backgroundColor = [UIColor whiteColor];
            allSelectView = [[UIImageView alloc] initWithFrame:CGRectMake(15*kZGY, 15*kZGY, 20*kZGY, 20*kZGY)];
            allSelectView.image = [UIImage imageNamed:@"ShopCarNoSelect"];
            [button1 addSubview:allSelectView];
        } else if (button.tag == 1) {
            button2 = button;
            button2.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
            button2.hidden = YES;
        } else if (button.tag == 2) {
            button3 = button;
            button3.backgroundColor = [UIColor colorWithRed:72.0/255.0 green:126.0/255.0 blue:207.0/255.0 alpha:1.0];
        }
        [bigView addSubview:button];
    }
}
- (void)creatTableView {
    self.myTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, kScreenH - 50*kZGY)];
    self.myTableView.dataSource = self;
    self.myTableView.delegate = self;
//    self.myTableView.backgroundColor = [UIColor redColor];
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
    return self.dataBasaHandle.shoppingCarArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShoppingCarCell *cell = [tableView dequeueReusableCellWithIdentifier:shopCarCellIdentifier forIndexPath:indexPath];
    
    ShopCarModel *shopCar = self.shoppingCarArray[indexPath.row];
    
    cell.selectButton.tag = 222 + indexPath.row;
    [cell.selectButton addTarget:self action:@selector(actionOfSelect:) forControlEvents:UIControlEventTouchUpInside];
    if (shopCar.isSelect == YES) {
        cell.selectView.image = [UIImage imageNamed:@"ShopCarIsSelect"];
    } else {
        cell.selectView.image = [UIImage imageNamed:@"ShopCarNoSelect"];
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
        cell.shopCarColor.text = [NSString stringWithFormat:@"颜色：%@", shopCar.shopCarColor];
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
        cell.shopCarColor.text = [NSString stringWithFormat:@"数量：%@ ；颜色：%@", shopCar.shopCarNumber, shopCar.shopCarColor];
    }
    
    cell.photoView.image = [UIImage imageNamed:@"5.jpg"];
    cell.shopCarTitle.text = shopCar.shopCarTitle;
    
    cell.shopCarPrice.text = [NSString stringWithFormat:@"￥ %@", shopCar.shopCarPrice];
    
    
    return cell;
        
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105*kZGY;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)actionOfBottom:(UIButton *)button {
    if (button.tag == 0) {
        DLog(@"全选");
        if (button.selected == YES) {
            allSelectView.image = [UIImage imageNamed:@"ShopCarNoSelect"];
            button.selected = NO;
            for (int i = 0; i < self.shoppingCarArray.count; i++) {
                ShopCarModel *shopCarModel = self.shoppingCarArray[i];
                shopCarModel.isSelect = NO;
                [self.myTableView reloadData];
            }
        } else {
            allSelectView.image = [UIImage imageNamed:@"ShopCarIsSelect"];
            button.selected = YES;
            for (int i = 0; i < self.shoppingCarArray.count; i++) {
                ShopCarModel *shopCarModel = self.shoppingCarArray[i];
                shopCarModel.isSelect = YES;
                [self.myTableView reloadData];
        }
    }
    } else if (button.tag == 1) {
        DLog(@"删除");
        DataBaseHandle *dataBaseHandle = [DataBaseHandle mainDataBaseHandle];
        for (int i = 0; i < self.shoppingCarArray.count; i++) {
            ShopCarModel *shopCar = self.shoppingCarArray[i];
            if (shopCar.isSelect == YES) {
//                [self.shoppingCarArray removeObject:shopCar];
                [dataBaseHandle deleteShoppingCarWithID:shopCar.ID];
                
//                        DetailCar *car = dataBaseHandle.shoppingCarArray[indexPath.row];
//                        [dataBaseHandle deleteCarWithID:car.ID];
            }
        }
        self.dataBasaHandle = [DataBaseHandle mainDataBaseHandle];
        [self.dataBasaHandle searchAllShoppingCar];
        self.shoppingCarArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < self.dataBasaHandle.shoppingCarArray.count; i++) {
            ShopCarModel *selectModel = self.dataBasaHandle.shoppingCarArray[i];
            selectModel.isSelect = NO;
            [self.shoppingCarArray addObject:selectModel];
        }

        
        [self.myTableView reloadData];
//        DataBaseHandle *dataBaseHandle = [DataBaseHandle mainDataBaseHandle];
//        DetailCar *car = dataBaseHandle.shoppingCarArray[indexPath.row];
//        [dataBaseHandle deleteCarWithID:car.ID];
        

        
    } else if (button.tag == 2) {
        DLog(@"结算");
    }
}

- (void)actionOfSelect:(UIButton *)button {
    DLog(@"^^^^^^^^^^^^^^^^^^^");
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
        allSelectView.image = [UIImage imageNamed:@"ShopCarIsSelect"];
    } else {
        allSelectView.image = [UIImage imageNamed:@"ShopCarNoSelect"];
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
- (void)actionOfAddNumberSelect:(UIButton *)button {
    ShopCarModel *shopCarModel = self.shoppingCarArray[button.tag - 3000];
    NSIndexPath *index = [NSIndexPath indexPathForItem:button.tag - 3000 inSection:0];
    ShoppingCarCell *cell = [self.myTableView cellForRowAtIndexPath:index];
    cell.myTextfield.text = [NSString stringWithFormat:@"%ld", [shopCarModel.shopCarNumber integerValue] + 1];
    shopCarModel.shopCarNumber = cell.myTextfield.text;
    [self.myTableView reloadData];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    ShopCarModel *shopCarModel = self.shoppingCarArray[textField.tag - 2000];
    if ([textField.text integerValue] == 0 || textField.text == nil) {
        textField.text = @"1";
    }
    shopCarModel.shopCarNumber = textField.text;
    [self.myTableView reloadData];


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

//
//  SupplierOrderDetail_VC.m
//  Cofactories
//
//  Created by GTF on 15/12/1.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "SupplierOrderDetail_VC.h"
#import "OrderPhotoViewController.h"
#import "OrderBid_Supplier_VC.h"

@interface SupplierOrderDetail_VC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView         *_tableView;
    NSInteger            _sectionFooterHeight;
    BOOL                 _isMyselfOrder;
    BOOL                 _isCompletion;
    BOOL                 _isAlreadyBid;
    NSArray             *_bidAmountArray;
}
@property(nonatomic,strong)UserModel *userModel;

@end
static NSString *const reuseIdentifier = @"reuseIdentifier";

@implementation SupplierOrderDetail_VC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (!self.userModel) {
        self.userModel = [[UserModel alloc] getMyProfile];
    }
    if ([_dataModel.userUid isEqualToString:_userModel.uid]) {
        _isMyselfOrder = YES;
    }else{
        _isMyselfOrder = NO;
    }
    
    if ([_dataModel.status isEqualToString:@"0"]) {
        _isCompletion = NO;
    }else if ([_dataModel.status isEqualToString:@"1"]){
        _isCompletion = YES;
    }
    
    [HttpClient getSupplierOrderBidUserAmountWithOrderID:_dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
        DLog("%@,%@",dictionary,_userModel.uid);
        
        _bidAmountArray = dictionary[@"message"];
        [_bidAmountArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dic = (NSDictionary *)obj;
            NSString *uID = [NSString stringWithFormat:@"%@",dic[@"uid"]];
            if ([uID isEqualToString:_userModel.uid]) {
                _isAlreadyBid = YES;
            }else{
                _isAlreadyBid = NO;
            }if (_isAlreadyBid) {
                *stop = YES;
            }
        }];
        [_tableView reloadData];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initTableView];
}

- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:kScreenBounds style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource =self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 35;
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    [self.view addSubview:_tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 126)];
    _tableView.tableHeaderView = headerView;
    
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeCustom];
    imageButton.frame = CGRectMake(15,10, 80, 65);
    imageButton.layer.masksToBounds = YES;
    imageButton.layer.cornerRadius = 5;
    if (_dataModel.photoArray.count > 0) {
        [imageButton sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,_dataModel.photoArray[0]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
    }else{
        [imageButton setBackgroundImage:[UIImage imageNamed:@"placeHolderImage"] forState:UIControlStateNormal];
    }
    [imageButton addTarget:self action:@selector(imageDetailClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:imageButton];
    
    UILabel *nameLB = [[UILabel alloc] initWithFrame:CGRectMake(105, 10, kScreenW-120, 30)];
    nameLB.font = [UIFont systemFontOfSize:14];
    nameLB.text = _otherUserModel.name;
    [headerView addSubview:nameLB];
    
    UILabel *addressLB = [[UILabel alloc] initWithFrame:CGRectMake(105, 40, kScreenW-120, 30)];
    addressLB.font = [UIFont systemFontOfSize:12];
    addressLB.text = [NSString stringWithFormat:@"地址: %@",_otherUserModel.address];
    addressLB.textColor = [UIColor grayColor];
    [headerView addSubview:addressLB];
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = MAIN_COLOR.CGColor;
    lineLayer.frame = CGRectMake(15,85, kScreenW-30, 0.5);
    [headerView.layer addSublayer:lineLayer];
    
    NSArray *buttonArray = @[@"chatImage",@"bidImage"];
    for (int i=0; i<buttonArray.count; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*kScreenW/2.f, 86, kScreenW/2.f, 40);
        [button setBackgroundImage:[UIImage imageNamed:buttonArray[i]] forState:UIControlStateNormal];
        button.tag = i+1;
        [button addTarget:self action:@selector(chatBidClick:) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:button];
    }
    
}

- (void)chatBidClick:(id)sender{
    UIButton *button = (UIButton *)sender;
    
    
    DLog("-->>%d",_isAlreadyBid);
    
    if (button.tag == 1) {
        // 聊天
    }else if (button.tag == 2){
        // 投标
        if (!_isMyselfOrder) {
            if (!_isCompletion) {
                if (!_isAlreadyBid) {
                    NSLog(@"%ld",(long)button.tag);
                    OrderBid_Supplier_VC *vc = [OrderBid_Supplier_VC new];
                    vc.orderID = _dataModel.ID;
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    kTipAlert(@"该订单您已投过标");
                }
            }else{
                kTipAlert(@"该订单已完成投标");
            }
        }else{
            kTipAlert(@"不可投标自己的订单");
        }
    }
}

- (void)imageDetailClick{
    if (_dataModel.photoArray.count == 0) {
        kTipAlert(@"用户未上传图片");
    }else{
        OrderPhotoViewController *vc = [[OrderPhotoViewController alloc] initWithPhotoArray:_dataModel.photoArray];
        vc.titleString = @"订单图片";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 4;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
        cell.textLabel.font = [UIFont systemFontOfSize:13];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = [NSString stringWithFormat:@"  类型:   %@",_dataModel.type];
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"  名称:   %@",_dataModel.name];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"  数量:   %@%@",_dataModel.amount,_dataModel.unit];
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"  下单时间:   %@",_dataModel.createdAt];
                break;
                
            default:
                break;
        }
        return cell;
        
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已参与投标的厂商有%zi家",_bidAmountArray.count]];
    NSString *lengthString = [NSString stringWithFormat:@"%lu",(unsigned long)_bidAmountArray.count];
    NSInteger length = lengthString.length;
    [labelText addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(9,length)];
    cell.textLabel.attributedText = labelText;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenW, 50)];
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0].CGColor;
    lineLayer.frame = CGRectMake(0,0, kScreenW, 10);
    [view.layer addSublayer:lineLayer];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 20, 25)];
    imageView.image = [UIImage imageNamed:@"dd.png"];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, 100, 25)];
    label.textColor = MAIN_COLOR;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:16];
    label.text = @"订单信息";
    [view addSubview:label];
    
    UILabel *numberLB = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-160, 20, 150, 25)];
    numberLB.text = [NSString stringWithFormat:@"订单编号: %@",_dataModel.ID];
    numberLB.textColor = [UIColor grayColor];
    numberLB.textAlignment = NSTextAlignmentRight;
    numberLB.font = [UIFont systemFontOfSize:12];
    [view addSubview:numberLB];
    
    if (section == 0) {
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 55;
    }else if (section == 1){
        return 0.01;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, _sectionFooterHeight-30)];
    
    NSString *string = [NSString stringWithFormat:@"备注信息: %@",_dataModel.descriptions];
    CGSize size = [self returnSizeWithString:string];
    UILabel *LB1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, size.width, size.height+20)];
    LB1.font = kFont;
    LB1.numberOfLines = 0;
    LB1.textColor = [UIColor grayColor];
    LB1.text = string;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:LB1.text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:4];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, LB1.text.length)];
    LB1.attributedText = attributedString;
    [view addSubview:LB1];
    
    CALayer *lineLayer = [CALayer layer];
    lineLayer.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0].CGColor;
    lineLayer.frame = CGRectMake(0,_sectionFooterHeight-10, kScreenW, 10);
    [view.layer addSublayer:lineLayer];
    
    if (section == 0) {
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        NSString *string = [NSString stringWithFormat:@"备注信息: %@",_dataModel.descriptions];
        CGSize size = [self returnSizeWithString:string];
        _sectionFooterHeight = size.height+20+10+20;
        return _sectionFooterHeight;
    }else if (section == 1){
        return 0.01;
    }
    return 0;
}

- (CGSize)returnSizeWithString:(NSString *)string{
    NSDictionary *attribute = @{NSFontAttributeName: kFont};
    CGSize size = [string boundingRectWithSize:CGSizeMake(kScreenW-30, LONG_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                    attributes:attribute context:nil].size;
    return size;
}
@end

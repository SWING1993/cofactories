//
//  DesignOrderDetail_VC.m
//  Cofactories
//
//  Created by GTF on 15/12/2.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "DesignOrderDetail_VC.h"
#import "OrderPhotoViewController.h"
#import "OrderBid_Factory_VC.h"
#import "BidManage_Design_VC.h"
#import "MarkOrder_VC.h"
#import "IMChatViewController.h"
#import "PersonalMessage_Design_VC.h"
#import "PersonalMessage_Factory_VC.h"
#import "PersonalMessage_Clothing_VC.h"
@interface DesignOrderDetail_VC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView         *_tableView;
    NSInteger            _sectionFooterHeight;
    BOOL                 _isMyselfOrder;
    BOOL                 _isCompletion;
    BOOL                 _isAlreadyBid;
    NSArray             *_bidAmountArray;
    UIImageView         *_orderImageOne;
    UIImageView         *_orderImageTwo;
    UIImageView         *_orderImageThree;
    CGSize               _descriptionSize;

}
@property(nonatomic,strong)UserModel *userModel;

@end
static NSString *const reuseIdentifier = @"reuseIdentifier";

@implementation DesignOrderDetail_VC

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
    
    [HttpClient getDesignOrderBidUserAmountWithOrderID:_dataModel.ID WithCompletionBlock:^(NSDictionary *dictionary) {
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

    _descriptionSize = [Tools getSize:_dataModel.descriptions andFontOfSize:12 andWidthMake:kScreenW-90];
    DLog(@"+++++++++++++=======%f",_descriptionSize.width);
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
    
    UIButton *headerView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 126+10)];
    headerView.userInteractionEnabled = YES;
    [headerView addTarget:self action:@selector(userDetailClick) forControlEvents:UIControlEventTouchUpInside];
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
        
        if (i == 1) {
            
            switch (_designOrderDetailBidStatus) {
                case DesignOrderDetailBidStatus_Common:
                    [button setBackgroundImage:[UIImage imageNamed:buttonArray[i]] forState:UIControlStateNormal];
                    break;
                case DesignOrderDetailBidStatus_BidOver:
                    [button setBackgroundImage:[UIImage imageNamed:@"alreadyBid"] forState:UIControlStateNormal];
                    break;
                case DesignOrderDetailBidStatus_BidManagement:
                    [button setBackgroundImage:[UIImage imageNamed:@"manageBid"] forState:UIControlStateNormal];
                    break;
                case DesignOrderDetailBidStatus_BidMark:
                    [button setBackgroundImage:[UIImage imageNamed:@"markBid"] forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }

        
    }
    
    UILabel *lineLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 126, kScreenW, 10)];
    lineLB.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [headerView addSubview:lineLB];
}

- (void)userDetailClick{
    NSLog(@"325435");

    if ([_otherUserModel.role isEqualToString:@"加工配套"]) {
        PersonalMessage_Factory_VC *vc = [PersonalMessage_Factory_VC new];
        vc.userModel = _otherUserModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([_otherUserModel.role isEqualToString:@"服装企业"]){
        PersonalMessage_Clothing_VC *vc = [PersonalMessage_Clothing_VC new];
        vc.userModel = _otherUserModel;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        // 设计师、供应商
        PersonalMessage_Design_VC *vc = [PersonalMessage_Design_VC new];
        vc.userModel = _otherUserModel;
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (void)chatBidClick:(id)sender{
    UIButton *button = (UIButton *)sender;

    if (button.tag == 1) {
        // 聊天
        IMChatViewController *conversationVC = [[IMChatViewController alloc]init];
        conversationVC.conversationType = ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        conversationVC.targetId = self.otherUserModel.uid; // 接收者的 targetId，这里为举例。
        conversationVC.title = self.otherUserModel.name; // 会话的 title。
        conversationVC.hidesBottomBarWhenPushed=YES;
        
        [self.navigationController.navigationBar setHidden:NO];
        [self.navigationController pushViewController:conversationVC animated:YES];

    }else if (button.tag == 2){
        // 投标
        switch (_designOrderDetailBidStatus) {
            case DesignOrderDetailBidStatus_Common:{
                if (!_isMyselfOrder) {
                    if (!_isCompletion) {
                        if (!_isAlreadyBid) {
                            NSLog(@"%ld",(long)button.tag);
                            OrderBid_Factory_VC *vc = [OrderBid_Factory_VC new];
                            vc.orderTypeString = @"DesignOrder";
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
                
                break;
            case DesignOrderDetailBidStatus_BidOver:
                kTipAlert(@"不可投标自己的订单");
                break;
                
            case DesignOrderDetailBidStatus_BidManagement:{
                if ([_dataModel.bidCount isEqualToString:@"0"]) {
                    kTipAlert(@"该订单暂无商家投标");
                }else{
                    BidManage_Design_VC *vc = [BidManage_Design_VC new];
                    vc.orderID = _dataModel.ID;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            }
                break;
                
            case DesignOrderDetailBidStatus_BidMark:{
                // 评分
                MarkOrder_VC *vc = [MarkOrder_VC new];
                vc.markOrderType = MarkOrderType_Design;
                vc.orderID = _dataModel.ID;
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            default:
                break;
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


#pragma mark - 表
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.font = [UIFont systemFontOfSize:13];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableAttributedString *labelText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"  已参与投标的厂商有%zi家",_bidAmountArray.count]];
    NSString *lengthString = [NSString stringWithFormat:@"%lu",(unsigned long)_bidAmountArray.count];
    NSInteger length = lengthString.length;
    [labelText addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(11,length)];
    cell.textLabel.attributedText = labelText;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 146+_descriptionSize.height+30;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 146+_descriptionSize.height+30)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 20, 15, 20)];
    imageView.image = [UIImage imageNamed:@"dd.png"];
    [view addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50-2, 18, 100, 25)];
    label.textColor = MAIN_COLOR;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14];
    label.text = @"订单信息";
    [view addSubview:label];
    
    UILabel *numberLB = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW-160, 20, 150, 25)];
    numberLB.text = [NSString stringWithFormat:@"订单编号: %@",_dataModel.ID];
    numberLB.textColor = [UIColor grayColor];
    numberLB.textAlignment = NSTextAlignmentRight;
    numberLB.font = [UIFont systemFontOfSize:12];
    [view addSubview:numberLB];
    

    UILabel *titleLB = [[UILabel alloc]initWithFrame:CGRectMake(20, 45, kScreenW-30, 30)];
    titleLB.font = [UIFont systemFontOfSize:12];
    titleLB.text = [NSString stringWithFormat:@"标题          %@",_dataModel.name];
    [view addSubview:titleLB];
    
    UILabel *orderPhotoLB = [[UILabel alloc] initWithFrame:CGRectMake(20, 75, 60, 25)];
    orderPhotoLB.font = [UIFont systemFontOfSize:12];
    orderPhotoLB.text = @"订单照片";
    [view addSubview:orderPhotoLB];


    for (int i = 0; i<3; i++) {
        UIImageView *orderImage = [[UIImageView alloc] initWithFrame:CGRectMake(80+i*82, 80, 72, 54)];
        orderImage.layer.masksToBounds = YES;
        orderImage.layer.cornerRadius = 5;
        [view addSubview:orderImage];
        
        if (i == 0) {
            _orderImageOne = orderImage;
        }else if (i == 1){
            _orderImageTwo = orderImage;
        }else{
            _orderImageThree = orderImage;
        }
    }
    
    DLog(@">>>>++%lu",(unsigned long)_dataModel.photoArray.count);
    switch (_dataModel.photoArray.count) {
        case 0:
            _orderImageOne.image = [UIImage imageNamed:@"placeHolderImage"];
            _orderImageTwo.image = nil;
            break;
        case 1:
            [_orderImageOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,_dataModel.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
            _orderImageTwo.image = nil;
            break;
            case 2:
            [_orderImageOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,_dataModel.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
            [_orderImageTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,_dataModel.photoArray[1]]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
            
            break;
          default:
            [_orderImageOne sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,_dataModel.photoArray[0]]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
            [_orderImageTwo sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,_dataModel.photoArray[1]]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
                [_orderImageThree sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,_dataModel.photoArray[2]]] placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
            break;
    }

    UILabel *co = [[UILabel alloc]initWithFrame:CGRectMake(20, 138, 40, 30)];
    co.font = [UIFont systemFontOfSize:12];
    co.text = @"备注";
    [view addSubview:co];
    
    UILabel *commentLB = [[UILabel alloc] initWithFrame:CGRectMake(80, 146, kScreenW - 90, _descriptionSize.height)];
    commentLB.font = [UIFont systemFontOfSize:12];
    commentLB.numberOfLines = 0;
    commentLB.text = _dataModel.descriptions;
    [view addSubview:commentLB];
    
    UILabel *lineLB = [[UILabel alloc] initWithFrame:CGRectMake(0, view.frame.size.height - 20, kScreenW, 10)];
    lineLB.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [view addSubview:lineLB];

    return view;
}



@end

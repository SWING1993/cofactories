//
//  EaseInputTipsView.m
//  Cofactories
//
//  Created by 宋国华 on 16/1/12.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "EaseInputTipsView.h"
#import "Login.h"

@interface EaseInputTipsView ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) NSArray *dataList;

@property (strong, nonatomic) NSArray *loginAllList, *emailAllList;

@end

@implementation EaseInputTipsView

+ (instancetype)tipsViewWithType:(EaseInputTipsViewType)type{
    return [[self alloc] initWithTipsType:type];
}

- (instancetype)initWithTipsType:(EaseInputTipsViewType)type{
    CGFloat padingWith = type == 18.0;
    self = [super initWithFrame:CGRectMake(padingWith, 0, kScreenW-2*padingWith, 110)];
    if (self) {
        [self addRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(2, 2)];
        [self setClipsToBounds:YES];
        _myTableView = ({
            UITableView *tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
            tableView.backgroundColor = [UIColor colorWithWhite:5.0 alpha:0.95];
            tableView.dataSource = self;
            tableView.delegate = self;
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            [self addSubview:tableView];
            [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
            }];
            tableView.tableFooterView = [UIView new];
            tableView;
        });
        _type = type;
        _active = YES;
    }
    return self;
}

- (void)refresh{
    [self.myTableView reloadData];
    self.hidden = self.dataList.count <= 0 || !_active;
}
#pragma mark SetM

- (void)setActive:(BOOL)active{
    _active = active;
    self.hidden = self.dataList.count <= 0 || !_active;
}

- (void)setValueStr:(NSString *)valueStr{
    _valueStr = valueStr;
    if (_valueStr.length <= 0) {
        self.dataList = nil;
    }else{
        self.dataList = [self loginList];
    }
    [self refresh];
}

- (NSArray *)loginList{
    if (_valueStr.length <= 0) {
        return nil;
    }
    NSString *tipStr = [_valueStr copy];
    NSMutableArray *list = [NSMutableArray new];
    [[self loginAllList] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if ([obj rangeOfString:tipStr].location != NSNotFound) {
            [list addObject:obj];
        }
    }];
    return list;
}


- (NSArray *)loginAllList{
    if (!_loginAllList) {
        _loginAllList = [[Login readLoginDataList] allKeys];
    }
    return _loginAllList;
}

#pragma mark Table
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"EaseInputTipsViewCell";
    NSInteger labelTag = 99;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18.0, 0, kScreenW - 2*18.0, 35)];
        label.font = [UIFont systemFontOfSize:14];
        label.tag = labelTag;
        [cell.contentView addSubview:label];
    }
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:labelTag];
    label.textColor = [UIColor colorWithHexString:@"0x222222"];
    label.text = [_dataList objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView addLineforPlainCell:cell forRowAtIndexPath:indexPath withLeftSpace:18.0 hasSectionLine:NO];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.selectedStringBlock && self.dataList.count > indexPath.row) {
        self.selectedStringBlock([self.dataList objectAtIndex:indexPath.row]);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 35;
}

- (void)addRoundingCorners:(UIRectCorner)corners cornerRadii:(CGSize)cornerRadii{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:cornerRadii];
    CAShapeLayer *maskLayer = [CAShapeLayer new];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

@end
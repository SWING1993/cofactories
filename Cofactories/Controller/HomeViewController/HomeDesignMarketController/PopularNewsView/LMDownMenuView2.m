//
//  LMDownMenuView2.m
//  美团下拉菜单
//
//  Created by 赵广印 on 15/11/6.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "LMDownMenuView2.h"
#import "ClassCell.h"
#define kSelectTitleColor [UIColor colorWithRed:65.0f/255.0f green:145.0f/255.0f blue:228.0f/255.0f alpha:1.0f]


static NSString *levelCellIdentifier = @"levelCell";
static NSString *classCellIdentifier = @"classCell";
static NSString *placeCellIdentifier = @"placeCell";
@implementation LMDownMenuView2
{
    UIView* selectView;
    UIButton* dragBtn;
    CGFloat currH;//当前视图的高度
    
    SelectType currType;
    NSString* currTitle;
    NSString* currSubTitle;
    NSString* selectMainItem;
    
    //数据处理
    NSArray *levelArray;//等级数组
    NSArray *classArray;//分类数组
    NSArray *placeArray;//地址数组
    
    NSDictionary *bigDic;
    
//    NSString *isSelect;
    NSString *chuShiZhi;
}
- (id)initWithFrame:(CGRect)frame withSelectType:(SelectType)type levelArray:(NSArray *)levelArr classArray:(NSArray *)classArr addressArray:(NSArray *)addressArr andTitle:(NSString *)title {
    self = [super initWithFrame:frame];
    if (self) {
        currType = type;
        NSLog(@"title = %@",title);
        currTitle = [title componentsSeparatedByString:@"&&"].firstObject;
        selectMainItem = [title componentsSeparatedByString:@"&&"].firstObject;
        currSubTitle = [title componentsSeparatedByString:@"&&"].lastObject;
        
        levelArray = levelArr;
//        classArray = classArr;
        placeArray = addressArr;
        bigDic = @{@"地区不限":@[], @"浙江":@[@"浙江不限", @"湖州（含织里）", @"杭州", @"宁波", @"浙江其他"], @"安徽":@[@"安徽不限", @"宣城（含广德）", @"安徽其他"], @"广东":@[@"广东不限", @"广州（含新塘）", @"广东其他"], @"福建":@[], @"江苏":@[], @"其他":@[]};
        self.frame = frame;
        self.backgroundColor = [UIColor colorWithRed:0.145 green:0.145 blue:0.145 alpha:0];
        self.userInteractionEnabled = YES;
        
        UIView* touchView = [[UIView alloc] initWithFrame:self.bounds];
        touchView.backgroundColor = [UIColor clearColor];
        [self addSubview:touchView];
        UITapGestureRecognizer* tapG = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [touchView addGestureRecognizer:tapG];
        
        //操作视图
        selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 0)];
        selectView.backgroundColor = [UIColor colorWithRed:0.941 green:0.937 blue:0.929 alpha:1];
        selectView.layer.masksToBounds = YES;
        [self addSubview:selectView];
        self.opaque = NO;
        
        //底部的拖动按钮
        dragBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dragBtn.backgroundColor = [UIColor colorWithRed:0.941 green:0.937 blue:0.929 alpha:1];
        dragBtn.frame = CGRectMake(0, 0, frame.size.width, 0);
        [dragBtn setImage:[UIImage imageNamed:@"Home-show.png"] forState:UIControlStateNormal];
        [dragBtn addTarget:self action:@selector(dragMoving:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [dragBtn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
        [dragBtn addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, dragBtn.bounds.size.width, 1)];
        line.backgroundColor = [UIColor colorWithRed:0.835 green:0.831 blue:0.827 alpha:1];
        [dragBtn addSubview:line];
        
        switch (type) {
            case 0:{
                [self categoryView];
                break;
            }
            case 1:{
                [self classView];
                break;
            }
            case 2:{
                [self placeView];
                break;
            }
            default:
                break;
        }
    }
    return self;

}


#pragma mark - 拖动
- (void) dragMoving: (UIButton *)sender withEvent:ev {
    CGPoint point = [[[ev allTouches] anyObject] locationInView:selectView];
    if (point.y>currH-20) {
        return;
    }
    selectView.frame = CGRectMake(0, 0, selectView.bounds.size.width, point.y+20);
    dragBtn.frame = CGRectMake(0, selectView.bounds.size.height-20, selectView.bounds.size.width, 20);
    if (point.y<currH/2) {
        sender.accessibilityIdentifier = @"1";
    }else{
        sender.accessibilityIdentifier = @"0";
    }
}
- (void)touchDown:(UIButton*)sender{
    sender.accessibilityIdentifier = @"0";
}
- (void)touchUpInside:(UIButton*)sender{
    BOOL cando = [sender.accessibilityIdentifier boolValue];
    if (cando) {
        [self tappedCancel];
    }else{
        //恢复
        [self noChange];
    }
}

- (void)noChange{
    [UIView animateWithDuration:0.35f animations:^{
        selectView.frame = CGRectMake(0, 0, self.frame.size.width, currH);
        dragBtn.frame = CGRectMake(0, selectView.bounds.size.height-20, selectView.bounds.size.width, 20);
    }];
}
#pragma mark - 全部订单分类

- (void)categoryView{
    
    float hh = 44*levelArray.count + 20 - 0.3;
        
    [selectView addSubview:dragBtn];
    
    UITableView* rootableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenW/3, hh-20)];
    rootableview.tag = 100;
    rootableview.delegate = self;
    rootableview.dataSource = self;
    rootableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [selectView addSubview:rootableview];
    [rootableview registerClass:[ClassCell class] forCellReuseIdentifier:levelCellIdentifier];
    [selectView addSubview:dragBtn];
    [UIView animateWithDuration:0.35f animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.145 green:0.145 blue:0.145 alpha:0.65];
        selectView.frame = CGRectMake(0, 0, self.frame.size.width, hh);
        dragBtn.frame = CGRectMake(0, selectView.bounds.size.height-20, selectView.bounds.size.width, 20);
        
    } completion:^(BOOL finished){
        currH = selectView.bounds.size.height;
        
    }];
}

#pragma mark - 设计师种类选择

- (void)classView{
    NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZGYLevelType"];//工厂类型
    if ([type isEqualToString:@"不限等级"]) {
        
    }
    float hh = 44*classArray.count + 20 - 0.3;
    
    UITableView* rootableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, selectView.bounds.size.width/3, hh-20)];
    rootableview.tag = 100;
    rootableview.delegate = self;
    rootableview.dataSource = self;
    rootableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [rootableview registerClass:[ClassCell class] forCellReuseIdentifier:classCellIdentifier];
    [selectView addSubview:rootableview];
    
    
    
    UITableView* subtableview = [[UITableView alloc] initWithFrame:CGRectMake(rootableview.bounds.size.width, 0, selectView.bounds.size.width/2, hh-20)];
    subtableview.tag = 101;
    subtableview.accessibilityIdentifier = [NSString stringWithFormat:@"%ld",(long)index];
    subtableview.delegate = self;
    subtableview.dataSource = self;
    subtableview.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
    subtableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [selectView addSubview:subtableview];

    [selectView addSubview:dragBtn];
    
    [UIView animateWithDuration:0.35f animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.145 green:0.145 blue:0.145 alpha:0.65];
        selectView.frame = CGRectMake(0, 0, self.frame.size.width, hh);
        dragBtn.frame = CGRectMake(0, selectView.bounds.size.height-20, selectView.bounds.size.width, 20);
    } completion:^(BOOL finished){
        currH = selectView.bounds.size.height;
    }];
}

#pragma mark - 地区筛选

- (void)placeView {
    
//    NSString *type = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZGYLevelType"];//工厂类型
    float hh = 44*placeArray.count + 20 - 0.3;
    
    UITableView* rootableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, selectView.bounds.size.width/3, hh-20)];
    rootableview.delegate = self;
    rootableview.dataSource = self;
    rootableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [rootableview registerClass:[ClassCell class] forCellReuseIdentifier:placeCellIdentifier];
    [selectView addSubview:rootableview];
    [selectView addSubview:dragBtn];
    [UIView animateWithDuration:0.35f animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.145 green:0.145 blue:0.145 alpha:0.65];
        selectView.frame = CGRectMake(0, 0, self.frame.size.width, hh);
        dragBtn.frame = CGRectMake(0, selectView.bounds.size.height-20, selectView.bounds.size.width, 20);
    } completion:^(BOOL finished){
        currH = selectView.bounds.size.height;
    }];
}




#pragma mark - 点击

- (void)tappedCancel{
    if (self.removeTheView) {
        self.removeTheView(YES);
    }
    [UIView animateWithDuration:0.35f animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.145 green:0.145 blue:0.145 alpha:0];
        selectView.frame = CGRectMake(0, 0, selectView.frame.size.width, 0);
        
    } completion:^(BOOL finished){
        if (finished) {
            [self removeFromSuperview];
            [selectView removeFromSuperview];
            selectView = nil;
        }
    }];
}

- (void)tappedCancel2{
    if (self.removeTheView) {
        self.removeTheView(YES);
    }
    self.backgroundColor = [UIColor colorWithRed:0.145 green:0.145 blue:0.145 alpha:0];
    selectView.frame = CGRectMake(0, 0, selectView.frame.size.width, 0);
    [self removeFromSuperview];
    [selectView removeFromSuperview];
    selectView = nil;
}

#pragma mark - UITableViewDatasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rows = 0;
    if (currType == SelectTypeOfClass) {
        if (tableView.tag == 100) {
            rows = classArray.count;
        } else {
            rows = [bigDic[currTitle] count];
        }
        
    }
    else if (currType == SelectTypeOfPlace)
    {
        rows = placeArray.count;
    }
    else if (currType == SelectTypeOfCategory) {
        rows = levelArray.count;

    }
    return rows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (currType == SelectTypeOfCategory) {
            ClassCell *cell = [tableView dequeueReusableCellWithIdentifier:levelCellIdentifier forIndexPath:indexPath];
            cell.sub_titleLb.text = levelArray[indexPath.row];

            if ([currTitle isEqualToString:cell.sub_titleLb.text]) {
                cell.backgroundColor = [UIColor colorWithRed:0.941 green:0.937 blue:0.929 alpha:1];
                cell.sub_titleLb.textColor = kSelectTitleColor;
                cell.rightView.backgroundColor = [UIColor colorWithRed:0.941 green:0.937 blue:0.929 alpha:1];
            }
            return cell;
    }
    if (currType == SelectTypeOfClass) {
        if (tableView.tag == 100) {
            ClassCell *cell = [tableView dequeueReusableCellWithIdentifier:classCellIdentifier forIndexPath:indexPath];
            cell.sub_titleLb.text = classArray[indexPath.row];
            if ([currTitle isEqualToString:cell.sub_titleLb.text]) {
                cell.backgroundColor = [UIColor colorWithRed:0.941 green:0.937 blue:0.929 alpha:1];
                cell.sub_titleLb.textColor = kSelectTitleColor;
                cell.rightView.backgroundColor = [UIColor colorWithRed:0.941 green:0.937 blue:0.929 alpha:1];
            }
            return cell;
        }
        
    }
    if (currType == SelectTypeOfPlace) {
        ClassCell *cell = [tableView dequeueReusableCellWithIdentifier:placeCellIdentifier forIndexPath:indexPath];
        cell.sub_titleLb.text = placeArray[indexPath.row];
        if ([currTitle isEqualToString:cell.sub_titleLb.text]) {
            cell.backgroundColor = [UIColor colorWithRed:0.941 green:0.937 blue:0.929 alpha:1];
            cell.sub_titleLb.textColor = kSelectTitleColor;
            cell.rightView.backgroundColor = [UIColor colorWithRed:0.941 green:0.937 blue:0.929 alpha:1];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (currType == SelectTypeOfClass) {
        ClassCell* classCell = (ClassCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (self.updateTitle) {
            self.updateTitle(classCell.sub_titleLb.text);
        }
        NSString* classId = classArray[indexPath.row];
        if (self.selected) {
            self.selected(currType,classId);
        }
        [self tappedCancel];
    }
    else if (currType == SelectTypeOfCategory) {
            ClassCell* levelCell = (ClassCell*)[tableView cellForRowAtIndexPath:indexPath];
//            selectMainItem = levelCell.sub_titleLb.text;
                NSString *levelId = levelArray[indexPath.row];

                if (self.updateTitle) {
                    self.updateTitle(levelCell.sub_titleLb.text);
                }
                if (self.selected) {
                    self.selected(currType,levelId);
                }
                [[NSUserDefaults standardUserDefaults] setObject:levelId forKey:@"ZGYLevelType"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self tappedCancel];

    }
    else if (currType == SelectTypeOfPlace) {
        ClassCell* placeCell = (ClassCell*)[tableView cellForRowAtIndexPath:indexPath];
        if (self.updateTitle) {
            self.updateTitle(placeCell.sub_titleLb.text);
        }
        NSString* placeId = placeArray[indexPath.row];
        if (self.selected) {
            self.selected(currType,placeId);
        }
        [self tappedCancel];
    }
}

@end

//
//  ZGYSelectView.m
//  美团下拉菜单
//
//  Created by 赵广印 on 15/11/6.
//  Copyright © 2015年 聚工科技. All rights reserved.
//

#import "ZGYSelectView.h"
#import "Tools.h"
#import "LMDownMenuView2.h"
#define kSelectTitleColor [UIColor colorWithRed:65.0f/255.0f green:145.0f/255.0f blue:228.0f/255.0f alpha:1.0f]

@implementation ZGYSelectView {
    NSMutableArray *buttons;//三个按钮
    NSMutableArray *marks;//三个箭头
    
    BOOL isShow;//操作视图没有收起直接按其他按钮的情况
    NSInteger currTag;//当前选择的按钮Tag
    
    NSArray *bts;
    NSArray *imgs;
    UIView *rootView;
    
    NSString *placeId;
    NSString *classifyId;
    NSString *rankId;
    
    //数据处理
    NSArray *levelArray;//等级数组
    NSArray *classArray;//分类数组
    NSArray *placeArray;//地址数组

    NSString *chuShiZhi;
}


@synthesize delegate = _delegate;


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    bts = @[self.btn_selectArea,self.btn_selectClass,self.btn_selectRank];
    imgs = @[self.img_areaMark,self.img_classMark,self.img_rankMark];
    for (UIImageView* obj in imgs) {
        [obj setImage:[UIImage imageNamed:@"Home-select.png"]];
        obj.contentMode = UIViewContentModeCenter;
    }
    [self.btn_selectArea addTarget:self action:@selector(actionOfClass:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_selectClass addTarget:self action:@selector(actionOfClass:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn_selectRank addTarget:self action:@selector(actionOfClass:) forControlEvents:UIControlEventTouchUpInside];
}

- (id)initWithFrame:(CGRect)frame levelArray:(NSArray *)levelArr classArray:(NSArray *)classArr addressArray:(NSArray *)addressArr title:(NSString *)title isTwo:(BOOL)isTwo {
    levelArray = levelArr;
    classArray = classArr;
    placeArray = addressArr;
    chuShiZhi = title;
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"self.frame = %@",NSStringFromCGRect(frame));
        self.frame = frame;
        
        buttons = [NSMutableArray array];
        marks = [NSMutableArray array];
        
        float ww = frame.size.width/3;
        float hh = frame.size.height;
        
        NSInteger num;
        
        _isSearchView = isTwo;
        if (isTwo) {
            //
            num = 2;
            ww = frame.size.width/2;
        }else{
            num = 3;
        }

        
        for (int i = 0; i<num; i++) {
            UIView* rootV = [[UIView alloc] initWithFrame:CGRectMake(ww*i, 0, ww, hh)];
            rootV.tag = 900+i;
            [self addSubview:rootV];
            
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionOfTap:)];
            [rootV addGestureRecognizer:tap];
            
            UIButton*btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            btn.tag = 1000+i;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [rootV addSubview:btn];
            [buttons addObject:btn];
            
            UIImageView* imgv = [[UIImageView alloc] init];
            imgv.backgroundColor = [UIColor clearColor];
            imgv.image = [UIImage imageNamed:@"Home-select.png"];
            imgv.contentMode = UIViewContentModeCenter;
            [rootV addSubview:imgv];
            [marks addObject:imgv];
        }
        UIButton* classBtn = buttons[0];
        [classBtn addTarget:self action:@selector(actionOfClass:) forControlEvents:UIControlEventTouchUpInside];
        UIButton* areaBtn = buttons[1];
        [areaBtn addTarget:self action:@selector(actionOfClass:) forControlEvents:UIControlEventTouchUpInside];
        if (!isTwo) {
            UIButton* rankBtn = buttons[2];
            [rankBtn addTarget:self action:@selector(actionOfClass:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self relodateTitles];
    }
    return self;
}

- (void)relodateTitles{
    UIButton* classBtn = buttons[0];
    [classBtn setTitle:chuShiZhi forState:UIControlStateNormal];
    classBtn.accessibilityLabel = chuShiZhi;

    UIButton* areaBtn = buttons[1];
    [areaBtn setTitle:classArray[0] forState:UIControlStateNormal];
    areaBtn.accessibilityLabel = areaBtn.titleLabel.text;
    if (!_isSearchView) {
        UIButton* rankBtn = buttons[2];
        [rankBtn setTitle:placeArray[0] forState:UIControlStateNormal];
        rankBtn.accessibilityLabel = rankBtn.titleLabel.text;
    }
    
    [self reloadFrame];
}

- (void)reloadFrame{
    for (int i = 0; i < buttons.count; i++) {
        UIButton* btn = buttons[i];
        UIImageView* markv = marks[i];
        NSString* titleS = btn.titleLabel.text;
        CGSize size = [Tools getSize:titleS andFontOfSize:13];
                CGFloat jxW = (btn.superview.bounds.size.width-size.width-25)/2; //间隙宽度
        btn.frame = CGRectMake(jxW, 0, size.width, 45);
        markv.frame = CGRectMake(btn.frame.origin.x+btn.frame.size.width, 12.5, 20, 20);
    }
}
- (void)actionOfTap:(UITapGestureRecognizer*)sender{
    NSInteger index = sender.view.tag-900;
    UIButton* btn = buttons[index];
    [self actionOfClass:btn];
}

- (void)actionOfClass:(UIButton*)sender{
    
    self.userInteractionEnabled = NO;
    [sender setTitleColor:kSelectTitleColor forState:UIControlStateNormal];
    if (isShow) {
        if (currTag == sender.tag) {
            NSLog(@"移除");
            [self hideSelectView];
        }else {
            NSLog(@"不用移除");
            [self hideSelectView];
            [self performSelector:@selector(showSelectViewOnBtn:) withObject:sender afterDelay:0.4];
        }
    }else{
        [self showSelectViewOnBtn:sender];
    }
}

- (void)showSelectViewOnBtn:(UIButton*)sender{
    
    currTag = sender.tag;
    UIImageView* currImgV = marks[currTag-1000];
    
    currImgV.image = [UIImage imageNamed:@"Home-selected.png"];
    [UIView animateWithDuration:0.35 animations:^{
        currImgV.transform = CGAffineTransformRotate(currImgV.transform, -M_PI);
    } completion:^(BOOL ok){
        if (ok) {
            self.userInteractionEnabled = YES;
        }
    }];
    
    float v_h = self.superview.bounds.size.height-49;
    LMDownMenuView2* cityMenuV = [[LMDownMenuView2 alloc] initWithFrame:CGRectMake(0, 108, self.superview.bounds.size.width, v_h) withSelectType:currTag-1000 levelArray:levelArray classArray:classArray addressArray:placeArray andTitle:sender.titleLabel.text];

    cityMenuV.tag = 100;
    
    [self.superview addSubview:cityMenuV];
    isShow = YES;
    
    NSLog(@"self.frame = %@", NSStringFromCGRect(self.frame));
    NSLog(@"self.superView = %@", NSStringFromCGRect(self.superview.frame));
    NSLog(@"cityMenuV = %@", NSStringFromCGRect(cityMenuV.frame));
    
    //取消
    cityMenuV.removeTheView = ^(BOOL ok){
        currImgV.image = [UIImage imageNamed:@"Home-select.png"];
        [UIView animateWithDuration:0.35 animations:^{
            currImgV.transform = CGAffineTransformRotate(currImgV.transform, M_PI);
        } completion:^(BOOL ok){
            if (ok) {
                self.userInteractionEnabled = YES;
                [sender setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                isShow = NO;
            }
        }];
    };
    
    //更新小标题
    cityMenuV.updateTitle = ^(NSString* str){
        

        [sender setTitle:str forState:UIControlStateNormal];
        sender.accessibilityLabel = str;
        [self reloadFrame];
        UIButton* btn = buttons[1];
        [_delegate selectView:self selectTitle:btn.titleLabel.text];
    };
    
    //选择了一个分类 然后刷新列表
    cityMenuV.selected = ^(SelectType type, NSString* selectid){
        
        switch (type) {
            case SelectTypeOfCategory:{
                placeId = selectid;
                break;
            }
            case SelectTypeOfClass:{
                classifyId = selectid;
                break;
            }
            case SelectTypeOfPlace:{
                rankId = selectid;
                break;
            }
            default:
                break;
        }
        NSLog(@"%@ %@ %@",placeId,classifyId,rankId);
        [_delegate selectView:self selectAreaId:placeId andClassifyId:classifyId andRankId:rankId];
    };
    
}
- (void)hideSelectView{
    LMDownMenuView2* cityMenuV = (LMDownMenuView2*)[self.superview viewWithTag:100];
    if (cityMenuV) {
        [cityMenuV tappedCancel];
    }
}

- (void)hideSelectView2{
    LMDownMenuView2* cityMenuV = (LMDownMenuView2*)[self.superview viewWithTag:100];
    if (cityMenuV) {
        [cityMenuV tappedCancel2];
    }
}
@end

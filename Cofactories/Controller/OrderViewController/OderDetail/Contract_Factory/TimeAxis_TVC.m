//
//  TimeAxis_TVC.m
//  TimeAxle
//
//  Created by GTF on 16/1/5.
//  Copyright © 2016年 GUY. All rights reserved.
//

#define kScrrenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

#define SelfHeight  self.frame.size.height
#define TopViewCenter_X  14 //圆点中心X
#define VerticalLineWidth 1  //线条宽度
#define TextFont  [UIFont systemFontOfSize:12.f]
#import "TimeAxis_TVC.h"
@implementation TimeAxis_TVC{
    UIView *_topView;
    UIView *_lineTop;
    UIView *_lineBottom;
    UIView *_centerView;
    UILabel *_contentLB;
    CALayer *_lineLayer;
    UIImageView *_refrushView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _topView = [UIView new];
        _topView.layer.masksToBounds = YES;
        _topView.layer.cornerRadius = 7;
        _topView.bounds = CGRectMake(0, 0, 14, 14);
        _topView.center = CGPointMake(TopViewCenter_X, TopViewCenter_X);
        _topView.backgroundColor = MAIN_COLOR;
        [self addSubview:_topView];
        
        _centerView = [UIView new];
        _centerView.backgroundColor = [UIColor grayColor];
        _centerView.center = _topView.center;
        _centerView.bounds = CGRectMake(0, 0, 8, 8);
        _centerView.layer.masksToBounds = YES;
        _centerView.layer.cornerRadius = 4;
        [self addSubview:_centerView];
        
        _lineTop = [UIView new];
        _lineTop.backgroundColor = [UIColor grayColor];
        _lineTop.frame = CGRectMake(TopViewCenter_X - VerticalLineWidth/2.f, 0, VerticalLineWidth, TopViewCenter_X - 4);
        [self addSubview:_lineTop];

        _lineBottom = [UIView new];
        _lineBottom.backgroundColor = [UIColor grayColor];
        [self addSubview:_lineBottom];
        
        _contentLB = [[UILabel alloc] init];
        _contentLB.font = TextFont;
        [self addSubview:_contentLB];
        
        _refrushView = [[UIImageView alloc] initWithFrame:CGRectMake(150 , 15, 60, 20)];
        _refrushView.image = [UIImage imageNamed:@"touchRefrush.png"];
        _refrushView.backgroundColor = [UIColor redColor];
        [self addSubview:_refrushView];
        
        _lineLayer = [CALayer layer];
        _lineLayer.backgroundColor = GRAYCOLOR(180).CGColor;
        [self.layer addSublayer:_lineLayer];
    }
    return self;
}

- (void)setData:(NSString *)string isFirst:(BOOL)isFirst isLast:(BOOL)isLast isOnlyOne:(BOOL)isOnlyOne{

    if (isOnlyOne) {
        _lineLayer.hidden = YES;
        _refrushView.hidden = NO;
    }else{
        _lineLayer.hidden = NO;
        _refrushView.hidden = YES;
    }

    if (isFirst) {
        _centerView.hidden = YES;
        _lineTop.hidden = YES;
        _topView.hidden = NO;
        _lineBottom.hidden = NO;
        _lineLayer.hidden = NO;
        _refrushView.hidden = YES;
        _lineBottom.frame = CGRectMake(TopViewCenter_X - VerticalLineWidth/2.f, TopViewCenter_X + 7, VerticalLineWidth, SelfHeight - 7 - 4);
        _contentLB.textColor = MAIN_COLOR;
        
    }else{
        _lineBottom.frame = CGRectMake(TopViewCenter_X - VerticalLineWidth/2.f, TopViewCenter_X + 4, VerticalLineWidth, SelfHeight - 7 - 4);
        _contentLB.textColor = [UIColor grayColor];
        _lineLayer.hidden = NO;
        _refrushView.hidden = YES;
        if (isLast) {
            _centerView.hidden = NO;
            _lineTop.hidden = NO;
            _topView.hidden = YES;
            _lineBottom.hidden = YES;
            _lineLayer.hidden = YES;
            _refrushView.hidden = NO;

        }else{
            _centerView.hidden = NO;
            _lineTop.hidden = NO;
            _topView.hidden = YES;
            _lineBottom.hidden = NO;
            _lineLayer.hidden = NO;
            _refrushView.hidden = YES;
        }
    }
    
    _contentLB.frame = CGRectMake(70, TopViewCenter_X, kScrrenWidth-120, SelfHeight-TopViewCenter_X-20);
    _contentLB.numberOfLines = 0;
    _contentLB.text = string;
    
    _lineLayer.frame = CGRectMake(50, SelfHeight-0.5f, kScrrenWidth-50, 0.5f);

}

+ (CGSize)getCellHeightWithString:(NSString *)string{
    NSDictionary *attribute = @{NSFontAttributeName: TextFont};
    CGSize requiredSize = [string boundingRectWithSize:CGSizeMake(kScrrenWidth-120, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                            attributes:attribute context:nil].size;
    return requiredSize;
}
@end

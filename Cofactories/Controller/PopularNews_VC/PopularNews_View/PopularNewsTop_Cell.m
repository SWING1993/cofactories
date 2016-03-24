//
//  PopularNewsTop_Cell.m
//  Cofactories
//
//  Created by 赵广印 on 16/3/5.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "PopularNewsTop_Cell.h"
#import "PopularNewsModel.h"

@implementation PopularNewsTop_Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        for (int i = 0; i < 2; i++) {
            
            UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(20*kZGY + i*kScreenW/2, 12*kZGY, 12*kZGY, 12*kZGY)];
            photoView.image = [UIImage imageNamed:@"PopularNews-引号"];
            [self addSubview:photoView];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35*kZGY + i*kScreenW/2, 10*kZGY, kScreenW/2 - 40*kZGY - 15*kZGY, 25*kZGY)];
            titleLabel.font = [UIFont boldSystemFontOfSize:14*kZGY];
            [self addSubview:titleLabel];
            
            UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(20*kZGY + i*kScreenW/2, CGRectGetMaxY(titleLabel.frame), kScreenW/2 - 40*kZGY, 25*kZGY)];
            detailLabel.font = [UIFont systemFontOfSize:13*kZGY];
            detailLabel.textColor = GRAYCOLOR(144);
            [self addSubview:detailLabel];
            
            UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
            myButton.frame = CGRectMake(i*kScreenW/2, 0, kScreenW/2, 70*kZGY);
            myButton.backgroundColor = [UIColor clearColor];
            [self addSubview:myButton];
            
            if (i == 0) {
                self.leftButton = myButton;
                self.leftTitle = titleLabel;
                self.leftDetail = detailLabel;
                self.leftImage = photoView;
            } else if (i == 1) {
                self.rightButton = myButton;
                self.rightTitle = titleLabel;
                self.rightDetail = detailLabel;
                self.rightImage = photoView;
            }

        }
        CALayer *line = [CALayer layer];
        line.frame = CGRectMake(kScreenW/2, 0, 0.5, 70*kZGY);
        line.backgroundColor = kLineGrayCorlor.CGColor;
        [self.layer addSublayer:line];
    }
    return self;
}

- (void)reloadDataWithTopNewsArray:(NSMutableArray *)topNewsArray {
    if (topNewsArray.count == 1) {
        PopularNewsModel *newsModel = topNewsArray[0];
        self.leftTitle.text = newsModel.newsTitle;
        self.leftDetail.text = newsModel.discriptions;
        self.rightButton.hidden = YES;
        self.rightImage.hidden = YES;
    } else if (topNewsArray.count > 1) {
        PopularNewsModel *leftNewsModel = topNewsArray[0];
        PopularNewsModel *rightNewsModel = topNewsArray[1];
        self.leftTitle.text = leftNewsModel.newsTitle;
        self.leftDetail.text = leftNewsModel.discriptions;
        self.rightTitle.text = rightNewsModel.newsTitle;
        self.rightDetail.text = rightNewsModel.discriptions;
    }
}
@end

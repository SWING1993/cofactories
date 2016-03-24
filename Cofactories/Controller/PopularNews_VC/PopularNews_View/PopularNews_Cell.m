//
//  PopularNews_Cell.m
//  Cofactories
//
//  Created by 赵广印 on 16/3/5.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "PopularNews_Cell.h"
#import "PopularNewsModel.h"
#define kMargin 20*kZGY //左右边距
#define kNewsPhotoHeight 65*kZGY //图片宽高

@implementation PopularNews_Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //文章作者头像
        self.userPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin, 15*kZGY, 20*kZGY, 20*kZGY)];
        self.userPhoto.layer.cornerRadius = 10*kZGY;
        self.userPhoto.clipsToBounds = YES;
        [self addSubview:self.userPhoto];
        
        //文章类型
        self.newsType = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - kMargin - kNewsPhotoHeight/2, 20*kZGY, kNewsPhotoHeight/2, 15*kZGY)];
        self.newsType.font = [UIFont systemFontOfSize:8*kZGY];
        self.newsType.textAlignment = NSTextAlignmentCenter;
        self.newsType.layer.borderWidth = 1;
        self.newsType.layer.borderColor = kLineGrayCorlor.CGColor;
        self.newsType.layer.cornerRadius = 3;
        self.newsType.clipsToBounds = YES;
        self.newsType.textColor = GRAYCOLOR(144);
        [self addSubview:self.newsType];
        
        //聚工厂
        UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenW - kMargin - kNewsPhotoHeight, CGRectGetMinY(self.newsType.frame), kNewsPhotoHeight/2, CGRectGetHeight(self.newsType.frame))];
        myLabel.font = [UIFont systemFontOfSize:9*kZGY];
        myLabel.text = @"聚工厂";
        myLabel.textColor = GRAYCOLOR(144);
        myLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:myLabel];
        //文章图片
        self.newsPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenW - kMargin - kNewsPhotoHeight, 40*kZGY, kNewsPhotoHeight, kNewsPhotoHeight)];
        self.newsPhoto.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.newsPhoto];
        //文章作者名字
        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userPhoto.frame) + 5*kZGY, 20*kZGY, kScreenW - 2*kMargin - CGRectGetWidth(self.userPhoto.frame) - kNewsPhotoHeight - 30*kZGY, 15*kZGY)];
        self.userName.font = [UIFont systemFontOfSize:10*kZGY];
        self.userName.textColor = GRAYCOLOR(144);
        [self addSubview:self.userName];
        //文章标题
        self.newsTitle = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, CGRectGetMaxY(self.userPhoto.frame) + 2.5*kZGY, kScreenW - 2*kMargin - kNewsPhotoHeight - kMargin, 20*kZGY)];
        self.newsTitle.font = [UIFont boldSystemFontOfSize:13*kZGY];
        [self addSubview:self.newsTitle];
        
        //文章描述
        self.newsDetail = [[UILabel alloc] initWithFrame:CGRectMake(kMargin, CGRectGetMaxY(self.newsTitle.frame), CGRectGetWidth(self.newsTitle.frame), 52.5*kZGY)];
        self.newsDetail.numberOfLines = 3;
        self.newsDetail.font = [UIFont systemFontOfSize:11*kZGY];
        self.newsDetail.textColor = GRAYCOLOR(144);
        [self addSubview:self.newsDetail];
        
        //阅读数图标
        UIImageView *readPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(kMargin, CGRectGetMaxY(self.newsDetail.frame) + 2.5*kZGY, 15*kZGY, 15*kZGY)];
        readPhoto.image = [UIImage imageNamed:@"PopularNews-阅读数"];
        [self addSubview:readPhoto];
        
        //阅读数
        self.readCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(readPhoto.frame) + 10*kZGY, CGRectGetMaxY(self.newsDetail.frame) + 2.5*kZGY, 50*kZGY, 15*kZGY)];
        self.readCount.font = [UIFont systemFontOfSize:10*kZGY];
        self.readCount.textColor = GRAYCOLOR(144);
        [self addSubview:self.readCount];
        
        //评论图标
        UIImageView *commentPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(100*kZGY, CGRectGetMaxY(self.newsDetail.frame) + 2.5*kZGY, 15*kZGY, 15*kZGY)];
        commentPhoto.image = [UIImage imageNamed:@"PopularNews-评论数"];
        [self addSubview:commentPhoto];
        
        //评论数
        self.commentCount = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(commentPhoto.frame) + 10*kZGY, CGRectGetMaxY(self.newsDetail.frame) + 2.5*kZGY, 50*kZGY, 15*kZGY)];
        self.commentCount.font = [UIFont systemFontOfSize:10*kZGY];
        self.commentCount.textColor = GRAYCOLOR(144);
        [self addSubview:self.commentCount];
        
        //线
        CALayer *line = [CALayer layer];
        line.frame = CGRectMake(0, CGRectGetMaxY(self.commentCount.frame) + 5.5*kZGY, kScreenW, 0.5*kZGY);
        line.backgroundColor = kLineGrayCorlor.CGColor;
        [self.layer addSublayer:line];
    }
    return self;
}

- (void)reloadDataWithPopularNewsModel:(PopularNewsModel *)newsModel {
    NSString* userPhotoString = [[NSString stringWithFormat:@"%@/%@", kPopularBaseUrl, newsModel.authorImage] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.userPhoto sd_setImageWithURL:[NSURL URLWithString:userPhotoString] placeholderImage:[UIImage imageNamed:@"ImageLoading"]];
    NSString* newsPhotoString = [[NSString stringWithFormat:@"%@/%@", kPopularBaseUrl, newsModel.newsImage] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.newsPhoto sd_setImageWithURL:[NSURL URLWithString:newsPhotoString] placeholderImage:[UIImage imageNamed:@"ImageLoading"]];
    self.userName.text = newsModel.newsAuthor;
    self.newsType.text = newsModel.newsType;
    self.newsTitle.text = newsModel.newsTitle;
    NSString *string = newsModel.discriptions;
    
    self.newsDetail.attributedText = [PopularNews_Cell getAttributedStringWithString:string];
    self.readCount.text = newsModel.clickNum;
    self.commentCount.text = newsModel.commentNum;
}

+ (NSMutableAttributedString *)getAttributedStringWithString:(NSString *)string {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:4];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    return attributedString;
}
@end

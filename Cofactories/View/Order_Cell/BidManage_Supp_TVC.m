//
//  BidManage_Supp_TVC.m
//  Cofactories
//
//  Created by GTF on 15/12/4.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import "BidManage_Supp_TVC.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
@implementation BidManage_Supp_TVC{
    UILabel      *_nameLB;
    UIButton     *_phoneButton;
    UILabel      *_phoneLB;
    UILabel      *_priceLB;
    UILabel      *_sourceLB;
    UIScrollView *_scrollView;
    NSArray      *_array;
    UILabel      *_descriptionLB;
    NSString     *_userID;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _nameLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 140, 25)];
        _nameLB.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:_nameLB];
        
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(kScreenW-65, 20, 50, 25);
        _selectButton.layer.masksToBounds = YES;
        _selectButton.layer.cornerRadius = 5;
        [_selectButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_selectButton setTitle:@"选择" forState:UIControlStateNormal];
        [self addSubview:_selectButton];
        
        _phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _phoneButton.frame = CGRectMake(15, 30, 30, 30);
        [_phoneButton setBackgroundImage:[UIImage imageNamed:@"phone.png"] forState:UIControlStateNormal];
        [_phoneButton addTarget:self action:@selector(phoneClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_phoneButton];
        
        _phoneLB = [[UILabel alloc] initWithFrame:CGRectMake(45, 30, 100, 25)];
        _phoneLB.font = [UIFont systemFontOfSize:12];
        _phoneLB.textColor = [UIColor grayColor];
        [self.contentView addSubview:_phoneLB];
        
        _priceLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 65, 140, 25)];
        _priceLB.font = [UIFont systemFontOfSize:12];
        _priceLB.textColor = [UIColor grayColor];
        [self.contentView addSubview:_priceLB];
        
        _sourceLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 90, 140, 25)];
        _sourceLB.font = [UIFont systemFontOfSize:12];
        _sourceLB.textColor = [UIColor grayColor];
        [self.contentView addSubview:_sourceLB];

        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(15, 115, kScreenW-30, 60)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        [self addSubview:_scrollView];
        
        _descriptionLB = [[UILabel alloc] initWithFrame:CGRectMake(15, 180, kScreenW-30, 25)];
        _descriptionLB.font = [UIFont systemFontOfSize:12];
        _descriptionLB.textColor = [UIColor grayColor];
        [self addSubview:_descriptionLB];
    }
    return self;
}

- (void)layoutDataWithModel:(BidManage_Supplier_Model *)model{
    _nameLB.text = model.userName;
    _phoneLB.text = model.userphone;
    if ([model.price isEqualToString:@"-1"]) {
        _priceLB.text = @"价格           面议";
    }else{
        _priceLB.text = [NSString stringWithFormat:@"价格          %@元",model.price];
    }
    _sourceLB.text = [NSString stringWithFormat:@"货源状态   %@",model.source];
    
    if (model.photoArray.count == 0) {
        _scrollView.contentSize = CGSizeMake(60, 60);
        UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        bg.image = [UIImage imageNamed:@"placeHolderImage"];
        [_scrollView addSubview:bg];
        
    }else if (model.photoArray.count > 0){
    
        _scrollView.contentSize = CGSizeMake(70 * model.photoArray.count, 60);
        _array = model.photoArray;
        for (int i = 0; i < model.photoArray.count; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,model.photoArray[i]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeHolderImage"]];
            [button setFrame:CGRectMake(i * 70, 0, 60, 60)];
            [button addTarget:self action:@selector(MJPhotoBrowserClick:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = i;
            [_scrollView addSubview:button];
            
        }
    }
    
    _descriptionLB.text = [NSString stringWithFormat:@"备注信息: %@",model.descriptions];
    _userID = model.userID;
}

- (void)MJPhotoBrowserClick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[_array count]];
    [_array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        MJPhoto *photo = [[MJPhoto alloc] init];
        // photo.image = self.collectionImage[idx]; // 图片
        photo.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PhotoAPI,_array[idx]]];
        [photos addObject:photo];
    }];
    
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = button.tag;
    browser.photos = photos;
    [browser show];

}

- (void)phoneClick{
    NSString *str = [NSString stringWithFormat:@"telprompt://%@", _phoneLB.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    [HttpClient statisticsWithKey:@"phoneCall" withUid:_userID andBlock:^(NSInteger statusCode) {
        DLog(@"------------%ld--------",(long)statusCode);
    }];
}

@end

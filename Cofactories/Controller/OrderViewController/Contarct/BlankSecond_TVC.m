//
//  BlankSecond_TVC.m
//  Cofactories
//
//  Created by GTF on 16/1/12.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import "BlankSecond_TVC.h"

@implementation BlankSecond_TVC{
    UILabel             *_titleLB;
    UILabel             *_selectLabelOne;
    UILabel             *_selectLabelTwo;
    NSMutableArray      *_container;
    NSString            *_deliveryString;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _deliveryString = @"once";
        [[NSUserDefaults standardUserDefaults] setObject:_deliveryString forKey:@"selectedIndexOne"];
        _container = [@[] mutableCopy];
        
        _titleLB = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, 100, 44)];
        _titleLB.font = [UIFont systemFontOfSize:13];
        [self addSubview:_titleLB];
        
        for (int i = 0; i<2; i++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(130+i*100, 15, 14, 14);
            button.backgroundColor = [UIColor whiteColor];
            button.layer.masksToBounds = YES;
            button.layer.borderWidth = 1;
            button.tag = i;
            button.layer.borderColor = [UIColor grayColor].CGColor;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(150+i*100, 0, 80, 44)];
            label.font = [UIFont systemFontOfSize:13];
            label.textColor = GRAYCOLOR(196);
            [self addSubview:label];
            
            if (i==0) {
                _selectButtonOne = button;
                _selectButtonOne.backgroundColor = MAIN_COLOR;
                [_container addObject:_selectButtonOne];
                _selectLabelOne = label;
            }else{
                _selectButtonTwo = button;
                _selectLabelTwo = label;
            }
        }
        
    }
    return self;
}

- (void)loadDataWithIndexpath:(NSIndexPath *)indexPath titleString:(NSString *)titleString selectArray:(NSArray *)selectArray{
    
    _titleLB.text = titleString;
    _selectLabelOne.text = selectArray[0];
    _selectLabelTwo.text = selectArray[1];
}

- (void)buttonClick:(id)sender{
    
    UIButton *button = (UIButton *)sender;
    button.backgroundColor = MAIN_COLOR;
    UIButton *lastButton = _container[0];
    lastButton.backgroundColor = [UIColor whiteColor];
    
    [_container removeAllObjects];
    [_container addObject:button];
    
    if (button.tag == 0) {
        _deliveryString = @"once";
    }else if (button.tag == 1){
        _deliveryString = @"batch";
    }
    [[NSUserDefaults standardUserDefaults] setObject:_deliveryString forKey:@"selectedIndexOne"];
}



@end

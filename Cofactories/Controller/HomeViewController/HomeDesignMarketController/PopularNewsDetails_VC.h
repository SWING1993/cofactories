//
//  PopularNewsDetails_VC.h
//  Cofactories
//
//  Created by 赵广印 on 15/12/18.
//  Copyright © 2015年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopularNewsModel.h"

@interface PopularNewsDetails_VC : UIViewController
@property (nonatomic, strong) NSString *newsID;
@property (nonatomic, strong) NSString *lijoString;
@property (nonatomic, strong) PopularNewsModel *popularNewsModel;

@end

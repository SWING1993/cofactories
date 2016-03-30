//
//  IMSearchResult_VC.h
//  Cofactories
//
//  Created by 赵广印 on 16/3/28.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Business_Supplier_Model.h"
@class IMSearchResult_VC;
@protocol IMSearchResult_VCDelegate <NSObject>

- (void)IMSearchResult_VC:(IMSearchResult_VC *)searchResultVC myModel:(Business_Supplier_Model *)myModel;

@end

@interface IMSearchResult_VC : UITableViewController

@property (nonatomic, strong) NSArray *searchResultArray;
@property (nonatomic, weak) id<IMSearchResult_VCDelegate>delegate;

//@property (nonatomic, strong) void(^searchModel)(Business_Supplier_Model *myModel);

@end

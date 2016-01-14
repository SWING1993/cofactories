//
//  Contract_VC.h
//  Cofactories
//
//  Created by GTF on 16/1/13.
//  Copyright © 2016年 Cofactorios. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SignContractDelgate <NSObject>
@required
- (void)signContract;
@end

@interface Contract_VC : UIViewController
@property (nonatomic,assign)BOOL   isClothing;  //是否从服装厂进入该界面
@property (nonatomic,copy)NSString *orderID;
@property (nonatomic,strong)NSData *imageData;
@property (nonatomic,weak)id<SignContractDelgate> signContractDelegate;
@end



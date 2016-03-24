//
//  HttpClient.h
//  Cofactories
//
//  Created by 宋国华 on 15/11/6.
//  Copyright © 2015年 宋国华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFOAuth2Manager.h"
#import "UpYun.h"
#import "SupplierOrderModel.h"
#import "FactoryOrderMOdel.h"
#import "DesignOrderModel.h"
#import "ProcessingAndComplitonOrderModel.h"
#import "BidManage_Supplier_Model.h"
#import "BidManage_Design_Model.h"
#import "BidManage_Factory_Model.h"
#import "OthersUserModel.h"
#import "PersonalShop_Model.h"
#import "DealComment_Model.h"
#import "DealComment_Model.h"

#import "FabricMarketModel.h"

/**
 * 商家模型
 */
#import "Business_Supplier_Model.h"

@interface HttpClient : NSObject

+ (void)iOSLaunchWithDeviceId:(NSString *)deviceId WithClientVersion:(NSString *)clientVersion;


/*User**********************************************************************************************************************************************/

/*!
 发送手机验证码
 
 @param phoneNumber 手机号码(11位)
 @param block       回调函数 会返回 0->(网络错误) 200->(成功) 400->(手机格式不正确) 409->(需要等待冷却) 502->(发送错误)
 */
+ (void)postVerifyCodeWithPhone:(NSString *)phoneNumber andBlock:(void (^)(NSDictionary *responseDictionary))block;
/*!
 校验验证码
 
 @param phoneNumber 手机号码
 @param code        验证码
 @param block       回调函数 会返回 0->(网络错误) 200->(验证码正确) 401->(验证码过期或者无效)
 */
+ (void)validateCodeWithPhone:(NSString *)phoneNumber code:(NSString *)code andBlock:(void (^)(NSInteger statusCode))block;


/*!
 注册账号
  
 @param username            用户名(手机号码)
 @param password            密码
 @param type                工厂类型(enum)
 @param code                验证码
 @param factoryName         工厂名称

 @param block               回调函数 会返回 @{@"statusCode": @201, @"responseObject": 字典}->(注册成功) @{@"statusCode": @401, @"message": @"验证码错误"}->(验证码错误) @{@"statusCode": @409, @"message": @"该手机已经注册过""}->(手机已经注册过) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误)
 */
+ (void)registerWithUsername:(NSString *)username password:(NSString *)password UserRole:(NSString *)role  code:(NSString *)code  UserName:(NSString *)name andBlock:(void (^)(NSDictionary *responseDictionary))block;

/*!
 登录账号
 
 @param username 用户名(手机号码)
 @param password 密码
 @param block    回调函数 会返回 0->(网络错误) 200->(登录成功) 400->(用户名密码错误)
 */
+ (void)loginWithUsername:(NSString *)username Password:(NSString *)password Enterprise:(BOOL)enterprise andBlock:(void (^)(NSInteger statusCode))block;


/*!
 刷新 access_token
 
 @param block 回调函数 会返回 0->(网络错误) 200->(成功) 400->(用户名密码错误) 404->(access_token不存在)
 */
+ (void)validateOAuthWithBlock:(void (^)(NSInteger statusCode))block;

/*!
 返回登录凭据
 
 @return 返回 AFOAuthCredential 包含 access_token 等登录信息
 */
+ (AFOAuthCredential *)getToken;

/*!
 退出账号  删除凭据
 
 @return 返回 BOOL 值表示是否成功删除
 */
+ (BOOL)deleteToken;


/*!
 发送邀请吗
 
 @param inviteCode 邀请码

 */
+ (void)registerWithInviteCode:(NSString *)inviteCode andBlock:(void (^)(NSInteger statusCode))block;

/*!
 重置密码
 
 @param phoneNumber 手机号码(11位)
 @param block       回调函数 会返回 0->(网络错误) 200->(成功) 400->(手机格式不正确) 409->(需要等待冷却) 502->(发送错误)
 */
+ (void)postResetPasswordWithPhone:(NSString *)phoneNumber code:(NSString *)code password:(NSString *)password andBlock:(void (^)(NSInteger statusCode))block;
/*!
 修改密码
 
 @param password    旧密码
 @param newPassword 新密码
 @param block       回调函数 会返回 0->(网络错误) 200->(成功) 403->(旧密码错误) 404->(access_token不存在)
 */
+ (void)changePassword:(NSString *)oldPassword newPassword:(NSString *)newPassword andBlock:(void (^)(NSInteger statusCode))block;


/*!
 获取用户资料
 
 @param block 回调函数 会返回 @{@"statusCode": @200, @"model": UserModel对象}->(获取成功) @{@"statusCode": @0, @"message": @"网络错误"}->(网络错误) @{@"statusCode": @400, @"message": @"未登录"} @{@"statusCode": @401, @"message": @"access_token过期或者无效"} @{@"statusCode": @404, @"message": @"access_token不存在"}
 */
+ (void)getMyProfileWithBlock:(void (^)(NSDictionary *responseDictionary))block;

/**
 *  修改自己的资料
 *   address 地址，需要拼接上完整的省市区
 province 市
 district 区
 description 备注
 scale 规模
 subRole 第二身份
 *  @param Dic   修改的字典
 *  @param block 返回状态码 200为修改成功
 */
+ (void)postMyProfileWithDic:(NSMutableDictionary *)Dic andBlock:(void (^)(NSInteger statusCode))block;



/**
 *  统计报告
 *
 *  @param key   IMChat 即时聊天 phoneCall 通话记录
 *  @param uid   用户uid
 *  @param block  回调statusCode
 */
+ (void)statisticsWithKey:(NSString *)key withUid:(NSString *)uid andBlock:(void (^)(NSInteger statusCode))block;

/**
 *  获取自己的钱包
 *
 *  @param block 回调函数  200 OK  返回钱包Model
 
 */
+ (void)getwalletWithBlock:(void (^)(NSDictionary *responseDictionary))block;

/**
 *  Wallet - 充值
 *
 *  @param block 返回参数
 */
+ (void)walletWithFee:(NSString *)fee WihtCharge:(void (^)(NSDictionary *responseDictionary))block;

/**
 *  Wallet - 充值
 *
 *  @param fee   money
 *  @param block 返回参数
 */
+ (void)walletEnterpriseWithFee:(NSString *)fee wihtCharge:(void (^)(NSDictionary *responseDictionary))block;


/**
 *  钱包订单详情
 *
 *  @param orderSpec
 *  @param block     返回参数
 */
+ (void)walletsignwithOrderSpec:(NSString *)orderSpec andBlock:(void (^)(NSDictionary *responseDictionary))block;

/**
 *  钱包历史记录
 *
 *  @param page  第几页
 *  @param block 返回data
 */
+ (void)walletHistoryWithPage:(NSNumber *)page WithBlock:(void (^)(NSDictionary *responseDictionary))block;

/**
 *  提现
 *
 *  @param fee     提现金额
 *  @param method  提现方式(将来万一加入微信啥的) 允許值: alipay
 *  @param account 提现账号
 *  @param block   回调block
 */
+ (void)walletWithDrawWithFee:(NSString *)fee WithMethod:(NSString *)method WithAccount:(NSString *)account  andBlock:(void (^)(NSInteger statusCode))block;

/**
 *  上传认证资料
 *
 *  @param enterpriseName    企业名称
 *  @param personName        法人姓名
 *  @param idCard            身份证号
 *  @param enterpriseAddress 企业地址
 *  @param block             返回状态码 200为成功
 */
+ (void)postVerifyWithenterpriseName:(NSString *)enterpriseName withpersonName:(NSString *)personName withidCard:(NSString *)idCard withenterpriseAddress:(NSString *)enterpriseAddress andBlock:(void (^)(NSInteger statusCode))block;

/**
 *  上传照片
 *
 *  @param type  头像还是图片 允許值: avatar, photo
 *  @param block 200 成功 401 未登录
 */
+ (void)uploadPhotoWithType:(NSString *)type WithImage:(UIImage *)image andBlock:(void (^)(NSInteger statusCode))block;

/*Config**********************************************************************************************************************************************/
/**
 *  获取广告
 *
 *  @param block 返回参数 200 广告Model
 */

+ (void)getConfigWithType:(NSString *)type WithBlock:(void (^)(NSDictionary *responseDictionary))block;

//获取活动列表
+ (void)getActivityWithBlock:(void (^)(NSDictionary *responseDictionary))block;


// 获取用户评论
+ (void)getUserCommentWithUserID:(NSString *)aUserID page:(NSNumber *)aPage WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;



// 获取他人信息
+ (void)getOtherIndevidualsInformationWithUserID:(NSString *)userID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;



// 商家汇总（找合作商，找厂家）
+ (void)searchBusinessWithRole:(NSString *)aRole scale:(NSString *)aScale province:(NSString *)aProvince city:(NSString *)aCity subRole:(NSString *)aSubRole keyWord:(NSString *)aKeyWord verified:(NSString *)aVerified page:(NSNumber *)aPage WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;


// 发布供应商订单
+ (void)publishSupplierOrderWithType:(NSString *)aType name:(NSString *)aName amount:(NSString *)aAmount unit:(NSString *)aUnit description:(NSString *)aDescription WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 发布找工厂订单
+ (void)publishFactoryOrderWithSubrole:(NSString *)aSubrole type:(NSString *)aType amount:(NSString *)aAmount deadline:(NSString *)aDeadline description:(NSString *)aDescription credit:(NSString *)aCredit WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 发布设计商订单
+ (void)publishDesignOrderWithName:(NSString *)aName description:(NSString *)aDescription WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 搜索供应商订单
+ (void)searchSupplierOrderWithKeyword:(NSString *)aKeyword type:(NSString *)aType pageCount:(NSNumber *)aPageCount WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 搜索找工厂订单
+ (void)searchFactoryOrderWithKeyword:(NSString *)aKeyword type:(NSString *)aType amount:(NSArray *)aAmount deadline:(NSString *)aDeadline pageCount:(NSNumber *)aPageCount WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 搜索设计商订单
+ (void)searchDesignOrderWithKeyword:(NSString *)aKeyword pageCount:(NSNumber *)aPageCount WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 获取供应商订单详情
+ (void)getSupplierOrderDetailWithID:(NSString *)aID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 获取找工厂订单详情
+ (void)getFactoryOrderDetailWithID:(NSString *)aID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 获取设计商订单详情
+ (void)getDesignOrderDetailWithID:(NSString *)aID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 投标工厂订单
+ (void)bidFactoryOrderWithDiscription:(NSString *)aDiscription orderID:(NSString *)aOrderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 投标供应商订单
+ (void)bidSupplierOrderWithPrice:(NSString *)aPrice source:(NSString *)aSource discription:(NSString *)aDiscription orderID:(NSString *)aOrderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 投标设计订单
+ (void)bidDesignerOrderWithDiscription:(NSString *)aDiscription orderID:(NSString *)aOrderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 获取供应订单竞标用户
+ (void)getSupplierOrderBidUserAmountWithOrderID:(NSString *)aOrderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 获取工厂订单竞标用户
+ (void)getFactoryOrderBidUserAmountWithOrderID:(NSString *)aOrderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 获取设计订单竞标用户
+ (void)getDesignOrderBidUserAmountWithOrderID:(NSString *)aOrderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 获取所有用户有关的订单
+ (void)getAllMyOrdersWithOrderStatus:(NSString *)aStatus page:(NSNumber *)aPage WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 关闭供应订单
+ (void)closeSupplierOrderWithOrderID:(NSString *)aOrderID winnerUserID:(NSString *)aWinnerUserID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 关闭工厂订单
+ (void)closeFactoryOrderWithOrderID:(NSString *)aOrderID winnerUserID:(NSString *)aWinnerUserID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 关闭设计订单
+ (void)closeDesignOrderWithOrderID:(NSString *)aOrderID winnerUserID:(NSString *)aWinnerUserID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 评价供应商订单
+ (void)judgeSupplierOrderWithOrderID:(NSString *)aOrderID score:(NSString *)aScore comment:(NSString *)aComment WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 评价工厂订单
+ (void)judgeFactoryOrderWithOrderID:(NSString *)aOrderID score:(NSString *)aScore comment:(NSString *)aComment WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 评价设计订单
+ (void)judgeDesignOrderWithOrderID:(NSString *)aOrderID score:(NSString *)aScore comment:(NSString *)aComment WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 签署协议
+ (void)signContractWithName:(NSString *)name fee:(NSString *)fee amount:(NSString *)amount delivery:(NSString *)delivery deadline:(NSString *)deadline  address:(NSString *)address  carriage:(NSString *)carriage  payStartDate:(NSString *)payStartDate  payStartFee:(NSString *)payStartFee  payEndDate:(NSString *)payEndDate  payEndDay:(NSString *)payEndDay orderID:(NSString *)orderID preview:(NSString *)preview WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 获取合同图片
+ (void)getContractImageWithOrderID:(NSString *)orderID WithCompletionBlock:(void(^)(UIImage *image))completionBlock;

// 加工厂同意签署协议
+ (void)factorySignContractWithOrderID:(NSString *)orderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 添加订单进度消息
+ (void)addOrderMessageWithOrderID:(NSString *)orderID message:(NSString *)message WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;
// 获取订单进度消息
+ (void)getOrderMessageWithOrderID:(NSString *)orderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;
// 首款支付
+ (void)payFirstWithOrderID:(NSString *)orderID payWay:(NSString *)payWay WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;
// 限制订单完成
+ (void)finishRestrictOrderWithOrderID:(NSString *)orderID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 获取店铺
+ (void)getUserShopWithUserID:(NSString *)aUserID page:(NSNumber *)aPage WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;


//获取认证信息
+ (void)getVerifyWithBlock:(void (^)(NSDictionary *responseDictionary))block;
/**
 *  上传认证资料和图片
 *
 *  @param enterpriseName    企业名称
 *  @param personName        法人姓名
 *  @param idCard            身份证号
 *  @param enterpriseAddress 企业地址
 
 *  @param idCardImage       身份证正面照片
 *  @param idCardBackImage   身份证反面照片
 *  @param licenseImage      营业执照照片
 
 *  @param block             返回状态码 200为成功
 */

+ (void)postVerifyWithenterpriseName:(NSString *)enterpriseName withenterpriseAddress:(NSString *)enterpriseAddress withpersonName:(NSString *)personName withidCard:(NSString *)idCard idCardImage:(UIImage *)idCardImage idCardBackImage:(UIImage *)idCardBackImage licenseImage:(UIImage *)licenseImage andBlock:(void (^)(NSInteger statusCode))block;

/*********************************IM聊天***************************************
 */
/**
 *获取融云的Token
 */

+ (void)getIMTokenWithBlock:(void (^)(NSDictionary *))block;

/*********************************流行资讯***************************************
 */
//获取搜索内容
+ (void)searchPopularNewsWithKeyword:(NSString *)keyWord WithBlock:(void (^)(NSDictionary *dictionary))block;
//获取两篇置顶文章
+ (void)getPopularNewsWithBlock:(void (^)(NSDictionary *dictionary))block;
//根据分类获取六篇显示的文章
+ (void)getSixPopularNewsListWithCategory:(NSInteger)category withBlock:(void (^)(NSDictionary *dictionary))block;

/**********************************商城模块****************************************
 */

// 发布设计（商城 店铺）
+ (void)publishDesignWithMarket:(NSString *)aMarket name:(NSString *)aName type:(NSString *)aType part:(NSString *)aPart price:(NSString *)aPrice marketPrice:(NSString *)aMarketPrice country:(NSString *)aCountry amount:(NSString *)aAmount description:(NSString *)aDescription category:(NSArray *)aCategory WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 发布面料、辅料、机械设备（商城 店铺）
+ (void)publishFabricWithMarket:(NSString *)aMarket name:(NSString *)aName type:(NSString *)aType price:(NSString *)aPrice marketPrice:(NSString *)aMarketPrice amount:(NSString *)aAmount unit:(NSString *)aUnit description:(NSString *)aDescription category:(NSArray *)aCategory WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 搜索设计（商城，市场）
+ (void)searchDesignWithMarket:(NSString *)aMarket type:(NSString *)aType part:(NSString *)aPart price:(NSString *)aPrice priceOrder:(NSString *)aPriceOrder keyword:(NSString *)aKeyword province:(NSString *)aProvince city:(NSString *)aCity country:(NSString *)aCountry aCreatedAt:(NSString *)aCreatedAt page:(NSNumber *)aPage WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 搜索面料、辅料、机械设备（商城））
+ (void)searchFabricWithMarket:(NSString *)aMarket type:(NSString *)aType price:(NSString *)aPrice priceOrder:(NSString *)aPriceOrder keyword:(NSString *)aKeyword province:(NSString *)aProvince city:(NSString *)aCity page:(NSNumber *)aPage WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 获取面料、辅料、机械设备、设计 详情（商城）
+ (void)getFabricDetailWithId:(NSString *)aID WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

// 获取店铺(我的店铺)
+ (void)getMyShopWithUserID:(NSString *)aUserID page:(NSNumber *)aPage WithCompletionBlock:(void(^)(NSDictionary *dictionary))completionBlock;

//删除店铺里的商品
+ (void)deleteUserShopWithShopID:(NSString *)aShopID withCompletionBlock:(void(^)(int statusCode))block;

//立即拍下
+ (void)getMallOrderWithDictionary:(NSData *)mallOrderDic withBlock:(void(^)(NSDictionary *dictionary))block;

//查看商城购买记录
+ (void)getMallOrderOfBuyWithStatus:(NSString *)aStatus page:(NSNumber *)aPage WithBlock:(void(^)(NSDictionary *dictionary))block;

//商城付款
+ (void)buyGoodsWithPurchaseId:(NSString *)purchaseId payment:(NSString *)payment WithBlock:(void(^)(NSDictionary *dictionary))block;

//查看商城出售记录
+ (void)getMallOrderOfSellWithStatus:(NSString *)aStatus page:(NSNumber *)aPage WithBlock:(void(^)(NSDictionary *dictionary))block;

//商城卖家确认发货
+ (void)sellerSendGoodsToBuyerWithPurchaseId:(NSString *)purchaseId WithBlock:(void(^)(NSDictionary *dictionary))block;

//商城买家家确认收货
+ (void)buyerReceiveGoodsFromSellerWithPurchaseId:(NSString *)purchaseId WithBlock:(void(^)(NSDictionary *dictionary))block;

//商城评论
+ (void)mallCommentWithPurchseId:(NSString *)purchseId score:(NSString *)aScore comment:(NSString *)aComment WithBlock:(void(^)(NSDictionary *dictionary))block;

//获取交易订单详情
+ (void)getMallOrderDetailWithPurchseId:(NSString *)purchseId WithBlock:(void(^)(NSDictionary *dictionary))block;
//钱包流水记录
+ (void)getWalletHistoryWithPage:(NSNumber *)aPage WithBlock:(void(^)(NSDictionary *responseDictionary))block;

@end

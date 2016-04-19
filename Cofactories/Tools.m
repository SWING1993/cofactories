//
//  Tools.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/13.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Tools.h"
#import "AFNetworking.h"
#import "JKAssets.h"
#import "JKPromptView.h"
#import <Accelerate/Accelerate.h>
#define kKeyWindow [UIApplication sharedApplication].keyWindow
#import "ZGYMallSelectModel.h"


@implementation Tools

+ (NSMutableArray *)RangeSizeWith:(NSString *)sizeString {
    
    
    NSMutableArray*mutableArray=[[NSMutableArray alloc]initWithCapacity:0];
    
    if ([sizeString rangeOfString:@"万件"].location !=NSNotFound) {
        
        NSArray*sizeArray=[sizeString componentsSeparatedByString:@"-"];
        
        //最小值
        NSString*firstSizeString = [sizeArray firstObject];
        NSArray*firstArray=[firstSizeString componentsSeparatedByString:@"万件"];
        NSString*min=[NSString stringWithFormat:@"%@0000",[firstArray firstObject]];
        NSNumber*sizeMin = [[NSNumber alloc]initWithInteger:[min integerValue]];
        [mutableArray addObject:sizeMin];
        
        //最大值
        NSString*lastSizeString = [sizeArray lastObject];
        NSArray*lastArray=[lastSizeString componentsSeparatedByString:@"万件"];
        NSString*max=[NSString stringWithFormat:@"%@0000",[lastArray firstObject]];
        NSNumber* sizeMax= [[NSNumber alloc]initWithInteger:[max integerValue]];
        [mutableArray addObject:sizeMax];
        
    }
    else if ([sizeString rangeOfString:@"人"].location !=NSNotFound) {
        
        NSArray*sizeArray=[sizeString componentsSeparatedByString:@"-"];
        
        //最小值
        NSString*firstSizeString = [sizeArray firstObject];
        NSArray*firstArray=[firstSizeString componentsSeparatedByString:@"人"];
        NSString*min=[firstArray firstObject];
        NSNumber*sizeMin = [[NSNumber alloc]initWithInteger:[min integerValue]];
        [mutableArray addObject:sizeMin];
        
        //最大值
        NSString*lastSizeString = [sizeArray lastObject];
        NSArray*lastArray=[lastSizeString componentsSeparatedByString:@"人"];
        NSString*max=[lastArray firstObject];
        NSNumber* sizeMax= [[NSNumber alloc]initWithInteger:[max integerValue]];
        [mutableArray addObject:sizeMax];
    }
    
    DLog(@"SizeArray == %@",mutableArray);
    return mutableArray;
}

+ (NSMutableArray *)WithTime:(NSString *)timeString {
    NSMutableArray*mutableArray=[[NSMutableArray alloc]initWithCapacity:0];
    NSArray*sizeArray=[timeString componentsSeparatedByString:@"T"];
    NSString*yearString = [sizeArray firstObject];
    NSString*dayString = [sizeArray lastObject];
    [mutableArray addObject:yearString];
    [mutableArray addObject:dayString];
    return mutableArray;
}


+ (MBProgressHUD *)createHUD {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithWindow:window];
    
    [window addSubview:hud];
    [hud show:YES];
    
    return hud;
}

+ (MBProgressHUD *)createHUDWithView:(UIView *)bigView {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:bigView];
    hud.color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [bigView addSubview:hud];
    [hud show:YES];
    
    return hud;
}

+ (void)showHudTipStr:(NSString *)tipStr{
    if (tipStr && tipStr.length > 0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:kKeyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabelFont = [UIFont boldSystemFontOfSize:15.0];
        hud.detailsLabelText = tipStr;
        hud.margin = 12.f;
        hud.removeFromSuperViewOnHide = YES;
        hud.userInteractionEnabled = NO;
        [hud hide:YES afterDelay:1.0];
    }
}

+ (void)showErrorTipStr:(NSString *)tipStr {
    if (tipStr && tipStr.length > 0) {
        [JKPromptView showWithImageName:@"picker_alert_sigh" message:tipStr]; 
    }
}

+ (NSString *)SizeWith:(NSString *)sizeString {
    NSString*string;
    if ([sizeString rangeOfString:@"万件以上"].location !=NSNotFound) {
        NSArray*sizeArray=[sizeString componentsSeparatedByString:@"万件以上"];
        int size = [[sizeArray firstObject] intValue];
        NSString*min=[NSString stringWithFormat:@"%d",size/10000];
        string = [NSString stringWithFormat:@"%@万件以上",min];
    }
    else{
        NSArray*sizeArray=[sizeString componentsSeparatedByString:@"万件"];
        NSString*size = [sizeArray firstObject];
        NSArray*sizeArray2=[size componentsSeparatedByString:@"到"];
        int firstSize = [[sizeArray2 firstObject] intValue];
        int lastSize = [[sizeArray2 lastObject] intValue];
        NSString*min=[NSString stringWithFormat:@"%d",firstSize/10000];
        NSString*max=[NSString stringWithFormat:@"%d",lastSize/10000];
        string = [NSString stringWithFormat:@"%@万件-%@万件",min,max];
    }
    return string;
}

//判断几天后
+ (NSString *)compareIfTodayAfterDates:(NSDate *)comps
{
    NSDate *todate = [NSDate date];//今天
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSChineseCalendar];
    NSDateComponents *comps_today= [calendar components:(NSYearCalendarUnit |
                                                         NSMonthCalendarUnit |
                                                         NSDayCalendarUnit |
                                                         NSWeekdayCalendarUnit) fromDate:todate];
    
    
    NSDateComponents *comps_other= [calendar components:(NSYearCalendarUnit |
                                                         NSMonthCalendarUnit |
                                                         NSDayCalendarUnit |
                                                         NSWeekdayCalendarUnit) fromDate:comps];
    
    
    
    long year = comps_other.year-comps_today.year;
    long month = comps_other.month - comps_today.month;
    long day = comps_other.day - comps_today.day;
    
    long x = year*365 + month*30 + day;
    
    return [NSString stringWithFormat:@"%ld天后",x];
    
}


+ (UIImage *)imageBlur:(UIImage *)aImage {
    
    DLog(@"高斯模糊");
    //boxSize必须大于0
    int boxSize = (int)(0.2f * 100);
    boxSize -= (boxSize % 2) + 1;
    DLog(@"boxSize:%i",boxSize);
    //图像处理
    CGImageRef img = aImage.CGImage;
    //需要引入
    /*
     This document describes the Accelerate Framework, which contains C APIs for vector and matrix math, digital signal processing, large number handling, and image processing.
     本文档介绍了Accelerate Framework，其中包含C语言应用程序接口（API）的向量和矩阵数学，数字信号处理，大量处理和图像处理。
     */
    
    //图像缓存,输入缓存，输出缓存
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    //像素缓存
    void *pixelBuffer;
    
    //数据源提供者，Defines an opaque type that supplies Quartz with data.
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    // provider’s data.
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    
    //宽，高，字节/行，data
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    //像数缓存，字节行*图片高
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    
    // 第三个中间的缓存区,抗锯齿的效果
    void *pixelBuffer2 = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    vImage_Buffer outBuffer2;
    outBuffer2.data = pixelBuffer2;
    outBuffer2.width = CGImageGetWidth(img);
    outBuffer2.height = CGImageGetHeight(img);
    outBuffer2.rowBytes = CGImageGetBytesPerRow(img);
    
    
    //Convolves a region of interest within an ARGB8888 source image by an implicit M x N kernel that has the effect of a box filter.
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer2, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    //error = vImageBoxConvolve_ARGB8888(&outBuffer2, &inBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    
    if (error) {
        DLog(@"error from convolution %ld", error);
    }
    
    
    //NSLog(@"字节组成部分：%zu",CGImageGetBitsPerComponent(img));
    //颜色空间DeviceRGB
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //用图片创建上下文,CGImageGetBitsPerComponent(img),7,8
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             CGImageGetBitmapInfo(aImage.CGImage));
    
    //根据上下文，处理过的图片，重新组件
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    free(pixelBuffer2);
    CFRelease(inBitmapData);
    
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    
    return returnImage;
}


+ (NSString *)getUTCFormateDate:(NSString *)newsDate
{
    //    newsDate = @"2013-08-09 17:01";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSLog(@"newsDate = %@",newsDate);
    NSDate *newsDateFormatted = [dateFormatter dateFromString:newsDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"GMT"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate* current_date = [[NSDate alloc] init];
    
    NSTimeInterval time=[current_date timeIntervalSinceDate:newsDateFormatted];//间隔的秒数
    int month = ((int)time)/(3600*24*30);//月
    int days = ((int)time)/(3600*24);//天
    int hours = ((int)time)%(3600*24)/3600;//小时
    int minute = ((int)time)%(3600)/60;//分钟
    
    NSString *dateContent;
    
    if(month!=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",month,@"个月前"];
        
    }else if (days !=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",days,@"天前"];
    }else if (hours !=0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",hours,@"小时前"];
    }else if (minute != 0){
        
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",minute,@"分钟前"];
    } else {
        //        dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",seconds,@"秒前"];
        dateContent = @"刚刚";
    }
    
    return dateContent;
}


+ (void)AFNetworkReachabilityStatusReachableVia {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //当网络状态发生变化时会调用这个block
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
                DLog(@"WiFi");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                DLog(@"手机网络");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                //                [WSProgressHUD showErrorWithStatus:@"您的网络状态不太顺畅哦！"];
                DLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusUnknown:
                DLog(@"未知网络");
                break;
                
            default:
                break;
        }
    }];
    [manager startMonitoring];
    
}


+ (CGSize)getSize:(NSString *)string andFontOfSize:(CGFloat)fontSize {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize requiredSize = [string boundingRectWithSize:CGSizeMake(kScreenW-20, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                            attributes:attribute context:nil].size;
    return requiredSize;
}
+ (CGSize)getSize:(NSString *)string andFontOfSize:(CGFloat)fontSize andWidthMake:(CGFloat)width {
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]};
    CGSize requiredSize = [string boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                            attributes:attribute context:nil].size;
    return requiredSize;
}

+ (void)removeAllCached {
    DLog(@"清除图片缓存！");
    [[[SDWebImageManager sharedManager] imageCache] clearDisk];
    [[[SDWebImageManager sharedManager] imageCache] clearMemory];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}
+ (UIImageView *)rotate360DegreeWithImageView:(UIImageView *)imageView{
    CABasicAnimation *animation = [ CABasicAnimation
                                   animationWithKeyPath: @"transform" ];
    //围绕Z轴旋转，垂直与屏幕
    animation.fromValue = [ NSValue valueWithCATransform3D:
                           
                           CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0) ];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.duration = 1.5;
    animation.cumulative = YES;
    animation.repeatCount = 1;
    [imageView.layer addAnimation:animation forKey:nil];
    return imageView;
}

+ (NSDictionary *)returenSelectDataDictionaryWithIndex:(NSInteger)index{
    
    NSArray * array = @[@{@"accountType":@[@"用户类型不限",@"企业用户",@"认证用户",@"注册用户"],@"scale":@[@"身份不限",@"个人设计者",@"设计工作室"],@"area":@[@"地区不限",@"浙江",@"安徽",@"广东",@"福建",@"江苏",@"其他"]},
                        @{@"accountType":@[@"用户类型不限",@"企业用户",@"认证用户",@"注册用户"],@"scale":@[@"规模不限",@"0-10万件",@"10-40万件",@"40-100万件",@"100-200万件",@"200万件以上"],@"area":@[@"地区不限",@"浙江",@"安徽",@"广东",@"福建",@"江苏",@"其他"]},
                        @{@"accountType":@[@"用户类型不限",@"企业用户",@"认证用户",@"注册用户"],@"scale":@[@"规模不限"],@"area":@[@"地区不限",@"浙江",@"安徽",@"广东",@"福建",@"江苏",@"其他"]},
                        @{@"accountType":@[@"用户类型不限",@"企业用户",@"认证用户",@"注册用户"],@"scale":@[@"规模不限",@"0-2人",@"2-10人",@"10-20人",@"20人以上"],@"area":@[@"地区不限",@"浙江",@"安徽",@"广东",@"福建",@"江苏",@"其他"]}];
    
    return [array objectAtIndex:index-1];
}
+ (NSDictionary *)goodsSelectDataDictionaryWithIndex:(NSInteger)index {
    NSArray * array = @[@{@"accountType":@[@"全部面料",@"针织",@"梭织",@"特种面料"],@"scale":@[@"价格不限",@"从低到高",@"从高到低"],@"area":@[@"地区不限",@"浙江",@"安徽",@"广东",@"福建",@"江苏",@"其他"]},
                        
                        @{@"accountType":@[@"价格不限",@"从低到高",@"从高到低"], @"area":@[@"地区不限",@"浙江",@"安徽",@"广东",@"福建",@"江苏",@"其他"]},
                        
                        @{@"accountType":@[@"全部设备",@"机械设备",@"配件"],@"scale":@[@"价格不限",@"从低到高",@"从高到低"],@"area":@[@"地区不限",@"浙江",@"安徽",@"广东",@"福建",@"江苏",@"其他"]},
                        
                        @{@"accountType":@[@"不限",@"男装",@"女装",@"男童",@"女童"],@"scale":@[@"价格不限",@"从低到高",@"从高到低"],@"area":@[@"地区不限",@"浙江",@"安徽",@"广东",@"福建",@"江苏",@"其他"]},
                        
                        @{@"accountType":@[@"不限",@"女装",@"童装",@"男装"],@"scale":@[@"价格不限",@"从低到高",@"从高到低"]}];
    
    return [array objectAtIndex:index-1];
}


/**
 *  判断字符串为空和只为空格解决办法
 *
 *  @param string String
 *
 *  @return BOOL
 */
+ (BOOL)isBlankString:(NSString *)string {
    
    if (string == nil) {
        return YES;
    }
    
    if (string == NULL) {
        return YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (UIImage *)captureScrollView:(UIScrollView *)scrollView{
    UIImage* image = nil;
    UIGraphicsBeginImageContext(scrollView.contentSize);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    
    if (image != nil) {
        return image;
    }
    return nil;
}


+ (void)saveImageToMyAlbumWithOrderID:(NSString *)orderID{
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@%@%@%@",kBaseUrl,@"/order/factory/contract/",orderID,@"?access_token=",[HttpClient getToken].accessToken]]];
    UIImage *image = [UIImage imageWithData:data];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo{
    if (error) {
        DLog(@"123456");
    }else{
        DLog(@"87654");
    }
}

+ (void)showOscillatoryAnimationWithLayer:(CALayer *)layer isToBig:(BOOL)isToBig {
    NSNumber *animationScale1 = isToBig == YES ? @(1.15) : @(0.5);
    NSNumber *animationScale2 = isToBig == YES ? @(0.92) : @(1.15);
    
    [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:animationScale1 forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [layer setValue:animationScale2 forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:nil];
        }];
    }];
}

+ (UIButton *)buttonWithFrame:(CGRect)frame withTitle:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15.5];
    button.layer.cornerRadius = 4;
    button.clipsToBounds = YES;
    button.backgroundColor = kMainLightBlueColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    return button;
}

+ (void)upLoadImagesWithArray:(NSMutableArray *)array
                 policyString:(NSString *)policyString
              signatureString:(NSString *)signatureString{
    
    UpYun *upYun = [[UpYun alloc] init];
    upYun.bucket = bucketAPI;//图片测试
    upYun.expiresIn = 600;// 10分钟
    
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ALAssetsLibrary   *lib = [[ALAssetsLibrary alloc] init];
        
        JKAssets *asset = array[idx];
        [lib assetForURL:asset.assetPropertyURL resultBlock:^(ALAsset *asset) {
            if (asset) {
                UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
                [upYun uploadImage:image policy:policyString signature:signatureString];
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }];
}

+ (NSString *)saveImageToLocal:(UIImage *)image imageName:(NSString *)name{
    NSString *documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *filePath = [documentPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];   // 保存文件的名称
    [UIImagePNGRepresentation(image)writeToFile:filePath atomically:YES];
    return filePath;
}
//图片等比压缩
+ (UIImage *)compressPicturesWithImage:(UIImage *)myImage {
    CGFloat imgH = myImage.size.height;
    CGFloat imgW = myImage.size.width;
    if (imgH >= imgW && imgH > 512) {
        myImage = [self thumbnailWithImageWithoutScale: myImage size: CGSizeMake(imgW*512/imgH, 512)];
    } else if (imgW > imgH && imgW > 512) {
        myImage = [self thumbnailWithImageWithoutScale: myImage size: CGSizeMake(512, imgH*512/imgW)];
    }
    NSData *imageData = UIImageJPEGRepresentation(myImage,0.5);
    UIImage*newImage = [UIImage imageWithData:imageData];
    return newImage;
}


+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize {
    UIImage *newimage = nil;
    if (image) {
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        } else {
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

+ (NSMutableDictionary *)initMoreSelectDictionary {
    NSArray *moreTitleArray = @[@"所有分类", @"商品分类", @"款式分类"];
    NSDictionary *bigDic = @{@"所有分类":@[@"不限", @"实拍",@"精品"],
                             @"商品分类":@[@"不限", @"女装",@"童装"],
                             @"款式分类":@[@"不限", @"上装",@"下装", @"套装"]};
    
    NSMutableDictionary *moreDic = [NSMutableDictionary dictionaryWithDictionary:bigDic];
    for (int i = 0; i < moreTitleArray.count; i++) {
        NSMutableArray *array = [moreDic objectForKey:moreTitleArray[i]];
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:0];
        for (int j = 0; j < array.count; j++) {
            ZGYMallSelectModel *selectModel = [[ZGYMallSelectModel alloc] init];
            selectModel.name = bigDic[moreTitleArray[i]][j];
            if ([selectModel.name isEqualToString:@"不限"]) {
                selectModel.mySelect = YES;
            } else {
                selectModel.mySelect = NO;
            }
            [items addObject:selectModel];
        }
        [moreDic setObject:items forKey:moreTitleArray[i]];
    }
    return moreDic;
}

@end

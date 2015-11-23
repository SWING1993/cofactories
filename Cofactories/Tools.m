//
//  Tools.m
//  cofactory-1.1
//
//  Created by 唐佳诚 on 15/7/13.
//  Copyright (c) 2015年 聚工科技. All rights reserved.
//

#import "Tools.h"
#import "AFNetworking.h"
#import <Accelerate/Accelerate.h>

#define kKeyWindow [UIApplication sharedApplication].keyWindow

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


@end

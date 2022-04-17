//
//  XKQRCode.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/2.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKQRCode.h"

@implementation XKQRCode

/** 根据CIImage生成指定大小的UIImage */
+ (UIImage *)createUIImageWithCIImage:(CIImage *)image size:(CGSize)size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size.width/CGRectGetWidth(extent), size.height/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

/**
 生成二维码
 QRStering：字符串
 
 imageFloat：二维码图片大小
 */

+ (UIImage *)createQRCodeWithString:(NSString *)QRString withImgSize:(CGSize)size{
    // 1、创建滤镜对象
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2、恢复滤镜的默认属性
    [filter setDefaults];
    //3、 恢复滤镜的默认属性
    NSData *dataString = [QRString dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:dataString forKey:@"inputMessage"];
    ///获取滤镜输出的图像
    CIImage *outImage = [filter outputImage];
   // UIImage *imageV = [UIImage imageWithCIImage:outImage];
    UIImage *imageV = [self createUIImageWithCIImage:outImage size:size];
    //返回二维码图像
    return imageV;
}


+ (NSString *)parseCodeFromImage:(UIImage *)image{
    if (!image)return nil;
    NSString *result = nil;
    @try {
        // CIDetector(CIDetector可用于人脸识别)进行图片解析，从而使我们可以便捷的从相册中获取到二维码
        // 声明一个CIDetector，并设定识别类型 CIDetectorTypeQRCode
        CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{ CIDetectorAccuracy : CIDetectorAccuracyHigh}];
        // 取得识别结果
        CIImage *ciImage = [CIImage imageWithCGImage:image.CGImage];
        NSArray *features = [detector featuresInImage:ciImage];
        for (int index = 0; index < [features count]; index ++) {
            CIQRCodeFeature *feature = [features objectAtIndex:index];
            NSString *scannedResult = feature.messageString;
            NSLog(@"result:%@",scannedResult);
            if (scannedResult) {
                result = scannedResult;
                break;
            }
        }
    }@catch(...){
        ;
    }
    
    return result;
}


//根据二维码图片设置生成水印图片rect 这里限制水印的图片为二维码的1/4
+(CGRect)getWaterImageRectFromOutputQRImage:(UIImage *)orginQRImage{
    CGSize linkSize = CGSizeMake(orginQRImage.size.width / 4, orginQRImage.size.height / 4);
    CGFloat linkX = (orginQRImage.size.width -linkSize.width)/2;
    CGFloat linkY = (orginQRImage.size.height -linkSize.height)/2;
    return CGRectMake(linkX, linkY, linkSize.width, linkSize.height);
}

+(UIImage*)scaleImage:(UIImage *)image toSize:(CGSize)size{
    size = CGSizeMake(size.width  , size.height );
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width , size.height )];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

//添加水印图片
+ (UIImage *)waterImageWithImage:(UIImage *)image waterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect{
    
    //1.获取图片
    
    //2.开启上下文
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    //3.绘制背景图片
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    //绘制水印图片到当前上下文
    [waterImage drawInRect:rect];
    
    //4.从上下文中获取新图片
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //5.关闭图形上下文
    UIGraphicsEndImageContext();
    //返回图片
    return newImage;
    
}

@end

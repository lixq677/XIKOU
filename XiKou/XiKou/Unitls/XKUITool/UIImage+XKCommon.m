//
//  UIImage+EKCommon.m
//  CallWatch
//
//  Created by kingo on 9/21/15.
//  Copyright © 2015 shenqi329. All rights reserved.
//

#import "UIImage+XKCommon.h"
#import <objc/runtime.h>
#import <float.h>
#import <Accelerate/Accelerate.h>

#import <SDWebImageManager.h>
#import <SDImageCache.h>

@implementation UIImage (XKCommon)

+ (UIImage *)middleStretchableImageWithKey:(NSString *)key {
    UIImage *image = [UIImage imageNamed:key];
    return [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
}


+(UIImage *)imageContentFileWithName:(NSString *)imageName
{
    NSString* type = @"png";
    if([imageName containsString:@"."]){
        type = [imageName pathExtension];
        imageName = [imageName stringByDeletingPathExtension];
    }
    return [self imageContentFileWithName:imageName ofType:type];
}


+(UIImage *)imageContentFileWithName:(NSString *)imageName ofType:(NSString *)type
{
    if([UIScreen mainScreen].scale>=2)
    {
        if(![imageName hasSuffix:@"@2x"])
        {
            imageName = [imageName stringByAppendingString:@"@2x"];
        }
        NSData* imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:type]];
        return [UIImage imageWithData2:imageData scale:2];
    }
    else{
        return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:imageName ofType:type]];
    }
}

//压缩
+ (UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize {
    CGFloat compression = 1.0f;
    CGFloat maxCompression = 0.0f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    while ([imageData length] > maxFileSize && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return compressedImage;
}




//缩放
+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    //UIGraphicsBeginImageContext( newSize );
    UIGraphicsBeginImageContextWithOptions(newSize,NO,[UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
//剪切
+(UIImage *)imageWithImage:(UIImage *)image cutToRect:(CGRect)newRect
{
    CGImageRef subImageRef = CGImageCreateWithImageInRect(image.CGImage, newRect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    // UIGraphicsBeginImageContext(smallBounds.size);
    UIGraphicsBeginImageContextWithOptions(smallBounds.size,NO,[UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    CGImageRelease(subImageRef);
    return smallImage;
}
//等比缩放
+(UIImage *)imageWithImage:(UIImage *)image ratioToSize:(CGSize)newSize
{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    float verticalRadio = newSize.height/height;
    float horizontalRadio = newSize.width/width;
    float radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    width = width*radio;
    height = height*radio;
    
    return [self imageWithImage:image scaledToSize:CGSizeMake(width,height)];
}
//按最短边 等比压缩
+(UIImage *)imageWithImage:(UIImage *)image ratioCompressToSize:(CGSize)newSize
{
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    if(width < newSize.width && height < newSize.height)
    {
        return image;
    }
    else
    {
        return [self imageWithImage:image ratioToSize:newSize];
    }
}
#pragma mark 添加圆角
+(UIImage *)imageWithImage:(UIImage *)image roundRect:(CGSize)size
{
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, (uint32_t)kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0, 0, w, h);
    
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, 5, 5);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    UIImage* image2 =  [UIImage imageWithCGImage:imageMasked];
    CGContextRelease(context);
    CGImageRelease(imageMasked);
    CGColorSpaceRelease(colorSpace);
    return image2;
}
+(UIImage *)imageWithData2:(NSData *)data scale:(CGFloat)scale
{
    return [UIImage imageWithData:data scale:scale];
}
//添加圆角
static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth,
                                 float ovalHeight)
{
    float fw,fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    
    CGContextMoveToPoint(context, fw, fh/2);  // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);  // Top right corner
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1); // Top left corner
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1); // Lower left corner
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1); // Back to lower right
    
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+(UIImage *)imageWithImage:(UIImage *)image darkValue:(float)darkValue
{
    return [UIImage imageWithImage:image pixelOperationBlock:^(UInt8 *redRef, UInt8 *greenRef, UInt8 *blueRef) {
        *redRef = *redRef * darkValue;
        *greenRef = *greenRef * darkValue;
        *blueRef = *blueRef * darkValue;
    }];
}
// 图片处理 0 半灰色  1 灰度   2 深棕色    3 反色
+(UIImage *)imageWithImage:(UIImage *)image grayLevelType:(UIImageGrayLevelType)type{
    return [UIImage imageWithImage:image pixelOperationBlock:^(UInt8 *redRef, UInt8 *greenRef, UInt8 *blueRef) {
        
        UInt8 red = * redRef , green = * greenRef , blue = * blueRef;
        switch (type) {
            case 0:
                *redRef = red * 0.5;
                *greenRef = green * 0.5;
                *blueRef = blue * 0.5;
                break;
            case 1:{
                UInt8 brightness = (77 * red + 28 * green + 151 * blue) / 256;
                *redRef = brightness;
                *greenRef = brightness;
                *blueRef = brightness;
            }
                break;
            case 2:
                *redRef = red;
                *greenRef = green * 0.7;
                *blueRef = blue * 0.4;
                break;
                
            case 3:
                *redRef = 255 - red;
                *greenRef = 255 - green;
                *blueRef = 255 - blue;
                break;
        }
        
    }];
}
+(UIImage *)imageWithImage:(UIImage *)image pixelOperationBlock:(void(^)(UInt8 *redRef, UInt8 *greenRef, UInt8 *blueRef))block
{
    if(block == nil)
        return image;
    
    CGImageRef  imageRef = image.CGImage;
    if(imageRef == NULL)
        return nil;
    
    size_t width  = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    
    size_t bitsPerPixel = CGImageGetBitsPerPixel(imageRef);
    
    size_t bytesPerRow = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    bool shouldInterpolate = CGImageGetShouldInterpolate(imageRef);
    
    CGColorRenderingIntent intent = CGImageGetRenderingIntent(imageRef);
    
    CGDataProviderRef dataProvider = CGImageGetDataProvider(imageRef);
    
    CFDataRef   data = CGDataProviderCopyData(dataProvider);
    UInt8* buffer = (UInt8*)CFDataGetBytePtr(data);
    
    NSUInteger  x, y;
    for (y = 0; y < height; y++) {
        for (x = 0; x < width; x++) {
            UInt8*  tmp;
            tmp = buffer + y * bytesPerRow + x * 4;
            // RGB値を取得
            UInt8 red,green,blue;
            red = *(tmp + 0);
            green = *(tmp + 1);
            blue = *(tmp + 2);
            
            block(&red,&green,&blue);
            
            *(tmp + 0) = red;
            *(tmp + 1) = green;
            *(tmp + 2) = blue;
        }
    }
    
    CFDataRef   effectedData;
    effectedData = CFDataCreate(NULL, buffer, CFDataGetLength(data));
    
    CGDataProviderRef   effectedDataProvider;
    effectedDataProvider = CGDataProviderCreateWithCFData(effectedData);
    
    CGImageRef  effectedCgImage;
    UIImage*    effectedImage;
    effectedCgImage = CGImageCreate(
                                    width, height,
                                    bitsPerComponent, bitsPerPixel, bytesPerRow,
                                    colorSpace, bitmapInfo, effectedDataProvider,
                                    NULL, shouldInterpolate, intent);
    effectedImage = [UIImage imageWithCGImage:effectedCgImage];
    CGImageRelease(effectedCgImage);
    CFRelease(effectedDataProvider);
    CFRelease(effectedData);
    CFRelease(data);
    
    return effectedImage;
}

+ (UIImage*)imageWithColor: (UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    //UIGraphicsBeginImageContext(rect.size);
    UIGraphicsBeginImageContextWithOptions(rect.size,NO,[UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

/**
 *  设置图片透明度
 * @param alpha 透明度
 * @param image 图片
 */
+(UIImage *)imageByApplyingAlpha:(CGFloat )alpha  image:(UIImage*)image{
    if (!image) return image;
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (UIImage *)imageNamed:(NSString *)name alpha:(CGFloat)alpha{
    UIImage *image = [UIImage imageNamed:name];
    return [self imageByApplyingAlpha:alpha image:image];
}

- (UIImage *)circleImage{
    return [UIImage circleImageWithImage:self borderWidth:0.0f borderColor:[UIColor clearColor]];
}

+ (UIImage *)circleImageWithImage:(UIImage *)sourceImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor{
    CGFloat imageWidth = sourceImage.size.width + 2 * borderWidth;
    CGFloat imageHeight = sourceImage.size.height + 2 * borderWidth;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imageWidth, imageHeight), NO, 0.0);
    UIGraphicsGetCurrentContext();
    CGFloat radius = (sourceImage.size.width < sourceImage.size.height?sourceImage.size.width:sourceImage.size.height)*0.5;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(imageWidth * 0.5, imageHeight * 0.5) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    bezierPath.lineWidth = borderWidth;
    [borderColor setStroke];
    [bezierPath stroke];
    [bezierPath addClip];
    [sourceImage drawInRect:CGRectMake(borderWidth, borderWidth, sourceImage.size.width, sourceImage.size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (XKImageType)imageTypeFromData:(NSData *)data{
    XKImageType type = XKImageTypeNone;
    
    if (data.length>0) {
        uint8_t c;
        [data getBytes:&c length:1];
        switch (c) {
            case 0xFF:
                type = XKImageTypeJpg;
                break;
            case 0x89:
                type = XKImageTypePng;
                break;
            case 0x47:
                type = XKImageTypeGif;
                break;
            case 0x49:
            case 0x4D:
                type = XKImageTypeTiff;
            case 0x52:
                // R as RIFF for WEBP
                if ([data length] < 12) {
                    break;
                }
                
                NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
                if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                    type = XKImageTypeWebP;
                }
                
                break;
        }
    }
    return type;
}

+ (UIImage *)snapshotSingleView:(UIView *)view

{
    
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

/**
 *  根据图片url获取网络图片尺寸
 */
+ (CGSize)getImageSizeWithURL:(id)URL{
    NSURL * url = nil;
    if ([URL isKindOfClass:[NSURL class]]) {
        url = URL;
    }
    if ([URL isKindOfClass:[NSString class]]) {
        url = [NSURL URLWithString:URL];
    }
    if (!URL) {
        return CGSizeZero;
    }
    CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
    CGFloat width = 0, height = 0;
    
    if (imageSourceRef) {
        
        // 获取图像属性
        CFDictionaryRef imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, NULL);
        
        //以下是对手机32位、64位的处理
        if (imageProperties != NULL) {
            
            CFNumberRef widthNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelWidth);
            
#if defined(__LP64__) && __LP64__
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat64Type, &width);
            }
            
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat64Type, &height);
            }
#else
            if (widthNumberRef != NULL) {
                CFNumberGetValue(widthNumberRef, kCFNumberFloat32Type, &width);
            }
            
            CFNumberRef heightNumberRef = CFDictionaryGetValue(imageProperties, kCGImagePropertyPixelHeight);
            
            if (heightNumberRef != NULL) {
                CFNumberGetValue(heightNumberRef, kCFNumberFloat32Type, &height);
            }
#endif
            /***************** 此处解决返回图片宽高相反问题 *****************/
            // 图像旋转的方向属性
            NSInteger orientation = [(__bridge NSNumber *)CFDictionaryGetValue(imageProperties, kCGImagePropertyOrientation) integerValue];
            CGFloat temp = 0;
            switch (orientation) {  // 如果图像的方向不是正的，则宽高互换
                case UIImageOrientationLeft: // 向左逆时针旋转90度
                case UIImageOrientationRight: // 向右顺时针旋转90度
                case UIImageOrientationLeftMirrored: // 在水平翻转之后向左逆时针旋转90度
                case UIImageOrientationRightMirrored: { // 在水平翻转之后向右顺时针旋转90度
                    temp = width;
                    width = height;
                    height = temp;
                }
                    break;
                default:
                    break;
            }
            /***************** 此处解决返回图片宽高相反问题 *****************/
            
            CFRelease(imageProperties);
        }
        CFRelease(imageSourceRef);
    }
    return CGSizeMake(width, height);
}

+(UIImage*)imageFromSdcache:(NSString *)url{
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    NSString* key = [manager cacheKeyForURL:[NSURL URLWithString:url]];
    SDImageCache* cache = [SDImageCache sharedImageCache];
    UIImage *image = [cache imageFromDiskCacheForKey:key];
    return image;
}

/*!
 *
 *  @brief 使图片压缩后刚好小于指定大小

 *
 *  @return data对象
 */
//图片质量压缩到某一范围内，如果后面用到多，可以抽成分类或者工具类,这里压缩递减比二分的运行时间长，二分可以限制下限。
- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength {
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(self, compression);
    if (data.length < maxLength) return data;
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(self, compression);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    return data;
}
@end

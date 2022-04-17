//
//  UIImage+EKCommon.h
//  CallWatch
//
//  Created by kingo on 9/21/15.
//  Copyright © 2015 shenqi329. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    UIImageGrayLevelTypeHalfGray    = 0,
    UIImageGrayLevelTypeGrayLevel   = 1,
    UIImageGrayLevelTypeDarkBrown   = 2,
    UIImageGrayLevelTypeInverse     = 3
} UIImageGrayLevelType;

typedef NS_ENUM(NSInteger,XKImageType) {
    XKImageTypeNone,
    XKImageTypeJpg,
    XKImageTypePng,
    XKImageTypeGif,
    XKImageTypeTiff,
    XKImageTypeWebP,
};



@interface UIImage (XKCommon)


+ (UIImage *)middleStretchableImageWithKey:(NSString *)key;
+(UIImage*)imageContentFileWithName:(NSString*)imageName;
+(UIImage*)imageContentFileWithName:(NSString*)imageName ofType:(NSString*)type;

///缩放图片
+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

///剪切
+(UIImage*)imageWithImage:(UIImage*)image cutToRect:(CGRect)newRect;

///等比缩放
+(UIImage*)imageWithImage:(UIImage *)image ratioToSize:(CGSize)newSize;

//压缩
+(UIImage *)compressImage:(UIImage *)image toMaxFileSize:(NSInteger)maxFileSize;

///添加圆角
+(UIImage*)imageWithImage:(UIImage*)image roundRect:(CGSize)size;

///按最短边 等比压缩
+(UIImage*)imageWithImage:(UIImage *)image ratioCompressToSize:(CGSize)newSize;

+(UIImage *)imageWithData2:(NSData *)data scale:(CGFloat)scale;


// 图片处理 0 半灰色  1 灰度   2 深棕色    3 反色
+(UIImage*)imageWithImage:(UIImage*)image grayLevelType:(UIImageGrayLevelType)type;

//色值 变暗多少 0.0 - 1.0
+(UIImage*)imageWithImage:(UIImage*)image darkValue:(float)darkValue;

+ (UIImage*)imageWithColor: (UIColor*) color;

+(UIImage *)imageByApplyingAlpha:(CGFloat )alpha  image:(UIImage*)image;

+ (UIImage *)imageNamed:(NSString *)name alpha:(CGFloat)alpha;

- (UIImage *)circleImage;

+ (XKImageType)imageTypeFromData:(NSData *)data;

// 视图生成图片
+ (UIImage *)snapshotSingleView:(UIView *)view;
/**
 *  根据图片url获取网络图片尺寸
 */
+ (CGSize)getImageSizeWithURL:(id)URL;
/**
 *  根据图片url获取sd缓存图片
 */
+(UIImage*)imageFromSdcache:(NSString *)url;

/*!
 *
 *  @brief 使图片压缩后刚好小于指定大小
 *
 *
 *  @return data对象
 */
//图片质量压缩到某一范围内，如果后面用到多，可以抽成分类或者工具类,这里压缩递减比二分的运行时间长，二分可以限制下限。
- (NSData *)compressQualityWithMaxLength:(NSInteger)maxLength;
@end

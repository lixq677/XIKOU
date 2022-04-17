//
//  XKQRCode.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/2.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKQRCode : NSObject

/**
 
 生成二维码
 
 QRStering：字符串
 
 size：二维码图片大小
 
 */

+ (UIImage *)createQRCodeWithString:(NSString *)QRString withImgSize:(CGSize)size;


/**
 解析二维码图片

 @param image <#image description#>
 @return <#return value description#>
 */
+ (NSString *)parseCodeFromImage:(UIImage *)image;


/**
 添加水印

 @param image <#image description#>
 @param waterImage <#waterImage description#>
 @param rect <#rect description#>
 @return <#return value description#>
 */
+ (UIImage *)waterImageWithImage:(UIImage *)image waterImage:(UIImage *)waterImage waterImageRect:(CGRect)rect;


/**
 更改图片改寸

 @param image <#image description#>
 @param size <#size description#>
 @return <#return value description#>
 */
+ (UIImage*)scaleImage:(UIImage *)image toSize:(CGSize)size;



/**
 给二维码添加水印，占中间1/4

 @param orginQRImage <#orginQRImage description#>
 @return <#return value description#>
 */
+(CGRect)getWaterImageRectFromOutputQRImage:(UIImage *)orginQRImage;

@end

NS_ASSUME_NONNULL_END

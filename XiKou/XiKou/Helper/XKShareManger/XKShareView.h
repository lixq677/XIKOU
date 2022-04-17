//
//  XKShareView.h
//  XiKou
//
//  Created by L.O.U on 2019/7/10.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKShareManger.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    ShareUICenter, //弹窗在中间
    ShareUIBottom, //弹窗在底部
} ShareUIType;

typedef enum : NSUInteger {
    ShareWX,
    ShareCircle,
    ShareSina,
    SharePhoto,
} ShareType;

@class XKShareItemData;
@interface XKShareView : UIView

- (instancetype)initWithType:(ShareUIType)type;

- (void)showWithTitle:(NSString *)title
           andContent:(NSString *__nullable)content
          andPlaforms:(NSArray <XKShareItemData *> *)plaforms
          andComplete:(void(^)(ShareType type))complete;

- (void)dismiss;

@end

@interface XKShareCell: UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLabel;

@end

@interface XKShareItemData : NSObject

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *imgName;

@property (nonatomic, assign) ShareType type;

@end
NS_ASSUME_NONNULL_END

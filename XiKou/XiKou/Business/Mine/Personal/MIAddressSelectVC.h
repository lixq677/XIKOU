//
//  MIAddressSelectVC.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/19.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKAddressData.h"

NS_ASSUME_NONNULL_BEGIN
/**
 通过voData 获取省市区的字符串地址
 
 @param voModel <#voData description#>
 @return <#return value description#>
 */
FOUNDATION_IMPORT NSString *GetAreaAddressWithVoModel(XKAddressVoModel *voModel);


/**
 获取字符串地址

 @param provinceId <#provinceId description#>
 @param cityId <#cityId description#>
 @param districtId <#districtId description#>
 @return <#return value description#>
 */
FOUNDATION_IMPORT NSString *GetAreaAddress( NSNumber * _Nullable provinceId, NSNumber * _Nullable cityId, NSNumber * _Nullable districtId);

@class MIAddressSelectVC;

@protocol MIAddressSelectViewControllerDelegate <NSObject>
@optional

/**
 编辑的地址
 */
- (void)addressSelectViewController:(MIAddressSelectVC *)controller finishEditAddress:(XKAddressVoModel *)voModel;


/**
 编辑的地址
 */
- (void)addressSelectViewController:(MIAddressSelectVC *)controller finishEditAddress:(XKAddressVoModel *)voModel location:(CLLocation *)location;

/**
 自动定位，得到的地址信息
 */
- (void)addressSelectViewController:(MIAddressSelectVC *)controller locationAddress:(XKAddressVoModel *)voModel location:(CLLocation *)location;

/*自动定位失败*/
- (void)addressSelectViewController:(MIAddressSelectVC *)controller locationError:(NSError *)error;

@end

@interface MIAddressSelectVC : UIViewController

- (void)show;

- (void)dismiss;

- (BOOL)isShow;

- (void)editVoData:(XKAddressVoModel *)voData;

@property (nonatomic,assign)XKAddressLevel addressLevel;

@property (nonatomic,assign)BOOL autoLocation;

@property (nonatomic,strong)NSString *sheetTitle;

@property (nonatomic,weak)id<MIAddressSelectViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

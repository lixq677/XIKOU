//
//  XKUserData.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/15.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKUnitls.h"
#import "XKBaseResponse.h"
#import "XKAccountManager.h"
#import <LKDBHelper.h>

NS_ASSUME_NONNULL_BEGIN

@interface XKCodeResponse : XKBaseResponse

@property (nonatomic,strong)XKAccountData *data;

@end

typedef NS_ENUM(int,XKUserType) {
    XKUserTypeNomal =   1,//普通用户
    XKUserTypeVIP   =   2,//VIP用户
};

typedef NS_ENUM(int,XKSexType) {
    XKSexTypeUnknow =   0,//未知
    XKSexTypeMale =   1,//男
    XKSexTypeFemale =   2,//女
};

@interface XKUserInfoData : NSObject <YYModel,NSCopying>
//生日
@property (nonatomic,strong)NSString *barthday;

//实名认证标识：0-未实名认证；1-已实名认知
@property (nonatomic,strong)NSNumber *certification;

//注册时间
@property (nonatomic,strong)NSString *createTime;

//是否删除：0-否（未删除）；1-是（删除）
@property (nonatomic,strong)NSNumber *deleted;

//邮件
@property (nonatomic,strong)NSString *email;

//头像
@property (nonatomic,strong)NSString *headUrl;

//主键ID
@property (nonatomic,strong)NSString *id;

//推荐人id
@property (nonatomic,strong)NSString *inviterId;

//邀请码
@property (nonatomic,strong)NSString *extCode;

//手机号
@property (nonatomic,strong)NSString *mobile;

//昵称
@property (nonatomic,strong)NSString *nickName;

//性别 XKSexType ：1：男；2：女
@property (nonatomic,strong)NSNumber *sex;

//状态：1-正常；2-冻结
@property (nonatomic,strong)NSNumber *status;

//用户名
@property (nonatomic,strong)NSString *userName;

//用户类型：1-普通用户；2-VIP用户 XKUserType
@property (nonatomic,strong)NSNumber *userType;

//优惠券张数
@property (nonatomic,strong)NSNumber *couponNum;

//红包余额
@property (nonatomic,strong)NSNumber *balance;

//关注数
@property (nonatomic,strong)NSNumber *followCnt;

//是否绑定微信
@property (nonatomic,assign)BOOL isBindWX;

@property (nonatomic,strong)NSNumber *isPayPassword;

@end

@interface XKUserInfoResponse : XKBaseResponse

@property (nonatomic,strong)XKUserInfoData *data;

@end


/**
 修改用户信息
 */
@interface XKModifyUserVoParams : NSObject

//生日
@property (nonatomic,strong)NSString *barthday;

//头像
@property (nonatomic,strong)NSString *headUrl;

//主键ID
@property (nonatomic,strong)NSString *id;

//昵称
@property (nonatomic,strong)NSString *nickName;

//性别
@property (nonatomic,strong)NSNumber *sex;

//手机号码
@property (nonatomic,strong)NSString *mobile;

@end

typedef NS_ENUM(int,XKThirdPlatformType) {
    XKThirdPlatformTypeWeXin    =   1,
};

@interface XKRegisterParams : NSObject <YYModel>

@property (nonatomic,strong) NSString *invitationCode;

@property (nonatomic,strong) NSString *mobile;

@property (nonatomic,strong) NSString * thirdId;

@property (nonatomic,assign) NSNumber *type;//XKThirdPlatformType

@property (nonatomic,strong) NSString *validCode;

@end

@interface XKVerifyParams : NSObject <YYModel>
//证件号码
@property (nonatomic,copy) NSString *idCard;
//证件类型：1：身份证
@property (nonatomic,copy) NSString *idType;
//身份证正面图片，预留字段，默认为空
@property (nonatomic,copy) NSString *imgFirst;
//身份证背面图片，预留字段，默认为空
@property (nonatomic,copy) NSString *imgSecond;
//手机号码
@property (nonatomic,copy) NSString *mobile;
//姓名
@property (nonatomic,copy) NSString *realName;
//userid
@property (nonatomic,copy) NSString *userId;

@end

@class XKVerifyInfoData;
@interface XKVerifyInfoResponse : XKBaseResponse

@property (nonatomic,strong) XKVerifyInfoData *data;

@end

@interface XKVerifyInfoData : XKVerifyParams

@property (nonatomic, copy) NSString *createTime;

@end

typedef NS_ENUM(int,XKAccountType) {
    XKAccountTypeDefault    =   1,
};

/**
 支付密码修改参数
 */
@interface XKPayPasswordParams : NSObject <YYModel>

@property (nonatomic,copy) NSString *payPassword;

@property (nonatomic,copy) NSString *confirmPayPassword;

@property (nonatomic,copy) NSString *userId;

@property (nonatomic,copy)NSString *mobile;

@property (nonatomic,copy)NSString *verificationCode;

@property (nonatomic,assign)XKAccountType accountType;

@end

@class XKReferrerData;
@interface XKReferrerResponse : XKBaseResponse

@property (nonatomic,strong) XKReferrerData *data;

@end

@interface XKReferrerData : NSObject<YYModel>

@property (nonatomic,strong) NSString *invitationMobile;//推荐人联系电话

@property (nonatomic,strong) NSString *mobile;//所属城市运营商联系电话

@end

NS_ASSUME_NONNULL_END

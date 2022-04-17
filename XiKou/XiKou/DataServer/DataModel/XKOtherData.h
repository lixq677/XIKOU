//
//  XKOtherData.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/27.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKUnitls.h"
#import "XKBaseResponse.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int,XKTaskStatu) {
    XKTaskStatuUnComplete   =   0,
    XKTaskStatuCompleted    =   1,
};

typedef NS_ENUM(int,XKTaskType) {
    XKTaskTypeShare             =   1,//分享
    XKTaskTypeInviteRegister     =   2,//获取新用户
    XKTaskTypeConsume           =   3,//线下买单
    XKTaskTypeActivity          =   4,//促活
    XKTaskTypeCertification     =   5,//实名认证
};

@interface XKTaskModel : NSObject

@property (nonatomic,assign) int  award;//奖励值

@property (nonatomic,assign) XKTaskStatu  completeStatus;//状态：1 已完成，0 未完成

@property (nonatomic,assign) int  curTimes;//当前完成次数

@property (nonatomic,assign) int  maxTimes;//每天完成最大次数,0表示无限循环，-1表示唯一性任务，不可重复

@property (nonatomic,strong) NSString  *taskExplain;//说明

@property (nonatomic,strong) NSString  *url;//点击跳转的url，可以schema

@property (nonatomic,assign) XKTaskType  type;//类型：1: 分享、2 获客、3 消费、4 促活、5 用户数据


@end

@interface XKTaskData : NSObject

@property (nonatomic,strong) NSString  *userId;//用户id

@property (nonatomic,assign) int todayTotalValue;//当天获得总任务值

@property (nonatomic,assign) int taskValue;//任务值

@property (nonatomic,assign) int maxLimitValue;//任务值

@property (nonatomic,strong) NSArray<XKTaskModel *> *list;

@end

@interface XKTaskResponse : XKBaseResponse

@property (nonatomic,strong) XKTaskData *data;

@end

@interface XKPaySwitchData : NSObject <YYModel>

@property (nonatomic,assign) BOOL assemble;//定制拼团，1：开启，0：关闭

@property (nonatomic,assign) BOOL auction;//0元竞拍，1：开启，0：关闭

@property (nonatomic,assign) BOOL bargin;//砍价得红包，1：开启，0：关闭

@property (nonatomic,assign) BOOL buyGift;//买一赠二(吾G)，1：开启，0：关闭

@property (nonatomic,assign) BOOL globerBuyer;//全球买手，1：开启，0：关闭

@property (nonatomic,assign) BOOL moreDisCount;//多买多折，1：开启，0：关闭

@property (nonatomic,assign) BOOL oto;//oto，1：开启，0：关闭

@property (nonatomic,assign) BOOL nwPerson;//新人专区，1：开启，0：关闭

@end

@interface XKPaySwitchResponse : XKBaseResponse

@property (nonatomic,strong) XKPaySwitchData *data;

@end

@interface XKGroupUp : NSObject

@property (nonatomic,strong)NSString *date;

@property (nonatomic,strong)NSString *name;

@end

@interface XKSocialData : NSObject <YYModel>

@property (nonatomic,assign) NSInteger activities;//活动数

@property (nonatomic,assign) NSInteger collection;//收藏店铺数

@property (nonatomic,assign) NSInteger comments;//评论数

@property (nonatomic,assign) NSInteger  followDisigners;//关注设计师

@property (nonatomic,assign) NSInteger  inviteUsers;//邀请用户数

@property (nonatomic,assign) NSInteger likes;//点赞数

@property (nonatomic,assign) NSInteger  shareGoods;//转发商品数

@property (nonatomic,assign) NSInteger  tasks;//完成任务数

@property (nonatomic,strong)NSArray<XKGroupUp *> *growUps;//成长列表

@property (nonatomic,strong)NSString *userId;

@end

@interface XKSocialResponse : XKBaseResponse

@property (nonatomic,strong) XKSocialData *data;

@end

@interface XKLogisticsContextData : NSObject <YYModel>

@property (nonatomic,strong) NSString *context;//物流轨迹节点内容
@property (nonatomic,strong) NSString *ftime;//格式化后时间
@property (nonatomic,strong) NSString *time;//时间

@end

@interface XKLogisticsData : NSObject <YYModel>

@property (nonatomic,strong) NSString *address;//地址

@property (nonatomic,strong) NSString *areaName;//区
@property (nonatomic,strong) NSString *cityName;//市
@property (nonatomic,strong) NSString *provinceName;//省

@property (nonatomic,strong) NSString *consigneeMobile;//收货人手机号
@property (nonatomic,strong) NSString *consigneeName;//收货人姓名
@property (nonatomic,strong) NSArray<XKLogisticsContextData *> *data;
@property (nonatomic,strong) NSString *logisticsCompany;//快递公司
@property (nonatomic,strong) NSString *logisticsNo;//快递单号
@property (nonatomic,strong) NSString *message;//返回信息，ok表示成功，data有数据，否则直接显示此信息

@end

@interface XKLogisticsResponse : XKBaseResponse

@property (nonatomic,strong)XKLogisticsData *data;

@end

@interface XKBargainScheduleData : NSObject <YYModel>

@property (nonatomic,strong) NSString *assistUserHeadImageUrl;//帮砍用户头像url

@property (nonatomic,strong) NSString *assistUserId;//帮砍用户Id

@property (nonatomic,strong) NSString *assistUserName;//帮砍用户昵称

@property (nonatomic,strong) NSString *bargainScheduleId;//砍价进度Id

@property (nonatomic,strong) NSString *createTime;//参与时间

@property (nonatomic,strong) NSString *id;//规则Id

@property (nonatomic,strong) NSNumber *redPackAmount;//发送红包金额

@property (nonatomic,strong) NSNumber *bargainPrice;//帮砍价格

@end

@interface XKBargainScheduleResponse : XKBaseResponse

@property (nonatomic,strong)NSArray<XKBargainScheduleData *>  *data;

@end

@interface XKVersionParams : NSObject <YYModel>

//@property (nonatomic,strong)NSString *foreignVersionNumber;

@property (nonatomic,assign,readonly)int versionPlatform;//(1:IOS   2:Android)

@end

@interface XKVersionData : NSObject <YYModel>

@property (nonatomic,strong) NSString *id;//主键Id

@property (nonatomic,strong) NSString *appName;//app名称
@property (nonatomic,strong) NSString *appType;//app类别
@property (nonatomic,strong) NSString *foreignVersionNumber;//外部版本号

@property (nonatomic,strong) NSString *internallyVersionNumber;//内部版本号
@property (nonatomic,strong) NSString *versionNotes;//版本说明

@property (nonatomic,assign) BOOL ifForceUpdate;//是否强制更新(0:否    1:是)
@property (nonatomic,assign) BOOL ifImmediatelyEnable;//是否立即启用(0:否    1:是)
@property (nonatomic,assign) BOOL versionStatus;////版本状态(0:无效    1:有效)
@property (nonatomic,strong) NSString *versionUpdateDate;//版本更新时间
@property (nonatomic,strong) NSString *downloadLink;//下载地址
@end

@interface XKVersionResponse : XKBaseResponse

@property (nonatomic,strong)XKVersionData *data;

@end


NS_ASSUME_NONNULL_END

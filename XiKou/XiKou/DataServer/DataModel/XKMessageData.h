//
//  XKMessageData.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/28.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKBaseResponse.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(int,XKMsgType) {
    XKMsgTypeSystem      =   1,//消息类型
    XKMsgTypeOrder       =   2,//订单助手
    XKMsgTypeActivity    =   3,//活动消息
    XKMsgTypeNotice      =   4,//平台公告
};

@interface XKMsgTypeModel : NSObject

@property (nonatomic,assign)XKMsgType id;//

@property (nonatomic,strong)NSString *name;//消息类型名称

@property (nonatomic,assign)int unreadNum;//未读数

@end

@interface XKMsgUnReadData : NSObject

@property (nonatomic,assign)int totalUnreadNum;//总未读数

@property (nonatomic,strong)NSArray<XKMsgTypeModel *> *typesList;

@end

@interface XKMsgUnReadResponse : XKBaseResponse

@property (nonatomic,strong) XKMsgUnReadData *data;

@end


@interface XKMsgParams : NSObject<YYModel>
@property (nonatomic,strong) NSString *userId;//用户id
@property (nonatomic,assign) XKMsgType typeId;//消息类型id
@property (nonatomic,strong) NSNumber *page;//页码
@property (nonatomic,strong) NSNumber *limit;//每页多少条数据

@end

@interface XKMsgData : NSObject <YYModel>

@property (nonatomic,strong) NSString  *content;//内容

@property (nonatomic,strong) NSString  *id;//唯一ID主键

@property (nonatomic,strong) NSString  *img;//市id

@property (nonatomic,assign) BOOL  isRead;//是否已读：1：已读，0：未读

@property (nonatomic,strong) NSString  *sendTime;//发送时间

@property (nonatomic,strong) NSString  *url;//url或者schema

@property (nonatomic,strong) NSString  *title;//标题

@property (nonatomic,assign) XKMsgType msgType;//消息类型 自己装填，非服务器返回

@property (nonatomic,strong) NSString  *userId;//用户id 自己装填，非服务器返回

@end


@interface XKMsgResponse : XKBaseResponse

@property (nonatomic,strong) NSArray<XKMsgData *> *data;

@end


NS_ASSUME_NONNULL_END

//
//  XKEnum.h
//  XiKou
//
//  Created by L.O.U on 2019/7/15.
//  Copyright © 2019 李笑清. All rights reserved.
//

#ifndef XKEnum_h
#define XKEnum_h
//1 （买一赠2(吾G)） 2 （全球买手）  3 （0元竞拍）  4（多买多折） 5（砍立得 红包）6（定制拼团）
typedef enum : NSUInteger {
    Activity_WG  = 1,    // 买一赠2(吾G)
    Activity_Global,     // 全球买手
    Activity_ZeroBuy,    // 0元竞拍
    Activity_Discount,   // 多买多折
    Activity_Bargain,    // 砍立得 红包
    Activity_Custom,     // 定制拼团
    UIActivity_O2O,      //O2O线下
    Activity_NewUser   = 8,//新人专区
} XKActivityType;// 活动类型

typedef enum : NSUInteger {
    OTZeroBuy       = 1,  //0元购
    OTDiscount      = 2,     //多拍多得
    OTBargain       = 3,      //砍立得,
    OTWug           =  4,          //吾g,
    OTGlobalSeller  = 5, //全球买手,
    OTCustom        = 6,       //定制拼团,
    OTMyOTO         = 7,         //OTO订单
    OTMyPayment     = 8,      //我的代付
    OTNewUser       = 9,    //新用户专区订单
    OTCanConsign    = 10,   //我要寄卖,
    OTConsigning    = 11,   //我的寄卖(寄卖中),
    OTConsigned     = 12,    //所有寄卖订单,
    
   
}XKOrderType;//订单类型

typedef enum : NSUInteger {
    OSUnPay = 1,   //未支付
    OSUnDeliver ,  //待发货
    OSUnReceive,   //待收货,
    OSCancle,      //已取消,
    OSComlete,     //已完成,
    OSClose,       //已关闭,
    OSUnSure,      //待确认,
    OSUnGroup,     //待成团,
    OSGroupSus,    //成团成功,
    OSGroupFail,   //拼团失败,
    OSConsign,     //已寄卖,
}XKOrderStatus;    //订单状态

typedef enum : NSUInteger {
    RankHot,        //爆品榜
    RankRecommend,  //热推榜
    RankMakeMoney,  //喜赚榜
} RanKType;  //排行榜


typedef enum : NSUInteger{
    XKSortNone         =   0,
    XKSortAscending    =   2,//升序
    XKSortDescending   =   1,//降序
} XKSortResult;


typedef NS_ENUM(int,XKConsignType) {
    XKConsignTypeAll    =   0,//所有方式
    XKConsignTypeShare  =   1,//定点分享
    XKConsignTypeWg     =   2,//寄卖到吾G
};


#endif /* XKEnum_h */

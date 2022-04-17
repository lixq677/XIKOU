//
//  XKPropertyData.h
//  XiKou
//
//  Created by Tony on 2019/6/17.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKUnitls.h"
#import "XKBaseResponse.h"
#import "XKEnum.h"


NS_ASSUME_NONNULL_BEGIN

/*优惠券使用状态*/
typedef NS_ENUM(int,XKPreferenceState) {
    XKPreferenceStateUnused  =   0,
    XKPreferenceStateUsed    =   1,
    XKPreferenceStateUnvalid =   2
};

/*银行渠道*/
typedef NS_ENUM(int,XKBankChannel) {
    XKBankChannelWexin         =      1,
    XKBankChannelZhifubao      =      2,
    XKBankChannelBank          =      3,
    XKBankChannelCredit        =      4,
    XKBankChannelBankBook      =      5,
};

#pragma mark 优惠券

/**********************获取优惠券信息********************************/

@interface XKPrefrenceParams : NSObject<YYModel>

@property (nonatomic,strong) NSString *userId;//用户id
@property (nonatomic,strong) NSNumber *page;//页码
@property (nonatomic,strong) NSNumber *limit;//每页多少条数据

@end

@class XKPreferenceData;
@interface XKPreferenceDataModel : NSObject<YYModel>
@property (nonatomic,strong) NSArray <XKPreferenceData *> *result;
@property (nonatomic,strong) NSNumber *totalCount;
@property (nonatomic,strong) NSNumber *pageCount;
@end

typedef NS_ENUM(int,XKPreferenceUseable) {
    XKPreferenceUseableValid    =   1,//已生效
    XKPreferenceUseableUnvalid  =   2,//未生效
};

@interface XKPreferenceData : NSObject<YYModel>
@property (nonatomic,assign) XKPreferenceUseable useable;//是否生效
@property (nonatomic,strong) NSString *id;//优惠券ID
@property (nonatomic,strong) NSNumber *balance;//余额，券所剩的余额
@property (nonatomic,strong) NSString *userId;//用户id
@property (nonatomic,strong) NSString *total;//优惠券总余额
@property (nonatomic,strong) NSString *startTime;//开始时间
@property (nonatomic,strong) NSString *endTime;//结束时间
@property (nonatomic,strong) NSString *couponType; //couponType 优惠券类型，1-通用劵
@property (nonatomic,assign) XKPreferenceState state;//优惠券状态
@end

@interface XKPreferenceResponse : XKBaseResponse
@property (nonatomic,strong)XKPreferenceDataModel *data;

@end

/**/
typedef NS_ENUM(int,XKPreferenceOperateType) {
    XKPreferenceOperateTypeNone =   0,
    XKPreferenceOperateTypeCost =   1,//消费
    XKPreferenceOperateTypeGet  =   2,//操作
};

@interface XKPreferenceDetailRecordModel : NSObject<YYModel>

@property (nonatomic,strong) NSNumber *balance;//余额，券所剩的余额

@property (nonatomic,strong) NSNumber *cost;//消费，如果是获取，cost应为0

@property (nonatomic,strong) NSString *id;//主键ID

@property (nonatomic,strong) NSString *couponId;//优惠券id

@property (nonatomic,strong) NSString *createTime;//创建时间（使用时间）

@property (nonatomic,strong) NSString *primaryKey;//订单id

@property (nonatomic,assign) XKActivityType moduleId;//（1:买一赠二(吾G)，2: 全球买手, 3：0元竞拍 4:多买多折，5:砍价得红包，6:定制拼团）

@property (nonatomic,strong) NSString *remark;//备注

@property (nonatomic,strong) NSString *userId;//用户id

@property (nonatomic,assign) XKPreferenceOperateType operateType;//操作类型：1：消费，2：获取

- (NSString *)moduleIdFromString;

@end

@interface XKPreferenceDetailData : NSObject<YYModel>

@property (nonatomic,strong) NSNumber *balance;//优惠券余额

@property (nonatomic,strong) NSNumber *startTime;//开始时间

@property (nonatomic,strong) NSNumber *endTime;//结束时间

@property (nonatomic,strong) NSNumber *total;//优惠卷总余额

@property (nonatomic,strong) NSString *userId;//用户id

@property (nonatomic,strong) NSString *id;//优惠券ID

@property (nonatomic,strong) NSArray <XKPreferenceDetailRecordModel *> *recordModelList;//优惠卷使用明细列表

@end



/*优惠券明细*/
@interface XKPreferenceDetailResponse : XKBaseResponse

@property (nonatomic,strong) XKPreferenceDetailData *data;

@end

/*优惠券总额*/
@interface XKTicketTotalData : NSObject<YYModel>

@property (nonatomic,assign)int32_t couponSumNum;//优惠券总额

@property (nonatomic,assign)int32_t couponUsableSumNum;//可用优惠券

@end


/*优惠券总额*/
@interface XKTicketTotalResponse : XKBaseResponse

@property (nonatomic,strong) XKTicketTotalData *data;

@end

/******************************我关注的店铺********************************************/
#pragma mark 数据
//我的关注
@interface XKConcernData : NSObject<YYModel>
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *headUrl;
@property (nonatomic,strong) NSString *nickName;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *followedUserId;

@end

@interface XKConcernDataModel : NSObject<YYModel>
@property (nonatomic,strong) NSArray <XKConcernData *> *result;
@property (nonatomic,strong) NSNumber *totalCount;
@property (nonatomic,strong) NSNumber *pageCount;

@end

@interface XKConcernResponse : XKBaseResponse
@property (nonatomic,strong)XKConcernDataModel *data;

@end

#pragma mark 红包
/*********************红包数据********************************/

@class XKBankData;


typedef NS_ENUM(int,MICashOutValue) {
    MICashOutValueImmediately    =   1,//立即到账
    MICashOutValueThreeDay      =   2,//3天到账
    MICashOutValueSevenDay      =   3//7天到账
};

@interface MICashOutTypeModel : NSObject

@property (nonatomic,assign)MICashOutValue value;

@property (nonatomic,strong)NSString *label;

@end

//我的红包
@interface XKRedBagData : NSObject<YYModel>
@property (nonatomic,strong) NSString *userId;//用户id
@property (nonatomic,strong) NSNumber *balance;//用户余额
@property (nonatomic,strong) NSNumber *virtual;//虚拟余额
@property (nonatomic,strong) NSNumber *frozen;//冻结金额
@property (nonatomic,strong) NSNumber *onWay;//在途金额（未到账金额）

@property (nonatomic,strong) NSNumber *experienceBalance;//体验金额度

@property (nonatomic,strong) NSNumber *toCash;//可提现金额

@property (nonatomic,strong) NSNumber *createTime;//创建时间

@property (nonatomic,strong) NSNumber *updateTime;//修改时间

@property (nonatomic,strong) NSNumber *status;//1:正常，2:冻结

@property (nonatomic,strong) NSString *idCard;//实名身份证号

@property (nonatomic,strong) NSString *realName;//真实实名

@property (nonatomic,assign) NSInteger rate;//手续费率

@property (nonatomic,strong) NSArray<XKBankData *> *bankCardList;//

@property (nonatomic,strong) NSArray<MICashOutTypeModel *> *cashTypeList;//
@end

@interface XKRedBagResponse : XKBaseResponse
@property (nonatomic,strong)XKRedBagData *data;

@end


#pragma mark 绑定银行卡
/************银行卡*******************/
/*
 *  业务类型：1 ：红包分润，2：使用红包，3：管理费，4：红包提现，5:提现手续费，6:服务费转账，7:用户转账，8:代付支出，9:代付收入，10:砍立得红包，11:寄卖收入
 */
typedef NS_ENUM(int,XKBusinessType) {
    XKBusinessTypeShareBenefit          =   1,//红包分润
    XKBusinessTypeRedBagUse             =   2,//使用红包
    XKBusinessTypeManagerFee            =   3,//管理费
    XKBusinessTypeRedBagCash            =   4,//红包提现
    XKBusinessTypeRedBagCharge          =   5,//提现手续费
    XKBusinessTypeClusterRefund         =   6,//拼团退款
    XKBusinessTypeTransport              =   7,//转账
    XKBusinessTypePaymentExpenditure    =   8,//代付支出
    XKBusinessTypePaymentIncome         =   9, //代付收入
    XKBusinessTypePaymentBraign         =   10, //砍立得收入
    XKBusinessTypePaymentConsignSale    =   11 //寄卖收入
};

typedef NS_ENUM(int,XKOperateType) {//操作类型1，增加 2，扣减
    XKOperateTypeAdd    =   1,
    XKOperateTypeDed    =   2,
};

typedef NS_ENUM(int,XKMoneyType) {
    XKMoneyTypeIncome       =   1,//收入
    XKMoneyTypeExpense      =   2,//支出
};

typedef NS_ENUM(int,XKAmountCashStatus) {//提现状态：1,2：到账中， 3：已到账，4：提现失败
    XKAmountCashStatusApproving    =   1,//1：待审核 到账中
    XKAmountCashStatusWillCash     =   2,//2.待打款
    XKAmountCashStatusArrived      =   3,//3：已到账
    XKAmountCashStatusFailed       =   4,//4：提现失败
};

/*
 *  业务类型：1:吾G限时购，2: 全球买手, 3：0元竞拍 4:多买多折，5:砍立得，6:定制拼团，7:OTO线下
 */
typedef NS_ENUM(int,XKAmountModuleType) {
    XKAmountModuleTypeWg                =   1,
    XKAmountModuleTypeGlobleBuyer       =   2,
    XKAmountModuleTypeZeroBuy           =   3,
    XKAmountModuleTypeMultiBuy          =   4,
    XKAmountModuleTypeBargain           =   5,
    XKAmountModuleTypeCutomAssemble     =   6,
    XKAmountModuleTypeOTO               =   7,
    XKAmountModuleTypePaymentForOther   =   8,
    XKAmountModuleTypeNewUser           =   9,
};

/*
 * 获取红包明细，待结算明细的参数，带筛选参数
 *
 */

@interface XKAmountParams : NSObject<YYModel>

@property (nonatomic,strong) NSString *userId;//用户id
@property (nonatomic,strong) NSNumber *page;//页码
@property (nonatomic,strong) NSNumber *limit;//每页多少条数据

@property (nonatomic,strong) NSString *businessTypeList;//XKBusinessType

@property (nonatomic,strong) NSString *searchTime;//筛选时间(格式：2019-06)

//XKMoneyType
@property (nonatomic,strong) NSNumber *operateType;//收支类型：1：收入明细，2：支出明细

//XKAmountModuleType
@property (nonatomic,strong) NSNumber *moduleId;//业务类型：1:吾G限时购，2: 全球买手, 3：0元竞拍 4:多买多折，5:砍立得，6:定制拼团，7:O2O线下

@end



@interface XKAmountData : NSObject<YYModel>
@property (nonatomic,assign) XKBusinessType  businessType;//支持类型/收入类型

@property (nonatomic,assign) int32_t changeValue;//金额

@property (nonatomic,assign) XKBankChannel channel;//提现渠道

@property (nonatomic,strong) NSString *createTime;//创建时间

@property (nonatomic,assign) XKAmountModuleType moduleId;//服务ID

@property (nonatomic,copy) NSString *id;//主键

@property (nonatomic,strong) NSString *moduleName;//服务名称

@property (nonatomic,strong) NSString *businessName;//服务名称

@property (nonatomic,strong) NSString *refKey;//订单号

@property (nonatomic,strong) NSString *transferUserName;

@property (nonatomic,strong) NSString *transferUserPhone;

@property (nonatomic,strong) NSString *transferUserId;

@property (nonatomic,strong) NSString *remark;

@property (nonatomic,assign) XKOperateType operateType;//操作类型1，增加 2，扣减

@property (nonatomic,assign) XKAmountCashStatus status;//提现状态：1：到账中， 2：已到账，3：提现失败

@end

@interface XKCashOutParams : NSObject<YYModel>

@property (nonatomic,strong) NSString *userId;//用户id
@property (nonatomic,strong) NSNumber *page;//页码
@property (nonatomic,strong) NSNumber *limit;//每页多少条数据
@property (nonatomic,strong) NSString *cashTime;//筛选时间(格式：2019-06)

@property (nonatomic,assign) int32_t userType;//主体类型 2：城市合伙人公司，3：创始合伙人，4：优先合伙人， 5：用户， 6：商家， 7：设计师 写死5

@end


//typedef NS_ENUM(int,XKCashOutState) {
//    XKCashOutStateApproving =   1,//审批中
//    XKCashOutStateApproveSuccess =  2,  //审批通过
//    XKCashOutStatePaySuccess    =   3,  //支付成功
//    XKCashOutStateAbolish       =   4,  //废止
//    XKCashOutStateReject        =   5,  //驳回
//    XKCashOutStatePayFailed     =   6,  //支付失败
//};

@interface XKCashOutData : NSObject<YYModel>

@property (nonatomic,assign) int32_t cashAmount;//提现金额

@property (nonatomic,strong) NSString *cashBankCard;//提现到账银行卡号

@property (nonatomic,strong) NSString *cashId;//提现主键id

@property (nonatomic,strong) NSString *cashTime;//服务ID

//@property (nonatomic,copy) NSString *id;//主键

@property (nonatomic,assign) XKAmountCashStatus state;//提现工单状态:1：审批中 2：审批通过 3：支付成功 4：废止 5：驳回 6：支付失败

@property (nonatomic,strong) NSString *updateTime;//服务名称

@end

@interface XKCashOutResponse : XKBaseResponse
@property (nonatomic,strong)NSArray<XKCashOutData *> *data;

@end

@interface XKCashOutDetailData : NSObject<YYModel>

@property (nonatomic,assign) int32_t amount;//实际到账金额

@property (nonatomic,assign) int32_t cashAmount;//提现金额

@property (nonatomic,assign) int32_t cashCommission;//提现手续费

@property (nonatomic,strong) NSString *cashContent;//失败原因

@property (nonatomic,strong) NSString *cashBankCard;//提现到账银行卡号

@property (nonatomic,strong) NSString *cashTime;//申请提现时间

@property (nonatomic,assign) XKAmountCashStatus state;//提现工单状态:1：审批中 2：审批通过 3：支付成功 4：废止 5：驳回 6：支付失败

@property (nonatomic,strong) NSString *cashType;//到账类型：T+0; T+3; T+7

@property (nonatomic,strong) NSString *updateTime;//更新时间

@end

@interface XKCashOutDetailResponse : XKBaseResponse
@property (nonatomic,strong)XKCashOutDetailData *data;

@end


@interface XKAmountResponse : XKBaseResponse
@property (nonatomic,strong)NSArray<XKAmountData *> *data;

@end

/*获取一个月的结算总额，红包提现月统计，红包账户月收支*/
@interface XKAmountMonthlyTotalParams : NSObject<YYModel>

@property (nonatomic,strong) NSString *userId;//用户id

@property (nonatomic,strong) NSString *businessTypeList;//XKBusinessType

@property (nonatomic,strong) NSString *searchTime;//筛选时间(格式：2019-06)

@end



@interface XKAmountMonthlyTotalData : NSObject<YYModel>

@property (nonatomic,assign) int32_t haveCashAmount;//提现月统计(已提现)

@property (nonatomic,assign) int32_t onWayAmount;//提现月统计(到账中)

@property (nonatomic,assign) int32_t expenditureAmount;//月支出金额

@property (nonatomic,assign) int32_t incomeAmount;//月收入金额

@property (nonatomic,strong) NSString *userId;//用户ID

@end

@interface XKAmountMonthlyTotalResponse : XKBaseResponse

@property (nonatomic,strong)XKAmountMonthlyTotalData*data;

@end



#pragma mark bind 
/****************绑定银行卡*******************/

@interface XKBankBindParams : NSObject <YYModel>

@property (nonatomic,strong) NSString *account;

@property (nonatomic,strong) NSString *bankLocation;

@property (nonatomic,strong) NSString *bankName;

@property (nonatomic,strong) NSString *bankCode;

@property (nonatomic,strong) NSString *branchName;

@property (nonatomic,assign) XKBankChannel channel;

//@property (nonatomic,strong) NSString *id;

@property (nonatomic,strong) NSString *mobile;

@property (nonatomic,strong) NSString *userId;

@property (nonatomic,strong) NSString *validaCode;

@end

@interface XKBankData : NSObject <YYModel>

@property (nonatomic,strong) NSString *account;//账号

@property (nonatomic,strong) NSString *bankLocation;//开户行所在地

@property (nonatomic,strong) NSString *bankName;//银行名称

@property (nonatomic,strong) NSString *branchName;//支行名称

//账号类型：1：微信， 2：支付宝，3：银行卡，4：信用卡，5：存折
@property (nonatomic,assign) XKBankChannel channel;

@property (nonatomic,strong) NSString *id;//主键ID

@property (nonatomic,strong) NSString *mobile;//手机号码

@property (nonatomic,strong) NSString *userId;//用户id

@property (nonatomic,strong) NSString *image;//image

@end


@interface XKBankResponse:XKBaseResponse

@property (nonatomic,strong)NSArray<XKBankData *> *data;

@end


@interface XKCashVoParams : NSObject <YYModel>

@property (nonatomic,assign) int32_t amount;//实际到账金额

@property (nonatomic,assign) int32_t cashAmount;//提现金额

@property (nonatomic,strong) NSString *cashBankCard;//提现到账银行卡号

@property (nonatomic,assign) int32_t cashCommission;//提现手续费

//@property (nonatomic,assign) NSString *cashTime;//发起提现时间

@property (nonatomic,assign) NSString *cashType;//到账类型：T+0; T+3; T+7

//@property (nonatomic,assign) int32_t frozen;//是否冻结：0:否 1:是

@property (nonatomic,assign) int32_t state;//写死 1 提现工单状态:1：审批中 2：审批通过 3：支付成功 4：废止 5：驳回 6：支付失败

@property (nonatomic,strong) NSString *userId;//用户Id

@property (nonatomic,assign) int32_t userType;//写死 5 主体类型 2：城市合伙人公司，3：创始合伙人，4：优先合伙人， 5：用户， 6：商家， 7：设计师

@end

@interface XKBankListData : NSObject <YYModel>

@property (nonatomic,strong) NSString *code;//编号

@property (nonatomic,strong) NSString *id;//主键ID

@property (nonatomic,strong) NSString *image;//银行图标

@property (nonatomic,strong) NSString *name;//银行名称

@end

@interface XKBankListResponse:XKBaseResponse

@property (nonatomic,strong)NSArray<XKBankListData *> *data;

@end

@interface XKTransportAccounParams : NSObject<YYModel>

@property (nonatomic,assign) uint64_t  amount;

@property (nonatomic,strong) NSString  *fromUserId;

@property (nonatomic,strong) NSString  *toUserId;

@property (nonatomic,strong) NSString  *remark;

@property (nonatomic,strong) NSString  *payPassword;

@end


@interface XKRedbagCategoryTitle : NSObject <YYModel>

@property (nonatomic,strong) NSNumber *id;//主键ID

@property (nonatomic,strong) NSString *name;//银行名称

@property (nonatomic,assign) BOOL select;

@end

@interface XKRedbagCategoryData : NSObject <YYModel>

@property (nonatomic,strong) NSArray<XKRedbagCategoryTitle *> *income;

@property (nonatomic,strong) NSArray<XKRedbagCategoryTitle *> *outcome;

@end

@interface XKRedbagCategoryResponse:XKBaseResponse

@property (nonatomic,strong)XKRedbagCategoryData *data;

@end

@interface XKRedPacketDetailParams : NSObject<YYModel>

@property (nonatomic,strong) NSNumber  *operateType;

@property (nonatomic,strong) NSString  *refKey;

@property (nonatomic,strong) NSString  *moduleId;

@property (nonatomic,strong) NSString  *id;

@end


@interface XKRedPacketDetailResponse:XKBaseResponse

@property (nonatomic,strong)XKAmountData *data;

@end

NS_ASSUME_NONNULL_END

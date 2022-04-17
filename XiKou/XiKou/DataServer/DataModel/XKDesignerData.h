//
//  XKDesignerData.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/17.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XKUnitls.h"
#import "XKBaseResponse.h"

NS_ASSUME_NONNULL_BEGIN

@interface XKDesignerBriefData : NSObject <YYModel>

@property (nonatomic,strong) NSNumber  *commentCount;//设计师作品评论数

@property (nonatomic,strong) NSNumber  *fabulousCount;//设计师作品点赞数

@property (nonatomic,strong) NSString  *headUrl;//设计师头像

@property (nonatomic,strong) NSString  *id;//设计师id

@property (nonatomic,strong) NSString  *name;//设计师名称

@property (nonatomic,strong) NSString  *pageName;//设计师名称

@property (nonatomic,strong,readonly) NSString  *pinyin;//设计师名称的拼音 非服务器返回

@end

@interface XKDesignerBriefResponse : XKBaseResponse

@property (nonatomic,strong) NSArray<XKDesignerBriefData *> *data;

@end

@interface XKDesignerHomeData : NSObject <YYModel>

@property (nonatomic,strong) NSString  *coverUrl;//封面

@property (nonatomic,strong) NSString  *desc;//个人简介

@property (nonatomic,strong) NSString  *designerId;//设计师ID

@property (nonatomic,strong) NSNumber  *fabulousCnt;//获赞数

@property (nonatomic,strong) NSNumber  *fanCnt;//粉丝数

@property (nonatomic,strong) NSString  *headUrl;//设计师头像

@property (nonatomic,strong) NSString  *id;//

@property (nonatomic,strong) NSNumber  *isFollow;//是否关注（1-已关注；0-未关注）

@property (nonatomic,strong) NSString  *name;//设计师名称

@property (nonatomic,strong) NSString  *pageName;//主页名称

@property (nonatomic,strong) NSNumber  *workCnt;//作品数

@end

@interface XKDesignerHomeResponse : XKBaseResponse

@property (nonatomic,strong) XKDesignerHomeData *data;

@end


@interface XKDesignerWorkImageModel : NSObject <YYModel>

@property (nonatomic,strong) NSString  *createTime;

@property (nonatomic,strong) NSString  *id;

@property (nonatomic,strong) NSString  *imageUrl;

@property (nonatomic,strong) NSString  *type;

@property (nonatomic,strong) NSString  *updateTime;

@property (nonatomic,strong) NSString  *workId;

@end



/**
 设计师作品信息
 */
@interface XKDesignerWorkData : NSObject <YYModel,NSCopying>

@property (nonatomic,strong) NSNumber  *commentCnt;//作品评论数

@property (nonatomic,strong) NSString  *desc;//作品来源介绍

@property (nonatomic,strong) NSString  *designerId;//设计师ID

@property (nonatomic,strong) NSNumber  *fabulousCnt;//作品点赞数

@property (nonatomic,strong) NSNumber  *fanCnt;//粉丝数

@property (nonatomic,strong) NSString  *headUrl;//设计师头像

@property (nonatomic,strong) NSString  *id;//作品主键id

@property (nonatomic,strong) NSNumber  *isFollow;//是否关注（1-已关注；0-未关注）

@property (nonatomic,strong) NSNumber  *isPraise;//是否点赞作品（1:已赞 0:未赞）

@property (nonatomic,strong) NSString  *name;//设计师名称

@property (nonatomic,strong) NSString  *pageName;//主页名称

@property (nonatomic,strong) NSString  *showTime;//展示时间

@property (nonatomic,strong) NSString  *updateTime;//作品发布时间

@property (nonatomic,strong) NSString  *workName;//作品名称

@property (nonatomic,strong) NSArray<XKDesignerWorkImageModel *>  *imageList;//图片

@end

@interface XKDesignerWorkResponse : XKBaseResponse

@property (nonatomic,strong) NSArray<XKDesignerWorkData *> *data;

@end

@interface XKDesignerFollowVoParams : NSObject <YYModel>

@property (nonatomic,strong)NSString *createTime;

@property (nonatomic,strong)NSString *designerId;

@property (nonatomic,strong)NSString *id;

@property (nonatomic,strong)NSString *userId;

@property (nonatomic,strong)NSString *workId;//设计师作品id

@property (nonatomic,assign)BOOL follow;//是否关注（1-已关注；0-未关注）

@property (nonatomic,assign)BOOL praise;//是否点赞作品（1:已赞 0:未赞）

@end

typedef NS_ENUM(int,XKCommentStatus){
    XKCommentStatusNone     =   0,
    XKCommentStatusSuccess  =   1,
    XKCommentStatusFailed   =   2,
    XKCommentStatusSending  =   3
};

@interface XKDesignerCommentVoModel : NSObject <YYModel>

@property (nonatomic,strong)NSString *commentContent;//评论内容

@property (nonatomic,strong)NSNumber *commentCount;//评论数

@property (nonatomic,strong)NSString *commentTime;//评论时间

@property (nonatomic,strong)NSString *designerId;//设计师ID

@property (nonatomic,strong)NSString *headUrl;//用户头像

@property (nonatomic,strong)NSString *id;//评论ID

@property (nonatomic,strong) NSArray<XKDesignerWorkImageModel *>  *imageList;//图片

@property (nonatomic,strong)NSString *name;//设计师名称

@property (nonatomic,strong)NSString *replayContent;//回复内容

@property (nonatomic,strong)NSString *replayTime;//回复时间

@property (nonatomic,strong)NSString *userId;//用户ID

@property (nonatomic,strong)NSString *userName;//用户昵称

@property (nonatomic,strong)NSString *workId;//作品ID

@property (nonatomic,strong)NSString *workName;//作品名称

/*本机状态*/
@property (nonatomic,assign)XKCommentStatus commentStatus;

@end


@interface XKDesignerCommentData : NSObject <YYModel>

@property (nonatomic,strong)NSNumber *pageCount;//

@property (nonatomic,strong)NSNumber *totalCount;//

@property (nonatomic,strong)NSArray<XKDesignerCommentVoModel *> *result;//

@end


@interface XKDesignerCommentResponse : XKBaseResponse

@property (nonatomic,strong)XKDesignerCommentData *data;

@end



@interface XKDesignerCommentsRequestParams : NSObject <YYModel>

@property (nonatomic,strong)NSString *designerId;//设计师id

@property (nonatomic,strong)NSString *workId;//设计师作品id

@property (nonatomic,strong)NSNumber *page;//page

@property (nonatomic,strong)NSNumber *limit;//

@end

@interface XKDesignerMyConcernParams : NSObject <YYModel>

@property (nonatomic,strong)NSString *userId;//用户id

@property (nonatomic,strong)NSNumber *page;//page

@property (nonatomic,strong)NSNumber *limit;//

@end

@interface XKDesignerMyConcernData : NSObject <YYModel>


@property (nonatomic,strong) NSString  *headUrl;//设计师头像

@property (nonatomic,strong) NSString  *id;//设计师id

@property (nonatomic,strong) NSString  *clientUserId;//设计师C端用户id

@property (nonatomic,strong) NSString  *createTime;//关注关系创建时间

@property (nonatomic,strong) NSString  *name;//设计师名称

@property (nonatomic,strong) NSString  *createTimeDifference;//关注关系显示时间

@end


@interface XKDesignerMyConcernResponse : XKBaseResponse

@property (nonatomic,strong) NSArray<XKDesignerMyConcernData *> *data;

@end

@interface XKDesignerWorksParams : NSObject <YYModel>

@property (nonatomic,strong)NSString *designerId;//设计师id

@property (nonatomic,strong)NSString *userId;//设计师作品id

@property (nonatomic,strong)NSNumber *page;//page

@property (nonatomic,strong)NSNumber *limit;//

@end

NS_ASSUME_NONNULL_END

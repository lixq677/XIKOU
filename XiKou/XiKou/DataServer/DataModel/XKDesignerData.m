//
//  XKDesignerData.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/17.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKDesignerData.h"
#import <LKDBHelper.h>

@implementation XKDesignerBriefData

+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSString *)getPrimaryKey{
    return @"id";
}

- (void)setPageName:(NSString *)pageName{
    if ([NSString isNull:pageName]) {
        _pinyin = nil;
    }else{
        _pinyin = [pageName chineseCapitalizedString];
    }
    _pageName = pageName;
}


@end


@implementation XKDesignerBriefResponse
@synthesize data = _data;

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"data" : @"data.result"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKDesignerBriefData class]};
}

@end


@implementation XKDesignerHomeData

+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSString *)getPrimaryKey{
    return @"id";
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc" : @"description"};
}

@end

@implementation XKDesignerHomeResponse
@synthesize data = _data;
@end


@implementation XKDesignerWorkImageModel

@end

@implementation XKDesignerWorkData

+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSString *)getPrimaryKey{
    return @"id";
}

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"desc" : @"description"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"imageList":[XKDesignerWorkImageModel class]};
}

- (id)copyWithZone:(NSZone *)zone{
    XKDesignerWorkData *workData = [XKDesignerWorkData yy_modelWithJSON:[self yy_modelToJSONObject]];
    return workData;
}

@end


@implementation XKDesignerWorkResponse
@synthesize data = _data;

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"data" : @"data.result"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKDesignerWorkData class]};
}

@end

@interface XKDesignerFollowVoParams ()

//操作类型(是关注(follow)还是取消关注(cancel))   操作类型(是点赞(praise)还是取消点赞(cancel)
@property (nonatomic,strong)NSString *operationType;

@end

@implementation XKDesignerFollowVoParams
@dynamic praise;
@dynamic follow;

+ (NSArray *)modelPropertyBlacklist {
    return @[@"follow",@"praise"];
}

- (void)setPraise:(BOOL)praise{
    if (praise) {
        self.operationType = @"praise";
    }else{
        self.operationType = @"cancel";
    }
}

- (BOOL)praise{
    if ([self.operationType isEqualToString:@"praise"]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)setFollow:(BOOL)follow{
    if (follow) {
        self.operationType = @"follow";
    }else{
        self.operationType = @"cancel";
    }
}

- (BOOL)follow{
    if ([self.operationType isEqualToString:@"follow"]) {
        return YES;
    }else{
        return NO;
    }
}


@end


@implementation XKDesignerCommentVoModel


@end

@implementation XKDesignerCommentData

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"result":[XKDesignerCommentVoModel class]};
}

+ (NSArray *)modelPropertyBlacklist {
    return @[@"XKCommentStatus",];
}

@end


@implementation XKDesignerCommentResponse
@synthesize data = _data;

@end

@implementation XKDesignerCommentsRequestParams


@end


@implementation XKDesignerMyConcernParams


@end

@implementation XKDesignerMyConcernData

+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSString *)getPrimaryKey{
    return @"id";
}

@end

@implementation XKDesignerMyConcernResponse
@synthesize data = _data;

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"data" : @"data.result"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass{
    return @{@"data":[XKDesignerMyConcernData class]};
}

@end

@implementation XKDesignerWorksParams

@end




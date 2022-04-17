//
//  XKAccountManager.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/18.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKAccountManager.h"
#import "XKUserData.h"
#import "XKDataService.h"
#import "XKNetworkManager.h"
#import "NSError+XKNetwork.h"
#import "XKUserService.h"
#import <UMCommon/UMCommon.h>
#import <UMPush/UMessage.h>
#import "XKAddressService.h"

@implementation XKAccountData

+(NSString *)getTableName{
    return NSStringFromClass([self class]);
}

+ (nullable NSString *)getPrimaryKey{
    return @"userId";
}

@end

@interface XKAccountManager ()<XKUserServiceDelegate,XKNetworkManagerDelegate>

@end

@implementation XKAccountManager
@synthesize account = _account;

+(XKAccountManager *)defaultManager{
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init{
    if (self = [super init]) {
        [[XKFDataService() userService] addWeakDelegate:self];
        [[XKNetworkManager sharedInstance] addWeakDelegate:self];
        
        XKAccountData *data = [[XKAccountData searchWithWhere:nil] firstObject];
       
        if (NO == [NSString isNull:data.userId]) {
             /*初始化用户数据*/
            _account = data;
            _userId = data.userId;
            _refreshToken = data.refreshToken;
            _token = data.token;
            _login = YES;
            XKUserInfoData *user = [XKUserInfoData searchSingleWithWhere:@{@"id":data.userId?:@""} orderBy:nil];
            _mobile = user.mobile;
            _extCode = user.extCode;
            _headUrl = user.headUrl;
            _name = user.nickName;
            _ver = user.certification.boolValue;
            _isPayPassword = user.isPayPassword;
            _couponNum = user.couponNum;
            _balance = user.balance;
            _followCnt = user.followCnt;
            
            if (![NSString isNull:data.refreshToken]) {
                [[XKFDataService() userService] refreshToken:data.refreshToken completion:^(XKCodeResponse * _Nonnull response) {
                    if (response.code.intValue == CodeStatus_TokenInvalid) {
                        [[XKFDataService() userService] logoutWithUserId:self.userId completion:nil];
                    }
                }];
            }
        }
    }
    return self;
}


/*登录成功调用*/
- (void)loginWithService:(XKUserService *)service userInfo:(XKAccountData *)data{
    _account = data;
    _userId = data.userId;
    _refreshToken = data.refreshToken;
    _token = data.token;
    _login = YES;
    
    [[XKNetworkConfig shareInstance] setToken:data.token];
    [[XKNetworkConfig shareInstance] setUserId:data.userId];
    [XKAccountData deleteWithWhere:nil];
    [data saveToDB];
    
    //绑定别名
//    [UMessage addAlias:data.userId type:@"XK_iOS" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
//    }];
    
    [UMessage setAlias:data.userId type:@"userId" response:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"替换别名");
    }];
    /*登录成功，解发获取基本信处的函数*/
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[XKFDataService() userService] getUserBasicInfomationWithId:self.userId completion:nil];
        [[XKFDataService() userService] getUserMineInfomationWithId:self.userId completion:nil];
        
        /*登录成功后，请求全国省市县地址信息*/
        [[XKFDataService() addressService] queryAllAddressInfoWithLevel:XKAddressLevelProvince completion:nil];
        [[XKFDataService() addressService] queryAllAddressInfoWithLevel:XKAddressLevelCity completion:nil];
        [[XKFDataService() addressService] queryAllAddressInfoWithLevel:XKAddressLevelDistrict completion:nil];
        
        /*获取地址信息*/
        [[XKFDataService() addressService] queryAddressListWithUserId:data.userId completion:nil];
    });
}

/*退出登录调用*/
- (void)logoutWithService:(XKUserService *)service userId:(NSString *)userId{
    _account = nil;
    _userId = nil;
    _refreshToken = nil;
    _token = nil;
    _login = NO;
    _mobile = nil;
    _extCode = nil;
    _headUrl = nil;
    _name = nil;
    _ver = NO;
    _isPayPassword = NO;
    [XKAccountData deleteWithWhere:nil];
    [[XKNetworkConfig shareInstance] setToken:nil];
    [[XKNetworkConfig shareInstance] setUserId:nil];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"recentSearchFriend"];
    //移除别名
//    [UMessage removeAlias:userId type:@"XK_iOS" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
//        NSLog(@"移除别名");
//    }];
}

/*刷新token*/
- (void)refreshTokenWithService:(XKUserService *)service userInfo:(XKAccountData *)data{
    _account = data;
    _userId = data.userId;
    _refreshToken = data.refreshToken;
    _token = data.token;
    _login = YES;
    
    /*设置与登录相关的数据*/
    [[XKNetworkConfig shareInstance] setToken:data.token];
    [[XKNetworkConfig shareInstance] setUserId:data.userId];
    
    [XKAccountData deleteWithWhere:nil];
    [data saveToDB];
    
    [UMessage setAlias:data.userId type:@"userId" response:^(id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"替换别名");
    }];
    /*设置与登录相关的数据*/
    [[XKNetworkConfig shareInstance] setToken:data.token];
    [[XKNetworkConfig shareInstance] setUserId:data.userId];
    /*登录成功，解发获取基本信处的函数*/
    [[XKFDataService() userService] getUserBasicInfomationWithId:self.userId completion:nil];
    [[XKFDataService() userService] getUserMineInfomationWithId:self.userId completion:nil];
}

/*查询用户基本信息*/
- (void)queryUserBasicInfoWithService:(XKUserService *)service userInfoData:(XKUserInfoData *)userInfoData{
    _mobile = userInfoData.mobile;
    if (![NSString isNull:userInfoData.headUrl]) {
        _headUrl = userInfoData.headUrl;
    }
    if (![NSString isNull:userInfoData.nickName]) {
        _name = userInfoData.nickName;
    }
    if (userInfoData.isPayPassword) {
        _isPayPassword = [userInfoData.isPayPassword boolValue];
    }
    if (userInfoData.couponNum) {
        _couponNum = userInfoData.couponNum;
    }
    if (userInfoData.balance) {
        _balance = userInfoData.balance;
    }
    if (userInfoData.followCnt) {
        _followCnt = userInfoData.followCnt;
    }
}

- (void)queryUserMineInfoWithService:(XKUserService *)service userInfoData:(XKUserInfoData *)userInfoData{
    if (NO == [NSString isNull:userInfoData.extCode]) {
        _extCode = userInfoData.extCode;
    }
    if (![NSString isNull:userInfoData.headUrl]) {
        _headUrl = userInfoData.headUrl;
    }
    if (![NSString isNull:userInfoData.nickName]) {
        _name = userInfoData.nickName;
    }
    _ver = [userInfoData.certification boolValue];
    if (userInfoData.isPayPassword) {
        _isPayPassword = [userInfoData.isPayPassword boolValue];
    }
    if (userInfoData.couponNum) {
           _couponNum = userInfoData.couponNum;
    }
    if (userInfoData.balance) {
        _balance = userInfoData.balance;
    }
    if (userInfoData.followCnt) {
        _followCnt = userInfoData.followCnt;
    }
}

- (void)changePaymentPasswordWithService:(XKUserService *)service userId:(NSString *)userId{
    _isPayPassword = YES;
}


- (void)verifySuccessWithSevice:(XKUserService *)service userId:(NSString *)userId{
    if (NO == [NSString isNull:userId] && [self.userId isEqualToString:userId]) {
        _ver = YES;
    }
}

/*修改用户信息*/
- (void)modifyWithSevice:(XKUserService *)service userInfomation:(XKModifyUserVoParams *)params userId:(NSString *)userId{
    
}

- (void)handleRequest:(XKBaseRequest *)request response:(XKBaseResponse *)response{
    if (response.code.intValue == CodeStatus_TokenInvalid) {
        if ([NSString isNull:self.userId]) return;
        [[XKFDataService() userService] logoutWithUserId:self.userId completion:^(XKBaseResponse * _Nonnull response) {
            if(response.isSuccess){
                [MGJRouter openURL:kRouterLogin];
            }
        }];
    }
}


@end

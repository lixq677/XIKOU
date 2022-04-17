//
//  XKTextEnum.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/15.
//  Copyright © 2019 李笑清. All rights reserved.
//

#ifndef XKTextEnum_h
#define XKTextEnum_h

typedef NS_OPTIONS(NSUInteger, XKTextSupportContent) {
    XKTextSupportContentAll    =   0,//支持所有字符
    XKTextSupportContentCustom    =   1,//自定义
    XKTextSupportContentChinese   =   1  <<    1,//只支持中文
    XKTextSupportContentCharacter =   1  <<    2,//只支持字母
    XKTextSupportContentNumber    =   1  <<    3,//只支持数字
    XKTextSupportContentSymbol    =   1  <<    4,//特殊字符
    XKTextSupportContentSpace     =   1  <<    5,//空格
};

typedef NS_ENUM(int, XKTextFormatter) {
    XKTextFormatterNone =   0,
    XKTextFormatterMobile   =   1,//电话码
    XKTextFormatterID       =   2,//身份证
    XKTextFormatterOther    =   3,//其它
};

#endif /* XKTextEnum_h */

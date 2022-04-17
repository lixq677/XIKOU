//
//  Marco.h
//  XiKou
//
//  Created by L.O.U on 2019/7/2.
//  Copyright © 2019 李笑清. All rights reserved.
//

#ifndef Marco_h
#define Marco_h

#define Font(f)         [UIFont systemFontOfSize:f] //普通字体
#define FontSemibold(f) [UIFont fontWithName:@"PingFangSC-Semibold" size: f] //中号粗字体
#define FontMedium(f)   [UIFont fontWithName:@"PingFangSC-Medium" size: f]  //中号字体
#define FontBoldMT(f)   [UIFont fontWithName:@"Arial-BoldMT" size: f]  //大号字体
#define FontThin(f)     [UIFont fontWithName:@"PingFangSC-Thin" size: f] //纤细体
#define FontLight(f)    [UIFont fontWithName:@"PingFangSC-Light" size: f] //细体
//颜色
#define COLOR_HEX(hexString) [UIColor colorWithRed:((float)((hexString &0xFF0000) >>16))/255.0 green:((float)((hexString &0xFF00) >>8))/255.0 blue:((float)(hexString &0xFF))/255.0 alpha:1.0]

#define COLOR_RGB(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

#define COLOR_RANDOM  [UIColor colorWithRed:(arc4random()%255)/255.0 green:(arc4random()%255)/255.0 blue:(arc4random()%255)/255.0 alpha:1.0]

#define COLOR_TEXT_BROWN   COLOR_HEX(0xBB9445)
#define COLOR_TEXT_BLACK   COLOR_HEX(0x444444)
#define COLOR_TEXT_GRAY    COLOR_HEX(0x999999)
#define COLOR_TEXT_RED     COLOR_HEX(0xF94119)

#define COLOR_PRICE_GRAY   COLOR_HEX(0xCCCCCC)

#define COLOR_LINE_GRAY    COLOR_HEX(0xE4E4E4)

#define COLOR_VIEW_GRAY    COLOR_HEX(0xF4F4F4)
#define COLOR_VIEW_SHADOW  [UIColor colorWithWhite:0 alpha:0.03].CGColor

#define KNotiWxPayResult   @"KNotiWxPayResult"
#define KNotiAliPayResult  @"KNotiAliPayResult"
#define KNotiNetworkChange @"KNotiNetworkChange"

#define kPlaceholderImg @"placeholder_background"

#define K_REQUEST_PAGE_COUNT   10
#endif /* Marco_h */

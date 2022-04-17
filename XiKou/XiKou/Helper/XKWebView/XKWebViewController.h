//
//  XKWebViewController.h
//  XiKou
//
//  Created by 李笑清 on 2019/5/30.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>
#import <WebViewJavascriptBridge.h>

NS_ASSUME_NONNULL_BEGIN

@protocol XKWebViewControllerDelegate <NSObject>
@optional
- (BOOL)webViewShouldStartLoadWithRequest:(NSURLRequest *)request;
- (void)webViewDidStartLoad;
- (void)webViewDidFinishLoad;
- (void)webViewDidFailLoadError:(NSError *)error;
- (void)webViewProgress:(float)progress;
- (void)webViewTitleChanged:(NSString *)title;
- (void)webViewWebContentProcessDidTerminate;

@end

@interface XKWebViewController : BaseViewController

@property (nonatomic,strong,readonly) WKWebView * _Nonnull webView;

@property (nonatomic,strong,readonly) NSURLRequest * _Nonnull request;

@property (nonatomic,strong,readonly)WebViewJavascriptBridge *bridge;

@property (nonatomic,weak) id<XKWebViewControllerDelegate> delegate;


- (instancetype _Nonnull )initWithRequest:(NSURLRequest *_Nonnull)request;

- (instancetype _Nonnull )initWithURL:(NSURL *_Nonnull)URL;

-(instancetype _Nonnull )initWithURLString:(NSString *_Nonnull)URLString;

+ (instancetype _Nonnull )WebControllerWithRequest:(NSURLRequest *_Nonnull)request;

+ (instancetype _Nonnull )WebControllerWithURL:(NSURL *_Nonnull)URL;

+ (instancetype _Nonnull )WebControllerWithURLString:(NSString *_Nonnull)URLString;

@end

NS_ASSUME_NONNULL_END

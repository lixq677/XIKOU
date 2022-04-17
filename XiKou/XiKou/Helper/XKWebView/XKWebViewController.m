//
//  XKWebViewController.m
//  XiKou
//
//  Created by 李笑清 on 2019/5/30.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKWebViewController.h"

@interface XKWebViewController () <WKNavigationDelegate>

@end

@implementation XKWebViewController
@synthesize webView = _webView;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero];
        _webView.navigationDelegate = self;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        //_bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    }
    return self;
}

- (instancetype)initWithRequest:(NSURLRequest *)request{
    if (self = [super init]) {
        _request = request;
    }
    return self;
}

- (instancetype)initWithURL:(NSURL *)URL{
    if (self = [super init]) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL];
        _request = request;
    }
    return self;
}

-(instancetype)initWithURLString:(NSString *)URLString{
    if (self = [super init]) {
        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:URLString]];
        _request = request;
    }
    return self;
}

+ (instancetype)WebControllerWithRequest:(NSURLRequest *)request{
    XKWebViewController *controller = [[XKWebViewController alloc] initWithRequest:request];
    return controller;
}


+ (instancetype)WebControllerWithURL:(NSURL *)URL{
    XKWebViewController *controller = [[XKWebViewController alloc] initWithURL:URL];
    return controller;
}

+ (instancetype)WebControllerWithURLString:(NSString *)URLString{
    XKWebViewController *controller = [[XKWebViewController alloc] initWithURLString:URLString];
    return controller;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    if (self.request) {
        [self.webView loadRequest:self.request];
    }
    [self addObserver:self.webView forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self.webView forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc{
    [self removeObserver:self.webView forKeyPath:@"estimatedProgress"];
    [self removeObserver:self.webView forKeyPath:@"title"];
    [XKLoading dismiss];
}

- (UIBarButtonItem *)rt_customBackItemWithTarget:(id)target action:(SEL)action{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Return"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    return item;
}

- (void)backAction:(id)sender{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    _request = navigationAction.request;
    WKNavigationActionPolicy policy =  WKNavigationActionPolicyAllow;
    if ([self.delegate respondsToSelector:@selector(webViewShouldStartLoadWithRequest:)]) {
        BOOL allow = [self.delegate webViewShouldStartLoadWithRequest:navigationAction.request];
        if (!allow) {
            policy = WKNavigationActionPolicyCancel;
        }
    }
    if (policy == WKNavigationActionPolicyAllow) {
        if ([XKLoading isShow] == NO) {
            [XKLoading show];
        }
    }
    decisionHandler(policy);
}


- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]){
        [self.delegate webViewDidStartLoad];
    }
}

- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView{
    [XKLoading dismiss];
    if([self.delegate respondsToSelector:@selector(webViewWebContentProcessDidTerminate)]){
        [self.delegate webViewWebContentProcessDidTerminate];
    }
}


/**
 *  在收到响应后，决定是否跳转
 *
 *  @param webView            实现该代理的webview
 *  @param navigationResponse 当前navigation
 *  @param decisionHandler    是否跳转block
 */
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    WKNavigationResponsePolicy policy = WKNavigationResponsePolicyAllow;
    if ([navigationResponse.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse * response = (NSHTTPURLResponse *)navigationResponse.response;
        if (response.statusCode != 200) {
            [XKLoading dismiss];
            if([self.delegate respondsToSelector:@selector(webViewDidFailLoadError:)]){
                NSError *error = [NSError errorWithDomain:@"Not Found Page" code:response.statusCode userInfo:nil];
                [self.delegate  webViewDidFailLoadError:error];
            }
            policy = WKNavigationResponsePolicyCancel;
        }
    }
    decisionHandler(policy);
}

/**
 *  当内容开始返回时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    
}

/**
 *  页面加载完成之后调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 */
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    [XKLoading dismiss];
    if (!self.title) {
        @weakify(self);
        [self.webView evaluateJavaScript:@"document.title" completionHandler:^(id _Nullable value, NSError * _Nullable error) {
            @strongify(self);
            if ([value isKindOfClass:[NSString class]]) {
                self.navigationItem.title = value;
            }
        }];
    }
    if([self.delegate respondsToSelector:@selector(webViewDidFinishLoad)]){
        [self.delegate webViewDidFinishLoad];
    }
}

/**
 *  加载失败时调用
 *
 *  @param webView    实现该代理的webview
 *  @param navigation 当前navigation
 *  @param error      错误
 */
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error{
   
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    [XKLoading dismiss];
    XKShowToast(@"加载失败");
    if(error.code!=NSURLErrorCancelled){
        if([self.delegate respondsToSelector:@selector(webViewDidFailLoadError:)]){
            [self.delegate  webViewDidFailLoadError:error];
        }
    }
}

/**
 *  接收到服务器重定向请求之后调用
 *
 *  @param webView      实现该代理的webview
 *  @param navigation   当前navigation
 */

- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"开始重定向的函数:%s", __FUNCTION__);
}


- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential *))completionHandler{
    completionHandler(NSURLSessionAuthChallengePerformDefaultHandling, nil);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self) {
            CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
            if ([self.delegate respondsToSelector:@selector(webViewProgress:)]) {
                [self.delegate webViewProgress:newprogress];
            }
        }
    }else if ([keyPath isEqualToString:@"title"]){
        NSString *title = [change objectForKey:NSKeyValueChangeNewKey];
        if ([self.delegate respondsToSelector:@selector(webViewTitleChanged:)]) {
            [self.delegate webViewTitleChanged:title];
        }
    }
}
@end

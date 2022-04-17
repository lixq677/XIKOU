//
//  StartupVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/9/23.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "StartupVC.h"


@interface StartupVC ()

/** 播放器 */
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic,copy) void(^enterBlock)(void);

@property (nonatomic,copy) void(^configurationBlock)(AVPlayerLayer *playerLayer);

@property (nonatomic,copy)NSString *filePath;

@end

@implementation StartupVC
@synthesize playerLayer = _playerLayer;

- (instancetype)initWithPath:(NSString *)filePath enterBlock:(void(^)(void))enterBlock configuration:(void (^)(AVPlayerLayer *playerLayer))configurationBlock{
    if (self = [super init]) {
        self.playerLayer = [self playerWith:[NSURL fileURLWithPath:filePath]];
        self.enterBlock = enterBlock;
        self.configurationBlock = configurationBlock;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.playerLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.playerLayer];
    [self.playerLayer.player play];
    
    [self setUpNotification];
    if (self.configurationBlock) {
        self.configurationBlock(self.playerLayer);
    }
    
}

- (void)dismiss{
    if (self.enterBlock) {
        self.enterBlock();
    }
}

// 监听通知
- (void)setUpNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismiss) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.playerLayer.player.currentItem cancelPendingSeeks];
    [self.playerLayer.player.currentItem.asset cancelLoading];
}

#pragma mark - 初始化播放器
- (AVPlayerLayer *)playerWith:(NSURL *)URL{
    if (_playerLayer == nil) {
        
        // 2.创建AVPlayerItem
        AVPlayerItem *item = [AVPlayerItem playerItemWithURL:URL];
        
        // 3.创建AVPlayer
        AVPlayer * player = [AVPlayer playerWithPlayerItem:item];
        
        // 4.添加AVPlayerLayer
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        _playerLayer = playerLayer;
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return _playerLayer;
}

@end

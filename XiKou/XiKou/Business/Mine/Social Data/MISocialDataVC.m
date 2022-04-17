//
//  MISocialDataVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/7/3.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "MISocialDataVC.h"
#import "XKOtherService.h"
#import "XKAccountManager.h"

@interface MIDrawView : UIView

@property (nonatomic,strong)NSArray<XKGroupUp *> *array;

@property (nonatomic,strong)void(^drawCompletionBlock)(CGSize frameSize);

@end

@implementation MIDrawView

+(Class)layerClass{
    return [CAScrollLayer class];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    CGFloat borderWidth = 2.0f;
    CGFloat x = 30.0;
    CGFloat y = 10.0f;
    CGFloat radius = 5.5f;
    CGPoint point = CGPointMake(x+radius, y+radius);

    UILabel *label = [[UILabel alloc] init];
    // 获取图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    for (int i = 0; i< self.array.count; i++) {
        XKGroupUp *group = [self.array objectAtIndex:i];
        UIColor *ellipseColor = nil;
        if (i == 0) {
            ellipseColor = HexRGB(0xffffff, 1.0f);
            radius = 5.50f;
        }else{
            ellipseColor = HexRGB(0x8a8a8a, 1.0f);
            radius = 4.0f;
        }
        /**
         *  画空心圆
         */
        CGRect ellipseRect = CGRectMake(point.x-radius,
                                    point.y - radius,
                                    2*radius,
                                    2*radius);
        
        //设置空心圆的线条宽度
        CGContextSetLineWidth(ctx,borderWidth);
        //以矩形bigRect为依据画一个圆
        CGContextAddEllipseInRect(ctx, ellipseRect);
        //填充当前绘画区域的颜色
        [ellipseColor set];
        //(如果是画圆会沿着矩形外围描画出指定宽度的（圆线）空心圆)/（根据上下文的内容渲染图层）
        CGContextStrokePath(ctx);
        
        label.font = [UIFont systemFontOfSize:13.0f];
        label.text = group.name;
        CGSize size = [label sizeThatFits:CGSizeMake(240.0f, 30)];
        
        CGFloat tx = CGRectGetMaxX(ellipseRect)+2*borderWidth+14.0f;
        CGRect msgFrame = CGRectMake(tx, CGRectGetMidY(ellipseRect)-0.5*size.height, size.width, size.height);
        [group.name drawInRect:msgFrame withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSForegroundColorAttributeName:HexRGB(0xffffff, 1.0f)}];
        
        label.font = [UIFont systemFontOfSize:10.0f];
        label.text = group.date;
        size = [label sizeThatFits:CGSizeMake(240.0f, 30)];
        CGRect timeFrame = CGRectMake(tx, CGRectGetMaxY(msgFrame)+6.0f, size.width, size.height);
        [group.date drawInRect:timeFrame withAttributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:10.0f],NSForegroundColorAttributeName:HexRGB(0x999999, 1.0f)
                                                     }];
        
        CGContextMoveToPoint(ctx, point.x, point.y+radius);
        CGContextAddLineToPoint(ctx, point.x, point.y + 43.0f);
        [HexRGB(0x999999, 1.0f) set];
        CGContextSetLineWidth(ctx, 0.5f);
        CGContextStrokePath(ctx);
        CGContextClosePath(ctx);
        point.y = point.y + 47.0f;
        
    }
    CGFloat height = point.y;
    if (self.drawCompletionBlock) {
        self.drawCompletionBlock(CGSizeMake(300,height));
    }
}

@end


@interface MISocialDataVC ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

@property (weak, nonatomic) IBOutlet UILabel *userCountLabel;//新增用户
@property (weak, nonatomic) IBOutlet UILabel *transmitCountLabel;//转发商品
@property (weak, nonatomic) IBOutlet UILabel *activitiesCountLabel;//发起活动
@property (weak, nonatomic) IBOutlet UILabel *designerCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *thumbupCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopCountLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong,readonly) MIDrawView *drawView;
    @property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHeight;
    
@end

@implementation MISocialDataVC
@synthesize drawView = _drawView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的社区流量";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = COLOR_VIEW_GRAY;
    self.navigationBarStyle = XKNavigationBarStyleTranslucent;
    self.edgesForExtendedLayout = UIRectEdgeTop;
    self.scrollView.alwaysBounceHorizontal = NO;
    //self.scrollView.bounces = NO;
    [self.scrollView addSubview:self.drawView];
    self.scrollView.contentSize = CGSizeMake(0, 600.0f);
    @weakify(self);
    self.drawView.drawCompletionBlock = ^(CGSize frameSize){
        @strongify(self);
        self.scrollView.contentSize = frameSize;
    };
    self.lineHeight.constant = 0.5/[UIScreen mainScreen].scale;
    NSString *url = [[XKAccountManager defaultManager] headUrl];
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"touxiang"] options:SDWebImageAvoidDecodeImage];
    self.titleLabel.text = [[XKAccountManager defaultManager] name];
    [self querySociaDataFromServer];
}

- (void)querySociaDataFromServer{
    NSString *userId = [[XKAccountManager defaultManager] userId];
    @weakify(self);
    [[XKFDataService() otherService] queryCirclesWithUserId:userId completion:^(XKSocialResponse * _Nonnull response) {
        @strongify(self);
        if (response.isSuccess) {
            self.userCountLabel.text = [@(response.data.inviteUsers) stringValue];
            self.transmitCountLabel.text = [@(response.data.shareGoods) stringValue];
            self.activitiesCountLabel.text = [@(response.data.activities) stringValue];
            
            self.designerCountLabel.text = [@(response.data.followDisigners) stringValue];
            self.thumbupCountLabel.text = [@(response.data. likes) stringValue];
            self.commentsCountLabel.text = [@(response.data.comments) stringValue];
            
            self.taskCountLabel.text = [@(response.data.tasks) stringValue];
            self.shopCountLabel.text = [@(response.data. collection) stringValue];
            self.drawView.array = response.data.growUps;
            [self.drawView setNeedsDisplay];
        }else{
            [response showError];
        }
    }];
}


- (MIDrawView *)drawView{
    if (!_drawView) {
        _drawView = [[MIDrawView alloc] initWithFrame:CGRectMake(0, 0, 300.0f, 3000.0f)];
        _drawView.backgroundColor = [UIColor clearColor];
    }
    return _drawView;
}
@end

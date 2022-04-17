//
//  CTBaseCell.h
//  XiKou
//
//  Created by 陆陆科技 on 2019/6/24.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XKProgressView.h"
#import "XKDesignerData.h"

NS_ASSUME_NONNULL_BEGIN


/**
 设计师圈cell
 */
@interface CTDesignerCell : UITableViewCell

@property (nonatomic,strong,readonly)UIButton *commentsBtn;

@property (nonatomic,strong,readonly)UIButton *thumbsupBtn;

@property (nonatomic,strong,readonly)UIButton *addBtn;

@property (nonatomic,strong,readonly)UILabel *nameLabel;

@property (nonatomic,strong,readonly)UILabel *pinyinLabel;


@end

/**
 设计师圈 cell 分类，根据不同的顺序 不同的布局
 */
@interface CTDesignerCellStyle1Cell : CTDesignerCell


@end

@interface CTDesignerCellStyle2Cell : CTDesignerCell


@end

@interface CTDesignerCellStyle3Cell : CTDesignerCell


@end



/**
 定制拼团cell
 */
@interface CTGoodsCell : UITableViewCell

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,strong,readonly)UILabel *priceLabel;

@property (nonatomic,strong,readonly)UILabel *origPriceLabel;

@property (nonatomic,strong,readonly)XKProgressView *progressView;

@property (nonatomic,strong,readonly)UILabel *leftGoodsLabel;

@property (nonatomic,strong,readonly)UIButton *buyBtn;

@property (nonatomic,strong,readonly)UILabel *verifyLabel;

@end


/**
 定制馆 cell
 */
@class CTDesignerHallCell;
@protocol CTDesignerHallCellDelegate <NSObject>

- (void)designerHallCell:(CTDesignerHallCell *_Nonnull)designerHallCell commentsAction:(nullable id)sender;

- (void)designerHallCell:(CTDesignerHallCell *_Nonnull)designerHallCell concernAction:(nullable id)sender;

- (void)designerHallCell:(CTDesignerHallCell *_Nonnull)designerHallCell thumbupAction:(nullable id)sender;

- (void)designerHallCell:(CTDesignerHallCell *_Nonnull)designerHallCell avatarAction:(nullable id)sender;

@end

@interface CTDesignerHallCell : UITableViewCell

@property (nonatomic,strong,readonly)UIButton *commentsBtn;

@property (nonatomic,strong,readonly)UIButton *thumbsupBtn;

@property (nonatomic,strong,readonly)UILabel *worksLabel;

@property (nonatomic,strong,readonly)UIButton *avatarBtn;

@property (nonatomic,strong,readonly)UILabel *nameLabel;

@property (nonatomic,strong,readonly)UILabel *timeLabel;

@property (nonatomic,strong,readonly)UILabel *signatureLabel;

@property (nonatomic,strong,readonly)UILabel *countLabel;

@property (nonatomic,strong)NSArray<NSURL *> *imageUrls;

@property (nonatomic,assign,getter=isConcern) BOOL concern;

@property (nonatomic,weak)id<CTDesignerHallCellDelegate> delegate;

- (void)sizeToFit;

- (void)reloadData;

@end


@class CTWorkCell;
@protocol CTWorkCellDelegate <NSObject>

- (void)workCell:(CTWorkCell *_Nonnull)workCell commentsAction:(nullable id)sender;

- (void)workCell:(CTWorkCell *_Nonnull)workCell thumbupAction:(nullable id)sender;

@end

/**
 作品cell 设计师主页展示
 */
@interface CTWorkCell : UITableViewCell

@property (nonatomic,strong,readonly)UIButton *commentsBtn;

@property (nonatomic,strong,readonly)UIButton *thumbsupBtn;

@property (nonatomic,strong,readonly)UILabel *worksLabel;

@property (nonatomic,strong,readonly)UILabel *timeLabel;

@property (nonatomic,strong,readonly)UILabel *signatureLabel;

@property (nonatomic,strong,readonly)UILabel *countLabel;

@property (nonatomic,strong)NSArray<NSURL *> *imageUrls;

@property (nonatomic,weak)id<CTWorkCellDelegate> delegate;

- (void)sizeToFit;

- (void)reloadData;

@end



@class CTCommentsCell;

@protocol CTCommentsCellDelegate <NSObject>

- (void)commentsCell:(CTCommentsCell *)cell retryAction:(id)sender;

@end

/**
 评论消息 cell
 */
@interface CTCommentsCell : UITableViewCell

@property (nonatomic,strong,readonly)UIImageView *imageView;

@property (nonatomic,strong,readonly)UILabel *nameLabel;

@property (nonatomic,strong,readonly)UILabel *timeLabel;

@property (nonatomic,strong,readonly)UILabel *textLabel;

@property (nonatomic,strong,readonly)UILabel *detailTextLabel;

@property (nonatomic,strong,readonly)UIButton *retryBtn;

@property (nonatomic,weak)id<CTCommentsCellDelegate> delegate;

- (void)setCommentVoModel:(XKDesignerCommentVoModel *)voModel;

@end

NS_ASSUME_NONNULL_END

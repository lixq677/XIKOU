//
//  XKGoodDetailDesView.m
//  XiKou
//
//  Created by L.O.U on 2019/8/1.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKGoodImageDetailView.h"
#import "XKSingleImageCell.h"
#import "XKGoodModel.h"

#import "XKOtherService.h"
#import "XKDataService.h"
#import "YBImageBrowser.h"

@interface XKGoodImageDetailView ()<UITableViewDelegate,UITableViewDataSource>

@end
@implementation XKGoodImageDetailView

- (instancetype)init{
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, 0) style:UITableViewStylePlain];
    if (self) {
        self.delegate = self;
        self.dataSource = self;
        self.separatorStyle  = UITableViewCellSeparatorStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        self.scrollEnabled   = NO;
        [self registerClass:[XKSingleImageCell class] forCellReuseIdentifier:@"XKSingleImageCell"];
    }
    return self;
}

- (void)setImgArray:(NSArray *)imgArray{
    _imgArray = imgArray;
    [self reloadData];
    dispatch_queue_t queueT = dispatch_queue_create("group.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t grpupT = dispatch_group_create();
    
    for (int i = 0; i< imgArray.count; i++) {
        
        dispatch_group_async(grpupT, queueT, ^{
            dispatch_group_enter(grpupT);
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                XKGoodImageModel *model = imgArray[i];
                
                UIImage *image = [UIImage imageFromSdcache:model.url];
                if (image) {
                    model.ImageWidth  = image.size.width;
                    model.ImageHeight = image.size.height;
                    dispatch_group_leave(grpupT);
                }else{
                    [[XKFDataService() otherService]queryImageSizeWithUrl:model.url completion:^(XKBaseResponse * _Nonnull response) {
                        model.ImageWidth = [response.responseObject[@"ImageWidth"][@"value"] floatValue];
                        model.ImageHeight = [response.responseObject[@"ImageHeight"][@"value"] floatValue];
                        dispatch_group_leave(grpupT);
                    }];
                }
            });
        });
        dispatch_group_notify(grpupT, queueT, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self reloadData];
            });
        });
    }
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.imgArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    XKSingleImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"XKSingleImageCell" forIndexPath:indexPath];
    XKGoodImageModel *imgModel = self.imgArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imgModel.url] placeholderImage:[UIImage imageNamed:@"placeholder_background"] options:SDWebImageAvoidDecodeImage];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XKGoodImageModel *imgModel = self.imgArray[indexPath.row];
    
    CGFloat height = (imgModel.ImageHeight/imgModel.ImageWidth * (kScreenWidth - 30));
    return height > 0 ? height : kScreenWidth - 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *datas = [NSMutableArray array];
    [self.imgArray enumerateObjectsUsingBlock:^(XKGoodImageModel *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        YBIBImageData *data = [YBIBImageData new];
        data.imageURL = [NSURL URLWithString:obj.url];
        [datas addObject:data];
    }];
    
    YBImageBrowser *browser = [YBImageBrowser new];
    browser.dataSourceArray = datas;
    browser.currentPage = indexPath.row;
    [browser show];
}

@end

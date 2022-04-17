//
//  XKPageController.m
//  PeachCoin
//
//  Created by Calvin on 2018/7/20.
//  Copyright © 2018年 calvin. All rights reserved.
//

#import "XKPageController.h"

@interface XKPageController ()

@end

@implementation XKPageController

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"currentViewController"];
}

- (void)updateMenuItemTitles {
    NSInteger itemCounts = 0;
    if ([self.dataSource respondsToSelector:@selector(numbersOfChildControllersInPageController:)]) {
        itemCounts = [self.dataSource numbersOfChildControllersInPageController:self];
    }
    for (NSInteger i = 0; i < itemCounts; i ++) {
        WMMenuItem *menuItem = [self.menuView itemAtIndex:i];
        if (self.selectIndex == i) {
            menuItem.font = [UIFont boldSystemFontOfSize:self.titleSizeSelected];
        }else{
            menuItem.font = [UIFont systemFontOfSize:self.titleSizeSelected];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self updateMenuItemTitles];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self addObserver:self forKeyPath:@"currentViewController" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial context:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

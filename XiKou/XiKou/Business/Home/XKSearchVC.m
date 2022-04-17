//
//  XKSearchVC.m
//  XiKou
//
//  Created by 陆陆科技 on 2019/10/8.
//  Copyright © 2019 李笑清. All rights reserved.
//

#import "XKSearchVC.h"

@interface XKSearchVC ()

@end

@implementation XKSearchVC

- (instancetype)initWithSearchResultsController:(UIViewController *)searchResultsController{
    if (self = [super initWithSearchResultsController:searchResultsController]) {
        UITextField *(^__block block)(UIView *view) = ^(UIView *view){
            UITextField *textField = nil;
            for (UIView *v in view.subviews) {
                if ([v isKindOfClass:[UITextField class]]) {
                    textField = (UITextField *)v;
                }else{
                    textField = block(v);
                }
                if (textField) {
                    break;
                }
            }
            return textField;
        };
        UITextField *textField = block(self.searchBar);
        textField.textColor = HexRGB(0x444444, 1.0f);
        textField.font = [UIFont systemFontOfSize:12.0f];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.searchBar.tintColor = HexRGB(0x444444, 1.0f);
    self.searchBar.barTintColor = HexRGB(0xffffff, 1.0f);
    self.view.backgroundColor = HexRGB(0xffffff, 1.0f);
  //  self.searchBar.backgroundImage = [UIImage imageNamed:@"SS_bar"];
    [self.searchBar setImage:[UIImage imageNamed:@"search"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"SS_bar"] forState:UIControlStateNormal];
    self.searchBar.searchFieldBackgroundPositionAdjustment = UIOffsetMake(6, 0);
    self.searchBar.searchTextPositionAdjustment = UIOffsetMake(6, 0);
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.searchBar becomeFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


@end

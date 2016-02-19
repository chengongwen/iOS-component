//
//  ScrollMenu.h
//  ScrollMenu
//
//  Created by yuanshanit on 15/5/7.
//  Copyright (c) 2015年 元善科技. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Menu.h"
#import "MenuButton.h"
#import "IndicatorView.h"

#define kXHMenuButtonPaddingX 30
#define kXHMenuButtonStarX 8

@class ScrollMenu;

@protocol ScrollMenuDelegate <NSObject>

// 选中某个标题按钮
- (void)scrollMenuDidSelected:(ScrollMenu *)scrollMenu menuIndex:(NSUInteger)selectIndex;

// 选中更多按钮
- (void)scrollMenuDidManagerSelected:(ScrollMenu *)scrollMenu;

@end

@interface ScrollMenu : UIView

@property (nonatomic, assign) id <ScrollMenuDelegate> delegate;

// UI
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) IndicatorView *indicatorView;

// DataSource
@property (nonatomic, strong) NSArray *menus;

// select
@property (nonatomic, assign) NSUInteger selectedIndex; // default is 0

/**
 *  设置ScrollMenu标题滑动事件
 *
 *  @param selectedIndex 选择的标题
 *  @param aniamted      是否开启动画效果
 *  @param calledDelgate 是否设置某个代理事件
 */
- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL)aniamted calledDelegate:(BOOL)calledDelgate;

- (CGRect)rectForSelectedItemAtIndex:(NSUInteger)index;

- (MenuButton *)menuButtonAtIndex:(NSUInteger)index;

// reload dataSource
- (void)reloadData;

@end

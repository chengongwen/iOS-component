//
//  CLLockInfoView.h
//  CoreLock
//
//  Created by 成林 on 15/4/27.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//  仅仅是做展示用

#import <UIKit/UIKit.h>

//背景色   深蓝色
#define BACKGROUNDCOLOR [UIColor colorWithRed:0.05 green:0.2 blue:0.35 alpha:1]

//选中颜色  浅蓝色
#define SELECTCOLOR [UIColor colorWithRed:0.13 green:0.7 blue:0.96 alpha:1]

//选错的颜色  红色
#define WRONGCOLOR [UIColor colorWithRed:1 green:0 blue:0 alpha:1]


@interface CLLockInfoView : UIView

- (void)resultArr:(NSArray *)array fillColor:(UIColor *)color;

@end

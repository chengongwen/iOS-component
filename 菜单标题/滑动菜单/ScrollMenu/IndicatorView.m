//
//  IndicatorView.m
//  ScrollMenu
//
//  Created by yuanshanit on 15/5/7.
//  Copyright (c) 2015年 元善科技. All rights reserved.
//

#import "IndicatorView.h"

@implementation IndicatorView

- (void)setIndicatorWidth:(CGFloat)indicatorWidth {
    
    _indicatorWidth = indicatorWidth;
    CGRect indicatorRect = self.frame;
    indicatorRect.size.width = _indicatorWidth;
    self.frame = indicatorRect;
}

+ (instancetype)initIndicatorView {
    
    IndicatorView *indicatorView = [[IndicatorView alloc] initWithFrame:CGRectMake(0, 0, 50, kXHIndicatorViewHeight)];
    return indicatorView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.752 green:0.026 blue:0.034 alpha:1.000];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end

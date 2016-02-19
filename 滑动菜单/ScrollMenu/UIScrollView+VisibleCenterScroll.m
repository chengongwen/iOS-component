//
//  UIScrollView+VisibleCenterScroll.m
//  ScrollMenu
//
//  Created by yuanshanit on 15/5/7.
//  Copyright (c) 2015年 元善科技. All rights reserved.
//

#import "UIScrollView+VisibleCenterScroll.h"

@implementation UIScrollView (VisibleCenterScroll)

- (void)scrollRectToVisibleCenteredOn:(CGRect)visibleRect
                             animated:(BOOL)animated {
    
    CGRect centeredRect = CGRectMake(visibleRect.origin.x + visibleRect.size.width/2.0 - self.frame.size.width/2.0,
                                     visibleRect.origin.y + visibleRect.size.height/2.0 - self.frame.size.height/2.0,
                                     self.frame.size.width,
                                     self.frame.size.height);
    
    [self scrollRectToVisible:centeredRect
                     animated:animated];
}

@end

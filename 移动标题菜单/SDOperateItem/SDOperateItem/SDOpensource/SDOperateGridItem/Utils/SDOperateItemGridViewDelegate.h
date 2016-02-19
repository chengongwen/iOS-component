//
//  SDOperateItemGridViewDelegate.h
//  SDOperateItem
//
//  Created by chengongwen on 15/12/2.
//  Copyright © 2015年 yuanshanit. All rights reserved.
//

 /* SDOperateItemGridViewDelegate_h */


@class SDHomeGridView;

@protocol SDOperateItemGridViewDelegate <NSObject>

@optional

/**
 *  点击选中当前item
 */
- (void)homeGrideView:(UIView *)gridView selectItemAtIndex:(NSInteger)index;

/**
 *  改变并刷新视图
 */
- (void)homeGrideViewDidChangeItems:(UIView *)gridView;

/**
 *  点击更多
 */
- (void)homeGrideViewmoreItemButtonClicked:(UIView *)gridView;

@end
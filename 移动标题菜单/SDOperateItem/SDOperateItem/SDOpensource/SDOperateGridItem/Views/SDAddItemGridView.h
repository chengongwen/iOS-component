//
//  SDAddItemGridView.h
//  GSD_ZHIFUBAO
//
//  Created by aier on 15-6-7.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 *********************************************************************************
 
 */

#import <UIKit/UIKit.h>
#import "SDOperateItemGridViewDelegate.h"

@interface SDAddItemGridView : UIScrollView <UIScrollViewDelegate,SDOperateItemGridViewDelegate>

@property (nonatomic, weak) id<SDOperateItemGridViewDelegate> gridViewDelegate;

@property (nonatomic, strong) NSArray *gridModelsArray;

@property (nonatomic, copy) void (^itemClickedOperationBlock)(SDAddItemGridView *gridView, NSInteger index);

@end

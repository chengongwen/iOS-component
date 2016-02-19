//
//  SDGridItemCacheTool.h
//  GSD_ZHIFUBAO
//
//  Created by gsd on 15/8/11.
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

#import <Foundation/Foundation.h>


@interface SDGridItemCacheTool : NSObject


/**
 *  获取当前首页标题数组列表
 *
 *  @return 标题数组列表
 */
+ (NSArray *)loadHomeItemsArrayList;

/**
 *  保存当前首页标题数组列表
 *
 *  @param array 标题数组列表
 */
+ (void)saveHomeItemsArrayList:(NSArray *)array;

/**
 *  获取更多标题数组列表
 *
 *  @return 标题数组列表
 */
+ (NSArray *)loadAddItemsArrayList;

/**
 *  保存更多标题数组列表
 *
 *  @param array 标题数组列表
 */
+ (void)saveAddItemsArrayList:(NSArray *)array;

/**
 *  根据标题索引增加标题
 *
 *  @param title 标题
 *
 *  @return NO/YES
 */
+ (BOOL)addItemsList:(NSString *)title;

/**
 *  根据标题索引删除标题
 *
 *  @param title 标题
 *
 *  @return NO/YES
 */
+ (BOOL)removeItemsList:(NSString *)title;

@end

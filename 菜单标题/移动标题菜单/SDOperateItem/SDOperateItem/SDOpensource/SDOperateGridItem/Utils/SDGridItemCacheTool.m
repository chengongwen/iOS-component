//
//  SDGridItemCacheTool.m
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

#import "SDGridItemCacheTool.h"

#define kHomeItemsLimitCount 15

#define kAllItemsArrayCacheKey @"ItemsArrayCacheKey"
#define kHomeItemsArrayCacheKey @"HomeItemsArrayCacheKey"
#define kAddItemsArrayCacheKey @"AddItemsArrayCacheKey"

@implementation SDGridItemCacheTool

+ (void)initialize {
    
    // 初始化griditems
    NSArray *itemsCache = [SDGridItemCacheTool itemsArray];
    if (!itemsCache) {
        
        // 模拟数据
        itemsCache = @[ @{@"淘宝" : @"i00"}, // title => imageString
                        @{@"生活缴费" : @"i01"},
                        @{@"教育缴费" : @"i02"},
                        @{@"红包" : @"i03"},
                        @{@"物流" : @"i04"},
                        @{@"信用卡" : @"i05"},
                        @{@"转账" : @"i06"},
                        @{@"爱心捐款" : @"i07"},
                        @{@"彩票" : @"i08"},
                        @{@"当面付" : @"i09"},
                        @{@"余额宝" : @"i10"},
                        @{@"AA付款" : @"i11"},
                        @{@"国际汇款" : @"i12"},
                        @{@"淘点点" : @"i13"},
                        @{@"淘宝电影" : @"i14"},
                        @{@"亲密付" : @"i15"},
                        @{@"股市行情" : @"i16"},
                        @{@"汇率换算" : @"i17"},
                        @{@"天猫" : @"i18"},
                        @{@"贷款" : @"i19"},
                        @{@"天天驾校" : @"i20"}
                     ];
        
        [[NSUserDefaults standardUserDefaults] setObject:itemsCache forKey:kAllItemsArrayCacheKey];
        
        NSMutableArray *arrHomeItemList = [NSMutableArray arrayWithCapacity:10];
        NSMutableArray *arrAddItemList = [NSMutableArray arrayWithCapacity:10];
        
        int i = 0;
        for (NSDictionary *dic in itemsCache) {
            if (i <= kHomeItemsLimitCount) {
                [arrHomeItemList addObject:dic];
            }
            else {
                [arrAddItemList addObject:dic];
            }
            i++;
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:arrHomeItemList forKey:kHomeItemsArrayCacheKey];
        [[NSUserDefaults standardUserDefaults] setObject:arrAddItemList forKey:kAddItemsArrayCacheKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSArray *)itemsArray {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAllItemsArrayCacheKey];
}

/**
 *  获取当前首页标题数组列表
 */
+ (NSArray *)loadHomeItemsArrayList {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kHomeItemsArrayCacheKey];
}

/**
 *  保存当前首页标题数组列表
 */
+ (void)saveHomeItemsArrayList:(NSArray *)array {
    [[NSUserDefaults standardUserDefaults] setObject:[array copy] forKey:kHomeItemsArrayCacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
 

/**
 *  获取更多标题数组列表
 */
+ (NSArray *)loadAddItemsArrayList {
    return [[NSUserDefaults standardUserDefaults] objectForKey:kAddItemsArrayCacheKey];
}

/**
 *  保存更多标题数组列表
 */
+ (void)saveAddItemsArrayList:(NSArray *)array {
    [[NSUserDefaults standardUserDefaults] setObject:[array copy] forKey:kAddItemsArrayCacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *  根据标题索引操作（增加/删除）标题
 */
+ (BOOL)addItemsList:(NSString *)title {
    BOOL result = NO;
    
    NSArray *itemsCache = [SDGridItemCacheTool itemsArray];
    NSMutableArray *homeItemsArrayList = [NSMutableArray arrayWithArray:[SDGridItemCacheTool loadHomeItemsArrayList]];
    
    if (homeItemsArrayList.count <= kHomeItemsLimitCount) {
        
        NSMutableArray *addItemsArrayList = [NSMutableArray arrayWithArray:[SDGridItemCacheTool loadAddItemsArrayList]];
        
        for (NSDictionary *itemDict in itemsCache) {
            
            NSString *itemTitle = [itemDict.allKeys firstObject];
            if ([itemTitle isEqualToString:title]) {
                
                [homeItemsArrayList addObject:itemDict];
                [addItemsArrayList removeObject:itemDict];
                
                result = YES;
                break;
            }
        }
        [[NSUserDefaults standardUserDefaults] setObject:homeItemsArrayList forKey:kHomeItemsArrayCacheKey];
        [[NSUserDefaults standardUserDefaults] setObject:addItemsArrayList forKey:kAddItemsArrayCacheKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return result;
}

+ (BOOL)removeItemsList:(NSString *)title {
    BOOL result = NO;
    
    NSArray *itemsCache = [SDGridItemCacheTool itemsArray];
    NSMutableArray *homeItemsArrayList = [NSMutableArray arrayWithArray:[SDGridItemCacheTool loadHomeItemsArrayList]];
    
    NSMutableArray *addItemsArrayList = [NSMutableArray arrayWithArray:[SDGridItemCacheTool loadAddItemsArrayList]];
    
    for (NSDictionary *itemDict in itemsCache) {
        
        NSString *itemTitle = [itemDict.allKeys firstObject];
        if ([itemTitle isEqualToString:title]) {
            
            [homeItemsArrayList removeObject:itemDict];
            [addItemsArrayList addObject:itemDict];
            
            result = YES;
            break;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:homeItemsArrayList forKey:kHomeItemsArrayCacheKey];
    [[NSUserDefaults standardUserDefaults] setObject:addItemsArrayList forKey:kAddItemsArrayCacheKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return result;
}
@end

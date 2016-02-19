//
//  FMDBShareSession.h
//  FMDBDemo
//
//  Created by yuanshanit on 14/11/25.
//  Copyright (c) 2014年 liudonggan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMDBDataInstance.h"
#import "UserMessages.h"

@interface FMDBShareSession : NSObject

@property(nonatomic, retain) FMDatabase * database;

/**
 *  保存个人信息
 *
 *  @param account  账号
 *  @param password 密码
 *  @param data     Data
 *
 *  @return YES,成功；
 */
- (BOOL)storeUserMessagesWithAccount:(NSString *)account password:(NSString *)password data:(NSString *)data;

/**
 *  加载获取个人信息
 *
 *  @param account  账号
 *  @param password 密码
 *
 *  @return UserMessages*
 */
- (UserMessages *)reloadUserMessagesWithAccount:(NSString *)account;

/**
 *  删除特定查询数据
 *
 *  @param account 账号
 *
 *  @return YES,成功；
 */
- (BOOL)deleteUserMessagesWithAccount:(NSString *)account;

/**
 *  删除一个表的数据
 *
 *  @return YES,成功；
 */
- (BOOL)deleteFMDatabase;

@end

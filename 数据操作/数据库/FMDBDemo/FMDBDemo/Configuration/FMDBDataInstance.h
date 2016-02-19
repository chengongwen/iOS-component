//
//  FMDBDataInstance.h
//  FMDBDemo
//
//  Created by yuanshanit on 14/11/25.
//  Copyright (c) 2014年 yuanshanit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"


//  个人信息
#define kFMDBUserMessagesInitSql @"CREATE  TABLE IF NOT EXISTS \"UserMessages\" ( \"resourceid\" INTEGER PRIMARY KEY  NOT NULL, \"account\" TEXT, \"password\" TEXT,\"content\" TEXT, \"updateDate\" TEXT)"

@interface FMDBDataInstance : NSObject

@property (retain, nonatomic) FMDatabase *database;
@property (retain, nonatomic) NSString *dbPath;//数据库完整路径，包含文件名

/**
 *  初始化数据库
 */
+ (id)FMDBDataInstanceSession;

@end

//
//  FMDBShareSession.m
//  FMDBDemo
//
//  Created by yuanshanit on 14/11/25.
//  Copyright (c) 2014年 yuanshanit. All rights reserved.
//

#import "FMDBShareSession.h"
#import "UserMessages.h"

@implementation FMDBShareSession
@synthesize database=_database;

#pragma mark - memory management
- (void)dealloc
{
    [_database release];
    [super dealloc];
}

/**
 *  加载获取个人信息
 */
- (UserMessages *)reloadUserMessagesWithAccount:(NSString *)account
{
    self.database = [[FMDBDataInstance FMDBDataInstanceSession] database];
    
    BOOL result = [self.database open];
    
    if (!result) {
        return nil;
    }
    
    // 设置查询条件
    NSString *sql=[NSString stringWithFormat:@"select * from UserMessages WHERE account = \"%@\"", account];
    
    FMResultSet * rs = [self.database executeQuery:sql];
    NSMutableArray * recordArray = [[NSMutableArray alloc]initWithCapacity:4];
    while ([rs next]) {
        UserMessages * userMessage = [[UserMessages alloc]init];
        userMessage.account = [rs stringForColumn:@"account"];
        userMessage.password = [rs stringForColumn:@"password"];
        userMessage.content = [rs stringForColumn:@"content"];
        userMessage.updateDate = [rs stringForColumn:@"updateDate"];
        [recordArray addObject:userMessage];
        [userMessage release];
    }
    [rs close];
    [self.database close];
    
    if (recordArray.count <= 0) {
        
        return nil;
    }
    
    UserMessages *userMessages = recordArray[0];
    
    return userMessages;
}


/**
 *  保存个人信息
 */
- (BOOL)storeUserMessagesWithAccount:(NSString *)account password:(NSString *)password data:(NSString *)data
{
    /* 数据库 */
    self.database=[[FMDBDataInstance FMDBDataInstanceSession] database];
    
    BOOL result = [self.database open];
    
    if (!result) {
        return result;
    }

    UserMessages *userMessage = [[UserMessages alloc]init];
    userMessage.account = account;
    userMessage.password = password;
    userMessage.content = data;
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    userMessage.updateDate = [dateFormatter stringFromDate:[NSDate date]];
    
    /* 数据库 */
    [self.database beginTransaction];
    
    if (result) {
        
        // 查找遍历数据库
        FMResultSet *rs = [self.database executeQuery:@"select account FROM UserMessages WHERE account = ?" withArgumentsInArray:[NSArray arrayWithObjects:account,nil]];
        
        if ([rs next]) {
            
            // 更新数据库
            result = [self.database executeUpdate:@"update UserMessages SET password = ?,content=?,updateDate=? WHERE account = ? " withArgumentsInArray:[NSArray arrayWithObjects:userMessage.password,userMessage.content,userMessage.updateDate,account, nil]];
        }
        else
        {
            // 插入数据库
            result = [self.database executeUpdate:@"insert into UserMessages (account,password,content,updateDate) values(?,?,?,?)"
                             withArgumentsInArray:[NSArray arrayWithObjects:userMessage.account,userMessage.password,userMessage.content,userMessage.updateDate, nil]];
        }
        [rs close];
        [userMessage release];
        
        if (result) {
        #ifdef DEBUG
            NSLog(@"添加成功");
        #endif
            [self.database commit];
        }
        else
        {
        #ifdef DEBUG
            NSLog(@"添加失败");
        #endif
            [self.database rollback];
        }
    }
    
    [self.database close];
    
    return result;
}

/**
 *  删除特定查询数据
 */
- (BOOL)deleteUserMessagesWithAccount:(NSString *)account
{
    self.database = [[FMDBDataInstance FMDBDataInstanceSession] database];
    
    BOOL result = [self.database open];
    
    if (!result) {
        return result;
    }
    
    // 设置删除条件
    NSString *sql=[NSString stringWithFormat:@"delete from UserMessages WHERE account = \"%@\"",account];
    
    result = [self.database executeUpdate:sql];
    
    [self.database close];
    
    return result;
}

/**
 *  删除一个表的数据
 */
- (BOOL)deleteFMDatabase
{
    self.database = [[FMDBDataInstance FMDBDataInstanceSession] database];
    
    BOOL result = [self.database open];
    
    if (!result) {
        return result;
    }
    
    // 设置删除条件
    NSString *sql=[NSString stringWithFormat:@"delete from UserMessages "];
    
    result = [self.database executeUpdate:sql];
    
    [self.database close];
    
    return result;
}

@end

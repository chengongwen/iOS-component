//
//  FMDBDataInstance.m
//  FMDBDemo
//
//  Created by yuanshanit on 14/11/25.
//  Copyright (c) 2014年 yuanshanit. All rights reserved.
//

#import "FMDBDataInstance.h"

static FMDBDataInstance *instance=nil;

@implementation FMDBDataInstance
@synthesize database=_database;
@synthesize dbPath=_dbPath;


#pragma mark - memory management
- (void)dealloc
{
    [_database release];
    [_dbPath release];
    [super dealloc];
}

+ (NSString *)appDBPath
{
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];   //获取应用Document目录路径;
    
    NSString *stingPath=[NSString stringWithFormat:@"data.sqlite3"];
    NSString *dbPath = [rootPath stringByAppendingPathComponent:stingPath];
    #ifdef DEBUG
        NSLog(@"++++dbPath=%@",dbPath);
    #endif
    return dbPath;
}

+ (id)FMDBDataInstanceSession
{
    if (!instance)
    {
        @synchronized(self)
        {
            instance = [[FMDBDataInstance alloc] initWithDBPath:[FMDBDataInstance appDBPath]];
        }
    }
    return instance;
}

- (id)initWithDBPath:(NSString *)path
{
    if (self = [super init])
    {
        FMDatabase *db = [[FMDatabase alloc] initWithPath:path];
        self.database = db;
        [self.database open];
        
        //初使化表结构
        [self.database executeUpdate:kFMDBUserMessagesInitSql];
        [db release];
        [self.database close];
    }
    return self;
}

- (FMDatabase *)dataBase
{
    return self.database;
}


@end

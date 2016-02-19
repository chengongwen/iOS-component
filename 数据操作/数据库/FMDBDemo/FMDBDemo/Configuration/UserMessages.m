//
//  UserMessages.m
//  FMDBDemo
//
//  Created by yuanshanit on 14/11/25.
//  Copyright (c) 2014年 yuanshanit. All rights reserved.
//

#import "UserMessages.h"

@implementation UserMessages
@synthesize resourceid = _resourceid;
@synthesize account = _account;
@synthesize password = _password;
@synthesize content = _content;
@synthesize updateDate = _updateDate;

#pragma mark - memory management
- (void)dealloc
{
    [_account release];
    [_password release];
    [_content release];
    [_updateDate release];
    [super dealloc];
}

- (id)initWithAccount:(NSString *)account password:(NSString *)password content:(NSString *)content updateDate:(NSString *)updateDate
{
    if (self = [super init]) {
        self.account = account;
        self.password = password;
        self.content = content;
        self.updateDate = updateDate;
    }
    return self;
}

@end

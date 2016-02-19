//
//  UserMessages.h
//  FMDBDemo
//
//  Created by yuanshanit on 14/11/25.
//  Copyright (c) 2014年 yuanshanit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserMessages : NSObject

@property (assign, nonatomic) NSUInteger resourceid;
@property (retain, nonatomic) NSString *account;
@property (retain, nonatomic) NSString *password;
@property (retain, nonatomic) NSString *content;
@property (retain, nonatomic) NSString *updateDate;

- (id)initWithAccount:(NSString *)account password:(NSString *)password content:(NSString *)content updateDate:(NSString *)updateDate;

@end

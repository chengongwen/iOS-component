//
//  ViewController.m
//  FMDBDemo
//
//  Created by yuanshanit on 15/3/27.
//  Copyright (c) 2015年 元善科技. All rights reserved.
//

#import "ViewController.h"
#import "FMDBShareSession.h"
#import "UserMessages.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"数据库操作";
    
    // 初始化数据
    UserMessages *user1 = [[UserMessages alloc] initWithAccount:@"18520266186" password:@"18520266186" content:@"18520266186" updateDate:nil];
    
    UserMessages *user2 = [[UserMessages alloc] initWithAccount:@"1234567" password:@"1234567" content:@"1234567" updateDate:nil];
    
    NSArray *data = @[@1,@2,@3,@4,@5,@6,@7,@8];
    UserMessages *user3 = [[UserMessages alloc] initWithAccount:@"12345678" password:@"12345678" content:[NSString stringWithFormat:@"%@",data] updateDate:nil];
    
    // 插入数据
    FMDBShareSession *shareSession = [[FMDBShareSession alloc] init];
    
    // 插入数据
    BOOL result = [shareSession storeUserMessagesWithAccount:user1.account password:user1.password data:user1.content];
    
    if (result) {
        [shareSession storeUserMessagesWithAccount:user2.account password:user2.password data:user2.content];
    }
    
    if (result) {
        [shareSession storeUserMessagesWithAccount:user3.account password:user3.password data:user3.content];
    }
    
    // 查找数据
    UserMessages *userMesg1 = [shareSession reloadUserMessagesWithAccount:user1.account];
    NSLog(@"userMesg1= %@",userMesg1.account);
    result = [shareSession deleteUserMessagesWithAccount:user1.account];
    UserMessages *userMesg11 = [shareSession reloadUserMessagesWithAccount:user1.account];
    NSLog(@"userMesg11++++= %@",userMesg11.account);
    
    UserMessages *userMesg2 = [shareSession reloadUserMessagesWithAccount:user2.account];
    NSLog(@"userMesg2= %@",userMesg2.account);
//    result = [shareSession deleteFMDatabase];
    UserMessages *userMesg22 = [shareSession reloadUserMessagesWithAccount:user2.account];
    NSLog(@"userMesg22++++= %@",userMesg22.account);
    
    [user1 release];
    [user2 release];
    [user3 release];
    [shareSession release];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

//
//  CLLockVC.h
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    
    //设置密码
    CoreLockTypeSetPwd=0,
    
    //输入并验证密码
    CoreLockTypeVeryfiPwd,
    
    //修改密码
    CoreLockTypeModifyPwd,
    
}CoreLockType;

@interface CLLockVC : UIViewController

@property (nonatomic,assign) CoreLockType type;


/*======================***************************====================*/
/**
 *  保存当前应用手势密码的开启/关闭状态
 *
 *  @param status YES/NO
 */
+ (void)saveCodeLockStatus:(BOOL)status;

/**
 *  返回当前密码开启/关闭状态
 */
+ (BOOL)hasCodeLockStatus;

/**
 *  清除当前缓存的密码
 */
+ (void)clearPwd;

/*======================***************************====================*/


/*
 *  是否有本地密码缓存？即用户是否设置过初始密码？
 */
+(BOOL)hasPwd;

/*
 *  设置密码----展示设置密码控制器
 */
+(instancetype)showSettingLockVCInVC:(UIViewController *)vc successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock failureBlock:(void(^)(CLLockVC *lockVC))failureBlock ;



/*
 *  验证密码----展示验证密码输入框
 */
+(instancetype)showVerifyLockVCInVC:(UIViewController *)vc forgetPwdBlock:(void(^)())forgetPwdBlock successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock failureBlock:(void(^)(CLLockVC *lockVC))failureBlock ;



/*
 * 修改密码----展示验证密码输入框
 */
+(instancetype)showModifyLockVCInVC:(UIViewController *)vc forgetPwdBlock:(void(^)())forgetPwdBlock successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock failureBlock:(void(^)(CLLockVC *lockVC))failureBlock ;


/*
 *  消失
 */
-(void)dismiss:(NSTimeInterval)interval;

@end

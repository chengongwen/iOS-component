//
//  MainVC.m
//  TouchID
//
//  Created by ryu-ushin on 5/25/15.
//  Copyright (c) 2015 rain. All rights reserved.
//

#import "SmileMainVC.h"
#import "SmileAuthenticator.h"
#import "CLLockVC.h"

#import "TouchIdUnlock.h"           //指纹解锁

@interface SmileMainVC () <SmileAuthenticatorDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *mySwitch;
@property (weak, nonatomic) IBOutlet UIButton *changePasswordButton;

@property (weak, nonatomic) IBOutlet UISwitch *codeLockSwitch;
@property (weak, nonatomic) IBOutlet UIButton *btnCodeLock;
@end

@implementation SmileMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [SmileAuthenticator sharedInstance].delegate = self;
    
    self.title = @"User Data In Here";
    
//    [CLLockVC clearPwd];
    
    /**
     能否 进行校验指纹(即，指纹解锁)
     */
    BOOL canVerifyTouchID = [[TouchIdUnlock sharedInstance] canVerifyTouchID];
    if (canVerifyTouchID) {
        
        /**
         能否 进行校验指纹(即，指纹解锁)
         */
        BOOL canVerifyTouchID = [[TouchIdUnlock sharedInstance] canVerifyTouchID];
        if (canVerifyTouchID) {
            
            /**
             *  校验指纹(即，指纹解锁)
             */
            [[TouchIdUnlock sharedInstance] startVerifyTouchIDWithSuccess:^{
                
                //
            } andFailure:^(NSError *error) {
                
                /**
                 *  指纹验证失败，采取手势密码解锁
                 */
                NSLog(@"指纹验证失败%li",error.code);
                
                [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
                    
                    NSLog(@"忘记密码");
                    
                }successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                    
                    NSLog(@"密码正确");
                    [lockVC dismiss:1.0f];
                }failureBlock:^(CLLockVC *lockVC){
                    
                    NSLog(@"密码错误");
                    [lockVC dismiss:.1f];
                }];
            }];
        }
    }
    // 无指纹，判断是否有手势密码
    else if([CLLockVC hasPwd] && [CLLockVC hasCodeLockStatus]){
        
        /**
         *  采取手势密码解锁
         */
        [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
            
            NSLog(@"忘记密码");
            
        }successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            
            NSLog(@"密码正确");
            [lockVC dismiss:1.0f];
        }failureBlock:^(CLLockVC *lockVC){
            
            NSLog(@"密码错误");
            [lockVC dismiss:.1f];
        }];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // 判断密码是否已经设置
    if ([SmileAuthenticator hasPassword]) {
        self.mySwitch.on = YES;
        self.changePasswordButton.hidden = NO;
    } else {
        self.mySwitch.on = NO;
        self.changePasswordButton.hidden = YES;
    }
    
    
    // 判断手势密码是否开启
    if([CLLockVC hasPwd] && [CLLockVC hasCodeLockStatus]){
        
        self.codeLockSwitch.on = YES;
        self.btnCodeLock.hidden = NO;
    }else{
        
        self.codeLockSwitch.on = NO;
        self.btnCodeLock.hidden = YES;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([SmileAuthenticator hasPassword]) {
        [SmileAuthenticator sharedInstance].securityType = INPUT_TOUCHID;
        [[SmileAuthenticator sharedInstance] presentAuthViewControllerAnimated:NO];
    }
}

- (IBAction)changePassword:(id)sender {
    [SmileAuthenticator sharedInstance].securityType = INPUT_THREE;
    [[SmileAuthenticator sharedInstance] presentAuthViewControllerAnimated:TRUE];
}

- (IBAction)passwordSwitch:(UISwitch*)passwordSwitch {
    if (passwordSwitch.on) {
        [SmileAuthenticator sharedInstance].securityType = INPUT_TWICE;
    } else {
        [SmileAuthenticator sharedInstance].securityType = INPUT_ONCE;
    }
    
    [[SmileAuthenticator sharedInstance] presentAuthViewControllerAnimated:TRUE];
}


- (IBAction)codeLockSwitch:(UISwitch*)codeSwitch {
    
    // 当前密码没有缓存，则设置密码
    if(![CLLockVC hasPwd]){
        
        /**
         *  设置密码
         */
        [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            
                NSLog(@"密码设置成功");
                [lockVC dismiss:1.0f];
            
        } failureBlock:^(CLLockVC *lockVC){
            
                NSLog(@"密码设置失败");
                [lockVC dismiss:1.0f];
        }];
    }
    else {
        
        // 开启密码前需要验证
        if (codeSwitch.on) {
            
            /**
             *  验证密码
             */
            [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
                
                NSLog(@"忘记密码");
                
                codeSwitch.on = NO;
                // 保存当前应用是否开启手势密码的状态
                [CLLockVC saveCodeLockStatus:NO];
                
            } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
                
                NSLog(@"密码正确");
                [lockVC dismiss:1.0f];
            } failureBlock:^(CLLockVC *lockVC){
                
                NSLog(@"密码错误");
                
                codeSwitch.on = NO;
                // 保存当前应用是否开启手势密码的状态
                [CLLockVC saveCodeLockStatus:NO];
                [lockVC dismiss:.1f];
                
            }];
        }
        else {
            self.btnCodeLock.hidden = YES;
        }
    }
    
    // 保存当前应用是否开启手势密码的状态
    [CLLockVC saveCodeLockStatus:codeSwitch.on];
}


- (IBAction)changCodeLockClick:(id)sender {
    
    /**
     *  修改密码
     */
    if([CLLockVC hasPwd]){
        
        [CLLockVC showModifyLockVCInVC:self forgetPwdBlock:^{
            
            //
            NSLog(@"忘记密码");
            
        }successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            
            NSLog(@"修改密码成功");
            [lockVC dismiss:.5f];
            
        } failureBlock:^(CLLockVC *lockVC) {
            
            NSLog(@"修改密码失败");
            [lockVC dismiss:.5f];
        }];
    }
}

#pragma mark - AuthenticatorDelegate

- (void)userFailAuthenticationWithCount:(NSInteger)failCount{
    
    NSLog(@"userFailAuthenticationWithCount: %ld", (long)failCount);
}

-(void)userSuccessAuthentication{
    NSLog(@"userSuccessAuthentication");
}

-(void)userTurnPasswordOn{
    NSLog(@"userTurnPasswordOn");
}

-(void)userTurnPasswordOff{
    NSLog(@"userTurnPasswordOff");
}

-(void)userChangePassword{
    NSLog(@"userChangePassword");
}

-(void)AuthViewControllerPresented{
    NSLog(@"presentAuthViewController");
}

-(void)AuthViewControllerDismssed{
    NSLog(@"dismissAuthViewController");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

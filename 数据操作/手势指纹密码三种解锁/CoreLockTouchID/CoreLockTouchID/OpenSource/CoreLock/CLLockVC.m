//
//  CLLockVC.m
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CLLockVC.h"
#import "CoreLockConst.h"
#import "CoreArchive.h"
#import "CLLockLabel.h"
#import "CLLockNavVC.h"
#import "CLLockView.h"
#import "CLLockInfoView.h"


@interface CLLockVC ()

/** 操作成功：密码设置成功、密码验证成功 */
@property (nonatomic,copy) void (^successBlock)(CLLockVC *lockVC,NSString *pwd);

@property (nonatomic,copy) void (^failureBlock)(CLLockVC *lockVC);

@property (nonatomic,copy) void (^forgetPwdBlock)();

@property (nonatomic,weak) UIViewController *vc;

@property (nonatomic,strong) UIBarButtonItem *resetItem;

@property (nonatomic,copy) NSString *modifyCurrentTitle;
@property (nonatomic,copy) NSString *msg;

@property (weak, nonatomic) IBOutlet CLLockLabel *label;    // 手势滑动后展示结果
@property (weak, nonatomic) IBOutlet CLLockView *lockView;  // 设置手势密码视图
@property (weak, nonatomic) IBOutlet CLLockInfoView *lockInfoView; // 展示手势密码视图

@property (weak, nonatomic) IBOutlet UIView *actionView;    // 操作按钮视图（修改按钮、忘记密码按钮）
@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;


/** 直接进入修改页面的 */
@property (nonatomic,assign) BOOL isDirectModify;


@property (nonatomic, assign) NSInteger coreLockErrorNum; // 验证密码错误次数

@end

@implementation CLLockVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.coreLockErrorNum = 0;

    //控制器准备
    [self vcPrepare];
    
    //数据传输
    [self dataTransfer];
    
    //事件
    [self event];
}


/*
 *  事件
 */
-(void)event{
    
    
    /*
     *  设置密码
     */
    
    /** 开始输入：第一次 */
    self.lockView.setPWBeginBlock = ^(){
        
        [self.label showNormalMsg:CoreLockPWDTitleFirst];
    };
    
    /** 开始输入：确认 */
    self.lockView.setPWConfirmlock = ^(){
        
        [self.label showNormalMsg:CoreLockPWDTitleConfirm];
    };
    
    
    /** 密码长度不够 */
    self.lockView.setPWSErrorLengthTooShortBlock = ^(NSUInteger currentCount){
      
        [self.label showWarnMsg:[NSString stringWithFormat:@"请连接至少%@个点",@(CoreLockMinItemCount)]];
    };
    
    /** 两次密码不一致 */
    self.lockView.setPWSErrorTwiceDiffBlock = ^(NSString *pwd1,NSString *pwdNow){
        
        [self.label showWarnMsg:CoreLockPWDDiffTitle];
        
        self.navigationItem.rightBarButtonItem = self.resetItem;
    };
    
    /** 第一次输入密码：正确 */
    self.lockView.setPWFirstRightBlock = ^(){
      
        [self.label showNormalMsg:CoreLockPWDTitleConfirm];
    };
    
    /** 再次输入密码一致 */
    self.lockView.setPWTwiceSameBlock = ^(NSString *pwd){
      
        [self.label showNormalMsg:CoreLockPWSuccessTitle];
        
        //存储密码
        [CoreArchive setStr:pwd key:CoreLockPWDKey];
        
        //禁用交互
        self.view.userInteractionEnabled = NO;
        
        if(_successBlock != nil) _successBlock(self,pwd);
        
        if(CoreLockTypeModifyPwd == _type){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    };
    
    
    
    /*
     *  验证密码
     */
    
    /** 开始 */
    self.lockView.verifyPWBeginBlock = ^(){
        
        [self.label showNormalMsg:CoreLockVerifyNormalTitle];
    };
    
    /** 验证 */
    self.lockView.verifyPwdBlock = ^(NSString *pwd){
    
        //取出本地密码
        NSString *pwdLocal = [CoreArchive strForKey:CoreLockPWDKey];
        
        BOOL res = [pwdLocal isEqualToString:pwd];
        
        if(res){//密码一致
            
            self.coreLockErrorNum = 0;
            
            [self.label showNormalMsg:CoreLockVerifySuccesslTitle];
            
            if(CoreLockTypeVeryfiPwd == _type){
                
                //禁用交互
                self.view.userInteractionEnabled = NO;
                
            }else if (CoreLockTypeModifyPwd == _type){//修改密码
                
                [self.label showNormalMsg:CoreLockPWDTitleFirst];
                
                self.modifyCurrentTitle = CoreLockPWDTitleFirst;
            }
            
            if(CoreLockTypeVeryfiPwd == _type) {
                if(_successBlock != nil) _successBlock(self,pwd);
            }
            
        }else{//密码不一致
            
            if (CoreLockTypeVeryfiPwd == _type || CoreLockTypeModifyPwd == _type)
            {
                //输入次数限制
                self.coreLockErrorNum ++;
                
                if (self.coreLockErrorNum >= CoreLockErrorCount) { // 次数超过时
                    
                    [self.label showWarnMsg:CoreLockVerifyErrorPwdTitle];
                    if(_failureBlock != nil) _failureBlock(self);
                }
                else {
                    
                    [self.label showWarnMsg:[NSString stringWithFormat:@"%@,您还有%ld次验证密码机会",CoreLockVerifyErrorPwdTitle,(long)(CoreLockErrorCount - self.coreLockErrorNum)]];
                }
            }

        }
        
        return res;
    };
    
    
    
    /*
     *  修改
     */
    
    /** 开始 */
    self.lockView.modifyPwdBlock =^(){
      
        [self.label showNormalMsg:self.modifyCurrentTitle];
    };
    
    
    
    /**
     *  在手势结束滑动后，返回手势密码
     */
    self.lockView.passwordBlock = ^(NSString *pwd) {
        
        NSArray *resultArr = [pwd componentsSeparatedByString:@"-"];
        
        [self.lockInfoView resultArr:resultArr fillColor:SELECTCOLOR];
    };
}

/*
 *  数据传输
 */
-(void)dataTransfer{
    
    [self.label showNormalMsg:self.msg];
    
    //传递类型
    self.lockView.type = self.type;
}

/*
 *  控制器准备
 */
-(void)vcPrepare{
    
    //设置背景色
    self.view.backgroundColor = CoreLockViewBgColor;
    
    //初始情况隐藏
    self.navigationItem.rightBarButtonItem = nil;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //默认标题
    self.modifyCurrentTitle = CoreLockModifyNormalTitle;
    
    // 修改视图
    if(CoreLockTypeModifyPwd == _type) {
        
        if(_isDirectModify) { // 直接修改密码视图，隐藏修改和忘记密码按钮
            
            _actionView.hidden = YES;
            [_actionView removeFromSuperview];
        }
        else {
            
            _modifyBtn.hidden = YES;
            [_modifyBtn removeFromSuperview];
            
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
        }
    }
    
    if(![self.class hasPwd]){
        [_modifyBtn removeFromSuperview];
    }
    
    // 设置密码视图
    if (CoreLockTypeSetPwd == _type) {
        
        _actionView.hidden = YES;
        [_actionView removeFromSuperview];
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    }
    
    // 验证密码视图
    if (CoreLockTypeVeryfiPwd == _type) {
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelVeryfiPwdFail)];
    }
}

#pragma mark - class public methods
/*
 *  是否有本地密码缓存？即用户是否设置过初始密码？
 */
+(BOOL)hasPwd{
    
    NSString *pwd = [CoreArchive strForKey:CoreLockPWDKey];
    
    return pwd !=nil;
}


/*======================***************************====================*/
/**
 *  保存当前应用手势密码的开启/关闭状态
 */
+ (void)saveCodeLockStatus:(BOOL)status {
    
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
    [userDefaults setBool:status forKey:@"codeLockState"];
    
    //这里建议同步存储到磁盘中，但是不是必须的
    [userDefaults synchronize];
}

/**
 *  返回当前密码开启/关闭状态
 */
+ (BOOL)hasCodeLockStatus {
    
    BOOL isCodeLockStatus = NO;
    
    if ([self hasPwd]) {
        
        //从NSUserDefaults中读取数据
        NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
        isCodeLockStatus = [userDefaultes boolForKey:@"codeLockState"];
    }
    return isCodeLockStatus;
}

/**
 *  清除当前缓存的密码
 */
+ (void)clearPwd {
    
    [CoreArchive removeStrForKey:CoreLockPWDKey];
}
/*======================***************************====================*/

/*
 *  展示设置密码控制器
 */
+(instancetype)showSettingLockVCInVC:(UIViewController *)vc successBlock:(void (^)(CLLockVC *, NSString *))successBlock failureBlock:(void (^)(CLLockVC *))failureBlock{
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"设置密码";
    
    //设置类型
    lockVC.type = CoreLockTypeSetPwd;
    
    //保存block
    lockVC.successBlock = successBlock;
    lockVC.failureBlock = failureBlock;
    
    return lockVC;
}




/*
 *  验证密码----展示验证密码输入框
 */
+(instancetype)showVerifyLockVCInVC:(UIViewController *)vc forgetPwdBlock:(void (^)())forgetPwdBlock successBlock:(void (^)(CLLockVC *, NSString *))successBlock failureBlock:(void (^)(CLLockVC *))failureBlock{
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"手势解锁";
    
    //设置类型
    lockVC.type = CoreLockTypeVeryfiPwd;
    
    //保存block
    lockVC.successBlock = successBlock;
    lockVC.forgetPwdBlock = forgetPwdBlock;
    lockVC.failureBlock = failureBlock;
    
    return lockVC;
}




/*
 *  修改密码----展示验证密码输入框
 */
+(instancetype)showModifyLockVCInVC:(UIViewController *)vc forgetPwdBlock:(void (^)())forgetPwdBlock successBlock:(void (^)(CLLockVC *, NSString *))successBlock failureBlock:(void (^)(CLLockVC *))failureBlock {
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"修改密码";
    
    //设置类型
    lockVC.type = CoreLockTypeModifyPwd;
    
    //记录
    lockVC.successBlock = successBlock;
    lockVC.failureBlock = failureBlock;
    lockVC.forgetPwdBlock = forgetPwdBlock;
    
    return lockVC;
}

/*
 *  消失
 */
-(void)dismiss:(NSTimeInterval)interval{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}


#pragma mark - class private methods

+(instancetype)lockVC:(UIViewController *)vc{
    
    CLLockVC *lockVC = [[CLLockVC alloc] init];

    lockVC.vc = vc;
    
    CLLockNavVC *navVC = [[CLLockNavVC alloc] initWithRootViewController:lockVC];
    
    [vc presentViewController:navVC animated:YES completion:nil];

    
    return lockVC;
}



-(void)setType:(CoreLockType)type{
    
    _type = type;
    
    //根据type自动调整label文字
    [self labelWithType];
}



/*
 *  根据type自动调整label文字
 */
-(void)labelWithType{
    
    if(CoreLockTypeSetPwd == _type){//设置密码
        
        self.msg = CoreLockPWDTitleFirst;
        
    }else if (CoreLockTypeVeryfiPwd == _type){//验证密码
        
        self.msg = CoreLockVerifyNormalTitle;
        
    }else if (CoreLockTypeModifyPwd == _type){//修改密码
        
        self.msg = CoreLockModifyNormalTitle;
    }
}


-(void)dismiss {
    [self dismiss:0];
}

/**
 *  验证取消默认为验证失败
 *
 * （1）当用户登录验证时，选择取消代表用户验证失败，需要进行判断是否需要其他的方式验证登录；
 * （2）再次开启密码验证时，选择取消代表用户放弃操作，不开启手势密码
 */
- (void)cancelVeryfiPwdFail {
    
    [self dismiss:0];
    
    if (_failureBlock != nil) _failureBlock(self);
}


/*
 *  密码重设
 */
-(void)setPwdReset{
    
    [self.label showNormalMsg:CoreLockPWDTitleFirst];
    
    //隐藏
    self.navigationItem.rightBarButtonItem = nil;
    
    //通知视图重设
    [self.lockView resetPwd];
}


/*
 *  忘记密码
 */
-(void)forgetPwd{
    
}



/*
 *  修改密码
 */
-(void)modiftyPwd{
    
}


/*
 *  重置
 */
-(UIBarButtonItem *)resetItem{
    
    if(_resetItem == nil){
        //添加右按钮
        _resetItem= [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(setPwdReset)];
    }
    
    return _resetItem;
}

#pragma mark - sender IBAction
- (IBAction)forgetPwdAction:(id)sender {

    [self dismiss:0];
    
    if(_forgetPwdBlock != nil) _forgetPwdBlock();
}


- (IBAction)modifyPwdAction:(id)sender {
    
    CLLockVC *lockVC = [[CLLockVC alloc] init];
    
    lockVC.title = @"修改密码";
    
    lockVC.isDirectModify = YES;
    
    //设置类型
    lockVC.type = CoreLockTypeModifyPwd;
    
    [self.navigationController pushViewController:lockVC animated:YES];
}


@end

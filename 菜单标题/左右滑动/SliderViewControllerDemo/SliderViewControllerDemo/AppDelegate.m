//
//  AppDelegate.m
//  SliderViewControllerDemo
//
//  Created by yuanshanit on 15/3/18.
//  Copyright (c) 2015年 元善科技. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"
#import "SliderViewController.h"
#import "UIViewController+MLTransition.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    LeftViewController *leftCtrl = [[LeftViewController alloc] initWithNibName:@"LeftViewController" bundle:nil];
    [SliderViewController sharedSliderController].LeftVC = leftCtrl;
    
    RightViewController *rightCtrl= [[RightViewController alloc] initWithNibName:@"RightViewController" bundle:nil];
    [SliderViewController sharedSliderController].RightVC = rightCtrl;
    
    ViewController *mainCtrl = [[ViewController alloc] init];
    [SliderViewController sharedSliderController].MainVC = mainCtrl;
    
    [SliderViewController sharedSliderController].LeftSContentOffset=275;
    [SliderViewController sharedSliderController].LeftContentViewSContentOffset = 90;
    [SliderViewController sharedSliderController].LeftSContentScale=0.77;
    [SliderViewController sharedSliderController].LeftSJudgeOffset=160;
    [SliderViewController sharedSliderController].changeLeftView = ^(CGFloat sca, CGFloat transX)
    {
//        leftCtrl.view.layer.anchorPoint = CGPointMake(1, 1);
        CGAffineTransform ltransS = CGAffineTransformMakeScale(sca, sca);
        CGAffineTransform ltransT = CGAffineTransformMakeTranslation(transX, 0);
        CGAffineTransform lconT = CGAffineTransformConcat(ltransT, ltransS);
        leftCtrl.view.transform = lconT;
    };
    
    [SliderViewController sharedSliderController].RightSContentOffset=275;
    [SliderViewController sharedSliderController].RightSContentScale=0.77;
    [SliderViewController sharedSliderController].RightSJudgeOffset=160;
    
    [UIViewController validatePanPackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypePan];
    
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:[SliderViewController sharedSliderController]];
    navCtrl.navigationBarHidden = YES;
    self.window.rootViewController = navCtrl;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

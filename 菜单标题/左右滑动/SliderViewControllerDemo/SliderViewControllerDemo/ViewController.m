//
//  ViewController.m
//  SliderViewControllerDemo
//
//  Created by yuanshanit on 15/3/18.
//  Copyright (c) 2015年 元善科技. All rights reserved.
//

#import "ViewController.h"
#import "SliderViewController.h"

#define kSystemVersion [[[UIDevice currentDevice] systemVersion] floatValue]
#define kSystemVersionGetY ((CGFloat)kSystemVersion >= 7.0?20:0)

#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight ((kSystemVersion >= 7.0)?[[UIScreen mainScreen] bounds].size.height:[[UIScreen mainScreen] bounds].size.height-20)

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.wantsFullScreenLayout=YES;
    
    UIView *navBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44+[UIApplication sharedApplication].statusBarFrame.size.height)];
    navBarView.backgroundColor=[UIColor whiteColor];
    navBarView.alpha=0.8;
    [self.view addSubview:navBarView];
    
    UILabel *lbTitle = [[UILabel alloc] initWithFrame:CGRectMake(60,kSystemVersionGetY+5, kScreenWidth - 120, 40)];
    lbTitle.text = @"左右滑动" ;
    lbTitle.textAlignment = NSTextAlignmentCenter;
    [navBarView addSubview:lbTitle];
    
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    btnLeft.frame = CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, 44, 44);
    [btnLeft setTitle:@"左" forState:UIControlStateNormal];
    [btnLeft setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(leftItemClick) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:btnLeft];
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    btnRight.frame = CGRectMake(self.view.frame.size.width-44, [UIApplication sharedApplication].statusBarFrame.size.height, 44, 44);
    [btnRight setTitle:@"右" forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(rightItemClick) forControlEvents:UIControlEventTouchUpInside];
    [navBarView addSubview:btnRight];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leftItemClick
{
    [[SliderViewController sharedSliderController] showLeftViewController];
}

- (void)rightItemClick{
    [[SliderViewController sharedSliderController] showRightViewController];
}

@end

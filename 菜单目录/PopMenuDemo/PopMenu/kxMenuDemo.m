//
//  kxMenuDemo.m
//  kxMenu
//
//  Created by yuanshanit on 15/8/28.
//  Copyright (c) 2015年 元善科技. All rights reserved.
//

#import "kxMenuDemo.h"
#import "KxMenu.h"

@interface kxMenuDemo ()

@end

@implementation kxMenuDemo{
    
    UIButton *_btn1;
    UIButton *_btn2;
    UIButton *_btn3;
    UIButton *_btn4;
    UIButton *_btn5;
    UIButton *_btn6;
    UIButton *_btn7;
}

- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // 
    }
    return self;
}

- (void) loadView
{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    
    self.view = [[UIView alloc] initWithFrame:frame];
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    const CGFloat W = self.view.bounds.size.width;
    const CGFloat H = self.view.bounds.size.height;
    
    _btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn1.frame = CGRectMake(5, 5, 100, 50);
    [_btn1 setTitle:@"Click me" forState:UIControlStateNormal];
    [_btn1 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn1];
    
    _btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn2.frame = CGRectMake(5, H - 55, 100, 50);
    [_btn2 setTitle:@"Click me" forState:UIControlStateNormal];
    [_btn2 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn2];
    
    _btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn3.frame = CGRectMake(W - 105, 5, 100, 50);
    [_btn3 setTitle:@"Click me" forState:UIControlStateNormal];
    [_btn3 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn3];
    
    _btn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn4.frame = CGRectMake(W - 105, H - 55, 100, 50);
    [_btn4 setTitle:@"Click me" forState:UIControlStateNormal];
    [_btn4 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn4];
    
    _btn5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn5.frame = CGRectMake(5, (H-50) * 0.5, 100, 50);
    [_btn5 setTitle:@"Click me" forState:UIControlStateNormal];
    [_btn5 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn5];
    
    _btn6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn6.frame = CGRectMake(W - 105, (H-50) * 0.5, 100, 50);
    [_btn6 setTitle:@"Click me" forState:UIControlStateNormal];
    [_btn6 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn6];
    
    _btn7 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btn7.frame = CGRectMake((W - 100)* 0.5, (H-50) * 0.5, 100, 50);
    [_btn7 setTitle:@"Click me" forState:UIControlStateNormal];
    [_btn7 addTarget:self action:@selector(showMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btn7];
    
//    [KxMenu setTintColor: [UIColor colorWithRed:15/255.0f green:7/255.0f blue:3/255.0f alpha:1.0]];
    [KxMenu setTitleFont:[UIFont systemFontOfSize:14]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    const CGFloat W = self.view.bounds.size.width;
    const CGFloat H = self.view.bounds.size.height;
    
    _btn1.frame = CGRectMake(5, 65, 100, 50);
    _btn2.frame = CGRectMake(5, H - 55, 100, 50);
    _btn3.frame = CGRectMake(W - 205, 65, 100, 50);
    _btn4.frame = CGRectMake(W - 105, H - 55, 100, 50);
    _btn5.frame = CGRectMake(5, (H-50) * 0.5, 100, 50);
    _btn6.frame = CGRectMake(W - 105, (H-50) * 0.5, 100, 50);
    _btn7.frame = CGRectMake((W - 100)* 0.5, (H-50) * 0.5, 100, 50);
}

- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
    [KxMenuItem menuItem:@"可设置的菜单项"
                   image:nil
                  target:nil
                  action:NULL], // 设置一个不可选择的
    
    [KxMenuItem menuItem:@"发起群聊"
                   image:[UIImage imageNamed:@"share_icon"]
                  target:self
                  action:@selector(menuItemAction:)],
    
    [KxMenuItem menuItem:@"添加朋友"
                   image:[UIImage imageNamed:@"menu_icon"]
                  target:self
                  action:@selector(menuItemAction:)],
    
    [KxMenuItem menuItem:@"扫一扫"
                   image:[UIImage imageNamed:@"search_icon"]
                  target:self
                  action:@selector(menuItemAction:)],
    
    [KxMenuItem menuItem:@"付 款"
                   image:[UIImage imageNamed:@"action_icon"]
                  target:self
                  action:@selector(menuItemAction:)],
    
    [KxMenuItem menuItem:@"收 钱 啦"
                   image:[UIImage imageNamed:@"home_icon"]
                  target:self
                  action:@selector(menuItemAction:)]
    ];
    
    for (KxMenuItem *item in menuItems) {
        
        if (item.image == nil) {
            item.alignment = NSTextAlignmentCenter; // 设置image=nil居中
        }
    }
    
    // 设置单个KxMenuItem字段属性
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor colorWithRed:47/255.0f green:112/255.0f blue:225/255.0f alpha:1.0];
    
    //  设置KxMenu属性
    [KxMenu setTintColor:[UIColor colorWithRed:41/255.0f green:41/255.0f blue:41/255.0f alpha:1.0]];
    [KxMenu setTitleFont:[UIFont systemFontOfSize:14.0]];
    
    [KxMenu showMenuInView:self.view fromRect:sender.frame menuItems:menuItems];
}

#pragma mark - select MenuItem method
- (void)menuItemAction:(id)sender
{
    KxMenuItem *item = (KxMenuItem *)sender;
    
    NSLog(@"%@ \t %@",item,item.title);
}


@end

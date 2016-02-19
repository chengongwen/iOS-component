//
//  QBPopupMenuDemo.m
//  QBPopupMenuDemo
//
//  Created by yuanshanit on 15/8/28.
//  Copyright (c) 2015年 元善科技. All rights reserved.
//

#import "QBPopupMenuDemo.h"

#import "QBPopupMenu.h"
#import "QBPlasticPopupMenu.h"

@interface QBPopupMenuDemo ()

@property (nonatomic, strong) QBPopupMenu *popupMenu;
@property (nonatomic, strong) QBPlasticPopupMenu *plasticPopupMenu;


@end

@implementation QBPopupMenuDemo


- (id)init
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        //
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *btnQBPopupMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnQBPopupMenu.frame = CGRectMake(self.view.center.x/2 - 100, 200, 200, 45.f);
    [btnQBPopupMenu setTitle:@"QBPopupMenu" forState:UIControlStateNormal];
    [btnQBPopupMenu addTarget:self action:@selector(showPopupMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnQBPopupMenu];
    
    UIButton *btnQBPlasticPopupMenu = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btnQBPlasticPopupMenu.frame = CGRectMake(self.view.center.x/2 - 100, 300, 200, 45.f);
    [btnQBPlasticPopupMenu setTitle:@"QBPlasticPopupMenu" forState:UIControlStateNormal];
    [btnQBPlasticPopupMenu addTarget:self action:@selector(showPlasticPopupMenu:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnQBPlasticPopupMenu];
    
    // 初始化QBPopupMenuItem
    QBPopupMenuItem *item = [QBPopupMenuItem itemWithTitle:@"Cut" target:self action:@selector(popupMenuItemAction:)];
    QBPopupMenuItem *item2 = [QBPopupMenuItem itemWithTitle:@"Copy" target:self action:@selector(popupMenuItemAction:)];
    QBPopupMenuItem *item3 = [QBPopupMenuItem itemWithTitle:@"Paste" target:self action:@selector(popupMenuItemAction:)];
    
    QBPopupMenuItem *item4 = [QBPopupMenuItem itemWithTitle:@"Delete" image:[UIImage imageNamed:@"trash"] target:self action:@selector(popupMenuItemAction:)];
    
    QBPopupMenuItem *item5 = [QBPopupMenuItem itemWithTitle:@"Attachment" image:[UIImage imageNamed:@"clip"] target:self action:@selector(popupMenuItemAction:)];
    
    QBPopupMenuItem *item6 = [QBPopupMenuItem itemWithTitle:@"Share" image:[UIImage imageNamed:@"share"] target:self action:@selector(popupMenuItemAction:)];
    
    NSArray *items = @[item, item2, item3, item4, item5, item6];
    
    // 初始化QBPopupMenu
    QBPopupMenu *popupMenu = [[QBPopupMenu alloc] initWithItems:items];
    popupMenu.highlightedColor = [[UIColor colorWithRed:0 green:0.478 blue:1.0 alpha:1.0] colorWithAlphaComponent:0.8];
    self.popupMenu = popupMenu;
    
    // 初始化QBPlasticPopupMenu
    QBPlasticPopupMenu *plasticPopupMenu = [[QBPlasticPopupMenu alloc] initWithItems:items];
    plasticPopupMenu.height = 40;
    self.plasticPopupMenu = plasticPopupMenu;
}


- (void)showPopupMenu:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self.popupMenu showInView:self.view targetRect:button.frame animated:YES];
}

- (void)showPlasticPopupMenu:(id)sender
{
    UIButton *button = (UIButton *)sender;
    [self.plasticPopupMenu showInView:self.view targetRect:button.frame animated:YES];
}

#pragma mark - select click MenuItem method
- (void)popupMenuItemAction:(QBPopupMenuItem *)item
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"当前选择按钮: %@",item.title] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
    [alter show];
}


@end

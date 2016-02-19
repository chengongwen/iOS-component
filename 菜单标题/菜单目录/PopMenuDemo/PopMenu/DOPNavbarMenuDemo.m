//
//  DOPNavbarMenuDemo.m
//  PopMenuDemo
//
//  Created by yuanshanit on 15/12/25.
//  Copyright © 2015年 元善科技. All rights reserved.
//

#import "DOPNavbarMenuDemo.h"

#import "DOPNavbarMenu.h"

@interface DOPNavbarMenuDemo () <DOPNavbarMenuDelegate>

@property (strong, nonatomic) DOPNavbarMenu *navbarMenu;
@property (assign, nonatomic) NSInteger numberOfItemsInRow;

@end

@implementation DOPNavbarMenuDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blueColor];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"menu" style:UIBarButtonItemStylePlain target:self action:@selector(openMenu:)];
    
    // 初始化DOPNavbarMenu
     self.numberOfItemsInRow = 3;
    
    [self initializeDOPNavbarMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (self.navbarMenu) {
        [self.navbarMenu dismissWithAnimation:NO];
    }
}

#pragma mark -
#pragma mark - DOPNavbarMenu

- (void)initializeDOPNavbarMenu {
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    
    DOPNavbarMenuItem *item1 = [DOPNavbarMenuItem ItemWithTitle:@"kxMenuDemo" icon:[UIImage imageNamed:@"Development@2x"]];
    DOPNavbarMenuItem *item2 = [DOPNavbarMenuItem ItemWithTitle:@"QBPopupMenuDemo" icon:[UIImage imageNamed:@"menu_icon@2x"]];
    _navbarMenu = [[DOPNavbarMenu alloc] initWithItems:@[item1,item1,item1,item2,item2,item2] width:width maximumNumberInRow:_numberOfItemsInRow];
    _navbarMenu.backgroundColor = [UIColor blackColor];
    _navbarMenu.separatarColor = [UIColor whiteColor];
    _navbarMenu.delegate = self;
}

- (void)openMenu:(id)sender {
    self.navigationItem.leftBarButtonItem.enabled = NO;
    if (self.navbarMenu.isOpen) {
        [self.navbarMenu dismissWithAnimation:YES];
    } else {
        [self.navbarMenu showInNavigationController:self.navigationController];
    }
}

#pragma mark - DOPNavbarMenuDelegate
- (void)didShowMenu:(DOPNavbarMenu *)menu {
    [self.navigationItem.leftBarButtonItem setTitle:@"dismiss"];
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

- (void)didDismissMenu:(DOPNavbarMenu *)menu {
    [self.navigationItem.leftBarButtonItem setTitle:@"menu"];
    self.navigationItem.leftBarButtonItem.enabled = YES;
}

- (void)didSelectedMenu:(DOPNavbarMenu *)menu atIndex:(NSInteger)index {
    
    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"you selected" message:[NSString stringWithFormat:@"number %@", @(index+1)] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [av show];
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

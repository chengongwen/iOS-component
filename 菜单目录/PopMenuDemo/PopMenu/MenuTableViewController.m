//
//  TYGMenuTableViewController.m
//  MenuTableViewController
//
//  Created by yuanshanit on 15/8/28.
//  Copyright (c) 2015年 元善科技. All rights reserved.
//

//  下弹式导航栏菜单

#import "MenuTableViewController.h"
#import "REMenu.h"

@interface MenuTableViewController ()

@property (strong, readwrite, nonatomic) REMenu *reMenu;

@end

@implementation MenuTableViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        if (REUIKitIsFlatMode()) {
            
            [self.navigationController.navigationBar performSelector:@selector(setBarTintColor:) withObject:[UIColor colorWithRed:0/255.0 green:213/255.0 blue:161/255.0 alpha:1]];
        }
        else {
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        }
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"菜单集合";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"menu_icon@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenu)];
    
    // 初始化REMenu
    [self initializeREMenu];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark - REMenu
- (void)initializeREMenu {
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"垂直弹出式菜单-kxMenuDemo",@"横向弹出式菜单-QBPopupMenuDemo",@"导航横向菜单-DOPNavbarMenuDemo", nil];
    
    __typeof (self) __weak weakSelf = self;
    
    UIBarButtonItem *customLeftBarButtonItem = [[UIBarButtonItem alloc] init];
    customLeftBarButtonItem.title = @"返回";
    weakSelf.navigationItem.backBarButtonItem = customLeftBarButtonItem;
    
    NSArray *imageArray = [NSArray arrayWithObjects:@"Development@2x",@"Development@2x",@"Development@2x", nil];
    
    NSMutableArray *multArrayREMenuItems = [[NSMutableArray alloc] initWithCapacity:4];
    
    for (int i=0; i < titleArray.count; i++) {
        
        NSString *title = titleArray[i];
        
        NSString *classTitle = [[title componentsSeparatedByString:@"-"] firstObject];
        NSString *className = [[title componentsSeparatedByString:@"-"] lastObject];
        
        REMenuItem *homeItem = [[REMenuItem alloc] initWithTitle:classTitle
                                                        subtitle:className
                                                           image:[UIImage imageNamed:imageArray[i]]
                                                highlightedImage:nil
                                                          action:^(REMenuItem *item)
                                {
                                    NSLog(@"Item: %@", item);
                                    
                                    UIViewController* viewController = [[NSClassFromString(className) alloc] initWithNibName:className bundle:nil];
                                    viewController.title = classTitle;
                                    
                                    [weakSelf.navigationController pushViewController:viewController animated:YES];
                                }];
        
        [multArrayREMenuItems addObject:homeItem];
    }
    
    self.reMenu = [[REMenu alloc] initWithItems:multArrayREMenuItems];
    
    // Background view
    self.reMenu.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    self.reMenu.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.reMenu.backgroundView.backgroundColor = [UIColor colorWithWhite:0.500 alpha:0.200];
    
    self.reMenu.separatorOffset = CGSizeMake(15.0, 0.0);
    self.reMenu.imageOffset = CGSizeMake(5, -1);
    self.reMenu.waitUntilAnimationIsComplete = YES;
    
    self.reMenu.badgeLabelConfigurationBlock = ^(UILabel *badgeLabel, REMenuItem *item) {
        
        badgeLabel.backgroundColor = [UIColor colorWithRed:0 green:179/255.0 blue:134/255.0 alpha:1];
        badgeLabel.layer.borderColor = [UIColor colorWithRed:0.000 green:0.648 blue:0.507 alpha:1.000].CGColor;
    };
    
    [self.reMenu setClosePreparationBlock:^{
        
        NSLog(@"Menu will close");
    }];
    
    [self.reMenu setCloseCompletionHandler:^{
        NSLog(@"Menu did close");
    }];
}



- (void)toggleMenu
{
    if (self.reMenu.isOpen)
        return [self.reMenu close];
    
    [self.reMenu showFromNavigationController:self.navigationController];
}

@end

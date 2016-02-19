//
//  SDHomeViewController.m
//  GSD_ZHIFUBAO
//
//  Created by aier on 15-6-3.
//  Copyright (c) 2015年 GSD. All rights reserved.
//


/*
 
 *********************************************************************************
 *
 * 在您使用此自动布局库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 *********************************************************************************
 
 */


#import "SDHomeViewController.h"
#import "SDAddItemViewController.h"

#import "UIView+SDExtension.h"
#import "SDOperateGridItem.h"

@interface SDHomeViewController () <SDOperateItemGridViewDelegate>

@property (nonatomic, weak) SDHomeGridView *mainView;
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation SDHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"首页菜单排序";
    
    [self setupMainView];
}

- (void)viewDidAppear:(BOOL)animated {
    
    // 重新刷新SDHomeGridView标题视图
    [self setupDataArray];
    _mainView.gridModelsArray = _dataArray;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGFloat tabbarHeight = [[self.tabBarController tabBar] sd_height];
    
    CGFloat headerY = 0;
    headerY = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) ? 64 : 0;
    
    _mainView.frame = CGRectMake(0, headerY , self.view.sd_width, self.view.sd_height - headerY - tabbarHeight);
}

#pragma mark - private actions
- (void)setupMainView {
    SDHomeGridView *mainView = [[SDHomeGridView alloc] init];
    mainView.gridViewDelegate = self;
    mainView.showsVerticalScrollIndicator = NO;
    
    [self setupDataArray];
    mainView.gridModelsArray = _dataArray;
    
    // 模拟轮播图数据源
    mainView.scrollADImageURLStringsArray = @[
                                              @"http://ww4.sinaimg.cn/bmiddle/763cc1a7jw1esr747i13xj20dw09g0tj.jpg",
                                              @"http://ww4.sinaimg.cn/bmiddle/67307b53jw1esr4z8pimxj20c809675d.jpg",
                                              @"http://ww3.sinaimg.cn/bmiddle/9d857daagw1er7lgd1bg1j20ci08cdg3.jpg"];
    [self.view addSubview:mainView];
    _mainView = mainView;
}

- (void)setupDataArray {
    NSArray *itemsArray = [SDGridItemCacheTool loadHomeItemsArrayList];
    NSMutableArray *temp = [NSMutableArray array];
    for (NSDictionary *itemDict in itemsArray) {
        SDHomeGridItemModel *model = [[SDHomeGridItemModel alloc] init];
        model.destinationClass = [SDBasicViewContoller class];
        model.imageResString =[itemDict.allValues firstObject];
        model.title = [itemDict.allKeys firstObject];
        [temp addObject:model];
    }
    _dataArray = [temp copy];
}

#pragma mark - SDOperateItemGridViewDelegate

- (void)homeGrideView:(UIView *)gridView selectItemAtIndex:(NSInteger)index {
    SDHomeGridItemModel *model = _dataArray[index];
    UIViewController *vc = [[model.destinationClass alloc] init];
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)homeGrideViewmoreItemButtonClicked:(UIView *)gridView {
    SDAddItemViewController *addVc = [[SDAddItemViewController alloc] init];
    addVc.title = @"添加更多";
    [self.navigationController pushViewController:addVc animated:YES];
}

- (void)homeGrideViewDidChangeItems:(UIView *)gridView {
    [self setupDataArray];
}


@end

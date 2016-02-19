//
//  SDAddItemViewController.m
//  GSD_ZHIFUBAO
//
//  Created by aier on 15-6-7.
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

#import "SDAddItemViewController.h"
#import "SDOperateGridItem.h"

@interface SDAddItemViewController ()<SDOperateItemGridViewDelegate>

@property (nonatomic, weak) SDAddItemGridView *mainView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation SDAddItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMainView];
}

- (void)setupMainView {
    SDAddItemGridView *mainView = [[SDAddItemGridView alloc] initWithFrame:self.view.bounds];
    mainView.showsVerticalScrollIndicator = NO;
    mainView.gridViewDelegate = self;
    
    [self setupDataArray];
    mainView.gridModelsArray = _dataArray;

    [self.view addSubview:mainView];
    _mainView = mainView;
}

- (void)setupDataArray {
    NSArray *itemsArray = [SDGridItemCacheTool loadAddItemsArrayList];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - SDOperateItemGridViewDelegate

- (void)homeGrideView:(UIView *)gridView selectItemAtIndex:(NSInteger)index {
    SDHomeGridItemModel *model = _dataArray[index];
    UIViewController *vc = [[model.destinationClass alloc] init];
    vc.title = model.title;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)homeGrideViewmoreItemButtonClicked:(UIView *)gridView {
    //
}

- (void)homeGrideViewDidChangeItems:(UIView *)gridView {
    [self setupDataArray];
}

@end

//
//  ViewController.m
//  ScrollMenuDemo
//
//  Created by yuanshanit on 15/5/7.
//  Copyright (c) 2015年 元善科技. All rights reserved.
//

#import "ViewController.h"
#import "ScrollMenu.h"

@interface ViewController () <ScrollMenuDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ScrollMenu *scrollMenu;
@property (nonatomic, strong) NSMutableArray *menus;
@property (nonatomic, assign) BOOL shouldObserving;
@end

@implementation ViewController

- (NSMutableArray *)menus {
    if (!_menus) {
        _menus = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _menus;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.shouldObserving = YES;
    
    float getY = 0.0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        getY = 20.0;
    }
    _scrollMenu = [[ScrollMenu alloc] initWithFrame:CGRectMake(0, getY, CGRectGetWidth(self.view.bounds), 44)];
    _scrollMenu.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    _scrollMenu.delegate = self;
    [self.view addSubview:self.scrollMenu];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_scrollMenu.frame), CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds) - CGRectGetMaxY(_scrollMenu.frame))];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    
    [self.view addSubview:self.scrollView];
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"头条",@"热点新闻",@"原创",@"汽车",@"大数据",@"NBA", nil];
    
    for (int i = 0; i < titleArray.count; i ++) {
        
        Menu *menu = [[Menu alloc] init];
        
        UITableView *logoTableView = [[UITableView alloc] init];
        logoTableView.frame = CGRectMake(i * CGRectGetWidth(_scrollView.bounds), 5, CGRectGetWidth(_scrollView.bounds), CGRectGetHeight(_scrollView.bounds)/1.5f);
        if (i%2 == 0) {
            logoTableView.backgroundColor = [UIColor greenColor];
        }
        else
        {
            logoTableView.backgroundColor = [UIColor grayColor];
        }
        
        
        [_scrollView addSubview:logoTableView];
        
        menu.title = titleArray[i];
        menu.titleFont = [UIFont boldSystemFontOfSize:16];
        
        menu.titleNormalColor = [UIColor grayColor];
        menu.titleHighlightedColor = [UIColor lightGrayColor];
        menu.titleSelectedColor = [UIColor redColor];
        
        [self.menus addObject:menu];
    }
    _scrollMenu.menus = self.menus;
    
    [_scrollView setContentSize:CGSizeMake(self.menus.count * CGRectGetWidth(_scrollView.bounds), CGRectGetHeight(_scrollView.bounds))];
    
    [_scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    
    [_scrollMenu reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self stopObservingContentOffset];
}

- (void)stopObservingContentOffset
{
    if (self.scrollView) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        self.scrollView = nil;
    }
}

#pragma mark - ScrollMenuDelegate
// 选中某个标题
- (void)scrollMenuDidSelected:(ScrollMenu *)scrollMenu menuIndex:(NSUInteger)selectIndex {
    
    NSLog(@"selectIndex : %li", selectIndex);
    self.shouldObserving = NO;
    
    CGRect visibleRect = CGRectMake(selectIndex * CGRectGetWidth(self.scrollView.bounds), 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        [self.scrollView scrollRectToVisible:visibleRect animated:NO];
        
    } completion:^(BOOL finished) {
        self.shouldObserving = YES;
    }];
}

// 选中更多按钮
- (void)scrollMenuDidManagerSelected:(ScrollMenu *)scrollMenu {
    
    NSLog(@"scrollMenuDidManagerSelected");
}

#pragma mark - ScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    
    CGPoint offset = scrollView.contentOffset;
    
    //根据当前的坐标与页宽计算当前页码
    int currentPage = floor((offset.x - pageWidth/2)/pageWidth)+1;
    
#ifdef DEBUG
    NSLog(@"currentPageSelectIndex : %d", currentPage);
#endif
    // calledDelegate = NO;
    
    [self.scrollMenu setSelectedIndex:currentPage animated:YES calledDelegate:NO];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"] && self.shouldObserving) {
        
        //每页宽度
        CGFloat pageWidth = self.scrollView.frame.size.width;
        //根据当前的坐标与页宽计算当前页码
        NSUInteger currentPage = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if (currentPage > self.menus.count - 1)
            currentPage = self.menus.count - 1;
        
        CGFloat oldX = currentPage * CGRectGetWidth(self.scrollView.frame);
        if (oldX != self.scrollView.contentOffset.x) {
            BOOL scrollingTowards = (self.scrollView.contentOffset.x > oldX);
            NSInteger targetIndex = (scrollingTowards) ? currentPage + 1 : currentPage - 1;
            if (targetIndex >= 0 && targetIndex < self.menus.count) {
                CGFloat ratio = (self.scrollView.contentOffset.x - oldX) / CGRectGetWidth(self.scrollView.frame);
                CGRect previousMenuButtonRect = [self.scrollMenu rectForSelectedItemAtIndex:currentPage];
                CGRect nextMenuButtonRect = [self.scrollMenu rectForSelectedItemAtIndex:targetIndex];
                CGFloat previousItemPageIndicatorX = previousMenuButtonRect.origin.x;
                CGFloat nextItemPageIndicatorX = nextMenuButtonRect.origin.x;
                
                CGRect indicatorViewFrame = self.scrollMenu.indicatorView.frame;
                
                if (scrollingTowards) {
                    indicatorViewFrame.size.width = CGRectGetWidth(previousMenuButtonRect) + (CGRectGetWidth(nextMenuButtonRect) - CGRectGetWidth(previousMenuButtonRect)) * ratio;
                    indicatorViewFrame.origin.x = previousItemPageIndicatorX + (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio;
                } else {
                    indicatorViewFrame.size.width = CGRectGetWidth(previousMenuButtonRect) - (CGRectGetWidth(nextMenuButtonRect) - CGRectGetWidth(previousMenuButtonRect)) * ratio;
                    indicatorViewFrame.origin.x = previousItemPageIndicatorX - (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio;
                }
                
                self.scrollMenu.indicatorView.frame = indicatorViewFrame;
            }
        }
    }
}

@end

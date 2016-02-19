//
//  ViewController.m
//  AJComboBoxDemo
//
//  Created by yuanshanit on 15/3/25.
//  Copyright (c) 2015年 元善科技. All rights reserved.
//

#import "ViewController.h"

typedef enum {
    comboboxTagTypeAllType,
    comboboxTagTypeSubTitle,
    comboboxTagTypeThirdTitle,
}comboboxTagType;

@interface ViewController ()
@property(nonatomic, retain) NSArray *allTitleArray;
@property(nonatomic, retain) NSArray *allSubTitleArray;
@property(nonatomic, retain) NSArray *allThirdTitleArray;
@property(nonatomic, retain) NSString *selectedTitle;
@property(nonatomic, retain) NSArray *selectSubTitleArray;
@property(nonatomic, retain) NSArray *selectThirdTitleArray;
@property(nonatomic, retain) NSDictionary *subAndThirdDictionary;

@property (nonatomic, retain) UIScrollView *selectScrollView;
@property (nonatomic, retain) NSMutableArray *comboBoxMutArray;
@property (nonatomic, retain) UILabel *lbCurrentSelect;

@end

@implementation ViewController
@synthesize allTitleArray = _allTitleArray;
@synthesize allSubTitleArray = _allSubTitleArray;
@synthesize allThirdTitleArray = _allThirdTitleArray;
@synthesize selectedTitle = _selectedTitle;
@synthesize selectSubTitleArray = _selectSubTitleArray;
@synthesize selectThirdTitleArray = _selectThirdTitleArray;
@synthesize subAndThirdDictionary = _subAndThirdDictionary;
@synthesize selectScrollView = _selectScrollView;
@synthesize comboBoxMutArray = _comboBoxMutArray;
@synthesize lbCurrentSelect = _lbCurrentSelect;

- (void)dealloc
{
    [_lbCurrentSelect release];
    [_selectScrollView release];
    [_comboBoxMutArray release];
    
    [_subAndThirdDictionary release];
    [_selectedTitle release];
    [_selectSubTitleArray release];
    [_selectThirdTitleArray release];
    [_allTitleArray release];
    [_allSubTitleArray release];
    [_allThirdTitleArray release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.navigationController.navigationBarHidden == NO) {
        self.title = @"AJComboBox下拉框";
    }
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)/5, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)*2/3)];
    [self.view addSubview:backgroundView];
    backgroundView.backgroundColor = [UIColor greenColor];
    [backgroundView release];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, CGRectGetWidth(backgroundView.frame), CGRectGetHeight(backgroundView.frame)*2/3)];
    scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor brownColor];
    [backgroundView addSubview:scrollView];
    self.selectScrollView = scrollView;
    [scrollView release];
    
    self.selectScrollView.contentSize = CGSizeMake(CGRectGetWidth(self.selectScrollView.frame), CGRectGetHeight(self.selectScrollView.frame)*3/2);
    
    UILabel *lbCurrentSelected = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(scrollView.frame)+20, CGRectGetWidth(backgroundView.frame), 30)];
    lbCurrentSelected.text = @"";
    lbCurrentSelected.backgroundColor = [UIColor clearColor];
    lbCurrentSelected.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:lbCurrentSelected];
    self.lbCurrentSelect = lbCurrentSelected;
    [lbCurrentSelected release];
    
    NSMutableArray *comboBoxMutArray = [[NSMutableArray alloc] init];
    self.comboBoxMutArray = comboBoxMutArray;
    [comboBoxMutArray release];
    
    //初使化提交待办选择框
    CGFloat lbWidth=100.0,height=35.0;
    UILabel *lbTitle= [[UILabel alloc] initWithFrame:CGRectMake(10,20, lbWidth, height)];
    lbTitle.text=@"一级标题:";
    lbTitle.textColor = [UIColor redColor];
    lbTitle.backgroundColor = [UIColor clearColor];
    [self.selectScrollView addSubview:lbTitle];
    [lbTitle release];
    int width=CGRectGetWidth(backgroundView.frame)-CGRectGetMaxX(lbTitle.frame)-15;
    
    AJComboBox *comboBox= [[AJComboBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbTitle.frame), lbTitle.frame.origin.y, width, height) targetView:backgroundView superView:self.selectScrollView];
    [self.comboBoxMutArray addObject:comboBox];
    comboBox.tag= comboboxTagTypeAllType;
    comboBox.delegate=self;
    NSArray *routers=[self _getAllTypeTitle];
    comboBox.arrayData=routers;
    if (routers.count>0) {
        comboBox.selectedIndex=0;
        self.selectedTitle=[routers objectAtIndex:0];
    }
    [routers release];
    [self.selectScrollView addSubview:comboBox];
    [comboBox release];
    
    UILabel *lbSubTitle= [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbTitle.frame),CGRectGetMaxY(lbTitle.frame)+40, lbWidth, height)];
    lbSubTitle.text=@"二级标题:";
    lbSubTitle.textColor = [UIColor blueColor];
    lbSubTitle.backgroundColor = [UIColor clearColor];
    [self.selectScrollView addSubview:lbSubTitle];
    [lbSubTitle release];
    
    AJComboBox *comboBoxSub= [[AJComboBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbSubTitle.frame),lbSubTitle.frame.origin.y, width, height) targetView:backgroundView superView:self.selectScrollView];
    [self.comboBoxMutArray addObject:comboBoxSub];
    comboBoxSub.tag=comboboxTagTypeSubTitle;
    comboBoxSub.delegate=self;
    NSArray *subTitleArray=[self _getAllTypeSubTitle];
    comboBoxSub.arrayData=subTitleArray;
    
    if (subTitleArray.count>0) {
        comboBoxSub.selectedIndex=0;
        NSArray *tmpSubArray=[[NSArray alloc] initWithObjects:[subTitleArray objectAtIndex:0], nil];
        self.selectSubTitleArray=tmpSubArray;
        [tmpSubArray release];
    }
    [self.selectScrollView addSubview:comboBoxSub];
    [comboBoxSub release];
    
    UILabel *lbThirdTitle=[[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(lbSubTitle.frame),CGRectGetMaxY(lbSubTitle.frame)+40, lbWidth, height)];
    lbThirdTitle.text=@"三级标题:";
    lbThirdTitle.textColor = [UIColor cyanColor];
    lbThirdTitle.backgroundColor = [UIColor clearColor];
    [self.selectScrollView addSubview:lbThirdTitle];
    [lbThirdTitle release];
    
    AJComboBox *comboBoxThird=[[AJComboBox alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lbThirdTitle.frame), lbThirdTitle.frame.origin.y, width, height) targetView:backgroundView superView:self.selectScrollView];
    [self.comboBoxMutArray addObject:comboBoxThird];
    comboBoxThird.tag=comboboxTagTypeThirdTitle;
    comboBoxThird.delegate=self;
    NSArray *thirdArray=[self _getAllTypeThirdTitle];
    comboBoxThird.arrayData=thirdArray;
    
    if (thirdArray.count>0) {
        comboBoxThird.selectedIndex=0;
        NSArray *tmpThirdArray=[[NSArray alloc] initWithObjects:[thirdArray objectAtIndex:0], nil];
        self.selectThirdTitleArray=tmpThirdArray;
        [tmpThirdArray release];
    }
    [self.selectScrollView addSubview:comboBoxThird];
    [comboBoxThird release];
    
    // Do any additional setup after loading the view, typically from a nib
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - load data
- (NSArray *)_getAllTypeTitle
{
    self.allTitleArray = @[@"全部美食",@"全部旅游"];
    
    return self.allTitleArray;
}

- (NSArray *)_getAllTypeSubTitle
{
    if ([self.selectedTitle isEqualToString:@"全部美食"]) {
        
        NSArray *foodArray1 = @[@"不限人数", @"单人餐", @"双人餐", @"3~4人餐",@"5~10人餐",@"10~餐"];
        NSArray *foodArray2 = @[@"双人餐", @"3~4人餐",@"5~10人餐",@"10~餐"];
        NSArray *foodArray3 = @[@"单人餐", @"双人餐", @"3~4人餐",@"5~10人餐",@"10~餐"];
        NSArray *foodArray4 = @[@"3~4人餐",@"5~10人餐",@"10~餐"];
        
        self.subAndThirdDictionary = @{@"火锅":foodArray1,
                                       @"川菜":foodArray2,
                                       @"西餐":foodArray3,
                                       @"自助餐":foodArray4};
    }
    else if ([self.selectedTitle isEqualToString:@"全部旅游"])
    {
        NSArray *travelArray1 = @[@"智能排序", @"离我最近", @"评价最高", @"最新发布", @"人气最高", @"价格最低", @"价格最高"];
        NSArray *travelArray2 = @[@"离我最近", @"评价最高", @"最新发布", @"人气最高", @"价格最高"];
        NSArray *travelArray3 = @[@"评价最高", @"最新发布", @"人气最高"];
        NSArray *travelArray4 = @[@"最新发布",@"评价最高" ];
        
        self.subAndThirdDictionary = @{@"周边游":travelArray1,
                                       @"景点门票":travelArray2,
                                       @"国内游":travelArray3,
                                       @"境外游":travelArray4};
    }
    
    self.allSubTitleArray = [_subAndThirdDictionary allKeys];
    
    return self.allSubTitleArray;
}

- (NSArray *)_getAllTypeThirdTitle
{
    self.allThirdTitleArray = [_subAndThirdDictionary objectForKey:[_selectSubTitleArray objectAtIndex:0]];
    
    return self.allThirdTitleArray;
}

#pragma mark - AJComboBoxDelegate actions
- (void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
    switch (comboBox.tag) {
        case comboboxTagTypeAllType:
        {
            // 选择一级标题
            self.selectedTitle= [_allTitleArray objectAtIndex:selectedIndex];
            
            // 设置默认二级标题和三级标题
            AJComboBox *comboBoxSubTitle= (AJComboBox *)[self.view viewWithTag:comboboxTagTypeSubTitle];
            comboBoxSubTitle.arrayData=[self _getAllTypeSubTitle];
            if (_allSubTitleArray.count>0) {
                
                comboBoxSubTitle.selectedIndex=0;
                
                NSArray *tmpSubTitleArray=[[NSArray alloc] initWithObjects:[_allSubTitleArray objectAtIndex:0], nil];
                self.selectSubTitleArray=tmpSubTitleArray;
                [tmpSubTitleArray release];
            }
            
            // 设置默认三级标题
            AJComboBox *comboBoxThirdTitle= (AJComboBox *)[self.view viewWithTag:comboboxTagTypeThirdTitle];
            comboBoxThirdTitle.arrayData=[self _getAllTypeThirdTitle];
            
            if (_allThirdTitleArray.count>0) {
                
                comboBoxThirdTitle.selectedIndex= 0;
                NSArray *tmpThirdTitleArray=[[NSArray alloc] initWithObjects:[_allThirdTitleArray objectAtIndex:0], nil];
                self.selectThirdTitleArray=tmpThirdTitleArray;
                [tmpThirdTitleArray release];
            }
            
            self.lbCurrentSelect.text = [NSString stringWithFormat:@"%@,%@,%@",self.selectedTitle,self.selectSubTitleArray[0],self.selectThirdTitleArray[0]];
            break;
        }
        case comboboxTagTypeSubTitle:
        {
            // 选择二级标题
            NSArray *tmpSubTitleArray= [[NSArray alloc] initWithObjects:[_allSubTitleArray objectAtIndex:selectedIndex], nil];
            self.selectSubTitleArray=tmpSubTitleArray;
            [tmpSubTitleArray release];
            
            // 设置默认三级标题
            AJComboBox *comboBoxThirTitle= (AJComboBox *)[self.view viewWithTag:comboboxTagTypeThirdTitle];
            comboBoxThirTitle.arrayData=[self _getAllTypeThirdTitle];
            
            if (_allThirdTitleArray.count>0) {
                
                comboBoxThirTitle.selectedIndex=0;
                NSArray *tmpThirdTitleArray=[[NSArray alloc] initWithObjects:[_allThirdTitleArray objectAtIndex:0], nil];
                self.selectThirdTitleArray=tmpThirdTitleArray;
                [tmpThirdTitleArray release];
            }
            
            self.lbCurrentSelect.text = [NSString stringWithFormat:@"%@,%@,%@",self.selectedTitle,self.selectSubTitleArray[0],self.selectThirdTitleArray[0]];
            break;
        }
        case comboboxTagTypeThirdTitle:
        {
            // 选择三级标题
            NSArray *tmpThirdTitleArray= [[NSArray alloc] initWithObjects:[_allThirdTitleArray objectAtIndex:selectedIndex], nil];
            self.selectThirdTitleArray=tmpThirdTitleArray;
            [tmpThirdTitleArray release];
            
            self.lbCurrentSelect.text = [NSString stringWithFormat:@"%@,%@,%@",self.selectedTitle,self.selectSubTitleArray[0],self.selectThirdTitleArray[0]];
            break;
        }
        default:
            break;
    }
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (decelerate == NO) {
        for (AJComboBox *combox in self.comboBoxMutArray) {
            combox.contentOffsetY = scrollView.contentOffset.y;
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    for (AJComboBox *combox in self.comboBoxMutArray) {
        combox.contentOffsetY = scrollView.contentOffset.y;
    }
}


@end

//
//  CLLockInfoView.m
//  CoreLock
//
//  Created by 成林 on 15/4/27.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CLLockInfoView.h"
#import "CoreLockConst.h"

#define ALIPAYSUBITEMTAG 33

#define SUBITEMTOTALWH 50 // 整个subitem的大小
#define SUBITEMWH      12  //单个subitem的大小
#define SUBITEM_TOP    80 //整个的subitem的顶点位置(y点)


@implementation CLLockInfoView

/*
- (void)drawRect:(CGRect)rect {
    
    //获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //设置属性
    CGContextSetLineWidth(ctx, CoreLockArcLineW);
    
    //设置线条颜色
    [CoreLockCircleLineNormalColor set];
    
    //新建路径
    CGMutablePathRef pathM =CGPathCreateMutable();
    
    CGFloat marginV = 3.f;
    CGFloat padding = 1.0f;
    CGFloat rectWH = (rect.size.width - marginV * 2 - padding*2) / 3;
    
    //添加圆形路径
    for (NSUInteger i=0; i<9; i++) {
        
        NSUInteger row = i % 3;
        NSUInteger col = i / 3;
        
        CGFloat rectX = (rectWH + marginV) * row + padding;
        
        CGFloat rectY = (rectWH + marginV) * col + padding;
        
        CGRect rect = CGRectMake(rectX, rectY, rectWH, rectWH);
        
        CGPathAddEllipseInRect(pathM, NULL, rect);
    }
    
    //添加路径
    CGContextAddPath(ctx, pathM);
    
    //绘制路径
    CGContextStrokePath(ctx);
    
    //释放路径
    CGPathRelease(pathM);
}
*/


- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [self initViews];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews
{
    for (int i=0; i<9; i++)
    {
        int row        = i / 3 ;
        int column     = i % 3 ;
        CGFloat x_or_y = (SUBITEMTOTALWH-3*SUBITEMWH)/4 ;
        CGFloat posX   = x_or_y*(column+1)+column*SUBITEMWH ;
        CGFloat posY   = x_or_y*(row+1)+row*SUBITEMWH ;
        
        
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake( posX , posY , SUBITEMWH , SUBITEMWH)];
        myView.tag = i + ALIPAYSUBITEMTAG;
        [self addSubview:myView];
        
        
        [self drawCircle:myView color:[UIColor clearColor]];
    }
}

- (void)drawCircle:(UIView *)myView color:(UIColor *)color
{
    if (color == [UIColor clearColor])
    {
        myView.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        myView.backgroundColor = color;
    }
    
    CAShapeLayer *shape = [CAShapeLayer layer];
    shape.frame = CGRectMake( 1 , 1 , SUBITEMWH-2 , SUBITEMWH-2);
    shape.fillColor = color.CGColor;
    if (color == [UIColor clearColor])
    {
        shape.strokeColor = [UIColor whiteColor].CGColor;
    }
    else
    {
        shape.strokeColor = color.CGColor;
    }
    shape.lineWidth = 1;
    myView.layer.mask = shape;
    
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:shape.bounds];
    shape.path = path.CGPath;
}

- (void)resultArr:(NSArray *)array fillColor:(UIColor *)color
{
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        if ([array containsObject:[NSString stringWithFormat:@"%lu", (unsigned long)idx]])
        {
            UIView *myView = (UIView *)[self viewWithTag:(idx+ALIPAYSUBITEMTAG)];
            
            // 如果array里包含idx，填充为白色
            [self drawCircle:myView color:color];
            
            [self performSelector:@selector(drawCleanCircle:) withObject:myView afterDelay:1];
            
        }
        
    }];
}

- (void)drawCleanCircle:(UIView *)myView
{
    [self drawCircle:myView color:[UIColor clearColor]];
}


@end

//
//  AJComboBox.m
//  AJComboBox
//
//  Created by Jasperit on 2/6/12.
//  Copyright (c) 2012 Jasper IT Pvt Ltd. All rights reserved.
// http://www.jasperitsolutions.com
//

/*
 Copyright (c) 2012, Ajeet Shakya
 
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 
 * Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 * Neither the name of the Zang Industries nor the names of its
 contributors may be used to endorse or promote products derived from
 this software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
 OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
 TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*
 Copyright 2011 AJEET SHAKYA
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "AJComboBox.h"
#import <QuartzCore/QuartzCore.h>

@interface AJComboBox ()

@property (nonatomic, assign) UIView *targetView;
@property (nonatomic, assign) UIView *superView;

@property (nonatomic, assign) CGRect tableOriginRect;


@end

@implementation AJComboBox
@synthesize arrayData, delegate;
@synthesize dropDownHeight;
@synthesize labelText;
@synthesize enabled;
@synthesize selectedIndex;

- (void)__show {
    viewControl.alpha = 0.0f;
    UIWindow *mainWindow = [[UIApplication sharedApplication] keyWindow];
    [mainWindow addSubview:viewControl];
	[UIView animateWithDuration:0.3f
					 animations:^{
						 viewControl.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {}];
}

- (void)__hide {
	[UIView animateWithDuration:0.2f
					 animations:^{
						 viewControl.alpha = 0.0f;
					 }
					 completion:^(BOOL finished) {
						 [viewControl removeFromSuperview];
					 }];
}

- (id)initWithFrame:(CGRect)frame targetView:(UIView *)targetView superView:(UIView *)superView
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.targetView = targetView;
        self.superView = superView;
        self.backgroundColor = [UIColor clearColor];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [button setTitle:@"--Select--" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"combo_bg.png"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor clearColor]];
        [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventTouchUpInside];
        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [self addSubview:button];
        dropDownHeight = 150;
        
        CGFloat y1 = CGRectGetMinY(targetView.frame);
        
        #warning contentOffsetY
        if (kSystemVersion < 7.0) {
            y1 = y1 + 20.0 + kNavigationBarHeight;
        }
        else
        {
            _contentOffsetY = - (20.0 + kNavigationBarHeight);
        }
        
        viewControl = [[UIControl alloc] initWithFrame:CGRectMake(CGRectGetMinX(targetView.frame),y1,CGRectGetWidth(targetView.frame),CGRectGetHeight(targetView.frame))];
        [viewControl setBackgroundColor:RGBA(0, 0, 0, 0.5f)];
        [viewControl addTarget:self action:@selector(controlPressed) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat x = CGRectGetMinX(frame) + CGRectGetMinX(superView.frame);
        CGFloat y = CGRectGetMaxY(frame) + CGRectGetMinY(superView.frame);
        
        _table = [[UITableView alloc] initWithFrame:CGRectMake(x, y, frame.size.width, dropDownHeight) style:UITableViewStylePlain];
        _table.dataSource = self;
        _table.delegate = self;
        _tableOriginRect = _table.frame;
        
        if ([_table respondsToSelector:@selector(setSeparatorInset:)]) {
            _table.separatorInset = UIEdgeInsetsZero;
        }
        CALayer *layer = _table.layer;
        layer.masksToBounds = YES;
        layer.cornerRadius = 5.0f;
        layer.borderWidth = 1.5f;
        [layer setBorderColor:[UIColor grayColor].CGColor];
        [viewControl addSubview:_table];
        
        [self addObserver:self forKeyPath:@"contentOffsetY" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

#pragma mark - KVC - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffsetY"])
    {
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if (!( (_superView.frame.origin.x == 0) && (_superView.frame.origin.y == 0)&& (_superView.frame.size.width == 0)&& (_superView.frame.size.height == 0)))
    {
        _table.frame = CGRectMake(_tableOriginRect.origin.x, _tableOriginRect.origin.y - _contentOffsetY, _tableOriginRect.size.width, _tableOriginRect.size.height);
        
        CGFloat comboxY = CGRectGetMaxY(self.frame);
        CGFloat remainHeight = abs(comboxY - _contentOffsetY);
        CGFloat superViewRemainHeight = CGRectGetHeight(self.targetView.frame)-CGRectGetMaxY(_superView.frame);
        
        // 当给定视图高度不满足table 显示高度，要计算剩下能够显示的高度
        if (CGRectGetHeight(_superView.frame) - remainHeight + superViewRemainHeight <= CGRectGetHeight(_table.frame)) {
            _table.frame = CGRectMake(_tableOriginRect.origin.x, _tableOriginRect.origin.y - _contentOffsetY, _tableOriginRect.size.width, CGRectGetHeight(_superView.frame) - remainHeight + superViewRemainHeight);
        }
    }
}

- (void) setLabelText:(NSString *)_labelText
{
    [labelText release];
    labelText = [_labelText retain];
    [button setTitle:labelText forState:UIControlStateNormal];
}

- (void) setEnable:(BOOL)_enabled
{
    enabled = _enabled;
    [button setEnabled:_enabled];
}

- (void) setArrayData:(NSArray *)_arrayData
{
    [arrayData release];
    arrayData = [_arrayData retain];
    [_table reloadData];
}

- (void) dealloc
{
    [self removeObserver:self forKeyPath:@"contentOffsetY"];
    [arrayData release];
    [labelText release];
    [viewControl release];
    [_table release];
    [super dealloc];
}

- (void) buttonPressed
{
    [self __show];
}

- (void) controlPressed
{
    //[viewControl removeFromSuperview];
    [self __hide];
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 30;
}	

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
	return [arrayData count];
}	

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    
    cell.textLabel.text = [arrayData objectAtIndex:indexPath.row];
    
	return cell;
}	

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = [indexPath row];
    //[viewControl removeFromSuperview];
    [self __hide];
    
    [button setTitle:[self.arrayData objectAtIndex:[indexPath row]] forState:UIControlStateNormal];

    [delegate didChangeComboBoxValue:self selectedIndex:[indexPath row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
	return 0;
}	

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return @"";
}	

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
	return @"";
}	

- (NSInteger) selectedIndex
{
    return selectedIndex;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex1
{
    if (selectedIndex1>self.arrayData.count-1) {
        return;
    }
    selectedIndex=selectedIndex1;

    [button setTitle:[self.arrayData objectAtIndex:selectedIndex] forState:UIControlStateNormal];
}

#pragma mark -
#pragma mark AJComboBoxDelegate
- (void)didChangeComboBoxValue:(AJComboBox *)comboBox selectedIndex:(NSInteger)selectedIndex
{
	
}	


@end

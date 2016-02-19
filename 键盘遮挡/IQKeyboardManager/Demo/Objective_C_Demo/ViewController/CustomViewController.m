//
//  CustomViewController.m
//  IQKeyboardManager
//
//  Created by InfoEnum02 on 21/04/15.
//  Copyright (c) 2015 Iftekhar. All rights reserved.
//

#import "CustomViewController.h"
#import "IQKeyboardManager.h"
#import "CustomSubclassView.h"

@interface CustomViewController ()
{
    IBOutlet UISwitch *switchDisableViewController;
    IBOutlet UISwitch *switchDisableToolbar;
    IBOutlet UISwitch *switchConsiderPreviousNext;
}

@end

@implementation CustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    switchDisableViewController.on = [[IQKeyboardManager sharedManager] isDisableInViewControllerClass:[CustomViewController class]];
    switchDisableToolbar.on = [[IQKeyboardManager sharedManager] isDisableToolbarInViewControllerClass:[CustomViewController class]];
    switchConsiderPreviousNext.on = [[IQKeyboardManager sharedManager] isConsiderToolbarPreviousNextInViewClass:[CustomSubclassView class]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)disableInViewControllerAction:(UISwitch *)sender
{
    [self.view endEditing:YES];

    if (sender.on)
    {
        [[IQKeyboardManager sharedManager] disableInViewControllerClass:[CustomViewController class]];
    }
    else
    {
        [[IQKeyboardManager sharedManager] removeDisableInViewControllerClass:[CustomViewController class]];
    }
}

- (IBAction)disableToolbarAction:(UISwitch *)sender
{
    [self.view endEditing:YES];
    
    if (sender.on)
    {
        [[IQKeyboardManager sharedManager] disableToolbarInViewControllerClass:[CustomViewController class]];
    }
    else
    {
        [[IQKeyboardManager sharedManager] removeDisableToolbarInViewControllerClass:[CustomViewController class]];
    }
}

- (IBAction)considerPreviousNextAction:(UISwitch *)sender
{
    [self.view endEditing:YES];
    
    if (sender.on)
    {
        [[IQKeyboardManager sharedManager] considerToolbarPreviousNextInViewClass:[CustomSubclassView class]];
    }
    else
    {
        [[IQKeyboardManager sharedManager] removeConsiderToolbarPreviousNextInViewClass:[CustomSubclassView class]];
    }
}

@end

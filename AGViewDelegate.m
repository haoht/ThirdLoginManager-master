//
//  AGViewDelegate.m
//  ShareSDKForBackgroundOfNavigation
//
//  Created by lisa on 14-7-22.
//  Copyright (c) 2014年 lisa. All rights reserved.
//

#import "AGViewDelegate.h"

@implementation AGViewDelegate

#pragma mark - ISSShareViewDelegate
- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType
{
    UIButton *leftBtn = (UIButton *)viewController.navigationItem.leftBarButtonItem.customView;
    [leftBtn addTarget:self action:@selector(leftButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    
    // 修改分享界面和授权界面的导航栏背景
//    [viewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"background_top_bar.png"]];

}


#pragma mark - target action
- (void)leftButtonClickHandler:(id)sender
{
    // 发送"分享界面左上角的取消按钮被点击"的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SHARE_CANCEL_BUTTON_CLICK" object:nil];
}


#pragma mark - dealloc method - 移除所有通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

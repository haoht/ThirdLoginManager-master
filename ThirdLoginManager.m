//
//  ThirdLoginManager.m
//  213123
//
//  Created by liman on 15-1-7.
//  Copyright (c) 2015年 liman. All rights reserved.
//

#import "ThirdLoginManager.h"

@interface ThirdLoginManager ()
{
    // 为了监控分享界面左上角的取消按钮(叉叉)
    AGViewDelegate *agViewDelegate;
    
    // 是否点击了分享界面左上角的取消按钮
    BOOL isShareCancelButtonClick;
}

@end

@implementation ThirdLoginManager

#pragma mark - public methods
// GCD单例
+ (ThirdLoginManager *)sharedInstance
{
    static ThirdLoginManager *__singletion = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        __singletion = [[self alloc] init];
        
    });
    
    return __singletion;
}


- (void)loginWithType:(ShareType)shareType authViewStyle:(SSAuthViewStyle)authViewStyle result:(void (^)(MyResponseState state, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error))block
{
    // 1. 开启网页授权开关, 打开网页登陆 (仅用于Facebook)
    if (shareType == ShareTypeFacebook) {
//        id<ISSFacebookApp> app =(id<ISSFacebookApp>)[ShareSDK getClientWithType:ShareTypeFacebook];
//        [app setIsAllowWebAuthorize:YES];
    }
    
    // 2. 自定义第三方登录界面的弹出样式, 并隐藏"Powered by ShareSDK"
    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                         allowCallback:YES
                                                         authViewStyle:authViewStyle
                                                          viewDelegate:agViewDelegate
                                               authManagerViewDelegate:agViewDelegate];//为了监控分享界面左上角的取消按钮(叉叉)
    [authOptions setPowerByHidden:YES];
    
    // 3. 登陆核心代码
    if (![ShareSDK hasAuthorizedWithType:shareType]) {
        // 用户未登录:
        
        // 弹出第三方登录窗口
        [ShareSDK getUserInfoWithType:shareType
                          authOptions:authOptions
                               result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                                   
                                   // 处理最后的结果
                                   
                                   if (result == 1) {
                                       // 登录成功
                                       block(MyResponseStateSuccess, userInfo, error);
                                   }
                                   
                                   if (result == 0) {
                                       
                                       if (isShareCancelButtonClick) {
                                           isShareCancelButtonClick = NO;
                                           
                                           // 取消登录
                                           block(MyResponseStateCancel, userInfo, error);
                                           
                                       } else {
                                           // 登录失败
                                           block(MyResponseStateFail, userInfo, error);
                                       }
                                   }
                               }];
    } else {
        // 用户已登录:
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"第三方已经登录" delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}


#pragma mark - life cycle
- (id)init
{
    // 接收"分享界面左上角的取消按钮被点击"的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareCancelButtonClick) name:@"SHARE_CANCEL_BUTTON_CLICK" object:nil];
    
    
    if (self = [super init]) {
        // 为了监控分享界面左上角的取消按钮(叉叉)
        agViewDelegate = [[AGViewDelegate alloc] init];
    }
    return self;
}


#pragma mark - target action
// 接收"分享界面左上角的取消按钮被点击"的通知
- (void)shareCancelButtonClick
{
    isShareCancelButtonClick = YES;
}


#pragma mark - dealloc method - 移除所有通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

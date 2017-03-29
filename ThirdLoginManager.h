//
//  ThirdLoginManager.h
//  213123
//
//  Created by liman on 15-1-7.
//  Copyright (c) 2015年 liman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import "AGViewDelegate.h"
//#import <FacebookConnection/ISSFacebookApp.h>

typedef enum
{
	MyResponseStateSuccess = 0, /**< 登录成功 */
	MyResponseStateFail = 1, /**< 登录失败 */
    MyResponseStateCancel = 2 /**< 取消登录 */
}
MyResponseState;

@interface ThirdLoginManager : NSObject

// GCD单例
+ (ThirdLoginManager *)sharedInstance;

- (void)loginWithType:(ShareType)shareType authViewStyle:(SSAuthViewStyle)authViewStyle result:(void (^)(MyResponseState state, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error))block;

@end

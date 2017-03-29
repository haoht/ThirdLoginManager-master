

第三方登陆的封装 (Third-party login wrapper)
===============

Demo:

	ThirdLoginManager *manager = [ThirdLoginManager sharedInstance];
	    [manager loginWithType:type authViewStyle:0 result:^(MyResponseState state, id userInfo, id error) {
	        
	    }];




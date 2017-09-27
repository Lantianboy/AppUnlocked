//
//  GesturesController.h
//  UnlockedGestures
//
//  Created by 最爱是深蓝 on 2017/9/27.
//  Copyright © 2017年 ProductTest. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger,WUUnlockType) {
    WUUnlockTypeCreatePwd,//创建手势密码
    WUUnlockTypeValidatePwd//检验手势密码
};


@interface GesturesController : UIViewController

+ (void)deleteGesturesPassword;//删除手势密码
+ (NSString *)gesturesPassword;//获取手势密码


- (instancetype)initWithUnlockType:(WUUnlockType)unlockType;

@end

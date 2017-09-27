//
//  Gestures2.h
//  UnlockedGestures
//
//  Created by 最爱是深蓝 on 2017/9/26.
//  Copyright © 2017年 ProductTest. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Gestures2 ;
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define Screen_Width [UIScreen mainScreen].bounds.size.width
#define Screen_Height [UIScreen mainScreen].bounds.size.height

@protocol GesturesDelegate <NSObject>

- (void)gestureLockView:(Gestures2 *)lockView drawRectFinished:(NSMutableString *)gesturePassword;

@end


@interface Gestures2 : UIView

@property (nonatomic,weak) id<GesturesDelegate> delegate ;


@end

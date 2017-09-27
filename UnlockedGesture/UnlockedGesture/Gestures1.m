//
//  Gestures1.m
//  UnlockedGestures
//
//  Created by 最爱是深蓝 on 2017/9/26.
//  Copyright © 2017年 ProductTest. All rights reserved.
//

#import "Gestures1.h"
@interface Gestures1()

@property (nonatomic ,strong) NSMutableArray * buttons ;

@end

@implementation Gestures1

- (NSMutableArray *)buttons {
    if (!_buttons) {
        _buttons = [NSMutableArray array] ;
    }
    return _buttons ;
}




- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup] ;
        
    }
    return self ;
}




- (void)setup
{
    for (int i = 0; i < 9; i ++) {
        UIButton * bn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        bn.userInteractionEnabled = NO ;//禁止按钮的时间处理
        [bn setImage:[UIImage imageNamed:@"gesture_indicator_normal"] forState:UIControlStateNormal] ;
        [bn setImage:[UIImage imageNamed:@"gesture_indicator_selected"] forState:UIControlStateSelected] ;
        
        [self addSubview:bn] ;
        [self.buttons addObject:bn] ;
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews] ;
    NSUInteger count = self.subviews.count ;
    
    int cols = 3 ;//总列数
    
    CGFloat x = 0,y = 0,w = 9,h = 9 ;//bounds 按键的位置和宽高
    
    CGFloat margin = (self.bounds.size.width - cols * w ) / (cols + 1) ;//间距
    
    CGFloat col = 0 ;
    CGFloat row = 0 ;
    for (int i = 0; i < count; i ++) {
        col = i%cols ;
        row = i/cols ;
        
        x = margin + (w+margin)* col ;
        y = margin + (w+margin)* row ;
        
        UIButton * btn = self.subviews[i] ;
        btn.frame = CGRectMake(x, y, w, h) ;
        
    }
}


- (void)setGesturesPassword:(NSString *)gesturesPassword
{
    if (gesturesPassword.length == 0) {
        for (UIButton * button in self.buttons) {
            button.selected = NO ;
        }
        return ;
    }
    for (int i = 0; i < gesturesPassword.length;  i ++) {
        NSString * s = [gesturesPassword substringWithRange:NSMakeRange(i, 1)] ;
        [self.buttons[s.integerValue] setSelected:YES] ;
    }
}

@end

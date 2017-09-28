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
    //创建按钮
    for (int i = 0; i < 9; i ++) {
        UIButton * bn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        bn.userInteractionEnabled = NO ;//禁止按钮的时间处理
        //设置按钮普通状态下的图片
        [bn setImage:[UIImage imageNamed:@"gesture_indicator_normal"] forState:UIControlStateNormal] ;
        //设置按钮选中状态下的图片
        [bn setImage:[UIImage imageNamed:@"gesture_indicator_selected"] forState:UIControlStateSelected] ;
        
        [self addSubview:bn] ;
        [self.buttons addObject:bn] ;
    }
}

//设置按钮的尺寸
- (void)layoutSubviews
{
    [super layoutSubviews] ;
    NSUInteger count = self.subviews.count ;
    
    int cols = 3 ;//总列数
    
    CGFloat x = 0,y = 0,w = 9,h = 9 ;//bounds 按键的位置和宽高
    
    CGFloat margin = (self.bounds.size.width - cols * w ) / (cols + 1) ;//间距(按钮的间距 = (ESUnlockView控件的总高度 - 3 * 按钮宽度) ／ 4)
    
    //当前按钮所处的行号和列号
    CGFloat col = 0 ;//按钮当前所处的行号
    CGFloat row = 0 ;//按钮当前所处的列号
    
    //遍历子控件 取出按钮
    for (int i = 0; i < count; i ++) {
        
        //计算当前按钮的x值
        col = i % cols ;//计算当前按钮所处的列号
        x = margin + (w+margin)* col ;//计算当前按钮的坐标
        /*
         *  下标为0、3、6的按钮，和3取模运算以后，结果为0，即它们都处在第0列
         *  下标为1、4、7的按钮，和3取模运算以后，结果为1，即它们都处在第1列
         *  下标为2、5、8的按钮，和3取模运算以后，结果为2，即它们都处在第2列
         *  同一列按钮的x值都是相等的，即：x = 间距 + 列号 * (间距 + 按钮的宽度)
         */
        
        //计算当前按钮的y值
        row = i/cols ;//计算当前按钮所处的行号
        y = margin + (w+margin)* row ;//计算当前按钮的y坐标
        /*
         *  下标为0、1、2的按钮，和3整除运算以后，结果为0，即它们都处在第0行
         *  下标为3、4、5的按钮，和3整除运算以后，结果为0，即它们都处在第1行
         *  下标为6、7、8的按钮，和3整除运算以后，结果为0，即它们都处在第2行
         *  同一行按钮的y值都是相等的，即：y = 间距 + 行号 * (间距 + 按钮的高度)
         */
        
        
        //取出按钮
        UIButton * btn = self.subviews[i] ;
        
        //设置子控件的尺寸
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

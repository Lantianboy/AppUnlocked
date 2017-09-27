//
//  Gestures2.m
//  UnlockedGestures
//
//  Created by 最爱是深蓝 on 2017/9/26.
//  Copyright © 2017年 ProductTest. All rights reserved.
//

#import "Gestures2.h"

@interface Gestures2()
@property(nonatomic, strong) NSMutableArray * selectedBtns ;
@property(nonatomic, assign) CGPoint currentPoint ;


@end
@implementation Gestures2

- (id) initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup] ;
        
    }
    return self ;
}

- (void) layoutSubviews
{
    [super layoutSubviews] ;
    NSUInteger count = self.subviews.count ;
    
    int cols = 3 ; //总列数
    
    CGFloat x = 0,y = 0,w = 0,h = 0 ;
    if (Screen_Width == 320) {
        w = 50 ;
        h = 50 ;
    }else{
        w = 58 ;
        h = 58 ;
    }
    
    CGFloat margin = (self.bounds.size.width - cols * w) / (cols + 1) ;//间距
    
    CGFloat col = 0 ;
    CGFloat row = 0 ;
    
    for (int i = 0; i < count; i++) {
        col = i%cols ;
        row = i/cols ;
        
        x = margin + (w + margin) * col ;
        
        y = margin + (w + margin) * row ;
        if (Screen_Height == 480) {
            y = (w + margin) * row ;
            
        }else{
            y = margin + (w + margin) * row ;
        }
        
        UIButton * btn = self.subviews[i] ;
        btn.frame = CGRectMake(x, y, w, h) ;
    }
}



//只要调用这个方法机会把之前绘制的东西清空 重新绘制
- (void) drawRect:(CGRect)rect
{
    if (self.selectedBtns.count == 0) return ;
    //把所有选中的按钮中心点连线
    UIBezierPath * path = [UIBezierPath bezierPath] ;
    if (self.userInteractionEnabled) {
        [[UIColor yellowColor] set];
    } else {
        [[UIColor orangeColor] set];
    }
    NSUInteger count = self.selectedBtns.count ;
    for (int i = 0; i < count; i++) {
        
        //取出被选中的按钮
        UIButton * btn = self.selectedBtns[i] ;
        
        //判断当前取出的按钮是否第一个按钮
        if (i == 0) {
            //如果是第一个按钮则将中心位置设置为路径的起点
            [path moveToPoint:btn.center] ;
            
        }else{
            //如果不是第一个按钮则将其设置为终点
            [path addLineToPoint:btn.center] ;
        }
    }
    //除了按钮被选中时绘制路径，当手指在按钮之外时也要绘制路径的连线
    [path addLineToPoint:_currentPoint] ;//添加一根线到当前手指所在的点
    
    
    //设置路径状态
    [UIColorFromRGB(0xffc8ad) set] ;//设置路径颜色
    path.lineJoinStyle = kCGLineCapRound ;//设置路径线条连接处的样式
    path.lineCapStyle = kCGLineCapRound ; //渲染
    path.lineWidth = 8 ;//设置路径的线宽
    [path stroke] ;//绘制路径
   
}

- (void)setup
{
    self.backgroundColor = [UIColor clearColor] ;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)] ;
    [self addGestureRecognizer:pan] ;
    
    //创建九个按钮
    for (int i = 0; i< 9; i++) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        btn.userInteractionEnabled = NO ;
        [btn setImage:[UIImage imageNamed:@"gesture_normal"] forState:UIControlStateNormal] ;
        [btn setImage:[UIImage imageNamed:@"gesture_selected"] forState:UIControlStateNormal] ;
        btn.tag = 100 + i ;
        [self addSubview:btn] ;
    }
}

- (void)pan:(UIPanGestureRecognizer * )pan
{
    
    //获得手指在屏幕上移动的坐标
    _currentPoint = [pan locationInView:self] ;
    
    //重新绘图 调用drawRect方法。drawRect方法主要用来画图。
    [self setNeedsDisplay] ;
    
    for (UIButton * button in self.subviews) {
        if (CGRectContainsPoint(button.frame, _currentPoint) && button.selected == NO) {
            button.selected = YES ;
            [self.selectedBtns addObject:button] ;
        }
    }
    
    //setNeedsLayout方法并不会立即刷新，立即刷新需要调用layoutIfNeeded方法。 会默认用layoutSubViews方法
    [self layoutIfNeeded] ;
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        
        //保存输入的密码
        NSMutableString * gesturePwd = @"".mutableCopy ;
        for (UIButton * button in self.selectedBtns) {
            [gesturePwd appendFormat:@"%ld",button.tag-100] ;
            button.selected = NO ;
        }
        [self.selectedBtns removeAllObjects] ;
        
        //手势密码绘制完成后回调
        if ([self.delegate respondsToSelector:@selector(gestureLockView:drawRectFinished:)]) {
            [self.delegate gestureLockView:self drawRectFinished:gesturePwd] ;
        }
    }
}

- (NSMutableArray * )selectedBtns
{
    if (!_selectedBtns) {
        _selectedBtns = @[].mutableCopy ;
        
    }
    return _selectedBtns ;
}







@end

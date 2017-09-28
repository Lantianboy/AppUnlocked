//
//  GesturesController.m
//  UnlockedGestures
//
//  Created by 最爱是深蓝 on 2017/9/27.
//  Copyright © 2017年 ProductTest. All rights reserved.
//

#import "GesturesController.h"
#import "Gestures1.h"
#import "Gestures2.h"

#define GesturesPassword @"gesturespassword"

@interface GesturesController ()<GesturesDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) Gestures2 * gestureLockView ;
@property (nonatomic,strong) Gestures1 * gestureLockindicator ;


//手势状态提示lable
@property (nonatomic,weak) UILabel * statusLabel ;
//账户名
@property (nonatomic,weak) UILabel * nameLable ;
//账户头像
@property (nonatomic,weak) UIImageView * headIcon ;
//其他账户登陆按钮
@property (nonatomic,weak) UIButton * otherAcountBtn ;
//重新绘制
@property (nonatomic,weak) UIButton * resetPswBtn ;
//忘记手势密码按钮
@property (nonatomic,weak) UIButton * forgetPswbtn ;
//创建手势密码
@property (nonatomic,copy) NSString * lastGesturePsw ;

@property (nonatomic) WUUnlockType unlockType ;

@end

@implementation GesturesController


#pragma mark--类方法
+ (void)deleteGesturesPassword
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey: GesturesPassword] ;
    [[NSUserDefaults standardUserDefaults] synchronize] ;
    
}

+ (void)addGesturePassword:(NSString *)gesturePassword {
    [[NSUserDefaults standardUserDefaults] setObject:gesturePassword forKey:GesturesPassword] ;
    [[NSUserDefaults standardUserDefaults] synchronize] ;
}

+ (NSString *)gesturesPassword
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:GesturesPassword] ;
}

#pragma mark--init
- (instancetype)initWithUnlockType:(WUUnlockType)unlockType {
    if (self = [super init]) {
        _unlockType = unlockType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor] ;
    
    [self setupMainUI] ;
    
    self.gestureLockView.delegate = self ;
    
    self.resetPswBtn.hidden = YES ;
    
    switch (_unlockType) {//判断枚举
        case WUUnlockTypeCreatePwd://创建手势
        {
            self.gestureLockindicator.hidden = NO ;
            self.otherAcountBtn.hidden = self.forgetPswbtn.hidden = self.nameLable.hidden = self.headIcon.hidden = YES ;
        }
            break;
        case WUUnlockTypeValidatePwd://校验手势
        {
            self.gestureLockindicator.hidden = YES ;
            self.otherAcountBtn.hidden = self.forgetPswbtn.hidden = self.nameLable.hidden = self.headIcon.hidden = NO ;
            
        }
            break ;
            
        default:
            break;
    }
    
}

- (void)setupMainUI
{
    CGFloat maginX = 15 ;
    CGFloat magin = 5 ;
    CGFloat btnW = ([UIScreen mainScreen].bounds.size.width - maginX * 2 - magin * 2) / 3 ;
    CGFloat btnH = 30 ;
    
    // 账户头像
    UIImageView *headIcon = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 56) * 0.5, 30, 56, 56)];
    headIcon.image = [UIImage imageNamed:@"gesture_headIcon"];
    [self.view addSubview:headIcon];
    
    // 账户名
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 100) * 0.5, 90, 100, 20)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.text = @"最爱是深蓝";
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textColor = [UIColor orangeColor];
    [self.view addSubview:nameLabel];
    self.statusLabel = nameLabel;
    
    // 九宫格指示器 小图
    Gestures1 *gestureLockIndicator = [[Gestures1 alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 60) * 0.5, 110, 60, 60)];
    [self.view addSubview:gestureLockIndicator];
    self.gestureLockindicator = gestureLockIndicator;
    
    // 手势状态栏提示label
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 200) * 0.5, 160, 200, 30)];
    statusLabel.textAlignment = NSTextAlignmentCenter;
    statusLabel.text = @"请绘制手势密码";
    statusLabel.font = [UIFont systemFontOfSize:12];
    statusLabel.textColor = [UIColor redColor];
    [self.view addSubview:statusLabel];
    self.statusLabel = statusLabel;
    
    // 九宫格 手势密码页面
    Gestures2 *gestureLockView = [[Gestures2 alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - self.view.frame.size.width - 60 - btnH, self.view.frame.size.width, self.view.frame.size.width)];
    gestureLockView.delegate = self;
    [self.view addSubview:gestureLockView];
    self.gestureLockView = gestureLockView;
    
    // 底部三个按钮
    // 其他账户登录按钮
    UIButton *otherAcountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    otherAcountBtn.frame = CGRectMake(maginX, self.view.frame.size.height - 20 - btnH, btnW, btnH);
    otherAcountBtn.backgroundColor = [UIColor clearColor];
    [otherAcountBtn setTitle:@"其他账户" forState:UIControlStateNormal];
    otherAcountBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [otherAcountBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    [otherAcountBtn addTarget:self action:@selector(otherAccountLogin:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:otherAcountBtn];
    self.otherAcountBtn = otherAcountBtn;
    
    // 重新绘制按钮
    UIButton *resetPswBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    resetPswBtn.frame = CGRectMake(CGRectGetMaxX(otherAcountBtn.frame) + magin, otherAcountBtn.frame.origin.y, btnW, btnH);
    resetPswBtn.backgroundColor = otherAcountBtn.backgroundColor;
    [resetPswBtn setTitle:@"重新绘制" forState:UIControlStateNormal];
    resetPswBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [resetPswBtn setTitleColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1] forState:UIControlStateNormal];
    [resetPswBtn addTarget:self action:@selector(resetGesturePassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:resetPswBtn];
    self.resetPswBtn = resetPswBtn;
    
    // 忘记手势密码按钮
    UIButton *forgetPswBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetPswBtn.frame = CGRectMake(CGRectGetMaxX(resetPswBtn.frame) + magin, otherAcountBtn.frame.origin.y, btnW, btnH);
    forgetPswBtn.backgroundColor = otherAcountBtn.backgroundColor;
    [forgetPswBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetPswBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [forgetPswBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [forgetPswBtn addTarget:self action:@selector(forgetGesturesPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forgetPswBtn];
    self.forgetPswbtn = forgetPswBtn;

}


#pragma mark -- 手势设置

//创建手势密码
- (void)createGesturesPassword:(NSMutableString *)gesturesPasswoed
{
    if (self.lastGesturePsw.length == 0) {
        if (gesturesPasswoed.length < 4) {
            self.statusLabel.text = @"至少连接四个点，请重新输入" ;
            [self shakeAnimationForView:self.statusLabel] ;
            return ;
            
        }
        if (self.resetPswBtn.hidden == YES) {
            self.resetPswBtn.hidden = NO ;
        }
        
        self.lastGesturePsw = gesturesPasswoed ;
        [self.gestureLockindicator setGesturesPassword:gesturesPasswoed] ;
        self.statusLabel.text = @"请再次绘制手势密码" ;
        return ;
    }
    if ([self.lastGesturePsw isEqualToString:gesturesPasswoed]) {//绘制成功
        [self dismissViewControllerAnimated:YES completion:^{
            //保存手势密码
            [GesturesController addGesturePassword:gesturesPasswoed] ;
        }] ;
    }else {
        self.statusLabel.text = @"与上次绘制的不一致，请重新绘制" ;
        [self shakeAnimationForView:self.statusLabel] ;
    }
}


//验证手势密码
- (void)validateGesturesPassword:(NSMutableString *)gesturesPassword{
    static NSInteger errorCount = 5 ;
    
    if ([gesturesPassword isEqualToString:[GesturesController gesturesPassword]]) {
        [self dismissViewControllerAnimated:YES completion:^{
            errorCount = 5 ;
        }] ;
    }else{
        
        if (errorCount - 1 == 0) {//输错五次 退出重新登录
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"手势密码已失效" message:@"请重新登录" delegate:self cancelButtonTitle:nil otherButtonTitles:@"重新登录", nil] ;
            [alertView show] ;
            errorCount = 5 ;
            return ;
        }
        self.statusLabel.text = [NSString stringWithFormat:@"密码错误。还可以再输入%ld次",--errorCount] ;
        [self shakeAnimationForView:self.statusLabel] ;
    }
}


//抖动动画
- (void)shakeAnimationForView:(UIView *)view{
    
    CALayer * viewLayer = view.layer ;
    CGPoint position = viewLayer.position ;
    CGPoint left = CGPointMake(position.x - 10, position.y) ;
    CGPoint right = CGPointMake(position.x + 10, position.y) ;
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"position"] ;//平移动画
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]] ;
    [animation setFromValue:[NSValue valueWithCGPoint:left]] ;
    [animation setToValue:[NSValue valueWithCGPoint:right]] ;
    [animation setAutoreverses:YES] ;
    [animation setDuration:0.08] ;//动画持续时间
    [animation setRepeatCount:3] ;
    
    [viewLayer addAnimation:animation forKey:nil] ;
    
    
    
}
//点击其他登录按钮
- (void)otherAccountLogin:(id)sender {
    NSLog(@"暂无其他登录") ;
}
//点击重新绘制按钮
- (void)resetGesturePassword:(id)sender {
    NSLog(@"重新绘制") ;
    
    self.lastGesturePsw = nil ;
    self.statusLabel.text = @"请绘制手势密码" ;
    self.resetPswBtn.hidden = YES ;
    [self.gestureLockindicator setGesturesPassword:@""] ;
}
//点击忘记手势密码按钮
- (void)forgetGesturesPassword:(id)sender {
    NSLog(@"忘记密码") ;
}

- (void)gestureLockView:(Gestures2 *)lockView drawRectFinished:(NSMutableString *)gesturePassword;
{
    switch (_unlockType) {
        case WUUnlockTypeCreatePwd:
        {
            [self createGesturesPassword:gesturePassword] ;
        }
            
            break;
        case WUUnlockTypeValidatePwd:
        {
            [self validateGesturesPassword:gesturePassword] ;
        }
            break ;
            
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //重新登录
    NSLog(@"重新登录") ;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

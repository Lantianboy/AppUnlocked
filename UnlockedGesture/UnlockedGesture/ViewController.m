//
//  ViewController.m
//  UnlockedGestures
//
//  Created by 最爱是深蓝 on 2017/9/26.
//  Copyright © 2017年 ProductTest. All rights reserved.
//

#import "ViewController.h"
#import "GesturesController.h"
@interface ViewController ()
@property (nonatomic,strong) NSMutableArray * mut ;
@property (nonatomic,strong) UIButton * btn ;





@end

@implementation ViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mut = [NSMutableArray arrayWithObjects:@"创建手势密码",@"校验手势密码",@"删除手势密码", nil] ;
    
    for (int i = 0; i < 3; i++) {
        self.btn = [UIButton buttonWithType:UIButtonTypeRoundedRect] ;
        self.btn.frame = CGRectMake(self.view.frame.size.width / 2 - 100, 150+80*(i%3), 200, 40) ;
        [self.btn setTitle:[_mut objectAtIndex:i] forState:UIControlStateNormal] ;
        self.btn.tag = 100 + i ;
        self.btn.backgroundColor = [UIColor greenColor] ;
        [self.btn addTarget:self action:@selector(touch:) forControlEvents:UIControlEventTouchUpInside] ;
        [self.view addSubview:self.btn] ;
        
        
    }
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (void)touch:(UIButton *)btn {
    
    if (btn.tag == 100) {
        NSLog(@"点击了---创建手势密码") ;
        GesturesController *vc = [[GesturesController alloc] initWithUnlockType:WUUnlockTypeCreatePwd];
        [self presentViewController:vc animated:YES completion:nil];
    }else if (btn.tag == 101){
    
        NSLog(@"点击了---校验手势密码") ;
        if ([GesturesController gesturesPassword].length > 0) {
            
            GesturesController *vc = [[GesturesController alloc] initWithUnlockType:WUUnlockTypeValidatePwd];
            [self presentViewController:vc animated:YES completion:nil];
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"还没有设置手势密码" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
            [alertView show];
        }
    }else if (btn.tag == 102){
    
        NSLog(@"点击了---删除手势密码") ;
        [GesturesController deleteGesturesPassword];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

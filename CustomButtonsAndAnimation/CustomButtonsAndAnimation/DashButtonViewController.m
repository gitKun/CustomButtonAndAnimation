//
//  DashButtonViewController.m
//  LoadingButton
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "DashButtonViewController.h"
#import "DashButton.h"

@interface DashButtonViewController ()

@end

@implementation DashButtonViewController

-(void)dealloc {
    NSLog(@"%@ dealloc!",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1];
    [self creatDashButton];
}

- (void)creatDashButton {
    DashButton *dashBtn = [DashButton buttonWithType:UIButtonTypeCustom];
    dashBtn.frame = CGRectMake(20, 100, 120, 45);
    [dashBtn setTitle:@"开始动画" forState:UIControlStateNormal];
    [dashBtn setTitle:@"DashingAnim" forState:UIControlStateDisabled];
    [dashBtn setBackgroundColor:[UIColor colorWithRed:212/255.0 green:64/255.0 blue:19/255.0 alpha:1]];
    [dashBtn addTarget:self action:@selector(dashBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dashBtn];
}
- (void)dashBtnClick:(DashButton *)button {
    
    [button startBegainingAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /* 
         由于我在 DsahButton 中并没有对 传入的 block 进行 copy 等 引用操作 因此在这里你可以就看到 我直接使用了 self 调用方法 (可以对比`TestViewController`)
         */
        [button startFinishingAnimatonWithCompletion:^{
            [self testBlockPrintFun];
        }];
    });
}
- (void)testBlockPrintFun {
    NSLog(@"动画结束~_~! %@", NSStringFromSelector(_cmd));
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

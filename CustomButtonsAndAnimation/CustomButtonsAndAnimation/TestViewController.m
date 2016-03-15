//
//  TestViewController.m
//  LoadingButton
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "TestViewController.h"
#import "LoadingButton.h"

@interface TestViewController ()

@property (nonatomic, strong) LoadingButton *loadButton;

@end

@implementation TestViewController

-(void)dealloc {
    NSLog(@"TestViewController dealloc!");
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatLoadButton];
}
- (void)creatLoadButton {
    self.loadButton = [[LoadingButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds)-64, 44)];
    _loadButton.center = self.view.center;
    _loadButton.highlightedBackgroundColor = [UIColor redColor];
    _loadButton.normalBackgroundColor = [UIColor lightGrayColor];
    [_loadButton setTitle:@"Sing in" forState:UIControlStateNormal];
    _loadButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];
    [_loadButton addTarget:self action:@selector(loadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loadButton];

}
- (void)loadButtonClick:(LoadingButton *)button {
    [button startLoadingBegainingAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self endLoadingAction];
    });
}

- (IBAction)xibButtonClick:(LoadingButton *)sender {
    [sender startLoadingBegainingAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [sender startLoadingFinishingAnimatonWithCompletion:^{
            //做你想做的事情 但是请注意 使用 block 时，可能造成的死锁问题
            NSLog(@"xibButton click!");
        }];
    });
}

- (void)endLoadingAction {
    /*
     这里不能使用 __block 来引用 button，__block 是通过复制 button 的引用地址来实现访 具体细节请参阅  [__block和__weak的区别](http://blog.csdn.net/leikezhu1981/article/details/45009123)
     */
    __unused __weak LoadingButton *blockButton = self.loadButton;
    [_loadButton startLoadingFinishingAnimatonWithCompletion:^{
        NSLog(@"loadButton click!");
        //打开注释可以看到 self 被强引用了 可以对比 `DashButtonViewController` 中的 block
        //[self testBlockPrintFun];
    }];
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

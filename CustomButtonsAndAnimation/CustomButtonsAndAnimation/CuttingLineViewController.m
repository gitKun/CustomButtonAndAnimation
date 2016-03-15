
//
//  CuttingLineViewController.m
//  LoadingButton
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "CuttingLineViewController.h"
#import "DRCuttingLineView.h"

static Pattern patterns[] = {
    {{10.0, 10.0}, 2},
    {{10.0, 20.0, 10.0}, 3},
    {{8.0,4.0,2.0,4.0},4}
};

@interface CuttingLineViewController ()

@property (weak, nonatomic) IBOutlet DRCuttingLineView *xibView;

@property (nonatomic, strong) DRCuttingLineView *cuttingView;

@end

@implementation CuttingLineViewController

- (void)dealloc {
    NSLog(@"CuttingVC dealloc!");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self upsetXibView];
    [self upsetCuttingLineView];
}
- (void)upsetXibView {
    self.xibView.backgroundColor = [UIColor clearColor];
    self.xibView.storkeColor = [UIColor whiteColor];
    NSInteger row = 2;
    self.xibView.dashPhase = 0.1;
    [self.xibView setDashPattern:patterns[row].pattern count:patterns[row].count];
}
- (void)upsetCuttingLineView {
    NSInteger row = 0;
    self.cuttingView = [DRCuttingLineView new];
    _cuttingView.frame = CGRectMake(10, 80, CGRectGetWidth(self.view.bounds)-20, 2);
    _cuttingView.dashPhase = 0.0;
    _cuttingView.backgroundColor = [UIColor clearColor];
    _cuttingView.storkeColor = [UIColor redColor];
    [_cuttingView setDashPattern:patterns[row].pattern count:patterns[row].count];
    [self.view addSubview:_cuttingView];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateCuttingView];
    });
}
- (void)updateCuttingView {
    static unsigned int i = 0;
    self.cuttingView.dashPhase = (++i)*5;
    if (i >= 25) {
        i = 0;
        self.cuttingView.dashPhase = 0;
        return;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self updateCuttingView];
    });
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

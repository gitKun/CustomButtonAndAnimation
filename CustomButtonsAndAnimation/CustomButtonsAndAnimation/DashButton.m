//
//  DashButton.m
//  LoadingButton
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "DashButton.h"

/************************************************/
#pragma mark ==== DashLayer
/************************************************/

@interface DashLayer : CALayer

@property (nonatomic, assign) CGFloat dashPhase;

- (void)startAniamtion;
- (void)stopAnimation;

@end

static CGFloat startDashPhase = 2.5;
static CGFloat dr_dashLineWidth = 5.0;

@implementation DashLayer

//@dynamic dashPhase;

- (instancetype)init {
    if (self = [super init]) {
        self.hidden = YES;
        self.dashPhase = startDashPhase;
    }
    return self;
}
+(BOOL)needsDisplayForKey:(NSString *)key {
    if ([key isEqualToString:@"dashPhase"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}
- (void)startAniamtion {
    self.hidden = NO;
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"dashPhase"];
    anim.fromValue = @(4*dr_dashLineWidth+startDashPhase);
    anim.toValue = @(startDashPhase);
    anim.duration = 0.4;
    //anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anim.repeatCount = HUGE;
    //anim.fillMode = kCAFillModeForwards;//kCAFillModeBoth
    //anim.removedOnCompletion = NO;
    [self addAnimation:anim forKey:anim.keyPath];
}
- (void)stopAnimation {
    self.hidden = YES;
    [self removeAllAnimations];
}

-(void)drawInContext:(CGContextRef)ctx {
    CGRect bouns = self.bounds;
    
    //CGContextSetStrokeColorWithColor(ctx, [UIColor whiteColor].CGColor);/*用这种方法 你可以从外界传入填充的颜色*/
    CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1.0);
    //控制线条长和间隔的长度
    double pattenArr[2] = {dr_dashLineWidth,dr_dashLineWidth};
    /*
     设置线条为 分割线(破折号)类型 第二个参数 传入起始的位置 第三个参数出入一个 C数组的指针 第四个参数出入 次数组中所有非0值的个数
     备注：1.你可以修改 pattenArr 为 {5.0，15.0} 查看效果 2.在1的基础上 修改 CGContextSetLineDash(ctx, self.dashPhase, pattenArr, 1); 运行查看效果 通过1和2大概你就能明白这些参数的意义了
     */
    CGContextSetLineDash(ctx, self.dashPhase, pattenArr, 2);
    CGContextAddRect(ctx, bouns);
    CGContextSetLineWidth(ctx, 2.0);
    CGContextStrokePath(ctx);
}

@end

@interface DashButton ()

@property (nonatomic, strong) DashLayer *dashLayer;

@end

@implementation DashButton

-(void)dealloc {
    NSLog(@"DashButton dealloc!");
}

- (DashLayer *)dashLayer {
    if (!_dashLayer) {
        _dashLayer = [DashLayer layer];
        _dashLayer.frame = self.bounds;
        [self.layer addSublayer:_dashLayer];
    }
    return _dashLayer;
}

- (void)startBegainingAnimation {
    self.enabled = NO;
    [self.dashLayer startAniamtion];
}
- (void)startFinishingAnimatonWithCompletion:(DashAnimationCompletionBlock)completion {
    [self.dashLayer stopAnimation];
    completion();
    self.enabled = YES;
}

@end


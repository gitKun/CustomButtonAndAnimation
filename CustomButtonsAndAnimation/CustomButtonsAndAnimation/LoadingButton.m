//
//  LoadingButton.m
//  LoadingButton
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "LoadingButton.h"

/*********************************************/
#pragma mark ===== DRLoadingLayer
/*********************************************/
@interface DRLoadingLayer : CAShapeLayer

- (void)starLogAnimation;

- (void)stopLogAnimation;

@end

@implementation DRLoadingLayer

- (void)setFrame:(CGRect)frame {
    CGRect sFrame = CGRectMake(0, 0, CGRectGetHeight(frame), CGRectGetHeight(frame));
    [super setFrame:sFrame];
    CGFloat radius = (CGRectGetHeight(frame)/2)*0.5;
    CGPoint center = CGPointMake(CGRectGetHeight(frame)/2, CGRectGetHeight(frame)/2);
    CGFloat startAngle = 0 - M_PI_2;
    CGFloat endAngle = M_PI *2 - M_PI_2;
    BOOL colockwise = YES;
    self.path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:colockwise].CGPath;
    self.fillColor = nil;
    self.strokeColor = [UIColor whiteColor].CGColor;
    self.lineWidth = 1.5;
    self.strokeEnd = 0.4;
    self.hidden = YES;
}

- (void)starLogAnimation {
    self.hidden = NO;
    CABasicAnimation *rotate = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotate.fromValue = @(0);
    rotate.toValue = @(M_PI * 2);
    rotate.duration = 0.4;
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotate.repeatCount = HUGE;//MAXFLOAT
    rotate.fillMode = kCAFillModeForwards;
    rotate.removedOnCompletion = NO;
    [self addAnimation:rotate forKey:rotate.keyPath];
}
- (void)stopLogAnimation {
    self.hidden = YES;
    [self removeAllAnimations];
}

@end


@interface LoadingButton ()

@property (nonatomic, copy) NSString *cachedTitle;
@property (nonatomic, strong) DRLoadingLayer *loadingLayer;
#if 0
@property (nonatomic, copy) LoadingAnimationCompletionBlock didEndFinishAnimation;
#else
@property (nonatomic, copy) void(^didEndFinishAnimation)(void);
#endif

@end

@implementation LoadingButton

- (void)dealloc {
    NSLog(@"LoadingButton dealloc!");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}
- (void)setup {
    self.layer.cornerRadius = CGRectGetHeight(self.bounds)/2;
    self.layer.masksToBounds = YES;
}

#pragma mark -- layz 
- (DRLoadingLayer *)loadingLayer {
    if (!_loadingLayer) {
        _loadingLayer = [DRLoadingLayer layer];
        _loadingLayer.frame = self.bounds;
        [self.layer addSublayer:_loadingLayer];
    }
    return _loadingLayer;
}
#pragma mark -- public
- (void)startLoadingBegainingAnimation {
    self.cachedTitle = [self titleForState:UIControlStateNormal];
    [self setTitle:@"" forState:UIControlStateNormal];
    [self shirnkAnimation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.enabled = NO;
        [self.loadingLayer starLogAnimation];
    });
}
- (void)shirnkAnimation {
    CABasicAnimation *shrinkAnimation = [CABasicAnimation animationWithKeyPath:@"bounds.size.width"];
    shrinkAnimation.fromValue = @(CGRectGetWidth(self.frame));
    shrinkAnimation.toValue = @(CGRectGetHeight(self.frame));
    shrinkAnimation.duration = 0.1;
    shrinkAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    shrinkAnimation.fillMode = kCAFillModeForwards;
    shrinkAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:shrinkAnimation forKey:shrinkAnimation.keyPath];
}
- (void)startLoadingFinishingAnimatonWithCompletion:(void (^)(void))completion {
    //为了变形动画 能够遮挡住当前 view 上所有的 subView
    [self.superview bringSubviewToFront:self];
    self.didEndFinishAnimation = completion;
    [self expandAnimation];
    [self.loadingLayer stopLogAnimation];
    self.enabled = YES;
    
}
- (void)expandAnimation {
    CABasicAnimation *expandAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    expandAnimation.fromValue = @(1.0);
    expandAnimation.toValue = @(26.0);
    expandAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.95 :0.02 :1.0 :0.05];
    expandAnimation.duration = 0.3;
    expandAnimation.delegate = self;
    expandAnimation.fillMode = kCAFillModeForwards;
    expandAnimation.removedOnCompletion = NO;
    [self.layer addAnimation:expandAnimation forKey:expandAnimation.keyPath];
}
- (void)returnToOriginalState {
    [self.layer removeAllAnimations];
    [self setTitle:self.cachedTitle forState:UIControlStateNormal];
}

#pragma mark === CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    CABasicAnimation *animation = (CABasicAnimation *)anim;
    if ([animation.keyPath isEqualToString:@"transform.scale"]) {
        self.didEndFinishAnimation();
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self returnToOriginalState];
        });
    }
}
#pragma mark -- OVERRIDE
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    [self changeBackgroundColor];
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    if (self.highlightedBackgroundColor == highlightedBackgroundColor) {
        return;
    }
    _highlightedBackgroundColor = highlightedBackgroundColor;
    [self changeBackgroundColor];
}
- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor {
    if (self.normalBackgroundColor == normalBackgroundColor) {
        return;
    }
    _normalBackgroundColor = normalBackgroundColor;
    [self changeBackgroundColor];
}
- (void)changeBackgroundColor {
    if (self.highlighted) {
        self.backgroundColor = self.highlightedBackgroundColor;
    }else {
        self.backgroundColor = self.normalBackgroundColor;
    }
}


@end


//
//  DRCuttingLineView.m
//  LoadingButton /* 如果你注意到这里 那么应该明白我用了项目改名*/
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 kun. All rights reserved.
//

#import "DRCuttingLineView.h"

@interface DRCuttingLayer : CALayer

@property (nonatomic, strong) UIColor *storkeColor;
@property(nonatomic, readwrite) CGFloat dashPhase;

-(void)setDashPattern:(CGFloat*)pattern count:(size_t)count;

@end

@implementation DRCuttingLayer {
    CGFloat dashPattern[10];
    size_t dashCount;
}

-(void)setDashPhase:(CGFloat)phase {
    if (phase != _dashPhase)
    {
        _dashPhase = phase;
        [self setNeedsDisplay];
    }
}
- (void)setStorkeColor:(UIColor *)storkeColor {
    _storkeColor = storkeColor;
    [self setNeedsDisplay];
}

-(void)setDashPattern:(CGFloat *)pattern count:(size_t)count {
    if ((count != dashCount) || (memcmp(dashPattern, pattern, sizeof(CGFloat) * count) != 0)) {
        memcpy(dashPattern, pattern, sizeof(CGFloat) * count);
        dashCount = count;
        [self setNeedsDisplay];
    }
}

-(void)drawInContext:(CGContextRef)ctx {
    //用这种方法你可以传入自定义的分隔线颜色
    CGContextSetStrokeColorWithColor(ctx, _storkeColor.CGColor);
    //CGContextSetRGBStrokeColor(ctx, 1.0, 1.0, 1.0, 1.0);
    /* 根据数组重复的添加线条，例如: {10.0,20.0,10.0} 绘制顺序为 0到10(绘制10个) 10到30(不绘制此20个) 30到40(绘制此10个) 40到50(不绘制此10个) 50到70(绘制此20个) ...如此重复下去 */
    CGContextSetLineDash(ctx, self.dashPhase, dashPattern, dashCount);
    CGContextMoveToPoint(ctx, 0.0, 0);
    CGContextAddLineToPoint(ctx, CGRectGetWidth(self.bounds), 0);
    CGContextSetLineWidth(ctx, 2);
    CGContextStrokePath(ctx);
}

@end


@implementation DRCuttingLineView

+(Class)layerClass {
    return [DRCuttingLayer class];
}

- (DRCuttingLayer *)cuttingLayer {
    return (DRCuttingLayer *)self.layer;
}
- (void)setDashPattern:(CGFloat *)pattern count:(size_t)count {
    [self.cuttingLayer setDashPattern:pattern count:count];
}
- (void)setDashPhase:(CGFloat)dashPhase {
    [self.cuttingLayer setDashPhase:dashPhase];
}
- (CGFloat)dashPhase {
    return self.cuttingLayer.dashPhase;
}
- (void)setStorkeColor:(UIColor *)storkeColor {
    [self.cuttingLayer setStorkeColor:storkeColor];
}
- (UIColor *)storkeColor {
    return self.cuttingLayer.storkeColor;
}

@end

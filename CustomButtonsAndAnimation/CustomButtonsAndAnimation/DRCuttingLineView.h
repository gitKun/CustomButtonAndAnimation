//
//  DRCuttingLineView.h
//  LoadingButton
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef struct {
    CGFloat pattern[5];
    size_t count;
} Pattern;

@interface DRCuttingLineView : UIView

@property (nonatomic, readwrite) CGFloat dashPhase;
@property (nonatomic, strong) UIColor *storkeColor;
-(void)setDashPattern:(CGFloat*)pattern count:(size_t)count;

@end

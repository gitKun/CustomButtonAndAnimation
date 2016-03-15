//
//  LoadingButton.h
//  LoadingButton
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LoadingAnimationCompletionBlock)(void);

IB_DESIGNABLE
@interface LoadingButton : UIButton

@property (nonatomic, strong) IBInspectable UIColor *highlightedBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *normalBackgroundColor;

- (void)startLoadingBegainingAnimation;
- (void)startLoadingFinishingAnimatonWithCompletion:(void (^)(void))completion;

@end

//
//  DashButton.h
//  LoadingButton
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 kun. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DashAnimationCompletionBlock)(void);

@interface DashButton : UIButton

- (void)startBegainingAnimation;
- (void)startFinishingAnimatonWithCompletion:(DashAnimationCompletionBlock)completion;

@end



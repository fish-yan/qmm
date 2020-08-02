//
//  HYTopPayAnimator.m
//  QMM
//
//  Created by Joseph Koh on 2018/10/22.
//  Copyright © 2018 Joseph Koh. All rights reserved.
//

#import "HYTopPayAnimator.h"

@implementation HYTopPayAnimator

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.45;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    
    UIView *containerView = transitionContext.containerView;
    containerView.backgroundColor = [UIColor clearColor];
    
    if (toVC.isBeingPresented) {
        [containerView addSubview:toView];
        
        UIView *maskView = [toView viewWithTag:1024];
        maskView.alpha = 0.0;
        
        CGAffineTransform transform = CGAffineTransformMakeScale(0, 0);
        UIView *contentView = [toView viewWithTag:1025];
        contentView.transform =transform;
        
        UIButton *closeBtn = [toView viewWithTag:1026];
        closeBtn.transform = transform;
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                              delay:0.0
             usingSpringWithDamping:0.85
              initialSpringVelocity:0.5
                            options:0
                         animations:^{
                             maskView.alpha = 0.4;
                             CGAffineTransform transform = CGAffineTransformMakeScale(1, 1);
                             contentView.transform = transform;
                             closeBtn.transform = transform;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
    else {
        UIView *maskView = [fromView viewWithTag:1024];
        maskView.alpha = 0.0;
        
        UIView *contentView = [fromView viewWithTag:1025];
        UIButton *closeBtn = [fromView viewWithTag:1026];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext]
                         animations:^{
                             maskView.alpha = 0.0;
                             CGAffineTransform transform = CGAffineTransformMakeScale(0, 0);
                             contentView.transform = transform;
                             closeBtn.transform = transform;
                         }
                         completion:^(BOOL finished) {
                             [transitionContext completeTransition:YES];
                         }];
    }
    
}
@end

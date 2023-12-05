//
//  FASlideInBaseViewController.m
//  FymDemo
//
//  Created by fym on 2018/3/29.
//  Copyright © 2018年 fym. All rights reserved.
//

#import "FASlideInBaseViewController.h"

@interface FASlideInBaseViewController () <UIViewControllerTransitioningDelegate>

@end

@implementation FASlideInBaseViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self=[super initWithCoder:aDecoder];
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate=self;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    FASlideInPresentationController *pc=[[FASlideInPresentationController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    pc.performance=self;
    return pc;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    FASlideInTransitionAnimation *animation = [[FASlideInTransitionAnimation alloc] initWithState:FASlideInAnimationStatePresenting];
    animation.performance=self;
    return animation;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    FASlideInTransitionAnimation *animation = [[FASlideInTransitionAnimation alloc] initWithState:FASlideInAnimationStateDismissing];
    animation.performance=self;
    return animation;
}

-(CGRect)slideInTargetFrameOfState:(FASlideInAnimationState)state{
    if (state==FASlideInAnimationStatePresenting) {
        return CGRectMake(0, 100, 200, 400);
    }
    else{
        return CGRectMake(SCREEN_WIDTH, 100, 200, 400);
    }
}

-(float)slideInDurationOfState:(FASlideInAnimationState)state{
    return 0.3;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    NSLog(@"dealloc %@",self);
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

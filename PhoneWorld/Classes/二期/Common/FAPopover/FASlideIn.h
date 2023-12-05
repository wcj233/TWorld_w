//
//  FASlideIn.h
//  FymDemo
//
//  Created by fym on 2018/3/29.
//  Copyright © 2018年 fym. All rights reserved.
//

#ifndef FASlideIn_h
#define FASlideIn_h

//动画状态
typedef enum {
    //准备中
    FASlideInAnimationStatePreparing,
    //present动画中
    FASlideInAnimationStatePresenting,
    //dismimss动画中
    FASlideInAnimationStateDismissing
}FASlideInAnimationState;

////动画类型（可以添加）
//typedef enum {
//    //直接出现、直接消失
//    FASlideInAnimationTypeNone=0,
//    //从某侧滑入、向某侧滑出
//    FASlideInAnimationTypeTop,
//    FASlideInAnimationTypeLeft,
//    FASlideInAnimationTypeBottom,
//    FASlideInAnimationTypeRight
//    //
//}FASlideInAnimationType;

#endif /* FASlideIn_h */

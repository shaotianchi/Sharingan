//
//  UITouch+Synthesize.h
//  Sharingan-Player
//
//  Created by Shao Tianchi on 2017/2/13.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//
//  From https://github.com/kif-framework/KIF/tree/master/Additions
//

#import <UIKit/UIKit.h>

typedef struct __IOHIDEvent * IOHIDEventRef;
IOHIDEventRef srg_IOHIDEventWithTouches(NSArray *touches) CF_RETURNS_RETAINED;


@interface UITouch (SRGAdditions)

- (id)initInView:(UIView *)view;
- (id)initAtPoint:(CGPoint)point inView:(UIView *)view;
- (instancetype)initAtPoint:(CGPoint)point inWindow:(UIWindow *)window emptyTouchView:(BOOL)isEmpty;

- (void)setLocationInWindow:(CGPoint)location;
- (void)setPhaseAndUpdateTimestamp:(UITouchPhase)phase;

@end

@interface UIEvent (SRGAdditionsPrivateHeaders)
- (void)_addTouch:(UITouch *)touch forDelayedDelivery:(BOOL)arg2;
- (void)_clearTouches;
@end

@interface UIEvent (SRGAdditions)
- (void)srg_setEventWithTouches:(NSArray *)touches;
@end

@interface UIApplication (SRGAdditionsPrivate)
- (UIEvent *)_touchesEvent;
@end

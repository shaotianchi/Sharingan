//
//  UITouch+Synthesize.h
//  Sharingan-Player
//
//  From https://github.com/kif-framework/KIF/tree/master/Additions
//
//  KIF
//  Copyright 2011-2016 Square, Inc.
//  A full list of contributors is available at https://github.com/square/KIF/contributors
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

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

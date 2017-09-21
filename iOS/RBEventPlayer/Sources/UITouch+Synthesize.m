//
//  UITouch+Synthesize.m
//  Sharingan-Player
//
//  Created by Shao Tianchi on 2017/2/13.
//  Copyright © 2017年 Shao Tianchi. All rights reserved.
//

#import "UITouch+Synthesize.h"
#import <mach/mach_time.h>
#import <objc/runtime.h>


#define IOHIDEventFieldBase(type) (type << 16)
#ifdef __LP64__
typedef double IOHIDFloat;
#else
typedef float IOHIDFloat;
#endif
typedef UInt32 IOOptionBits;
typedef uint32_t IOHIDDigitizerTransducerType;
typedef uint32_t IOHIDEventField;
typedef uint32_t IOHIDEventType;

void IOHIDEventAppendEvent(IOHIDEventRef event, IOHIDEventRef childEvent);
void IOHIDEventSetIntegerValue(IOHIDEventRef event, IOHIDEventField field, int value);
void IOHIDEventSetSenderID(IOHIDEventRef event, uint64_t sender);

enum {
    kIOHIDDigitizerTransducerTypeStylus = 0,
    kIOHIDDigitizerTransducerTypePuck,
    kIOHIDDigitizerTransducerTypeFinger,
    kIOHIDDigitizerTransducerTypeHand
};

enum {
    kIOHIDEventTypeNULL,                    // 0
    kIOHIDEventTypeVendorDefined,
    kIOHIDEventTypeButton,
    kIOHIDEventTypeKeyboard,
    kIOHIDEventTypeTranslation,
    kIOHIDEventTypeRotation,                // 5
    kIOHIDEventTypeScroll,
    kIOHIDEventTypeScale,
    kIOHIDEventTypeZoom,
    kIOHIDEventTypeVelocity,
    kIOHIDEventTypeOrientation,             // 10
    kIOHIDEventTypeDigitizer,
    kIOHIDEventTypeAmbientLightSensor,
    kIOHIDEventTypeAccelerometer,
    kIOHIDEventTypeProximity,
    kIOHIDEventTypeTemperature,             // 15
    kIOHIDEventTypeNavigationSwipe,
    kIOHIDEventTypePointer,
    kIOHIDEventTypeProgress,
    kIOHIDEventTypeMultiAxisPointer,
    kIOHIDEventTypeGyro,                    // 20
    kIOHIDEventTypeCompass,
    kIOHIDEventTypeZoomToggle,
    kIOHIDEventTypeDockSwipe,               // just like kIOHIDEventTypeNavigationSwipe, but intended for consumption by Dock
    kIOHIDEventTypeSymbolicHotKey,
    kIOHIDEventTypePower,                   // 25
    kIOHIDEventTypeLED,
    kIOHIDEventTypeFluidTouchGesture,       // This will eventually superseed Navagation and Dock swipes
    kIOHIDEventTypeBoundaryScroll,
    kIOHIDEventTypeBiometric,
    kIOHIDEventTypeUnicode,                 // 30
    kIOHIDEventTypeAtmosphericPressure,
    kIOHIDEventTypeUndefined,
    kIOHIDEventTypeCount, // This should always be last
    
    
    // DEPRECATED:
    kIOHIDEventTypeSwipe = kIOHIDEventTypeNavigationSwipe,
    kIOHIDEventTypeMouse = kIOHIDEventTypePointer
};

enum {
    kIOHIDDigitizerEventRange                               = 0x00000001,
    kIOHIDDigitizerEventTouch                               = 0x00000002,
    kIOHIDDigitizerEventPosition                            = 0x00000004,
    kIOHIDDigitizerEventStop                                = 0x00000008,
    kIOHIDDigitizerEventPeak                                = 0x00000010,
    kIOHIDDigitizerEventIdentity                            = 0x00000020,
    kIOHIDDigitizerEventAttribute                           = 0x00000040,
    kIOHIDDigitizerEventCancel                              = 0x00000080,
    kIOHIDDigitizerEventStart                               = 0x00000100,
    kIOHIDDigitizerEventResting                             = 0x00000200,
    kIOHIDDigitizerEventSwipeUp                             = 0x01000000,
    kIOHIDDigitizerEventSwipeDown                           = 0x02000000,
    kIOHIDDigitizerEventSwipeLeft                           = 0x04000000,
    kIOHIDDigitizerEventSwipeRight                          = 0x08000000,
    kIOHIDDigitizerEventSwipeMask                           = 0xFF000000,
};
enum {
    kIOHIDEventFieldDigitizerX = IOHIDEventFieldBase(kIOHIDEventTypeDigitizer),
    kIOHIDEventFieldDigitizerY,
    kIOHIDEventFieldDigitizerZ,
    kIOHIDEventFieldDigitizerButtonMask,
    kIOHIDEventFieldDigitizerType,
    kIOHIDEventFieldDigitizerIndex,
    kIOHIDEventFieldDigitizerIdentity,
    kIOHIDEventFieldDigitizerEventMask,
    kIOHIDEventFieldDigitizerRange,
    kIOHIDEventFieldDigitizerTouch,
    kIOHIDEventFieldDigitizerPressure,
    kIOHIDEventFieldDigitizerAuxiliaryPressure, //BarrelPressure
    kIOHIDEventFieldDigitizerTwist,
    kIOHIDEventFieldDigitizerTiltX,
    kIOHIDEventFieldDigitizerTiltY,
    kIOHIDEventFieldDigitizerAltitude,
    kIOHIDEventFieldDigitizerAzimuth,
    kIOHIDEventFieldDigitizerQuality,
    kIOHIDEventFieldDigitizerDensity,
    kIOHIDEventFieldDigitizerIrregularity,
    kIOHIDEventFieldDigitizerMajorRadius,
    kIOHIDEventFieldDigitizerMinorRadius,
    kIOHIDEventFieldDigitizerCollection,
    kIOHIDEventFieldDigitizerCollectionChord,
    kIOHIDEventFieldDigitizerChildEventMask,
    kIOHIDEventFieldDigitizerIsDisplayIntegrated,
    kIOHIDEventFieldDigitizerQualityRadiiAccuracy,
};
IOHIDEventRef IOHIDEventCreateDigitizerEvent(CFAllocatorRef allocator, AbsoluteTime timeStamp, IOHIDDigitizerTransducerType type,
                                             uint32_t index, uint32_t identity, uint32_t eventMask, uint32_t buttonMask,
                                             IOHIDFloat x, IOHIDFloat y, IOHIDFloat z, IOHIDFloat tipPressure, IOHIDFloat barrelPressure,
                                             Boolean range, Boolean touch, IOOptionBits options);
IOHIDEventRef IOHIDEventCreateDigitizerFingerEventWithQuality(CFAllocatorRef allocator, AbsoluteTime timeStamp,
                                                              uint32_t index, uint32_t identity, uint32_t eventMask,
                                                              IOHIDFloat x, IOHIDFloat y, IOHIDFloat z, IOHIDFloat tipPressure, IOHIDFloat twist,
                                                              IOHIDFloat minorRadius, IOHIDFloat majorRadius, IOHIDFloat quality, IOHIDFloat density, IOHIDFloat irregularity,
                                                              Boolean range, Boolean touch, IOOptionBits options);

IOHIDEventRef srg_IOHIDEventWithTouches(NSArray *touches) {
    uint64_t abTime = mach_absolute_time();
    AbsoluteTime timeStamp;
    timeStamp.hi = (UInt32)(abTime >> 32);
    timeStamp.lo = (UInt32)(abTime);
    
    IOHIDEventRef handEvent = IOHIDEventCreateDigitizerEvent(kCFAllocatorDefault, // allocator
                                                             timeStamp, // timestamp
                                                             kIOHIDDigitizerTransducerTypeHand, // type
                                                             0, // index
                                                             0, // identity
                                                             kIOHIDDigitizerEventTouch, // eventMask
                                                             0, // buttonMask
                                                             0, // x
                                                             0, // y
                                                             0, // z
                                                             0, // tipPressure
                                                             0, // barrelPressure
                                                             0, // range
                                                             true, // touch
                                                             0); // options
    IOHIDEventSetIntegerValue(handEvent, kIOHIDEventFieldDigitizerIsDisplayIntegrated, true);
    
    for (UITouch *touch in touches)
    {
        uint32_t eventMask = (touch.phase == UITouchPhaseMoved) ? kIOHIDDigitizerEventPosition : (kIOHIDDigitizerEventRange | kIOHIDDigitizerEventTouch);
        uint32_t isTouching = (touch.phase == UITouchPhaseEnded) ? 0 : 1;
        
        CGPoint touchLocation = [touch locationInView:touch.window];
        
        IOHIDEventRef fingerEvent = IOHIDEventCreateDigitizerFingerEventWithQuality(kCFAllocatorDefault, // allocator
                                                                                    timeStamp, // timestamp
                                                                                    (UInt32)[touches indexOfObject:touch] + 1, //index
                                                                                    2, // identity
                                                                                    eventMask, // eventMask
                                                                                    (IOHIDFloat)touchLocation.x, // x
                                                                                    (IOHIDFloat)touchLocation.y, // y
                                                                                    0.0, // z
                                                                                    0, // tipPressure
                                                                                    0, // twist
                                                                                    5.0, // minor radius
                                                                                    5.0, // major radius
                                                                                    1.0, // quality
                                                                                    1.0, // density
                                                                                    1.0, // irregularity
                                                                                    (IOHIDFloat)isTouching, // range
                                                                                    (IOHIDFloat)isTouching, // touch
                                                                                    0); // options
        IOHIDEventSetIntegerValue(fingerEvent, kIOHIDEventFieldDigitizerIsDisplayIntegrated, 1);
        
        IOHIDEventAppendEvent(handEvent, fingerEvent);
        CFRelease(fingerEvent);
    }
    
    return handEvent;
}

typedef struct {
    unsigned int _firstTouchForView:1;
    unsigned int _isTap:1;
    unsigned int _isDelayed:1;
    unsigned int _sentTouchesEnded:1;
    unsigned int _abandonForwardingRecord:1;
} UITouchFlags;

@interface UITouch ()
- (void)setWindow:(UIWindow *)window;
- (void)setView:(UIView *)view;
- (void)setTapCount:(NSUInteger)tapCount;
- (void)setIsTap:(BOOL)isTap;
- (void)setTimestamp:(NSTimeInterval)timestamp;
- (void)setPhase:(UITouchPhase)touchPhase;
- (void)setGestureView:(UIView *)view;
- (void)_setLocationInWindow:(CGPoint)location resetPrevious:(BOOL)resetPrevious;
- (void)_setIsFirstTouchForView:(BOOL)firstTouchForView;

- (void)_setHidEvent:(IOHIDEventRef)event;

@end

@implementation UITouch (SRGAdditions)

- (id)initInView:(UIView *)view {
    CGRect frame = view.frame;
    CGPoint centerPoint = CGPointMake(frame.size.width * 0.5f, frame.size.height * 0.5f);
    return [self initAtPoint:centerPoint inView:view];
}

- (instancetype)initAtPoint:(CGPoint)point inWindow:(UIWindow *)window emptyTouchView:(BOOL)isEmpty {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    [self setWindow:window]; // Wipes out some values.  Needs to be first.
    
    [self setTapCount:1];
    [self _setLocationInWindow:point resetPrevious:YES];
    
    UIView *hitTestView = [window hitTest:point withEvent:nil];
    
    if (!isEmpty) {
        [self setView:hitTestView];
    }
    [self setPhase:UITouchPhaseBegan];
    [self _setIsFirstTouchForView:YES];
    [self setIsTap:YES];
    [self setTimestamp:[[NSProcessInfo processInfo] systemUptime]];
    
    if ([self respondsToSelector:@selector(setGestureView:)]) {
        [self setGestureView:hitTestView];
    }
    
    // Starting with iOS 9, internal IOHIDEvent must be set for UITouch object
    NSOperatingSystemVersion iOS9 = {9, 0, 0};
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)] && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS9]) {
        [self srg_setHidEvent];
    }
    
    return self;
}

- (id)initAtPoint:(CGPoint)point inWindow:(UIWindow *)window {
    return [self initAtPoint:point inWindow:window emptyTouchView:false];
}

- (id)initAtPoint:(CGPoint)point inView:(UIView *)view {
    if ([view isKindOfClass:[UIWindow class]]) {
        return [self initAtPoint:point inWindow:(UIWindow *)view];
    }
    return [self initAtPoint:[view.window convertPoint:point fromView:view] inWindow:view.window];
}

//
// setLocationInWindow:
//
// Setter to allow access to the _locationInWindow member.
//
- (void)setLocationInWindow:(CGPoint)location {
    [self setTimestamp:[[NSProcessInfo processInfo] systemUptime]];
    [self _setLocationInWindow:location resetPrevious:NO];
}

- (void)setPhaseAndUpdateTimestamp:(UITouchPhase)phase {
    [self setTimestamp:[[NSProcessInfo processInfo] systemUptime]];
    [self setValue:@(phase) forKey:@"phase"];
}

- (void)srg_setHidEvent {
    IOHIDEventRef event = srg_IOHIDEventWithTouches(@[self]);
    [self _setHidEvent:event];
    CFRelease(event);
}

@end

@interface SRGGSEventProxy : NSObject {
@public
    unsigned int flags;
    unsigned int type;
    unsigned int ignored1;
    float x1;
    float y1;
    float x2;
    float y2;
    unsigned int ignored2[10];
    unsigned int ignored3[7];
    float sizeX;
    float sizeY;
    float x3;
    float y3;
    unsigned int ignored4[3];
}
@end

@implementation SRGGSEventProxy
@end

typedef struct __GSEvent * GSEventRef;

@interface UIEvent (SRGAdditionsMorePrivateHeaders)
- (void)_setGSEvent:(GSEventRef)event;
- (void)_setHIDEvent:(IOHIDEventRef)event;
- (void)_setTimestamp:(NSTimeInterval)timestemp;
@end

@implementation UIEvent (SRGAdditions)

- (void)srg_setEventWithTouches:(NSArray *)touches {
    NSOperatingSystemVersion iOS8 = {8, 0, 0};
    if ([NSProcessInfo instancesRespondToSelector:@selector(isOperatingSystemAtLeastVersion:)]
        && [[NSProcessInfo new] isOperatingSystemAtLeastVersion:iOS8]) {
        [self srg_setIOHIDEventWithTouches:touches];
    } else {
        [self srg_setGSEventWithTouches:touches];
    }
}

- (void)srg_setGSEventWithTouches:(NSArray *)touches {
    UITouch *touch = touches[0];
    CGPoint location = [touch locationInView:touch.window];
    SRGGSEventProxy *gsEventProxy = [[SRGGSEventProxy alloc] init];
    gsEventProxy->x1 = location.x;
    gsEventProxy->y1 = location.y;
    gsEventProxy->x2 = location.x;
    gsEventProxy->y2 = location.y;
    gsEventProxy->x3 = location.x;
    gsEventProxy->y3 = location.y;
    gsEventProxy->sizeX = 1.0;
    gsEventProxy->sizeY = 1.0;
    gsEventProxy->flags = ([touch phase] == UITouchPhaseEnded) ? 0x1010180 : 0x3010180;
    gsEventProxy->type = 3001;
    
    [self _setGSEvent:(GSEventRef)gsEventProxy];
    
    [self _setTimestamp:(((UITouch*)touches[0]).timestamp)];
}

- (void)srg_setIOHIDEventWithTouches:(NSArray *)touches {
    IOHIDEventRef event = srg_IOHIDEventWithTouches(touches);
    [self _setHIDEvent:event];
    CFRelease(event);
}

@end

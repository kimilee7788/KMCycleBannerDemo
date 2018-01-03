//
//  UIView+Frame.m
//  Oc_runTimeTest
//
//  Created by kimilee on 2016/1/2.
//  Copyright © 2016年 kimilee. All rights reserved.
//

#import "UIView+Frame.h"
#import <objc/runtime.h>

void Swizzle(Class c, SEL orig, SEL new) {
    Method origMethod = class_getInstanceMethod(c, orig);
    Method newMethod = class_getInstanceMethod(c, new);
    if (class_addMethod(c, orig, method_getImplementation(newMethod), method_getTypeEncoding(newMethod))){
        class_replaceMethod(c, new, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    } else {
        method_exchangeImplementations(origMethod, newMethod);
    }
}


@implementation UIView (Frame)



+ (void)load {
    Swizzle(self, @selector(pointInside:withEvent:), @selector(myPointInside:withEvent:));
}

- (BOOL)myPointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (UIEdgeInsetsEqualToEdgeInsets(self.touchExtendInset, UIEdgeInsetsZero) || self.hidden ||
        ([self isKindOfClass:UIControl.class] && !((UIControl *)self).enabled)) {
        return [self myPointInside:point withEvent:event]; // original implementation
    }
    CGRect hitFrame = UIEdgeInsetsInsetRect(self.bounds, self.touchExtendInset);
    hitFrame.size.width = MAX(hitFrame.size.width, 0); // don't allow negative sizes
    hitFrame.size.height = MAX(hitFrame.size.height, 0);
    return CGRectContainsPoint(hitFrame, point);
}

static char touchExtendInsetKey;
- (void)setTouchExtendInset:(UIEdgeInsets)touchExtendInset {
    objc_setAssociatedObject(self, &touchExtendInsetKey, [NSValue valueWithUIEdgeInsets:touchExtendInset],
                             OBJC_ASSOCIATION_RETAIN);
}

- (UIEdgeInsets)touchExtendInset {
    return [objc_getAssociatedObject(self, &touchExtendInsetKey) UIEdgeInsetsValue];
}



- (id)initWithMainFrame
{
    CGRect frame = [UIView mainFrame];
    return [self initWithFrame:frame];
}

+ (CGRect)mainFrame
{
    return CGRectMake(0, 0, [[UIScreen mainScreen] applicationFrame].size.width, [[UIScreen mainScreen] applicationFrame].size.height - 20 - 44);
}

+ (CGRect)fullScreenBound{
    return [[UIScreen mainScreen] applicationFrame];
}






- (CGFloat)left
{
    return self.frame.origin.x;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setOrigin:(CGPoint)point
{
    CGRect frame = self.frame;
    frame.origin = point;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)centerX{
    self.center = CGPointMake(centerX, self.center.y);
}

- (void)setCenterY:(CGFloat)centerY{
    self.center = CGPointMake(self.center.x, centerY);
}

@end

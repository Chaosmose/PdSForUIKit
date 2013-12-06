// This file is part of "PDSCategoriesForUIKit"
//
// "PDSCategoriesForUIKit" is free software: you can redistribute it and/or modify
// it under the terms of the GNU LESSER GENERAL PUBLIC LICENSE as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// "PdSMatrix" is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU LESSER GENERAL PUBLIC LICENSE for more details.
//
// You should have received a copy of the GNU LESSER GENERAL PUBLIC LICENSE
// along with "PDSCategoriesForUIKit"  If not, see <http://www.gnu.org/licenses/>
//
//
//  UIView+RoundedRect.m
//  PDSCategoriesForUIKit
//
//  Created by Benoit Pereira da Silva on 23/11/2013.
//  Copyright (c) 2013 http://pereira-da-silva.com  All rights reserved.
//

#import "UIView+RectCorners.h"
#import <objc/runtime.h>

static char const * const hasBeenMaskedOnceKey="hasBeenMaskedOnceKey";
static char const * const rectCornersKey="rectCornersKey";
static char const * const radiusKey="radiusKey";
static char const * const paddingKey="paddingKey";

@implementation UIView (RectCorners)


/**
 *  Sets the rect corners.
 *
 *  @param corners UIRectCornerAllCorners for all, bottom only (UIRectCornerBottomLeft|UIRectCornerBottomRight)
 *  @param radius  the corner radius
 */
- (void)setRectCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    [self setRectCorners:corners radius:radius withPadding:0.f];
}


/**
 *  Sets the rect corners.
 *
 *  @param corners UIRectCornerAllCorners for all, bottom only (UIRectCornerBottomLeft|UIRectCornerBottomRight)
 *  @param radius  the corner radius
 *  @param padding the padding
 */
- (void)setRectCorners:(UIRectCorner)corners radius:(CGFloat)radius withPadding:(CGFloat)padding{
    
    BOOL i_hasBeenMaskedOnce=[objc_getAssociatedObject(self, hasBeenMaskedOnceKey) boolValue];
    UIRectCorner i_corners=[objc_getAssociatedObject(self, rectCornersKey) integerValue];
    CGFloat i_radius=[objc_getAssociatedObject(self, radiusKey) floatValue];
    CGFloat i_padding=[objc_getAssociatedObject(self, paddingKey) floatValue];
    if(!i_hasBeenMaskedOnce){
        [self _setRectCorners:corners radius:radius withPadding:padding];
    }else if (i_corners!=corners || i_radius!=radius || i_padding!=padding){
        [self _setRectCorners:corners radius:radius withPadding:padding];
    }
    
    objc_setAssociatedObject(self, hasBeenMaskedOnceKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, rectCornersKey, @(corners), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, radiusKey, @(radius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, paddingKey, @(padding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);

}


/**
 *  Defines if the view has already been masked
 *
 *  @return YES if the view has a mask
 */
- (BOOL)hasBeenMasked{
    BOOL i_hasBeenMaskedOnce=objc_getAssociatedObject(self, &hasBeenMaskedOnceKey);
    return i_hasBeenMaskedOnce;
}

/**
 *  Masks the current view to be circular
 *
 *  @param circular
 */
- (void)setCircular:(BOOL)circular{
    if(circular){
    [self setRectCorners:UIRectCornerAllCorners
                  radius:self.bounds.size.width/2.f];
    }else{
        self.layer.mask=nil;
    }
}


#pragma mark - Private implementation

- (void)_setRectCorners:(UIRectCorner)corners radius:(CGFloat)radius withPadding:(CGFloat)padding{
    CGRect rect = self.bounds;
    rect=[self _padRect:rect withPadding:padding];
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                               byRoundingCorners:corners
                                                     cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.frame = rect;
    mask.path  = path.CGPath;
    self.layer.mask = mask;
}


- (CGRect)_padRect:(CGRect)rect withPadding:(CGFloat)padding{
    if(padding==0.f)
        return rect;
    rect=CGRectInset(rect, padding, padding);
    rect.origin=CGPointMake(rect.origin.x+padding, rect.origin.y+padding);
    return rect;
}


@end

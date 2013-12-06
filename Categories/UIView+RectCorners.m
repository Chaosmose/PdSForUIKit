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

@interface UIView(){
    BOOL _hasBeenMasked;
    UIRectCorner _rectCorners;
    CGFloat _radius;
    CGFloat _padding;
}
@end

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
    if(!_hasBeenMasked){
        [self _setRectCorners:corners radius:radius withPadding:padding];
    }else if (_rectCorners!=corners ||_radius!=radius || _padding!=padding){
        [self _setRectCorners:corners radius:radius withPadding:padding];
    }
    _rectCorners=corners;
    _radius=radius;
    _padding=padding;
    _hasBeenMasked=YES;
}


/**
 *  Defines if the view has already been masked
 *
 *  @return YES if the view has a mask
 */
- (BOOL)hasBeenMasked{
    return _hasBeenMasked;
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

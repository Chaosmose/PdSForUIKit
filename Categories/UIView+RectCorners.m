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

@implementation UIView (RectCorners)

/**
 *  Sets the rect corners.
 *
 *  @param corners UIRectCornerAllCorners for all, bottom only (UIRectCornerBottomLeft|UIRectCornerBottomRight)
 *  @param radius  the corner radius
 */
- (void)setRectCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    CGRect rect = self.bounds;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.frame = rect;
    mask.path  = path.CGPath;
    self.layer.mask = mask;
}

/**
 *  Defines if the view has already been masked
 *
 *  @return YES if the view has a mask
 */
- (BOOL)hasBeenMasked{
    return (self.layer.mask!=nil);
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




@end

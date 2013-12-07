// This file is part of "PdSForUIKit"
//
// "PdSForUIKit" is free software: you can redistribute it and/or modify
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
// along with "PdSForUIKit"  If not, see <http://www.gnu.org/licenses/>
//
//  UIView+RoundedRect.h
//  PdSForUIKit
//
//  Created by Benoit Pereira da Silva on 23/11/2013.
//  Copyright (c) 2013 http://pereira-da-silva.com  All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (RectCorners)

/**
 *  Sets the rect corners.
 *
 *  @param corners UIRectCornerAllCorners for all, bottom only (UIRectCornerBottomLeft|UIRectCornerBottomRight)
 *  @param radius  the corner radius
 */
- (void)setRectCorners:(UIRectCorner)corners
                radius:(CGFloat)radius;

/**
 *  Sets the rect corners.
 *
 *  @param corners UIRectCornerAllCorners for all, bottom only (UIRectCornerBottomLeft|UIRectCornerBottomRight)
 *  @param radius  the corner radius
 *  @param padding the padding
 */
- (void)setRectCorners:(UIRectCorner)corners
                radius:(CGFloat)radius
           withPadding:(UIEdgeInsets)padding;


/**
 *  For those that do not like the UIEdgeInsets syntax
 *
 *  @param corners UIRectCornerAllCorners for all, bottom only (UIRectCornerBottomLeft|UIRectCornerBottomRight)
 *  @param radius  the corner radius
 *  @param top     top padding mask
 *  @param bottom  bottom  padding mask
 *  @param left    left padding mask
 *  @param right   right padding mask
 */
- (void)setRectCorners:(UIRectCorner)corners
                radius:(CGFloat)radius
            top:(CGFloat)top
         bottom:(CGFloat)bottom
           left:(CGFloat)left
          right:(CGFloat)right;


/**
 *  Defines if the view has already been masked
 *
 *  @return YES if the view has a mask
 */
- (BOOL)hasBeenMasked;

/**
 *  Re-apply the mask if there one if the size of the view has changed.
 */
- (void)remaskIfNecessary;



/**
 *  Masks the current view to be circular
 *
 *  @param circular
 */
- (void)setCircular:(BOOL)circular;


@end

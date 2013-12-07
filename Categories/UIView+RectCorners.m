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
//
//  UIView+RoundedRect.m
//  PdSForUIKit
//
//  Created by Benoit Pereira da Silva on 23/11/2013.
//  Copyright (c) 2013 http://pereira-da-silva.com  All rights reserved.
//

#import "UIView+RectCorners.h"
#import <objc/runtime.h>

static char const * const hasBeenMaskedOnceKey="hasBeenMaskedOnceKey";
static char const * const rectCornersKey="rectCornersKey";
static char const * const radiusKey="radiusKey";
static char const * const paddingKey="paddingKsey";
static char const * const previousSize="previousSize";
// Border
static char const * const borderLayer="borderLayer";
static char const * const strokeColor="strokeColor";
static char const * const lineWidth="lineWidth";
static char const * const usesAShapePrototype="usesAShapePrototype";

@implementation UIView (RectCorners)

/**
 *  Sets the rect corners.
 *
 *  @param corners UIRectCornerAllCorners for all, bottom only (UIRectCornerBottomLeft|UIRectCornerBottomRight)
 *  @param radius  the corner radius
 */
- (void)setRectCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    [self setRectCorners:corners radius:radius withPadding:UIEdgeInsetsZero];
}


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
                 right:(CGFloat)right{
    
    [self setRectCorners:corners
                  radius:radius
             withPadding:UIEdgeInsetsMake(top, left, bottom, right)];
}



/**
 *  Sets the rect corners.
 *
 *  @param corners UIRectCornerAllCorners for all, bottom only (UIRectCornerBottomLeft|UIRectCornerBottomRight)
 *  @param radius  the corner radius
 *  @param padding the padding
 */
- (void)setRectCorners:(UIRectCorner)corners radius:(CGFloat)radius withPadding:(UIEdgeInsets)padding{
    BOOL i_hasBeenMaskedOnce=[objc_getAssociatedObject(self, hasBeenMaskedOnceKey) boolValue];
    UIRectCorner i_corners=[objc_getAssociatedObject(self, rectCornersKey) integerValue];
    CGFloat i_radius=[objc_getAssociatedObject(self, radiusKey) floatValue];
    UIEdgeInsets i_padding=UIEdgeInsetsFromString(objc_getAssociatedObject(self, paddingKey)) ;
    CGSize i_size=CGSizeFromString(objc_getAssociatedObject(self,previousSize));
    BOOL proceed=NO;
    if( !i_hasBeenMaskedOnce){
        proceed=YES;
    }else if (  i_corners!=corners ||
              i_radius!=radius ||
              UIEdgeInsetsEqualToEdgeInsets(i_padding, padding)||
              !CGSizeEqualToSize(i_size,self.bounds.size)){
        proceed=YES;
    }
    if(proceed){
        objc_setAssociatedObject(self, hasBeenMaskedOnceKey, @YES, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, rectCornersKey, @(corners), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, radiusKey, @(radius), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, paddingKey,NSStringFromUIEdgeInsets(padding), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, previousSize,NSStringFromCGSize(self.bounds.size), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self _setRectCorners:corners radius:radius withPadding:padding];
    }
}


/**
 *  Defines if the view has already been masked
 *
 *  @return YES if the view has a mask
 */
- (BOOL)hasBeenMasked{
    BOOL i_hasBeenMaskedOnce=[objc_getAssociatedObject(self, hasBeenMaskedOnceKey) boolValue];
    return i_hasBeenMaskedOnce;
}

/**
 *  Re-apply the mask if there one if the size of the view has changed.
 */
- (void)remaskIfNecessary{
    if(self.hasBeenMasked){
        UIRectCorner i_corners=[objc_getAssociatedObject(self, rectCornersKey) integerValue];
        CGFloat i_radius=[objc_getAssociatedObject(self, radiusKey) floatValue];
        UIEdgeInsets i_padding=UIEdgeInsetsFromString(objc_getAssociatedObject(self, paddingKey)) ;
        [self setRectCorners:i_corners radius:i_radius withPadding:i_padding];
    }
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
        objc_setAssociatedObject(self, hasBeenMaskedOnceKey, @NO, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}


/**
 *  You can add a border
 *
 *  @param color the border color
 *  @param width the border width
 */
- (void)setBorderColor:(UIColor*)color andWidth:(CGFloat)width{
    if(![objc_getAssociatedObject(self, usesAShapePrototype) boolValue]){
        objc_setAssociatedObject(self, strokeColor, color, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(self, lineWidth, @(width), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }else{
        NSLog(@"Warning attempt to setBorderColor:andWidth when using ShapeLayerPrototype, those color will be ignored");
    }
    
}

/**
 *  Advanced shape addition, all the shapeLayer properties will be applied  to the current bezier path
 *  The shapeLayerPrototype will be retained so you need to pass a Weak reference.
 *  CAShapeLayer*__weak weakShape=[CAShapeLayer layer];
 *
 *  @param shapeLayer the shapeLayer prototype that will be applyied to the current bezier path
 */
- (void)applyShapeLayerPrototype:(CAShapeLayer*)shapeLayerPrototype{
    if(![objc_getAssociatedObject(self, usesAShapePrototype) boolValue]){
        CAShapeLayer *sublayer = objc_getAssociatedObject(self, borderLayer);
        if(!sublayer){
            [sublayer removeFromSuperlayer];
        }
        objc_setAssociatedObject(self, borderLayer, shapeLayerPrototype, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        UIColor *c=nil;
        if(shapeLayerPrototype.strokeColor)
            c=[UIColor colorWithCGColor:shapeLayerPrototype.strokeColor];
        
        objc_setAssociatedObject(self, strokeColor, c, OBJC_ASSOCIATION_RETAIN);
        objc_setAssociatedObject(self, lineWidth, @(shapeLayerPrototype.lineWidth), OBJC_ASSOCIATION_RETAIN);
        objc_setAssociatedObject(self, usesAShapePrototype, @(YES), OBJC_ASSOCIATION_RETAIN);
    }
}


#pragma mark - Private implementation


- (void)_setRectCorners:(UIRectCorner)corners radius:(CGFloat)radius withPadding:(UIEdgeInsets)padding{
    CGRect rect = UIEdgeInsetsInsetRect(self.bounds, padding);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect
                                               byRoundingCorners:corners
                                                     cornerRadii:CGSizeMake(radius, radius)];
    
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.frame = self.bounds;
    mask.path  = path.CGPath;
    self.layer.mask = mask;
    
    UIColor *i_strokeColor=objc_getAssociatedObject(self, strokeColor);
    CGFloat i_lineWidth=[objc_getAssociatedObject(self, lineWidth) floatValue];
    
    if(i_strokeColor){
        CAShapeLayer *sublayer = objc_getAssociatedObject(self, borderLayer);
        if(!sublayer){
            sublayer=[CAShapeLayer layer];
            sublayer.fillColor=nil; // transparent by default
            objc_setAssociatedObject(self, borderLayer, sublayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }else{
            [sublayer removeFromSuperlayer];
        }
        sublayer.path=path.CGPath;
        sublayer.strokeColor=i_strokeColor.CGColor;
        sublayer.lineWidth=i_lineWidth*2; // We mask half of the drawing to have a better rendering
        [self.layer addSublayer:sublayer];
    }
    
    
    
}







@end

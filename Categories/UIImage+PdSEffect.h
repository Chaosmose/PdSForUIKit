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
//  UIImage+PdSEffect.h
//  PdSForUIKit
//
//  Created by Benoit Pereira da Silva on 26/12/2013.
//  Copyright (c) 2013 http://pereira-da-silva.com All rights reserved.
//
//  This category provides basic image processing facilities
//
//  - resizing (sub and sur-sampling)
//  - blur (gaussian and motion blur)
//  - gray scale
//  - alpha extraction, and fusion
//
// ## History :
//
// Originally included in ve.rdict for "semi-realtime" blur, and alpha processing
// It synthesize repackaged and patched sources from :
//
// 1-  UIImage+Dsp.m Created by Andrew  https://github.com/gdawg/uiimage-dsp
//     from Mad Dog Software (http://www.mad-dog-software.com) on 18/05/11.
//
// 2-  Uses a trick from Mickael Tyson :
//     http://atastypixel.com/blog/achieve-smaller-app-downloads-by-replacing-large-pngs-with-jpeg-mask/
//
// 3-  And for alpha extraction UIImage+Alpha.h
//     Created by Trevor Harmon on 9/20/09.
//
// 4-  And for resizing UIImage+Resize.h
//     Created by Trevor Harmon on 8/5/09.

// TODO A full set of tests
// Documentation and clarification of  2);// kCGImageAlphaPremultipliedFirst BPDS

#import <UIKit/UIKit.h>


// all the different matrix sizes we support
typedef enum {
    DSPMatrixSize3x3,
    DSPMatrixSize5x5,
    DSPMatrixSizeCustom,
} DSPMatrixSize;

@interface UIImage(PdSEffect)


#pragma mark - Resize 

/**
 *  Crop the image according to bounds.
 *
 *  @param bounds the rect
 *
 *  @return the cropped image
 */
- (UIImage *)croppedImage:(CGRect)bounds;


- (UIImage *)resizedImage:(CGSize)newSize
     interpolationQuality:(CGInterpolationQuality)quality;

- (UIImage *)resizedImageWithContentMode:(UIViewContentMode)contentMode
                                  bounds:(CGSize)bounds
                    interpolationQuality:(CGInterpolationQuality)quality;

//cornerRadius may be not fast (need to be revised)
// Possibly deprecated.
/*
- (UIImage *)thumbnailImage:(NSInteger)thumbnailSize
          transparentBorder:(NSUInteger)borderSize
               cornerRadius:(NSUInteger)cornerRadius
       interpolationQuality:(CGInterpolationQuality)quality;
*/

#pragma mark - Alpha 

- (BOOL)hasAlpha;
- (UIImage *)imageWithAlpha;
- (UIImage *)transparentBorderImage:(NSUInteger)borderSize;


#pragma mark - Blur 

// Blurs
+ (UIImage *)imageByApplyingGaussianBlur5x5:(UIImage*)image;
+ (UIImage *)imageByApplyingGaussianBlur3x3:(UIImage*)image;
+ (UIImage *)imageByApplyingDiagonalMotionBlur5x5:(UIImage*)image;
+ (UIImage *)imageByApplyingBlurOn:(UIImage*)image size:(int)size sigma:(float)sigma;// 9,90.0

#pragma mark - grayScale

// Grayscale
+ (UIImage*)grayScale:(UIImage*)original;

#pragma mark - Mask

// Masks
+ (UIImage*)maskImage:(UIImage *)image withMask:(UIImage *)maskImage;

@end

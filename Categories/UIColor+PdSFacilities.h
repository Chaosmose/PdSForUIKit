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
//  UIColor+Facilities.h
//  
//
//  Created by Benoit Pereira da Silva on 05/12/2013.
//
//

#import <UIKit/UIKit.h>

#pragma mark UIColorMacros

// UICOLORFromRGB(255.f,255.f,255.f) white
#define UICOLORFromRGB(r,g,b) [UIColor colorWithRed:r/255.0 \
green:g/255.0 \
blue:b/255.0 \
alpha:1.0]

// UICOLORFromRGB(255.f,0.f,0.f,200.f) red with an alpha
#define UICOLORFromRGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 \
green:g/255.0 \
blue:b/255.0 \
alpha:a/255.0]


// UICOLORFromHex(0xFFFFFF)
#define UICOLORFromHex(c) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 \
green:((c>>16)&0xFF)/255.0 \
blue:((c>>8)&0xFF)/255.0 \
alpha:((c)&0xFF)/255.0]

// UICOLORFromHex(0xFFFFFF,200.f)
#define UICOLORFromHexWithAlpha(c,a) [UIColor colorWithRed:((c>>24)&0xFF)/255.0 \
green:((c>>16)&0xFF)/255.0 \
blue:((c>>8)&0xFF)/255.0 \
alpha:a]

@interface UIColor (PdSFacilities)

/**
 *  A lighter color
 *
 *  @return the color
 */
- (UIColor*)lighter;

/**
 *  A darker color
 *
 *  @return the color
 */
- (UIColor*)darker;


// OTHER ADDITIONS  TO  BE CLEANED AN QUALIFIED
// CURRENTLY COPYED AND PASTED FOR ANALYSIS

// Created by Erica Sadun, http://ericasadun.com
// iPhone Developer's Cookbook, 3.0 Edition
// BSD License, Use at your own risk


@property (nonatomic, readonly) CGColorSpaceModel colorSpaceModel;
@property (nonatomic, readonly) BOOL canProvideRGBComponents;

// With the exception of -alpha, these properties will function
// correctly only if this color is an RGB or white color.
// In these cases, canProvideRGBComponents returns YES.
@property (nonatomic, readonly) CGFloat red;
@property (nonatomic, readonly) CGFloat green;
@property (nonatomic, readonly) CGFloat blue;
@property (nonatomic, readonly) CGFloat white;
@property (nonatomic, readonly) CGFloat hue;
@property (nonatomic, readonly) CGFloat saturation;
@property (nonatomic, readonly) CGFloat brightness;
@property (nonatomic, readonly) CGFloat alpha;
@property (nonatomic, readonly) CGFloat luminance;
@property (nonatomic, readonly) UInt32 rgbHex;

- (NSString *)colorSpaceString;
- (NSArray *)arrayFromRGBAComponents;

// Bulk access to RGB and HSB components of the color
// HSB components are converted from the RGB components
- (BOOL)red:(CGFloat *)r green:(CGFloat *)g blue:(CGFloat *)b alpha:(CGFloat *)a;
- (BOOL)hue:(CGFloat *)h saturation:(CGFloat *)s brightness:(CGFloat *)b alpha:(CGFloat *)a;

// Return a grey-scale representation of the color
- (UIColor *)colorByLuminanceMapping;

// Arithmetic operations on the color
- (UIColor *)colorByMultiplyingByRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)       colorByAddingRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *) colorByLighteningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
- (UIColor *)  colorByDarkeningToRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;

- (UIColor *)colorByMultiplyingBy:(CGFloat)f;
- (UIColor *)       colorByAdding:(CGFloat)f;
- (UIColor *) colorByLighteningTo:(CGFloat)f;
- (UIColor *)  colorByDarkeningTo:(CGFloat)f;

- (UIColor *)colorByMultiplyingByColor:(UIColor *)color;
- (UIColor *)       colorByAddingColor:(UIColor *)color;
- (UIColor *) colorByLighteningToColor:(UIColor *)color;
- (UIColor *)  colorByDarkeningToColor:(UIColor *)color;

// Related colors
- (UIColor *)contrastingColor;                        // A good contrasting color: will be either black or white
- (UIColor *)complementaryColor;                // A complementary color that should look good with this color
- (NSArray*)triadicColors;                                // Two colors that should look good with this color
- (NSArray*)analogousColorsWithStepAngle:(CGFloat)stepAngle pairCount:(int)pairs;        // Multiple pairs of colors

// String representations of the color
- (NSString *)stringFromColor;
- (NSString *)hexStringFromColor;

// The named color that matches this one most closely
- (NSString *)closestColorName;
- (NSString *)closestCrayonName;

// Color builders
+ (UIColor *)randomColor;
+ (UIColor *)colorWithString:(NSString *)stringToConvert;
+ (UIColor *)colorWithRGBHex:(UInt32)hex;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorWithName:(NSString *)cssColorName;
+ (UIColor *)crayonWithName:(NSString *)crayonColorName;

// Return a dictionary mapping color names to colors.
// The named are from the css3 color specification.
+ (NSDictionary *)namedColors;

// Return a dictionary mapping color names to colors
// The named are standard Crayola style colors
+ (NSDictionary *)namedCrayons;

// Build a color with the given HSB values
+ (UIColor *)colorWithHue:(CGFloat)hue saturation:(CGFloat)saturation brightness:(CGFloat)brightness alpha:(CGFloat)alpha;

// Low level conversions between RGB and HSL spaces
+ (void)hue:(CGFloat)h saturation:(CGFloat)s brightness:(CGFloat)v toRed:(CGFloat *)r green:(CGFloat *)g blue:(CGFloat *)b;
+ (void)red:(CGFloat)r green:(CGFloat)g blue:(CGFloat)b toHue:(CGFloat *)h saturation:(CGFloat *)s brightness:(CGFloat *)v;



@end

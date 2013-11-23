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
//  NSAttributedString+PDSFacilities.h
//  PDSCategoriesForUIKit
//
//  Created by Benoit Pereira da Silva on 23/11/2013.
//  Copyright (c) 2013 http://pereira-da-silva.com All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (PDSFacilities)

/**
 *  An NSAttributedString factory with the essentials
 *
 *  @param string         the string
 *  @param font           the font
 *  @param textColor      the text color
 *  @param lineSpacing    the spacing between lines
 *  @param textAlignement the text alignement
 *
 *  @return an attributed string
 */
+ (NSAttributedString*)attributedStringFrom:(NSString*)string
                                   withFont:(UIFont*)font
                                  textColor:(UIColor*)textColor
                                lineSpacing:(CGFloat)lineSpacing
                             textAlignement:(NSTextAlignment)textAlignement;

/**
 *  Computes the height according to a constrained width
 *
 *  @param string the string
 *  @param width  the constraint
 *
 *  @return the height
 */
+(CGFloat)heightOfAttributedString:(NSAttributedString*)string constrainedToWidth:(CGFloat)width;

/**
 *  Computes the height according to a constrained height
 *
 *  @param string the string
 *  @param width  the constraint
 *
 *  @return the width
 */
+(CGFloat)widthOfAttributedString:(NSAttributedString*)string constrainedToHeight:(CGFloat)height;


@end

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
//  NSAttributedString+PDSFacilities.m
//  PdSForUIKit
//
//  Created by Benoit Pereira da Silva on 23/11/2013.
//  Copyright (c) 2013 http://pereira-da-silva.com All rights reserved.
//

#import "NSAttributedString+PdSFacilities.h"

@implementation NSAttributedString (PdSFacilities)


    /**
     *  An NSAttributedString factory with the essentials
     *
     *  @param string         the string
     *  @param font           the font
     *  @param textColor      the text color
     *  @param alignment      the alignment
     *  @param lineSpacing    the spacing between lines
     *
     *  @return an attributed string
*/
+ (NSAttributedString*)attributedStringFrom:(NSString*)string
                                   withFont:(UIFont*)font
                                  textColor:(UIColor*)textColor
                                  alignment:(NSTextAligment)alignment
                                lineSpacing:(CGFloat)lineSpacing{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setAlignment:alignment]
    
    NSDictionary *attributes = @{
                            NSParagraphStyleAttributeName:  paragraphStyle,
                            NSForegroundColorAttributeName : textColor,
                            NSFontAttributeName : font,
                            
                            };
    NSAttributedString*attString=[[NSAttributedString alloc] initWithString:string attributes:attributes];
    return attString;
}

/**
 *  Computes the height according to a constrained width
 *
 *  @param width  the constraint
 *
 *  @return the height
 */
-(CGFloat)heightConstrainedToWidth:(CGFloat)width{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       context:nil];
    return rect.size.height;

}

/**
 *  Computes the height according to a constrained height
 *
 *  @param width  the constraint
 *
 *  @return the width
 */
-(CGFloat)widthConstrainedToHeight:(CGFloat)height{
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       context:nil];
    return rect.size.width;
}




@end

//
//  NSAttributedString+PDSFacilities.m
//  PDSCategoriesForUIKit
//
//  Created by Benoit Pereira da Silva on 23/11/2013.
//  Copyright (c) 2013 http://pereira-da-silva.com All rights reserved.
//

#import "NSAttributedString+PDSFacilities.h"

@implementation NSAttributedString (PDSFacilities)

+(CGSize)heightOfAttributedString:(NSAttributedString*)string constrainedToWidth:(CGFloat)width{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       context:nil];
    return rect.size;
}

+(CGSize)widthOfAttributedString:(NSAttributedString*)string constrainedToHeight:(CGFloat)height{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, height)
                                       options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                       context:nil];
    return rect.size;
}

@end

//
//  NSAttributedString+PDSFacilities.h
//  PDSCategoriesForUIKit
//
//  Created by Benoit Pereira da Silva on 23/11/2013.
//  Copyright (c) 2013 http://pereira-da-silva.com All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (PDSFacilities)

+(CGSize)heightOfAttributedString:(NSAttributedString*)string constrainedToWidth:(CGFloat)width;

+(CGSize)widthOfAttributedString:(NSAttributedString*)string constrainedToHeight:(CGFloat)height;


@end

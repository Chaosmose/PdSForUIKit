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
//  Created by Benoit Pereira da Silva on 05/12/2013.
//
//
#import "UIColor+PdSFacilities.h"

@implementation UIColor (PdSFacilities)

/**
 *
 *
 *  @param multiplier if 1.1 the color will be lighter (+10%)
 *
 *  @return the color
 */
- (UIColor*)colorByMultiplyingBrightnessBy:(CGFloat)multiplier{
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a]){
        b=b*multiplier;
        if(b>1.f){
            b=1.f;
        }
        if(b<0.f){
            b=0.f;
        }
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b
                               alpha:a];
    }
    return nil;
}



/**
 *  Uses HSBA  to make a color more or less transparent
 *
 *  @param multiplier if 1.1 the color will be more transparent (+10%)
 *
 *  @return the color
 */
- (UIColor*)colorByMultiplyingAlphaBy:(CGFloat)multiplier{
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a]){
        a=a*multiplier;
        if(a>1.f){
            a=1.f;
        }
        if(a<0.f){
            a=0.f;
        }
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b
                               alpha:a];
    }
    return nil;
}


/**
 *  Uses HSBA  to make a color more or less saturated
 *
 *  @param multiplier if 1.1 the color will be more saturated (+10%)
 *
 *  @return the color
 */
- (UIColor*)colorByMultiplyingSaturationBy:(CGFloat)multiplier{
    CGFloat h, s, b, a;
    if ([self getHue:&h saturation:&s brightness:&b alpha:&a]){
        s=s*multiplier;
        if(s>1.f){
            s=1.f;
        }
        if(s<0.f){
            s=0.f;
        }
        return [UIColor colorWithHue:h
                          saturation:s
                          brightness:b
                               alpha:a];
    }
    return nil;

}


@end

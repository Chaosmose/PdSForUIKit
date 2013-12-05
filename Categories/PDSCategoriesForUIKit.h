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
//  PDSCategoriesForUIKit.h
//  Header
//
//  Created by Benoit Pereira da Silva on 23/11/2013.
//  http://pereira-da-silva.com
//

#ifndef PdSCategoriesForUIKit_h
#define PdSCategoriesForUIKit_h

#import "UIView+RectCorners.h"
#import "NSAttributedString+PdSFacilities.h"

#endif


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
//  PDSCategoriesForUIKit.h
//  Header
//
//  Created by Benoit Pereira da Silva on 23/11/2013.
//  http://pereira-da-silva.com
//

#ifndef PdSCategoriesForUIKit_h
#define PdSCategoriesForUIKit_h

#import "UIView+RectCorners.h"
#import "NSAttributedString+PdSFacilities.h"

#endif

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


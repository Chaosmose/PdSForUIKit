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
//  PdSUITableViewCell.h
//  PdSForUIKit
//
//  Created by Benoit Pereira da Silva on 07/12/2013.
//
//


#import "UIView+RectCorners.h"
/*
 
    You can  use appaerance proxy :
 
    [[PdSUITableViewCell appearance] setRectCorners:UIRectCornerAllCorners];
    [[PdSUITableViewCell appearance] setRadius:10.f];
    //UIEdgeInsetsMake(CGFloat top, CGFloat left, CGFloat bottom, CGFloat right)
    [[PdSUITableViewCell appearance] setPadding:UIEdgeInsetsMake(40.f, 40.f, 10.f,10.f)];
 
 
    Or call directly :
 
 
    [self setRectCorners:UIRectCornerTopLeft|UIRectCornerTopRight
                  radius:7.f
            withPadding:UIEdgeInsetsMake(5.f, 20.f, 0.f, 20.f)];
 
    or 
 
    [cell setRectCorners:UIRectCornerTopLeft|UIRectCornerTopRight
               radius:7.f
                  top:5.f
               bottom:0.f
                 left:20.f
                right:20.f];
 
 
 
 
 */


@interface PdSUITableViewCell : UITableViewCell

@end

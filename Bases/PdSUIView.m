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
//  PdSUIView.m
//  PdSForUIKit
//
//  Created by Benoit Pereira da Silva on 07/12/2013.
//
//

#import "PdSUIView.h"
#import "UIView+RectCorners.h"

@implementation PdSUIView


- (void)layoutSubviews{
    [self remaskIfNecessary];
    [super layoutSubviews];
}


@end

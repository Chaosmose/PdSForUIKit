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
//  NSString+PdSFacilities.h
//  PdSForUIKit
//
//  Created by Benoit Pereira da Silva on 13/01/2014.
//  Copyright (c) 2013 http://pereira-da-silva.com All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSString (PdSFacilities)

/**
 *  Filters a file path (a lot of valid URL absolutePath are not valid paths)
 *  eg : removes prefix and decodes the url encoded characters
 *  @param path the original path
 *  @return a filtered file path
 */
+ (NSString *)filteredFilePathFrom:(NSString*)path;


/**
 *  Applies the filter to self
 *  @return a filtered file path
 */
- (NSString *)filteredFilePath;



@end

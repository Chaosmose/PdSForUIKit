//
//  NSString+PdSFacilities.m
//  
//
//  Created by Benoit Pereira da Silva on 13/01/2014.
//
//

#import "NSString+PdSFacilities.h"

@implementation NSString (PdSFacilities)

/**
 *  Filters the files path
 *  eg : removes : "file:///private"
 *  @param path the original path
 *  @return a filtered file path
 */
+ (NSString*)filteredFilePathFrom:(NSString*)path{
    if(!path)
        return path;
    NSString *filtered=[path copy];
    filtered=[filtered stringByReplacingOccurrencesOfString:@"file:///private" withString:@""];
    filtered=[filtered stringByReplacingOccurrencesOfString:@"%20" withString @""];
    return filtered;
}


@end

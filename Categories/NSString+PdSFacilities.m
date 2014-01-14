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
 *  Filters a file path (a lot of valid URL absolutePath are not valid paths)
 *  eg : removes prefix and decodes the url encoded characters
 *  @param path the original path
 *  @return a filtered file path
 */
+ (NSString*)filteredFilePathFrom:(NSString*)path{
    if(!path)
        return path;
    // Those filtering operations may be necessary sometimes when manipulating IOS FS.
    NSString *filtered=[[path copy] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    filtered=[filtered stringByReplacingOccurrencesOfString:@"file:///private" withString:@""];
    filtered=[filtered stringByReplacingOccurrencesOfString:@"file://" withString:@""];
    return filtered;
}


/**
 *  Applies the filter to self
 *  @return a filtered file path
 */
- (NSString *)filteredFilePath{
    return [NSString filteredFilePathFrom:self];
}

@end

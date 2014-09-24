//
//  UIFont+PdSFacilities.m
//  Pods
//
//  Created by Benoit Pereira da Silva on 24/09/2014.
//
//

#import "UIFont+PdSFacilities.h"

@implementation UIFont (PdSFacilities)

+ (void)listFontName{
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    NSMutableString *s=[NSMutableString string];
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily){
        [s appendFormat:@"Family name: %@\n", [familyNames objectAtIndex:indFamily]];
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont){
            [s appendFormat:@"    Font name: %@\n", [fontNames objectAtIndex:indFont]];
        }
    }
    NSLog(@"%@",s);
}

@end

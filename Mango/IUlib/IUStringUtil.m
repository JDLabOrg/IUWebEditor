//
//  IUStringUtil.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 1..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import "IUStringUtil.h"

@implementation IUStringUtil

+ (NSString *)removeSpecialChar:(NSString *) str{
    NSMutableCharacterSet *characterSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [characterSet addCharactersInString:@"_-/"];
    [characterSet invert];
    
    NSString *output = [[ str componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    
    return output;
    
}
@end

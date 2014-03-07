//
//  MGUtil.m
//  Mango
//
//  Created by JD on 13. 2. 24..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGUtil.h"

@implementation MGUtil


+ (NSDictionary*)itemDict:(NSString*)name type:(NSString*)type{
    NSDictionary *contentDict = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",type,@"type", nil];
    return contentDict;
}


+ (NSDictionary*)itemDict:(NSString*)name type:(NSString*)type children:(NSArray*)children{
    NSDictionary *contentDict = [NSDictionary dictionaryWithObjectsAndKeys:name,@"name",type,@"type", children,@"children", nil];
    return contentDict;
}



+(NSString*)keywordToNSString:(NSInteger)key type:(NSString*)type{
    if ([type isEqualToString:@"IUGitType"]) {
        switch (key) {
            case IUGitTypeOutput: return @"output";
            case IUGitTypeSource: return @"source";
            case IUGitTypeNone: return @"";
            default: return @"";
        }
    }
    assert(0);
    return nil;
}

+(NSInteger)NSStringToKeyword:(NSString*)string{
    return 0;
}

@end

//
//  IUResponsivePage.m
//  WebGenerator
//
//  Created by JD on 11/14/13.
//  Copyright (c) 2013 jdlab.org. All rights reserved.
//

#import "IUResponsivePage.h"
#import "IUResponsiveSection.h"
#import "IUBottomSticker.h"

@implementation IUResponsivePage
-(BOOL)insertIU:(IUObj *)iu atZIndex:(NSInteger)zIndex error:(NSError**)error{
    if ([iu isKindOfClass:[IUBottomSticker class]]) {
        return YES;
    }
    if ([iu isKindOfClass:[IUResponsiveSection class]]) {
        *error = [NSError errorWithDomain:@"IU" code:0 userInfo:@{@"desciption": @"IUResponsivePage only accepts IUResponsiveSection"}];
        return NO;
    }
    return YES;
}
@end

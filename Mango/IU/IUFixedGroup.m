//
//  IUFixedGroup.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 12. 27..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import "IUFixedGroup.h"

@implementation IUFixedGroup

-(void)iuLoad{
    [super iuLoad];
    self.iuFrame.fixed = YES;
    
}

-(NSMutableDictionary *)CSSDictWithScreenType:(IUScreenType)screenType{
    NSMutableDictionary *dict = [super CSSDictWithScreenType:screenType];
    if(screenType == IUScreenTypeDefault){
        if (self.visible == NO) {
            [dict removeObjectForKey:@"visibility" param:nil];
            [dict putString:@"none" forKey:@"display" param:nil];
        }
    }
    return dict;
}

@end

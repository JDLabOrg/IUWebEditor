//
//  IUPresTemplate.m
//  Mango
//
//  Created by JD on 7/11/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import "IUPresTemplate.h"
#import "IUBody.h"
#import "IUCSS.h"

@implementation IUPresTemplate


-(id)instantiate{
    [super instantiate];
    IUBody *body;
    for (IUObj *obj in self.children){
        if ([obj isKindOfClass:[IUBody class]]) {
            body = (IUBody*)obj;
            body.iuFrame.currentScreenFrame.pixelY = 0;
        }
    }
    self.children = [NSMutableArray arrayWithObject:body];
    self.bg.color = nil;
    self.css.BGGradientEnable = YES;
    self.css.BGColor1 = [NSColor colorWithCalibratedRed:11/256.f green:11/256.f blue:11/256.f alpha:1];
    self.css.BGColor2 = [NSColor colorWithCalibratedRed:133/256.f green:133/256.f blue:133/256.f alpha:1];
    return self;
}


+(NSArray*)propertyList{
    return @[];
}

-(void)loadWithDict:(NSDictionary *)dict{
    [super loadWithDict:dict];
    NSDictionary *mydict = [dict objectForKey:@"IUPresTemplate" ];
    [self importPropertyFromDict:mydict ofClass:[IUPresTemplate class]];
}

-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [super dict];
    if (dict) {
        NSMutableDictionary *myDict = [self exportPropertyFromDictOfClass:[IUPresTemplate class]];
        [dict setObject:myDict forKey:@"IUPresTemplate"];
    }
    return dict;
}

@end
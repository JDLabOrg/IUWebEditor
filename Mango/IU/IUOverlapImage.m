//
//  IUOverlapImage.m
//  WebGenerator
//
//  Created by JD on 1/24/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "IUOverlapImage.h"


@implementation IUOverlapImage

-(id)instantiate{
    [super instantiate];
    self.targetOpacity = 1;
    self.transitionEvent = @"MouseOn";
    return self;
}

+(NSMutableArray *)undoPropertyList{
    NSMutableArray *array = [super undoPropertyList];
    [array addObjectsFromArray:@[@"eventImage",
                                @"eventImageStr",
                                @"targetOpacity",
                                 @"transitionEvent"]];
    return array;
}



-(NSString*)innerStyle1{
    return @"style='width:100%; height:100%; position:absolute;'";
}

-(NSString*)innerStyle2{
    return @"style='width:100%; height:100%; position:absolute; opacity:0;'";
}

-(NSString*)srcString:(NSString*)str{
    if ([str length] == 0) {
        return @"";
    }
    else return [NSString stringWithFormat:@"src=\"%@\"", str];
}

-(NSString*)innerHTML2:(id)caller{
    return [NSString stringWithFormat:@"<img class='IUTransationImageInner1' %@ %@ /><img class='IUTransationImageInner2' %@ style='opacity:0' %@ />",
            self.innerStyle1, [self srcString:[self.project toHTMLURL:self.bg.img]], self.innerStyle2, [self srcString:[self.project toHTMLURL:self.eventImageStr]]];
}

-(NSMutableString*)innerOutputHTML2{
    return [NSMutableString stringWithFormat:@"<img class='IUTransationImageInner1' %@ %@ /><img class='IUTransationImageInner2' %@ %@ />",
            self.innerStyle1, [self srcString:[self.project toHTMLURL:self.bg.img]], self.innerStyle2, [self srcString:[self.project toHTMLURL:self.eventImageStr]]];
}

+(NSArray*)propertyList{
    return @[@"eventImageStr", @"targetOpacity", @"transitionEvent"];
}

-(void)setEventImageStr:(NSString *)eventImageStr{
    _eventImageStr = eventImageStr;
    self.eventImage = [self.iuManager.pWC image:eventImageStr];
}

/* Make HTML */
-(BOOL)appendClosingTag{
    return YES;
}
-(NSString*)HTMLTag2{
    return @"div";
}


-(void)loadWithDict:(NSDictionary *)dict{
    [super loadWithDict:dict];
    [self importPropertyFromDict:[dict objectForKey:@"IUTransitoinImage"] ofClass:[IUOverlapImage class]];
}

-(NSMutableDictionary*)HTMLDict2{
    NSMutableDictionary *dict = [super HTMLDict2];
    [dict removeObjectForKey:@"src" param:nil];
    [dict putString:self.transitionEvent forKey:@"transitionEvent" param:nil];
    [dict putFloat:(4-self.targetOpacity)*0.25 forKey:@"targetOpacity" param:nil];
    return dict;
}

-(NSMutableDictionary*)outputDict2{
    NSMutableDictionary *dict = [super outputDict2];
    [dict removeObjectForKey:@"src" param:nil];
    [dict putString:self.transitionEvent forKey:@"transitionEvent" param:nil];
    [dict putFloat:(4-self.targetOpacity)*0.25 forKey:@"targetOpacity" param:nil];
    return dict;
}

-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [super dict];
    [dict setObject:[self exportPropertyFromDictOfClass:[IUOverlapImage class]] forKey:@"IUTransitoinImage"];
    return dict;
}

@end

//
//  IUMailLink.m
//  WebGenerator
//
//  Created by JD on 1/27/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "IUMailLink.h"
#import "IUCSS.h"

@implementation IUMailLink

-(id)instantiate{
    [super instantiate];
    self.subject = @"Hello World";
    self.address = @"iu@jdlab.org";
    
    self.css.BGGradientEnable = YES;
    self.css.BGColor1 = [NSColor orangeColor];
    self.css.BGColor2 = [NSColor redColor];
    
    self.css.borderRadius = @"20";
    self.iuFrame.defaultScreenFrame.pixelHeight = 25;
    

    self.fontColor = [NSColor whiteColor];
    self.sampleText = @"Send Mail";
    
    return self;
}

+(NSArray*)propertyList{
    return [self autoPropertyList];
}

+(NSMutableArray *)undoPropertyList{
    NSMutableArray *array = [super undoPropertyList];
    [array addObjectsFromArray:@[@"address", @"subject"]];
    return array;
}

-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [super dict];
    NSDictionary *myDict = [self exportPropertyFromDictOfClass:[IUMailLink class]];
    [dict setObject:myDict forKey:@"IUMailLink"];
    return dict;
}

-(void)loadWithDict:(NSDictionary *)dict{
    [super loadWithDict:dict];
    NSDictionary *myDict = [dict objectForKey:@"IUMailLink"];
    [self importPropertyFromDict:myDict ofClass:[IUMailLink class]];
}

-(NSString*)preHTML2{
    NSMutableString *retStr = [NSMutableString string];
    if (_address) {
        [retStr appendString:@"<a href=\"mailto:"];
        [retStr appendString:_address];
        if (_subject) {
            [retStr appendFormat:@"?subject="];
            [retStr appendString:_subject];
        }
        [retStr appendString:@"\">"];
    }
    return retStr;
}

-(NSString*)postHTML2{
    return @"</a>";
}
@end
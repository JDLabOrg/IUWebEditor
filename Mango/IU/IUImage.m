//
//  MGImageObj.m
//  Mango
//
//  Created by JD on 13. 2. 1..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUImage.h"

@implementation IUImage

@synthesize variable;

/*init part*/

+(NSArray*)propertyList{
    return [self autoPropertyList];
}

+(NSMutableArray *)undoPropertyList{
    NSMutableArray *array = [super undoPropertyList];
    [array addObjectsFromArray:@[@"variable", @"altText"]];
    return array;
}

-(void)iuLoad{
    [self addObserver:self forKeyPath:@"bg.img" options:0 context:nil];
}
-(void)dealloc{
    [self removeObserver:self forKeyPath:@"bg.img"];
}


/* XXXDidChange */

-(void)bg_imgDidChange{
    [self setNeedsDisplay:IUNeedsDisplayActionHTML];
}


/* Make HTML */
-(BOOL)appendClosingTag{
    return NO;
}
-(NSString*)HTMLTag2{
    return @"img";
}

-(NSMutableDictionary *)CSSDictWithScreenType:(IUScreenType)screenType{
    //img object can't have background img
    NSMutableDictionary *dict = [super CSSDictWithScreenType:screenType];
    [dict removeObjectForKey:@"background-image" param:nil];
    return dict;
}

-(NSMutableDictionary*)HTMLDict2{
    NSMutableDictionary *dict = [super HTMLDict2];
    if ([self.bg.img isHTTPURL]) {
        [dict putString:self.bg.img   forKey:@"src" param:nil];
    }
    else if (self.bg.img){
        [dict putString:[self.project.resDir stringByAppendingPathComponent:self.bg.img ]    forKey:@"src" param:nil];
    }
    if (self.altText) {
        [dict putString:self.altText forKey:@"ALT" param:nil];
    }
    
    return dict;
}

-(NSMutableDictionary*)outputDict2{
    NSMutableDictionary *dict = [super outputDict2];
    if (self.variable) {
        if ([self.rootIU isKindOfClass:[IUComp class]]) {
            NSString *compiledValue = [self.project.compiler statementOfVariableInComp:self.variable];
            [dict putString:compiledValue   forKey:@"src" param:nil];
        }
        else{
            NSString *compiledValue = [self.project.compiler statementOfVariable:self.variable];
            [dict putString:compiledValue   forKey:@"src" param:nil];
        }
    }
    else if (self.bg.img){
        //convert to img src tag from bg img
        if ([self.bg.img isHTTPURL]) {
            [dict putString:self.bg.img   forKey:@"src" param:nil];
        }
        else{
            [dict putString:[self.project.resDir stringByAppendingPathComponent:self.bg.img ]    forKey:@"src" param:nil];
        }
    }
    
    if (self.altText) {
        [dict putString:self.altText forKey:@"ALT" param:nil];
    }
    
    return dict;
}

/* Manage Dict */
-(NSMutableDictionary*)dict{
    NSMutableDictionary *d = [super dict];
    [d setObject:[self exportPropertyFromDictOfClass:[IUImage class]] forKey:@"IUImage"];
    return d;
}

-(void)loadWithDict:(NSDictionary *)dict{
    [super loadWithDict:dict];
    NSDictionary *imageDict = [dict objectForKey:@"IUImage"];
    [self importPropertyFromDict:imageDict ofClass:[IUImage class]];
}

@end
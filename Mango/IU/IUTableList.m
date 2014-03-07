//
//  IUTableListContainer.m
//  Mango
//
//  Created by JD on 13. 3. 16..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUTableList.h"
#import "IULayerOld.h"

@implementation IUTableList

+(NSArray*)propertyList{
    return [self autoPropertyList];
}

+(NSMutableArray *)undoPropertyList{
    NSMutableArray *array = [super undoPropertyList];
    [array addObject:@"representedArray"];
    return array;
}

-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [super dict];
    [dict setObject:[self exportPropertyFromDictOfClass:[IUTableList class]] forKey:NSStringFromClass([IUTableList class])];
    return dict;
}

-(void)loadWithDict:(NSDictionary *)dict{
    [super loadWithDict:dict];
    [self importPropertyFromDict:[dict objectForKey:NSStringFromClass([IUTableList class])] ofClass:[IUTableList class]];
    return;
}

-(NSString*)innerOutputHTML2{
    NSMutableString *str = [NSMutableString string];
    if (self.representedArray) {
        [str appendString:[self.project.compiler statementOfForEachLoopWithArray:self.representedArray]];
        [str appendString:[self.compIU source:IUSourceTypeOutputInclude]];
        [str appendString:[self.project.compiler statementOfEndOfFor]];
    }
    return str;
}

@end
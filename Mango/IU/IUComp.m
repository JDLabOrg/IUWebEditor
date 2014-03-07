//
//  IUComp.m
//  Mango
//
//  Created by JD on 13. 4. 16..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUComp.h"
#import "IUScreenFrame.h"

@implementation IUComp

-(id)instantiate{
    [super instantiate];
    self.iuFrame.defaultScreenFrame.pixelHeight = 400;
    self.iuFrame.defaultScreenFrame.pixelWidth = 400;
    return self;
}

-(void)iuLoad{
    [super iuLoad];
    self.draggable = NO;
}

-(NSMutableDictionary*)sourceReplacementDict:(IUSourceType)type{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    switch (type) {
        case IUSourceTypeEditor:{
            dict[@"__IUEditor__"] = @(YES);
            dict[@"<!-_IUComp_HTML_-!>"] = [self HTMLSource2:self];
        }
            break;
        case IUSourceTypeEditorInclude:{
            return nil;
        }
        case IUSourceTypeOutputInclude:{
            return nil;
        }
        case IUSourceTypeOutput:{
            dict[@"__IUEditor__"] = @(NO);
            dict[@"<!-_IUComp_HTML_-!>"] = [self outputHTMLSource2:self];
            dict[@"_IUPageHeight_"] = @[@{@"width":@"9999", @"height":@([self.iuFrame screenFrame:IUScreenTypeDefault].pixelHeight)}];
        }
        default:
            break;
    }
    
    dict[@"/*<!-_IUComp_CSS_-!>*/"] = [self CSSSourceWithScreenType:IUScreenTypeDefault];
    dict[@"/*<!-_IUComp_CSS_Tablet_-!>*/"] = [self CSSSourceWithScreenType:IUScreenTypeTablet];
    dict[@"/*<!-_IUComp_CSS_Mobile_-!>*/"] = [self CSSSourceWithScreenType:IUScreenTypeMobile];
    dict[@"_IURes_Dir_"] = self.project.resDir;
    
    
    dict[@"_IUProjectInfo_"] = [NSMutableDictionary dictionaryWithObject:self.project.className forKey:@"projectType"];
    
    return dict;
}

-(NSString*)source:(IUSourceType)type{
    switch (type) {
        case IUSourceTypeEditor:{
            NSDictionary *dict = [self sourceReplacementDict:IUSourceTypeEditor];
            NSString *ret = [self.project compSourceWithReplaceDict:dict JSReplaceDict:self.emptyJSDict];
            return ret;
        }
        case IUSourceTypeOutputInclude:{
            NSString *ret = [self outputHTMLSource2:self];
            return ret;
        }
        case IUSourceTypeEditorInclude:{
            NSString *ret = [self HTMLSource2:self];
            return ret;
        }
        case IUSourceTypeOutput:{
            NSString *ret = [self.project compSourceWithReplaceDict:[self sourceReplacementDict:IUSourceTypeOutput] JSReplaceDict:self.emptyJSDict];
            return ret;
        }
        default:
            assert(0);
            break;
    }
    return nil;
}

@end

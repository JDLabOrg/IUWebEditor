//
//  iuTemplate.m
//  Mango
//
//  Created by JD on 13. 2. 9..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUTemplate.h"
#import "IUObjs.h"
#import "IUBG.h"
#import "IUBody.h"

@implementation IUTemplate

-(id)instantiate{
    [super instantiate];
    self.iuFrame.defaultScreenFrame.pixelWidth = 1200;
    self.iuFrame.defaultScreenFrame.pixelHeight = 1300;


    IUHeaderWrapper *headerWrapper = [[IUHeaderWrapper alloc] init];
    [headerWrapper instantiate];
    [self addIU:headerWrapper  error:nil];

    IUBody *body = [[IUBody alloc] init];
    [body instantiate];
    [self addIU:body  error:nil];
    
    body.iuFrame.defaultScreenFrame.pixelY = 70;
    return self;
}


-(NSMutableDictionary*)CSSDictWithScreenType:(IUScreenType)screenType{
    NSMutableDictionary *dict = [super CSSDictWithScreenType:screenType];
    [dict removeObjectForKey:@"width" param:nil];
    [dict removeObjectForKey:@"height" param:nil];
    [dict removeObjectForKey:@"left" param:nil];
    [dict removeObjectForKey:@"top" param:nil];
    [dict removeObjectForKey:@"overflow" param:nil];
    [dict removeObjectForKey:@"z-index" param:nil];
    [dict removeObjectForKey:@"position" param:nil];
    return dict;
}

-(NSString*)HTMLClassString{
    if([self.iuManager.pWC.iuController.selectedObjects containsObject:self]){
        return @"selectedIUObj";
    }
    return nil;
}

-(NSString*)outputHTMLClassString{
    return nil;
}


-(IUBody*)body{
    for (IUObj *iu in self.children) {
        if ([iu isKindOfClass:[IUBody class]]) {
            return (IUBody*)iu;
        }
    }
    
    return nil;
}


-(void)iuLoad{
    [super iuLoad];
    //iuTemplate 는 dict 에 프레임정보를 담지 않으므로 여기서 설정해준다.
    self.draggable = NO;
    self.iuFrame.disableX = YES;
    self.iuFrame.disableY = YES;

}

-(NSString*)HTMLTag2{
    return @"body";
}

-(BOOL)shouldChangeXByUserInput:(CGFloat)x{
    return NO;
}

-(BOOL)shouldChangeYByUserInput:(CGFloat)y{
    return NO;
}


-(NSMutableDictionary*)dict{
    NSMutableDictionary* dict = [super dict];
    if (dict) {
        [dict removeObjectForKey:@"frame"];
    }
    return dict;
}




-(NSString*)source:(IUSourceType)type{
    switch (type) {
        case IUSourceTypeEditor:{
            NSDictionary *dict = [self sourceReplacementDict:IUSourceTypeEditor];
            NSString *ret = [self.project compSourceWithReplaceDict:dict JSReplaceDict:self.emptyJSDict];
            return ret;
        }
        case IUSourceTypeEditorInclude:{
            NSString *ret = [self HTMLSource2:self];
            return ret;
        }
        case IUSourceTypeOutputInclude:{
            NSString *ret = [self outputHTMLSource2:self];
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

-(NSMutableDictionary*)sourceReplacementDict:(IUSourceType)type{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    switch (type) {
        case IUSourceTypeEditor:{
            dict[@"__IUEditor__"] = @(YES);
            dict[@"<!-_IUComp_HTML_-!>"] = [self HTMLSource2:self];
        }
            break;
        case IUSourceTypeEditorInclude:
        case IUSourceTypeOutputInclude:
        {
            return nil;
        }
            break;
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

@end
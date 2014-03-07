//
//  IUPage.m
//  Mango
//
//  Created by JD on 13. 2. 10..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUPage.h"
#import "IUObjs.h"
#import "MGFileItem.h"
#import "IUBG.h"
#import "IUCSS.h"


@implementation IUPage
@synthesize title;
@synthesize templateName;
@synthesize autoResizePageHeight;
@synthesize templateFileItem;

+(NSMutableArray *)undoPropertyList{
    NSMutableArray *array = [super undoPropertyList];
    [array addObjectsFromArray:@[@"templateName",
                                @"AutoResizePageHeight",
                                @"title",
                                @"author",
                                @"pageDesc",
                                 @"keywords"]];
    return array;
    
}


-(id)instantiate{
    [super instantiate];
    self.iuFrame.defaultScreenFrame.pixelX = 0;
    self.iuFrame.defaultScreenFrame.pixelY = 0;
    self.iuFrame.defaultScreenFrame.percentFlagWidth = YES;
    self.iuFrame.defaultScreenFrame.percentWidth = 100;
    //*** It uses percentWidth
    //*** but pixelWidth must be set because initialization needs pixelWidth
    //*** (not yet received from js)
    self.iuFrame.defaultScreenFrame.pixelWidth = 1200;
    self.iuFrame.defaultScreenFrame.pixelHeight = 1300;
    self.iuFrame.disableWidth = YES;
    self.templateName = @"template.tmiu";
    self.autoResizePageHeight = YES;
    self.bg.color = [NSColor whiteColor];
    self.pageDesc = @"";
    self.author = @"";
    self.keywords = @"";
    self.showOverflow = YES;
    return self;
}


+(NSString*)getIconFileName{
    return IUPageIconFileName;
}

-(NSString*)desc{
    return @"IUObj is basic object IU framework.";
}


-(void)dealloc{
    if (self.iuLoaded) {
        [self removeObserver:self forKeyPath:@"templateName" context:@"IUProject"];
    }
}

- (void)iuLoad{
    self.enableShadowLayer = YES;

    //page 의 경우, template IU를 미리 로딩하고 그 다음 본 페이지를 로딩한다.
    [self addObserver:self forKeyPath:@"templateName" options:NSKeyValueObservingOptionInitial context:@"IUProject"];
    [super iuLoad];
    self.iuFrame.disableX = YES;
    self.iuFrame.disableY = YES;
    self.draggable = NO;
    self.css.disableBorder = YES;
    self.css.disableShadow = YES;
    if(self.author==nil) self.author = @"";
    if(self.pageDesc==nil) self.pageDesc = @"";
    if(self.keywords==nil) self.keywords = @"";
}

-(BOOL)shouldChangeXByUserInput:(CGFloat)x{
    return NO;
}

-(BOOL)shouldChangeYByUserInput:(CGFloat)y{
    return NO;
}

-(NSMutableDictionary*)CSSDictWithScreenType:(IUScreenType)screenType{
    NSMutableDictionary *dict = [super CSSDictWithScreenType:screenType];
    [dict putString:@"relative" forKey:@"position" param:nil];
    [dict removeObjectForKey:@"left" param:nil];
    [dict removeObjectForKey:@"top" param:nil];
    [dict putString:@"auto" forKey:@"margin" param:nil];
    return dict;
}


-(void)templateNameDidChange{
    self.templateFileItem = [self.iuManager.project.templateFileItems objectForKey:self.templateName];
    IUManager *templateFileManager = [self.iuManager.pWC iuManagerOfFileItem:self.templateFileItem];
    self.templateIU =  (IUTemplate*)templateFileManager.rootIU;
    [self.templateIU.referenceIUs addObject:self];
    //[self HTMLAttributeContextDidChange];
}



-(NSMutableDictionary*)dict{
    NSMutableDictionary* dict = [super dict];

    NSMutableDictionary *pageDict = [NSMutableDictionary dictionary];
    if (templateName) {
        [pageDict setObject:templateName forKey:@"template"];
    }
    if ([title length]) {
        [pageDict setObject:title forKey:@"title"];
    }
    
    [pageDict setBool:autoResizePageHeight forKey:@"autoResizePageHeight"];
    
    //metadata
    [pageDict setObject:self.author forKey:@"author"];
    [pageDict setObject:self.pageDesc forKey:@"pageDesc"];
    [pageDict setObject:self.keywords forKey:@"keywords"];
    
    [dict setObject:pageDict forKey:@"IUPage"];
    return dict;
}

-(void)loadWithDict:(NSDictionary *)dict{
    [super loadWithDict:dict];
    NSMutableDictionary* myDict = [dict objectForKey:@"IUPage"];
    self.templateName = [myDict objectForKey:@"template" ];
    self.title = [myDict objectForKey:@"title"];
    self.autoResizePageHeight = [[myDict objectForKey:@"autoResizePageHeight"] boolValue];

    //metadata
    self.author = [myDict objectForKey:@"author"];
    self.pageDesc = [myDict objectForKey:@"pageDesc"];
    self.keywords = [myDict objectForKey:@"keywords"];
}

-(NSUInteger)depth{
    return 2;
}


-(NSDictionary *)metaDict{
    NSMutableDictionary* metadict = [[NSMutableDictionary alloc] init];
    [metadict setObject:self.author forKey:@"author"];
    [metadict setObject:self.pageDesc forKey:@"description"];
    [metadict setObject:self.keywords forKey:@"keywords"];
    return metadict;
}




-(NSMutableDictionary*)sourceReplacementDict:(IUSourceType)type{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    //setting css, env, header
    dict[@"/*<!-_IUTemplate_CSS_-!>*/"] = [_templateIU CSSSourceWithScreenType:IUScreenTypeDefault];
    dict[@"/*<!-_IUTemplate_CSS_Tablet_-!>*/"] = [_templateIU CSSSourceWithScreenType:IUScreenTypeTablet];
    dict[@"/*<!-_IUTemplate_CSS_Mobile_-!>*/"] = [_templateIU CSSSourceWithScreenType:IUScreenTypeMobile];
    
    dict[@"/*<!-_IUPage_CSS_-!>*/"] = [self CSSSourceWithScreenType:IUScreenTypeDefault];
    dict[@"/*<!-_IUPage_CSS_Tablet_-!>*/"] = [self CSSSourceWithScreenType:IUScreenTypeTablet];
    dict[@"/*<!-_IUPage_CSS_Mobile_-!>*/"] = [self CSSSourceWithScreenType:IUScreenTypeMobile];
    
    dict[@"_IURes_Dir_"] = self.project.resDir;
    
    if (self.title) {
        dict[@"_IUPAGE_TITLE_"] = self.title;
    }
    else{
        dict[@"_IUPAGE_TITLE_"] = self.project.appName;
    }
    
    dict[@"_IUProjectInfo_"] = [NSMutableDictionary dictionaryWithObject:self.project.className forKey:@"projectType"];
    
    dict[@"_IUPageHeight_"] = @[@{@"width":@"9999", @"height":@([self.iuFrame screenFrame:IUScreenTypeDefault].pixelHeight)}];
    
    //make body
    switch (type) {
        case IUSourceTypeEditor:{
            dict[@"__IUEditor__"] = @"true";
            dict[@"<!-_IUTemplate_HTML_-!>"] = [_templateIU source:IUSourceTypeEditorInclude];
            dict[@"<!-_IUPage_HTML_-!>"] = [self HTMLSource2:self];
            break;
        }
        case IUSourceTypeEditorInclude:
        case IUSourceTypeOutputInclude:
        {
            assert(0);
        }
        case IUSourceTypeOutput:{
            dict[@"__IUEditor__"] = @"false";
            dict[@"<!-_IUTemplate_HTML_-!>"] = [_templateIU source:IUSourceTypeOutputInclude];
            dict[@"<!-_IUPage_HTML_-!>"] = [self outputHTMLSource2:self];
            break;
        }
        default:
            assert(0);
            break;
    }
    return dict;
}

-(NSString*)source:(IUSourceType)type{
    switch (type) {
        case IUSourceTypeEditor:{
            NSString *src = [self.project pageSourceWithReplaceDict:[self sourceReplacementDict:IUSourceTypeEditor] JSReplaceDict:self.emptyJSDict];
            return src;
        }
        case IUSourceTypeOutputInclude:
        case IUSourceTypeEditorInclude:
        {
            assert(0);
        }
        case IUSourceTypeOutput:{
            [self buildJS];
            NSMutableDictionary *replacementDict = [self sourceReplacementDict:IUSourceTypeOutput];
            if (self.JSReplaceDict) {
                NSString *v =  [self.project pageSourceWithReplaceDict:replacementDict JSReplaceDict:self.JSReplaceDict];
                return v;
            }
            else{
                NSString *v =  [self.project pageSourceWithReplaceDict:replacementDict JSReplaceDict:self.emptyJSDict];
                return v;
            }
        }
        default:
            break;
    }
}

@end
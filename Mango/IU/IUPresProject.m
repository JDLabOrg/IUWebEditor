//
//  IUPresProject.m
//  Mango
//
//  Created by JD on 13. 8. 25..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUPresProject.h"
#import "IUNote.h"
#import "IUPresTemplate.h"

@implementation IUPresProject

+(NSString*)desc{
    return @"Keynote Project";
}

+(NSString*)displayName{
    return @"Presentation";
}

+(NSImage*)icon{
    return [NSImage imageNamed:@"presentation"];
}

+(IUPage *)defaultPageIU{
    IUNote *page = [[[IUNote alloc] init] instantiate];
    return page;
}

+(IUTemplate*)defaultTemplateIU{
    IUPresTemplate *template = [[[IUPresTemplate alloc] init] instantiate];
    return template;
}


+(NSArray*)pageWidgets{
    IUWidget *widget = [IUNote widget];
    return @[widget];
}

-(BOOL)initFile:(IUWidget *)widget{
    IUPage *page;
    IUComp *comp;
    IUTemplate *template;
    
    MGFileItem *pageFileItem = [MGFileItem fileItemWithName:@"1.pgiu" type:MGFileItemTypePGIU];
    [self.rootFileItem.pageFileDirItem addFileItem:pageFileItem];
    page = [self.class defaultPageIU];
    [page saveAsFileWithPath:pageFileItem.absolutePath];
    
    MGFileItem *compFileItem = [MGFileItem fileItemWithName:@"comp.coiu" type:MGFileItemTypeCOIU];
    compFileItem.defaultFile = YES;
    [self.rootFileItem.compFileDirItem addFileItem:compFileItem];
    comp = [self.class defaultCompIU];
    [comp saveAsFileWithPath:compFileItem.absolutePath];
    
    MGFileItem *templateFileItem = [MGFileItem fileItemWithName:@"template.tmiu" type:MGFileItemTypeTMIU];
    templateFileItem.defaultFile = YES;
    [self.rootFileItem.templateFileDirItem addFileItem:templateFileItem];
    if ([widget.param objectForKey:@"template.tmiu"]) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:[widget.param objectForKey:@"template.tmiu"] options:0 error:nil];
        [[NSFileManager defaultManager] createFileAtPath:templateFileItem.absolutePath contents:data attributes:nil];
    }
    else {
        template = [self.class defaultTemplateIU];
        [template saveAsFileWithPath:templateFileItem.absolutePath];
    }
    
    if ([self copyResourceToResDir]){
        return NO;
    }
    return YES;
}

-(IUCompileResult*)buildProject{
    IUCompileResult *result = [super buildProject];
    if ([[NSFileManager defaultManager] fileExistsAtPath:result.indexFilePath] == NO){
        NSString  *emptyIndex = [[NSBundle mainBundle] pathForResource:@"emptyIndex" ofType:@"html"];
        NSMutableString *emptyIndexSource = [NSMutableString stringWithContentsOfFile:emptyIndex encoding:NSUTF8StringEncoding error:nil];
        
        NSArray *pageFiles = [self.rootFileItem subFileItemsWithExtension:@"pgiu"];
        NSArray *pageIUManagers = [self.pWC iuManagerOfFileItems:pageFiles];
        IUManager *firstManager = [pageIUManagers objectAtIndex:0];
        NSString *firstFileName = [[firstManager.filePath lastPathComponent] stringByChangeExtension:@"html"];
        
        [emptyIndexSource replaceOccurrencesOfString:@"__REDIRECT_PAGE__" withString:firstFileName options:0 range:NSMakeRange(0, emptyIndexSource.length)];
        
        NSData *data = [emptyIndexSource dataUsingEncoding:NSUTF8StringEncoding];
        [data writeToFile:result.indexFilePath atomically:YES];
    }
    return result;
}

@end

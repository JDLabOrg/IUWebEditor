//
//  IUProject.m
//  Mango
//
//  Created by JD on 13. 5. 10..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUProject.h"
#import "IUNote.h"
#import "IUPresTemplate.h"
#import "MGNewProjectVC.h"
#import "IUWidget.h"

@implementation IUCompileResult
-(id)init{
    self = [super init];
    _compiledFilePaths = [NSMutableDictionary dictionary];
    return self;
}
@end

@implementation IUProject

/* following codes define project class */
+(NSString*)desc{
    return @"Default IU Project";
}

+(NSString*)displayName{
    return @"IUProject";
}

+(NSImage*)icon{
    return [NSImage imageNamed:@"IUML"];
}


/* following codes define project class */

+(IUTemplate*)defaultTemplateIU{
    IUTemplate *template = [[[IUTemplate alloc] init] instantiate];
    return template;
}
+(IUPage *)defaultPageIU{
    IUPage *page = [[[IUPage alloc] init] instantiate];
    return page;
}
+(IUComp *)defaultCompIU{
    IUComp *comp = [[[IUComp alloc] init] instantiate];
    return comp;
}

+(NSArray*)templateWidgets{
    return @[[IUTemplate widget]];
}

+(NSArray*)pageWidgets{
    IUWidget *widget = [IUPage widget];
    IUWidget *responsiveWidget = [IUPage widget];
    responsiveWidget.name = @"Responsive Page";
    responsiveWidget.param = @{@"name": @"WOW"};
    return @[widget, responsiveWidget];
}

+(NSArray*)compWidgets{
    return @[[IUComp widget]];
}



-(MGNewProjectVC*)initializeVC{
    MGNewProjectVC *ret = [[MGNewProjectVC alloc] initWithNibName:@"MGNewProjectVC" bundle:nil];
    ret.project = self;
    return ret;
}

-(void)clearProject{
    NSFileManager* fm = [[NSFileManager alloc] init];
    NSURL *directoryToScan = [NSURL fileURLWithPath:self.absoluteOutputDir];
    NSDirectoryEnumerator *en = [fm enumeratorAtURL:directoryToScan
                                                  includingPropertiesForKeys:0
                                                                     options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                errorHandler:nil];

    NSError* err = nil;
    BOOL res;
    
    NSURL* file;
    while (file = [en nextObject]) {
        res = [fm removeItemAtURL:file error:&err];
        if (!res && err) {
            NSLog(@"oops: %@", err);
        }
    }
}


+(id)project{
    id project = [[[self class] alloc] init];
    return project;
}


-(NSString*)absoluteOutputDir{
    return [fileDir stringByAppendingPathComponent:_outputDir];
}

-(NSString*)absoluteIUMLDir{
    return [fileDir stringByAppendingPathComponent:_IUMLDir];
}

-(NSString*)absoluteGitDir{
    if ([_git isEqualToString:@"output"]) {
        return self.absoluteOutputDir;
    }
    else if ([_git isEqualToString:@"source"]){
        return fileDir;
    }
    return nil;
}


-(NSString*)absoluteObjectDir{
    return [fileDir stringByAppendingPathComponent:self.objectDir];
}

-(void)loadFileItem:(MGFileItem*)item{
    if (item.isDirectory) {
        for (MGFileItem *child in item.children) {
            [self loadFileItem:child];
        }
    }
    else{
        if ([[item.name pathExtension] isEqualToString:@"pgiu"]) {
            [self.pageFileItems setObject:item forKey:item.name];
        }
        else if ([[item.name pathExtension] isEqualToString:@"tmiu"]){
            [self.templateFileItems setObject:item forKey:item.name];
        }
        else if ([[item.name pathExtension] isEqualToString:@"coiu"]){
            [self.compFileItems setObject:item forKey:item.name];
        }
    }
}

-(NSMutableString*)bundleHtmlSource{
    NSError *err;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"html" ofType:@"html"];
    NSMutableString *html = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    NSAssert(err == nil, @"err");
    return html;
}

-(NSMutableString*)bundleCompSource{
    NSError *err;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"comp" ofType:@"html"];
    NSMutableString *html = [NSMutableString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&err];
    NSAssert(err == nil, @"err");
    return html;
}


-(NSString*)pageSourceWithReplaceDict:(NSDictionary*)replaceDict
                  JSReplaceDict:(NSDictionary*)JSReplaceDict
{
    NSMutableString *html = [self bundleHtmlSource];
    
    for (NSString *key in replaceDict) {
        id obj = [replaceDict objectForKey:key];
        if ([obj isKindOfClass:[NSString class]]) {
            [html replaceOccurrencesOfString:key withString:[replaceDict objectForKey:key] options:0 range:NSMakeRange(0, html.length)];
        }
        else if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]){
            NSError *err;
            NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&err];
            NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [html replaceOccurrencesOfString:key withString:aStr options:0 range:NSMakeRange(0, html.length)];
        }
        else if ([obj isKindOfClass:[NSNumber class]]){
            [html replaceOccurrencesOfString:key withString:[NSString stringWithFormat:@"%d", [obj intValue]] options:0 range:NSMakeRange(0, html.length)];
        }
        else{
            assert(0);
        }
    }
    
    if (JSReplaceDict) {
        for (NSString *key in JSReplaceDict) {
            id obj = [JSReplaceDict objectForKey:key];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSError *err;
                NSData *serializedData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:&err];
                if (err) {
                    [JDLogUtil log:@"JS Compile Error" err:err];
                    return nil;
                }
                NSString *serializeString = [[NSString alloc] initWithData:serializedData encoding:NSUTF8StringEncoding];
                [html replaceOccurrencesOfString:key withString:serializeString options:0 range:NSMakeRange(0, [html length])];
          }
            else{
                assert(0); // not coded
            }
        }
    }
    return [html copy];
}

-(NSString*)compSourceWithReplaceDict:(NSDictionary*)replaceDict
                        JSReplaceDict:(NSDictionary*)JSReplaceDict{
    NSMutableString *html = [self bundleCompSource];
    
    for (NSString *key in replaceDict) {
        id obj = [replaceDict objectForKey:key];
        if ([obj isKindOfClass:[NSString class]]) {
            [html replaceOccurrencesOfString:key withString:[replaceDict objectForKey:key] options:0 range:NSMakeRange(0, html.length)];
        }
        else if ([obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSArray class]]){
            NSError *err;
            NSData *data = [NSJSONSerialization dataWithJSONObject:obj options:NSJSONWritingPrettyPrinted error:&err];
            NSString* aStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            [html replaceOccurrencesOfString:key withString:aStr options:0 range:NSMakeRange(0, html.length)];
        }
        else if ([obj isKindOfClass:[NSNumber class]]){
            [html replaceOccurrencesOfString:key withString:[NSString stringWithFormat:@"%d", [obj intValue]] options:0 range:NSMakeRange(0, html.length)];
        }
        else{
            assert(0);
        }
    }
    
    if (JSReplaceDict) {
        for (NSString *key in JSReplaceDict) {
            id obj = [JSReplaceDict objectForKey:key];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSError *err;
                NSData *serializedData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:&err];
                if (err) {
                    [JDLogUtil log:@"JS Compile Error" err:err];
                    return nil;
                }
                NSString *serializeString = [[NSString alloc] initWithData:serializedData encoding:NSUTF8StringEncoding];
                [html replaceOccurrencesOfString:key withString:serializeString options:0 range:NSMakeRange(0, [html length])];
            }
            else{
                assert(0); // not coded
            }
        }
    }
    return [html copy];
}


-(void)startWithDir:(NSString*)dir widget:(IUWidget *)widget{
    if (self.appName == nil) {
        [NSException raise:@"appName" format:@"no app name"];
        return;
    }
    NSString *newfileName = [NSString stringWithFormat:@"%@/%@.iuproject", _appName, _appName];
    
    //set filedir and filename
    [self setFilePath:[dir stringByAppendingPathComponent:newfileName]];

    //set root file item
    self.rootFileItem = [MGRootFileItem fileItemWithName:_appName type:MGFileItemTypeProject project:self];
    
    [self initDir:widget];
    [self initFile:widget];
    [self initEnv:widget];
    [self save];
}


-(void)setFilePath:(NSString *)filePath{
    fileName = [filePath lastPathComponent];
    fileDir = [filePath stringByDeletingLastPathComponent];
}

-(NSString*)filePath{
    return [fileDir stringByAppendingPathComponent:fileName];
}

-(NSString*)fileDir{
    return fileDir;
}

-(NSURL*)fileURL{
    return [NSURL fileURLWithPath:fileDir];
}

-(id)init{
    self = [super init];
    if (self) {
        self.gitUtil = [[JDGitUtil alloc] initWithProject:self];
        self.herokuUtil = [[JDHerokuUtil alloc] initWithProject:self];
        self.projectType = NSStringFromClass([self class]);
        self.defaultWidth = 1200;
        compiler = [self compiler];
    }
    return self;
}

-(void)loadWithContentOfFile:(NSString*)filePath{
    self.filePath = filePath;
    
    self.pageFileItems       = [[JDMutableArrayDict alloc] init];
    self.templateFileItems   = [[JDMutableArrayDict alloc] init];
    self.compFileItems   = [[JDMutableArrayDict alloc] init];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSError *err;
    NSMutableDictionary *contentDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        [JDLogUtil log:@"load project" err:err];
        assert(0);
    }
    
    // For subclasses, it should override loadwithdict only.
    [self loadWithDict:contentDict];
    self.rootFileItem = [[MGRootFileItem alloc] initWithContents:[contentDict objectForKey:@"files"] fromProject:self];
    [self loadFileItem:_rootFileItem];
}

-(id)initWithContentOfFile:(NSString*)filePath{
    self = [self init];
    if (self) {
        [self loadWithContentOfFile:filePath];
    }
    return self;
}


+(NSArray*)propertyList{
    return @[ @"cloud",@"IUMLDir",@"outputDir",@"resDir",@"imageURL",@"appName",@"projectType",@"objectDir",@"git", @"disableTabletType", @"disableMobileType"];
}

//can be overriding
-(void)loadWithDict:(NSDictionary *)dict{
    [self importPropertyFromDict:dict ofClass:[IUProject class]];
    self.gitUtil = [[JDGitUtil alloc] initWithProject:self];
}

-(NSDictionary*)dict{
    NSMutableDictionary *dict = [self exportPropertyFromDictOfClass:[IUProject class]];
    [dict setObject:self.rootFileItem.contents forKey:@"files"];
    return dict;
}

-(void)save{
    NSLog(@"----Saving-----");
    NSDictionary *dict = [self dict];
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&err];
    if (err) {
        [err description]; return;
    }
    [data writeToFile:[self filePath] atomically:YES];
}



-(void)initDir:(IUWidget *)widget{
    [JDFileUtil mkdirPath:fileDir atDirecory:nil];
    
    //create IU Dir
    [self.rootFileItem createSubDirectoryAndFileItems];
    
    //create output and object Dir
    [JDFileUtil mkdirPath:self.absoluteObjectDir atDirecory:nil];
    [JDFileUtil mkdirPath:self.absoluteResDirPath atDirecory:nil];
    [JDFileUtil mkdirPath:self.absoluteObjectDir atDirecory:nil];
}

-(void)initFile:(IUWidget *)widget{
    IUPage *page;
    IUComp *comp;
    IUTemplate *template;
    
    MGFileItem *pageFileItem = [MGFileItem fileItemWithName:@"index.pgiu" type:MGFileItemTypePGIU];
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

    
    [self copyResourceToResDir];
}

-(void)copyResourceToResDir{
    
    NSError *err;

    
    NSArray *resArray = @[@"sampleImage.jpg",
                          @"Logo_120_70.png",
                          @"rightarrow.png",
                          @"leftarrow.png",
                          @"london.jpg",
                          @"winter.jpg",
                          /*
                          @"seoul.jpg",
                          @"kyeongboknight.jpg",
                          @"sanfranciscobaseball.jpg",
                          @"San_Francisco.jpg",
                          @"San_Francisco_Oakland_Bay_Bridge_at_night.jpg",
                          @"Eiffeltower.jpg",
                          @"newyorknight.jpg",
                          @"londoneye.jpg",
                          @"spring.png",
                          @"summer.jpg",
                          @"winter2.jpg",
                         */
                          
                          @"reset.css",
                          @"iu.css",
                          @"iuframe.js",
                          @"iucarousel.js",
                          @"iulib.js"
                          ];
    
    
    NSString *srcPath;
    NSString *destPath;
    
    for(NSString *resName in resArray){
        NSString *res = [resName stringByDeletingPathExtension];
        NSString *resExtension = [resName pathExtension];

        srcPath = [[NSBundle mainBundle] pathForResource:res ofType:resExtension];
        destPath = [self.absoluteResDirPath stringByAppendingPathComponent:resName];
        
        [[NSFileManager defaultManager] removeItemAtPath:destPath error:nil];
        [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:destPath error:&err];
        if (err) {
            [NSException raise:@"Initialize Resource Image File" format:err.description, nil];
        }
    }
}


-(void)initEnv:(IUWidget *)widget{
    /* git init */
    if ([_git isEqualToString:@"output"] || [_git isEqualToString:@"source"]) {
//        self.gitUtil = [[JDGitUtil alloc] initWithProject:self];
        [_gitUtil gitInit];
        [_gitUtil addAll];
        [_gitUtil commit:@"initial commit"];
    }
    if ([self.cloud isEqualToString:@"heroku"]) {
        [self.herokuUtil combineGit];
    }
}

-(NSString*) absoluteResDirPath{
    NSString *path =  [fileDir stringByAppendingPathComponent:_resDir];
    return path;
}

-(NSString*) absoluteHTMLDirPath{
    return [self fileDir];
}


-(void)fileItem:(MGFileItem*)fileItem changeName:(NSString*)changeName{
    NSString *newPath = [[fileItem.absolutePath stringByDeletingLastPathComponent] stringByAppendingPathComponent:changeName];
    NSError *err;
    [[NSFileManager defaultManager] moveItemAtPath:[fileItem absolutePath] toPath:newPath error:&err];
    fileItem.name = changeName;
}

-(IUCompileResult*)buildProject{
    /* save all page file to output dir */
    NSArray *pageFiles = [self.rootFileItem subFileItemsWithExtension:@"pgiu"];
    NSArray *pageIUs = [self.pWC iuManagerOfFileItems:pageFiles];
    
    for (IUManager *manager in pageIUs) {
        //output dir 에 full web source 를 저장. 끝.
        MGFileItem* fileItem = manager.rootIU.fileItem;
        NSString *outputFileName = [[self.absoluteOutputDir stringByAppendingPathComponent:fileItem.name] stringByChangeExtension:@"html"];
        NSData *data = [[manager.rootIU source:IUSourceTypeOutput] dataUsingEncoding:NSUTF8StringEncoding];
        [data writeToFile:outputFileName atomically:YES];
    }
    
    IUCompileResult *result = [[IUCompileResult alloc] init];
    result.result = YES;
    result.log  = @"";
    result.outputDirPath = self.absoluteOutputDir;
    result.indexFilePath = [self.absoluteOutputDir stringByAppendingPathComponent:@"index.html"];
    return result;
}

-(IUCompiler*)compiler{
    return [[IUCompiler alloc] init];
}

-(NSURL*)serverURL{
    if ([self.cloud isEqualToString:@"heroku"]) {
        NSString *urlStr = [NSString stringWithFormat:@"http://%@.herokuapp.com", self.appName];
        return [NSURL URLWithString:urlStr];
    }
    return nil;
}

+(IUWidget*)widget{
    IUWidget *widget = [[IUWidget alloc] init];
    widget.name = self.displayName;
    widget.image = self.icon;
    widget.desc = NSLocalizedString(self.className, @"");
    widget.value = self.className;
    widget.param = nil;
    return widget;
}

-(NSString*)toHTMLURL:(NSString*)source{
    if (source == nil) {
        return nil;
    }
    if ([source isHTTPURL]) {
        return source;
    }
    else{
        return [self.resDir stringByAppendingPathComponent:source];
    }
}

-(BOOL)programmable{
    return NO;
}

@end


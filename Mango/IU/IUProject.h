//
//  IUProject.h
//  Mango
//
//  Created by JD on 13. 5. 10..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>
#import "MGFileItem.h"
#import "IUProperty.h"
#import "IUCompiler.h"
#import "IUDefinition.h"

@class  MGNewProjectVC;

@interface IUCompileResult : NSObject{
    
}
@property   BOOL    result;
@property   NSString    *log;
@property   NSString    *outputDirPath;
@property   NSString    *indexFilePath;
@property   NSMutableDictionary    *compiledFilePaths;
@end

@class  MGProjectWC;
@class  MGRootFileItem;
@class  IUFile;
@class IUPage;
@class IUComp;
@class IUTemplate;

@interface IUProject : IUProperty{
    NSString        *fileName;
    NSString        *fileDir;
    IUCompiler      *compiler;
}

@property MGRootFileItem         *rootFileItem;
@property JDMutableArrayDict     *pageFileItems;
@property JDMutableArrayDict     *templateFileItems;
@property JDMutableArrayDict     *compFileItems;

@property   NSString        *cloud;
@property   NSString        *git;
@property   NSString        *IUMLDir;
@property   NSString        *outputDir;
@property   NSString        *objectDir;
@property   NSString        *resDir;
@property   NSString        *imageURL;
@property   NSString        *appName;
@property   NSString        *projectType;
@property   JDGitUtil       *gitUtil;
@property   JDHerokuUtil    *herokuUtil;
@property   MGProjectWC     *pWC;
@property   NSInteger       defaultWidth;

@property   BOOL disableTabletType, disableMobileType;

-(NSURL*)serverURL;

+(NSString*)desc;
+(NSString*)displayName;
+(NSImage*)icon;

+(NSArray*)templateWidgets;
+(NSArray*)pageWidgets;
+(NSArray*)compWidgets;

+(IUTemplate*)defaultTemplateIU;
+(IUPage *)defaultPageIU;
+(IUComp *)defaultCompIU;

-(MGNewProjectVC*)initializeVC;
+(id)project;

-(BOOL)startWithDir:(NSString*)dir widget:(IUWidget*)widget;


-(id)initWithContentOfFile:(NSString*)filePath;
-(void)setFilePath:(NSString*)tFilePath;

-(BOOL)initDir:(IUWidget*)widget;
-(BOOL)initFile:(IUWidget*)widget;
-(BOOL)initEnv:(IUWidget*)widget;
-(void)removeProjectDir;

-(void)save;
-(NSString*)filePath;
-(NSString*)fileDir;
-(NSURL*)fileURL;
-(NSString*)absoluteResDirPath;
-(NSString*)absoluteGitDir;
-(NSString*)absoluteIUMLDir;
-(NSString*)absoluteOutputDir;
-(NSString*)absoluteHTMLDirPath;
-(NSString*)absoluteObjectDir;


-(void)fileItem:(MGFileItem*)fileItem changeName:(NSString*)changeName;

/*-(NSString*)compCompileSourceWithHTML:(NSString*)HTML
                                  CSS:(NSString*)CSS
                        JSReplaceDict:(NSDictionary*)JSReplaceDict;*/

-(NSString*)compSourceWithReplaceDict:(NSDictionary*)replaceDict
                        JSReplaceDict:(NSDictionary*)JSReplaceDict;


-(NSString*)pageSourceWithReplaceDict:(NSDictionary*)replaceDict
                  JSReplaceDict:(NSDictionary*)JSReplaceDict;


/* compile project */
-(NSMutableString*)bundleHtmlSource;
-(void)clearProject;
-(IUCompileResult*)buildProject;
-(IUCompiler*)compiler;

-(void)loadWithContentOfFile:(NSString*)filePath;

+(IUWidget*)widget;

-(NSString*)toHTMLURL:(NSString*)source;

-(BOOL)programmable;
-(BOOL)copyResourceToResDir;
@end

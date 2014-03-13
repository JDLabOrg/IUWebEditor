//
//  IUDjangoProject.m
//  Mango
//
//  Created by JD on 13. 8. 25..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUDjangoProject.h"
#import "MGNewDjangoProjectVC.h"
#import "IUDjangoCompiler.h"

@implementation IUDjangoProject

+(NSString*)desc{
    return @"Default Django Project Template";
}

+(NSString*)displayName{
    return @"Django";
}

+(NSImage*)icon{
    return [NSImage imageNamed:@"python"];
}

-(BOOL)programmable{
    return YES;
}

-(MGNewProjectVC*)initializeVC{
    MGNewDjangoProjectVC *dVC = [[MGNewDjangoProjectVC alloc] initWithNibName:@"MGNewDjangoProjectVC" bundle:nil];
    dVC.project = self;
    return dVC;
}

-(BOOL)startWithDir:(NSString*)dir widget:(IUWidget *)widget{
    if (self.appName == nil) {
        return NO;
    }
    
    if (self.appName == nil) {
        return NO;
    }

    NSString *newfileName = [NSString stringWithFormat:@"%@.iuproject", self.appName];
    [self setFilePath:[dir stringByAppendingPathComponent:newfileName]];
    //set root file item
    self.rootFileItem = [MGRootFileItem fileItemWithName:self.appName type:MGFileItemTypeProject project:self];

    GotoErrorIfNot([self initDir:widget]);
    GotoErrorIfNot([self initFile:widget]);
    GotoErrorIfNot([self initEnv:widget]);
    GotoErrorIfNot([self initDir:widget]);

    [self save];
    return YES;
    
Error:
    [self removeProjectDir];
    return NO;
}

-(IUCompiler*)compiler{
    return [[IUDjangoCompiler alloc] init];
}

-(BOOL)initDir:(IUWidget *)widget{
    ReturnNoIfNot([JDFileUtil mkdirPath:fileDir]);
    
    //create IU Dir
    ReturnNoIfNot([self.rootFileItem createSubDirectoryAndFileItems]);
    
    //create output and object Dir
    ReturnNoIfNot([JDFileUtil mkdirPath:self.absoluteObjectDir]);
    ReturnNoIfNot([JDFileUtil mkdirPath:self.absoluteResDirPath]);
    ReturnNoIfNot([JDFileUtil mkdirPath:self.absoluteOutputDir ]);
    ReturnNoIfNot([JDFileUtil mkdirPath:[self.absoluteOutputDir stringByAppendingPathComponent:@"res"]]);
    return YES;
}




-(id)init{
    self = [super init];
    if (self) {
        self.outputDir = @"site";
        self.resDir = @"res";
        self.IUMLDir = @"IUML";
        self.objectDir = @"object";
    }
    return self;
}

-(NSString*)objectDir{
    return [self.outputDir stringByAppendingPathComponent:@"object"];
}

-(BOOL)copyResourceToResDir{
    ReturnNoIfNot([JDFileUtil mkdirPath:[self.absoluteOutputDir stringByAppendingPathComponent:@"res"]]);

    NSError *err;
    NSArray *resArray = @[//Image files
                          
                          @"sampleImage.jpg",
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
                          
                          //css files
                          @"reset.css",
                          @"iu.css",
                          //javascript files
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
            return NO;
        }
        
        destPath = [[self.absoluteOutputDir stringByAppendingPathComponent:@"res"] stringByAppendingPathComponent:resName];
        [[NSFileManager defaultManager] removeItemAtPath:destPath error:nil];
        [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:destPath error:&err];
        if (err) {
            return NO;
        }

    }
    return YES;
}


-(IUCompileResult*)buildProject{
    
    [self clearProject];
    IUCompileResult *result = [[IUCompileResult alloc] init];
    result.log  = @"";
    result.outputDirPath = self.absoluteOutputDir;
    result.indexFilePath = [self.absoluteOutputDir stringByAppendingPathComponent:@"index.html"];

    /* save all page file to output dir */
    [[NSFileManager defaultManager] createDirectoryAtPath:self.absoluteOutputDir withIntermediateDirectories:YES attributes:nil error:nil];
    [[NSFileManager defaultManager] createDirectoryAtPath:self.absoluteObjectDir withIntermediateDirectories:YES attributes:nil error:nil];
    
    NSArray *pageFiles = [self.rootFileItem subFileItemsWithExtension:@"pgiu"];
    NSArray *compFiles = [self.rootFileItem subFileItemsWithExtension:@"coiu"];

    NSArray *pageIUs = [self.pWC iuManagerOfFileItems:pageFiles];
    NSArray *compIUs = [self.pWC iuManagerOfFileItems:compFiles];
    
    for (IUManager *manager in pageIUs) {
        //output dir 에 full web source 를 저장.
        MGFileItem* fileItem = manager.rootIU.fileItem;
        NSString *outputFileName = [[self.absoluteOutputDir stringByAppendingPathComponent:fileItem.name] stringByChangeExtension:@"html"];
        NSData *data = [[manager.rootIU source:IUSourceTypeOutput] dataUsingEncoding:NSUTF8StringEncoding];
        [data writeToFile:outputFileName atomically:YES];
        [result.compiledFilePaths setObject:outputFileName forKey:fileItem.name];
    }
    
    for (IUManager *manager in compIUs) {
        //output dir 에 full web source 를 저장.
        MGFileItem* fileItem = manager.rootIU.fileItem;
        NSString *modifiedFileItemName = [manager.rootIU.fileItem.name stringByChangeExtension:@"o.html"];
        NSString *outputFileName = [self.absoluteObjectDir stringByAppendingPathComponent:modifiedFileItemName];
        NSData *data = [[manager.rootIU source:IUSourceTypeOutput] dataUsingEncoding:NSUTF8StringEncoding];
        [data writeToFile:outputFileName atomically:YES];
        [result.compiledFilePaths setObject:outputFileName forKey:fileItem.name];
    }

    result.result = YES;
    [self copyResourceToResDir];
    
    return result;
}


@end

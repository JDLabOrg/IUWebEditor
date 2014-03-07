//
//  IURackProject.m
//  Mango
//
//  Created by JD on 13. 8. 25..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IURackProject.h"
#import "MGNewRackProjectVC.h"

@implementation IURackProject

+(NSString*)desc{
    return @"Default Project. This project uses Ruby-Rack interface to support Heroku.";
}

+(NSString*)displayName{
    return @"Default";
}

+(NSImage*)icon{
    return [NSImage imageNamed:@"ruby"];
}



-(id)init{
    self = [super init];
    if (self) {
        self.outputDir = @"site/";
        self.resDir = @"res/";
        self.IUMLDir = @"IUML/";
        self.objectDir = @"object/";
    }
    return self;
}

-(id)initializeVC{
    MGNewRackProjectVC *vc = [[MGNewRackProjectVC alloc] initWithNibName:@"MGNewRackProjectVC" bundle:nil];
    vc.project = self;
    [self bind:@"cloud" toObject:vc withKeyPath:@"cloud" options:nil];
    [self bind:@"appName" toObject:vc withKeyPath:@"appName" options:nil];
    [self bind:@"git" toObject:vc withKeyPath:@"git" options:nil];
    return vc;
}

-(NSDictionary*)projectDict{
    return nil;
}

-(IUCompileResult*)buildProject{
    [self clearProject];
    
    IUCompileResult *result = [[IUCompileResult alloc] init];
    result.result = YES;
    result.log  = @"";
    result.outputDirPath = self.absoluteOutputDir;
    result.indexFilePath = [self.absoluteOutputDir stringByAppendingPathComponent:@"public/index.html"];
    /* save all page file to output dir */
    NSArray *pageFiles = [self.rootFileItem subFileItemsWithExtension:@"pgiu"];
    NSArray *pageIUs = [self.pWC iuManagerOfFileItems:pageFiles];
    
    NSError *err;

    /* make dir to target directory */
    NSString *outputResDir = [self.absoluteOutputDir stringByAppendingPathComponent:@"public"];
    [[NSFileManager defaultManager]createDirectoryAtPath:outputResDir withIntermediateDirectories:YES attributes:nil error:&err];
    
    /* copy resource file */
    NSString *gemFilePath = [[NSBundle mainBundle] pathForResource:@"Gemfile" ofType:nil];
    NSString *gemLockFilePath = [[NSBundle mainBundle] pathForResource:@"Gemfile" ofType:@"lock"];
    [[NSFileManager defaultManager] copyItemAtPath:gemFilePath toPath:[self.absoluteOutputDir stringByAppendingPathComponent:@"Gemfile"] error:&err];
    [[NSFileManager defaultManager] copyItemAtPath:gemLockFilePath toPath:[self.absoluteOutputDir stringByAppendingPathComponent:@"Gemfile.lock"] error:&err];
    [[NSFileManager defaultManager] copyItemAtPath:self.absoluteResDirPath toPath:[self.absoluteOutputDir stringByAppendingPathComponent:@"public/res"] error:&err];
    
    /* make config.ru file */
    NSString  *configRUPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"ru"];
    NSString  *configRUUnitPath = [[NSBundle mainBundle] pathForResource:@"config.ru" ofType:@"unit"];

    NSMutableString *configRU = [NSMutableString stringWithContentsOfFile:configRUPath encoding:NSUTF8StringEncoding error:nil];
    NSString *configRUUnit = [NSString stringWithContentsOfFile:configRUUnitPath encoding:NSUTF8StringEncoding error:nil];

    IUManager *firstManager = [pageIUs firstObject];
    MGFileItem* fileItem = firstManager.rootIU.fileItem;
    NSString *outputFileName = [fileItem.name stringByChangeExtension:@"html"];
    NSString *newConfigRUUnit = [configRUUnit stringByReplacingOccurrencesOfString:@"_FILENAME_MAP_" withString:@""];
    NSString *newConfigRUUnit2 = [newConfigRUUnit stringByReplacingOccurrencesOfString:@"_FILENAME_SRC_" withString:outputFileName];
    [configRU appendString:newConfigRUUnit2];
    [configRU appendString:@"\n"];
    

    //make config.ru
    for (IUManager *manager in pageIUs) {
        MGFileItem* fileItem = manager.rootIU.fileItem;
        NSString *outputFileName = [fileItem.name stringByChangeExtension:@"html"];
        NSString *newConfigRUUnit = [configRUUnit stringByReplacingOccurrencesOfString:@"_FILENAME_MAP_" withString:outputFileName];
        NSString *newConfigRUUnit2 = [newConfigRUUnit stringByReplacingOccurrencesOfString:@"_FILENAME_SRC_" withString:outputFileName];
        [configRU appendString:newConfigRUUnit2];
        [configRU appendString:@"\n"];
    }
    
    [configRU writeToFile:[self.absoluteOutputDir stringByAppendingPathComponent:@"config.ru"] atomically:YES encoding:NSUTF8StringEncoding error:nil];


    //save .html file
    for (IUManager *manager in pageIUs) {
        MGFileItem* fileItem = manager.rootIU.fileItem;
        NSString *outputFileName = [[[self.absoluteOutputDir stringByAppendingPathComponent:@"public"] stringByAppendingPathComponent:fileItem.name] stringByChangeExtension:@"html"];
        NSData *data = [[manager.rootIU source:IUSourceTypeOutput] dataUsingEncoding:NSUTF8StringEncoding];
        [data writeToFile:outputFileName atomically:YES];
        [result.compiledFilePaths setObject:outputFileName forKey:fileItem.name];
    }
    
    NSString *destPath;
    NSString *srcPath;
    
    destPath = [self.absoluteOutputDir stringByAppendingPathComponents:@[self.resDir, @"reset.css"]];
    srcPath = [[NSBundle mainBundle] pathForResource:@"reset" ofType:@"css"];
    [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:destPath error:&err];
    
    destPath = [self.absoluteOutputDir stringByAppendingPathComponents:@[self.resDir, @"iucss.js"]];
    srcPath = [[NSBundle mainBundle] pathForResource:@"iu" ofType:@"css"];
    [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:destPath error:&err];
    
    destPath = [self.absoluteOutputDir stringByAppendingPathComponents:@[self.resDir, @"iuframe.js"]];
    srcPath = [[NSBundle mainBundle] pathForResource:@"iuframe" ofType:@"js"];
    [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:destPath error:&err];
    
    destPath = [self.absoluteOutputDir stringByAppendingPathComponents:@[self.resDir, @"iulib.js"]];
    srcPath = [[NSBundle mainBundle] pathForResource:@"iulib" ofType:@"js"];
    [[NSFileManager defaultManager] copyItemAtPath:srcPath toPath:destPath error:&err];
    
    return result;
}

-(NSString*)absolutePathOfCompiledIUName:(NSString*)iuName{
    if ([[iuName pathExtension] isEqualToString:@"coiu"]) {
        return [[self.absoluteObjectDir stringByAppendingPathComponent:@"public"] stringByAppendingPathComponent:[iuName stringByChangeExtension:@"html"]];
    }
    if ([[iuName pathExtension] isEqualToString:@"pgiu"]) {
        return [[self.absoluteObjectDir stringByAppendingPathComponent:@"public"] stringByAppendingPathComponent:[iuName stringByChangeExtension:@"html"]];
    }
    return nil;
}

@end

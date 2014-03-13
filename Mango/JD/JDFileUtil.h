//
//  JDFileUtil.h
//  Mango
//
//  Created by JD on 13. 2. 6..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>

@interface JDFileUtil : NSObject <NSOpenSavePanelDelegate>{
    NSMutableDictionary *shellCommandDict;
}

+(JDFileUtil*)util;
+(BOOL)isFileImage:(NSURL*)url;
-(NSURL*)openFileByNSOpenPanel;
-(NSURL*)openFileByNSOpenPanel:(NSString*)title withExt:(NSArray*)extensions;
-(NSURL*)openDirectoryByNSOpenPanel:(NSString*)title;
-(NSURL*)openDirectoryByNSOpenPanel;


+(NSInteger) launch:(NSString*)launchPath atDirectory:(NSString*)directoryPath arguments:(NSArray*)arguments stdOut:(NSString**)stdOutLog stdErr:(NSString**)stdErrLog;


+(BOOL)touch:(NSString*)filePath;
+(BOOL)mkdirPath:(NSString*)path;
+(void)rmDirPath:(NSString*)path;


-(BOOL) appendToFile:(NSString*)path content:(NSString*)content;
- (void)readCompleted:(NSNotification *)notification;

-(NSError*)copyBundleItem:(NSString *)filename toDirectory:(NSString *)directoryPath;
- (BOOL) unzip:(NSString*)filePath toDirectory:(NSString*)path createDirectory:(BOOL)createDirectory;
- (BOOL) unzipResource:(NSString*)resource toDirectory:(NSString*)path createDirectory:(BOOL)createDirectory;
@end
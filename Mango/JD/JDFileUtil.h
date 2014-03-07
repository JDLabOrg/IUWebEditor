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

@property int lastStatusCode;

+(JDFileUtil*)util;
+(BOOL)isFileImage:(NSURL*)url;
-(NSURL*)openFileByNSOpenPanel;
-(NSURL*)openFileByNSOpenPanel:(NSString*)title withExt:(NSArray*)extensions;
-(NSURL*)openDirectoryByNSOpenPanel:(NSString*)title;
-(NSURL*)openDirectoryByNSOpenPanel;

-(BOOL)shellCommandExist:(NSString*)command;
-(BOOL)shellCommandExist:(NSString*)command raiseException:(BOOL)raise;

-(NSString*) launch:(NSString*)launchPath atDirectory:(NSString*)directoryPath arguments:(NSArray*)arguments;
-(NSString*) launch:(NSString*)launchPath atDirectory:(NSString*)directoryPath argument:(NSString*)argument;
-(NSString*) launchShellCommand:(NSString*)command atDirectory:(NSString*)directory argument:(NSString*)argument timeout:(NSUInteger)timeout;
-(NSString*) launchShellCommand:(NSString*)command atDirectory:(NSString*)directory arguments:(NSArray*)argument timeout:(NSUInteger)timeout;

+(NSString*)touch:(NSString*)file atDirecory:(NSString*)dir;
+(NSString*)mkdirPath:(NSString*)path atDirecory:(NSString*)dir touchDummy:(BOOL)dummy;
+(NSString*)mkdirPath:(NSString*)path atDirecory:(NSString*)dir;

-(BOOL) appendToFile:(NSString*)path content:(NSString*)content;
- (void)readCompleted:(NSNotification *)notification;

-(NSError*)copyBundleItem:(NSString *)filename toDirectory:(NSString *)directoryPath;
- (BOOL) unzip:(NSString*)filePath toDirectory:(NSString*)path createDirectory:(BOOL)createDirectory;
- (BOOL) unzipResource:(NSString*)resource toDirectory:(NSString*)path createDirectory:(BOOL)createDirectory;
@end
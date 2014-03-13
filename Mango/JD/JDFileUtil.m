//
//  JDFileUtil.m
//  Mango
//
//  Created by JD on 13. 2. 6..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "JDFileUtil.h"

static JDFileUtil *sharedJDFileUtill;

@implementation JDFileUtil

+(JDFileUtil*)util{
    if (sharedJDFileUtill == nil){
        sharedJDFileUtill = [[JDFileUtil alloc] init];
    }
    return sharedJDFileUtill;
}


-(id)init{
    self = [super init];
    if (self) {
        shellCommandDict = [NSMutableDictionary dictionary];
    }
    return self;
}



+(BOOL)isFileImage:(NSURL*)url{
    NSString *file = [url absoluteString];
    CFStringRef fileExtension = (__bridge CFStringRef) [file pathExtension];
    CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
    
    if (UTTypeConformsTo(fileUTI, kUTTypeImage)){
        CFRelease(fileUTI);
        return YES;
    }
    CFRelease(fileUTI);
    return NO;
}


+(BOOL)mkdirPath:(NSString*)path{
    NSString *stdErr;
    NSInteger resultCode = [JDFileUtil launch:@"/bin/mkdir" atDirectory:@"/" arguments:@[@"-p", path] stdOut:nil stdErr:&stdErr];
    if (resultCode !=0 ) {
        NSLog(@"err at mkdirpath");
    }
    return !resultCode;
}

+(void)rmDirPath:(NSString*)path{
    [JDFileUtil launch:@"/bin/rm" atDirectory:@"/" arguments:@[@"-rf", path] stdOut:nil stdErr:nil];
}

+(BOOL)touch:(NSString*)filePath{
    NSInteger resultCode = [JDFileUtil launch:@"/usr/bin/touch" atDirectory:@"/" arguments:@[filePath] stdOut:nil stdErr:nil];
    return !resultCode;
}



-(NSURL*)openFileByNSOpenPanel{
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanCreateDirectories:YES];

    // Display the dialog.  If the OK button was pressed,
    // process the files.
    if ( [panel runModal] == NSOKButton ){
        return [[panel URLs] objectAtIndex:0];
    }
    
    return nil;

}

-(NSURL*)openFileByNSOpenPanel:(NSString*)title withExt:(NSArray*)extensions{
    NSOpenPanel* panel = [NSOpenPanel openPanel];
    [panel setCanChooseFiles:YES];
    [panel setCanChooseDirectories:NO];
    [panel setAllowsMultipleSelection:NO];
    [panel setCanCreateDirectories:YES];
    if (title != nil) {
        [panel setTitle:title];
    }
    [panel setAllowedFileTypes:extensions];

    // Display the dialog.  If the OK button was pressed,
    // process the files.
    if ( [panel runModal] == NSOKButton ){
        return [[panel URLs] objectAtIndex:0];
    }
        
    return nil;
}


-(NSURL*)openDirectoryByNSOpenPanel:(NSString*)title{
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    [openDlg setCanChooseFiles:NO];
    [openDlg setCanChooseDirectories:YES];
    [openDlg setAllowsMultipleSelection:NO];
    [openDlg setCanCreateDirectories:YES];
    
    if (title != nil) {
        [openDlg setTitle:title];
    }
    
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    //openDlg.directoryURL = nil;
    //openDlg.nameFieldStringValue = @"";
    if ( [openDlg runModal] == NSOKButton ){
        return [[openDlg URLs] objectAtIndex:0];
    }
    return nil;
}


-(NSURL*)openDirectoryByNSOpenPanel{
    return [self openDirectoryByNSOpenPanel:nil];
}




+(NSInteger) launch:(NSString*)launchPath atDirectory:(NSString*)directoryPath arguments:(NSArray*)arguments stdOut:(NSString**)stdOutLog stdErr:(NSString**)stdErrLog{
    NSTask *task;
    
    task = [[NSTask alloc] init];
    [task setLaunchPath: launchPath];
    
    if ([arguments count]) {
        [task setArguments: arguments];
    }
    
    NSPipe *pipe = [NSPipe pipe];
    NSPipe *pipe2 = [NSPipe pipe];
    
    [task setStandardOutput:pipe];
    [task setStandardError:pipe2];
    
    NSFileHandle *file = [pipe fileHandleForReading];
    NSFileHandle *file2 = [pipe2 fileHandleForReading];
    
    [task setCurrentDirectoryPath:directoryPath];
    [task launch];
    [task waitUntilExit];
    
    if (stdOutLog) {
        NSData *data = [file readDataToEndOfFile];
        *stdOutLog = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    }
    if (stdErrLog) {
        NSData *data = [file2 readDataToEndOfFile];
        *stdErrLog = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
    }
    
    return [task terminationStatus];
}

- (void)readCompleted:(NSNotification *)notification {
    NSLog(@"Read data: %@", [[notification userInfo] objectForKey:NSFileHandleNotificationDataItem]);
    NSLog([[notification userInfo] objectForKey:NSFileHandleNotificationFileHandleItem],nil);
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSFileHandleReadToEndOfFileCompletionNotification object:[notification object]];
}

-(BOOL) appendToFile:(NSString*)path content:(NSString*)content{
    NSFileHandle *myHandle = [NSFileHandle fileHandleForWritingAtPath:path];
    if (myHandle == nil){
        NSLog(@"Failed to open file");
        return NO;
    }

    NSData *theData = [content dataUsingEncoding:NSUTF8StringEncoding];
    [myHandle seekToEndOfFile];
    [myHandle writeData:theData];
    [myHandle closeFile];
    return YES;
}

-(NSError*)copyBundleItem:(NSString *)filename toDirectory:(NSString *)directoryPath{
    NSError *result;
    NSString *resourceFilePath =[[[NSBundle mainBundle] resourcePath] stringByAppendingFormat:@"/%@",filename];
    NSString *newFilePath      =[directoryPath stringByAppendingFormat:@"/%@",filename];
    [[NSFileManager defaultManager] copyItemAtPath:resourceFilePath toPath:newFilePath error:&result];
    if (result) {
        NSLog([result description],nil);
    }
    return result;
}

- (BOOL) unzipResource:(NSString*)resource toDirectory:(NSString*)path createDirectory:(BOOL)createDirectory{
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:[resource stringByDeletingPathExtension] ofType:[resource pathExtension]];
    if (resourcePath == nil) {
        return NO;
    }
    [self unzip:resourcePath toDirectory:path createDirectory:createDirectory];
    return YES;
}


- (BOOL) unzip:(NSString*)filePath toDirectory:(NSString*)path createDirectory:(BOOL)createDirectory{
    //directory create
    if (createDirectory) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES
                                                   attributes:nil error:NULL];
    }

    //now create a unzip-task
    NSArray *arguments = @[@"-o", filePath];
    NSTask *unzipTask = [[NSTask alloc] init];
    [unzipTask setLaunchPath:@"/usr/bin/unzip"];
    [unzipTask setCurrentDirectoryPath:path];
    [unzipTask setArguments:arguments];
    [unzipTask launch];
    [unzipTask waitUntilExit];
    return YES;
}


@end

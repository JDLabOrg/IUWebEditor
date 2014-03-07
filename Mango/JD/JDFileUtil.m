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

+(NSString*)mkdirPath:(NSString*)path atDirecory:(NSString*)dir{
    return [self mkdirPath:path atDirecory:dir touchDummy:YES];
}

+(NSString*)mkdirPath:(NSString*)path atDirecory:(NSString*)dir touchDummy:(BOOL)dummy{
    if (dir == nil) {
        dir = @"/";
    }
    NSArray *argu = [NSArray arrayWithObjects:@"-p", [NSString stringWithFormat:@"./%@/",path], nil];
    NSString *result = [[JDFileUtil util] launch:@"/bin/mkdir" atDirectory:dir arguments:argu];
    if (dummy) {
        result = [[JDFileUtil util] launch:@"/usr/bin/touch" atDirectory:[NSString stringWithFormat:@"%@/%@",dir,path] argument:@".dummy"];
    }
    return result;
}

+(NSString*)touch:(NSString*)file atDirecory:(NSString*)dir{
    NSString *touchFile=[NSString stringWithFormat:@"./%@",file];
    NSString *result = [[JDFileUtil util] launch:@"/usr/bin/touch" atDirectory:dir argument:touchFile];
    return result;
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

-(NSString*) launch:(NSString*)launchPath atDirectory:(NSString*)directoryPath argument:(NSString*)argument{
    if (argument == nil) {
        return [self launch:launchPath atDirectory:directoryPath arguments:nil];
    }
    return [self launch:launchPath atDirectory:directoryPath arguments:[NSArray arrayWithObject:argument]];
}

-(BOOL)shellCommandExist:(NSString*)command raiseException:(BOOL)raise{
    if ([command length] == 0) {
        [NSException raise:@"JDArgumentNilException" format:nil];
    }

    if (raise) {
        NSString *output = [self launch:@"/usr/bin/which" atDirectory:@"/" argument:command];
        [shellCommandDict setObject:output forKey:command];
        return YES;
    }
    else{
        @try {
            NSString *output = [[self launch:@"/usr/bin/which" atDirectory:@"/" argument:command] trim];
            [shellCommandDict setObject:output forKey:command];
            return YES;
        }
        @catch (NSException *exception) {
            return NO;
        }
    }
}


-(BOOL)shellCommandExist:(NSString*)command{
    return [self shellCommandExist:command raiseException:NO];
}

-(NSString*) launchShellCommand:(NSString*)command atDirectory:(NSString*)directory argument:(NSString*)argument timeout:(NSUInteger)timeout{
    if (argument == nil) {
        return [self launchShellCommand:command atDirectory:directory arguments:nil timeout:timeout];
    }
    return [self launchShellCommand:command atDirectory:directory arguments:[NSArray arrayWithObject:argument ] timeout:timeout];
}

-(NSString*) launchShellCommand:(NSString*)command atDirectory:(NSString*)directory arguments:(NSArray*)arguments timeout:(NSUInteger)timeout{
    if (directory==nil) {
        directory = @"/";
    }
    NSString *path = [shellCommandDict objectForKey:command];
    if (path == nil) {
        if ( [self shellCommandExist:command] == NO){
            [NSException raise:@"JDCommandNotExistException" format:command,nil];
        }
        path = [shellCommandDict objectForKey:command];
    }

    if (arguments == nil) {
        return [self launch:path atDirectory:directory arguments:nil timeOutLimit:timeout];
    }
    return [self launch:path atDirectory:directory arguments:arguments timeOutLimit:timeout];
}

-(NSString*) launch:(NSString*)launchPath atDirectory:(NSString*)directoryPath arguments:(NSArray*)arguments {
    return [self launch:launchPath atDirectory:directoryPath arguments:arguments timeOutLimit:0];
}

-(NSString*) launch:(NSString*)launchPath atDirectory:(NSString*)directoryPath arguments:(NSArray*)arguments timeOutLimit:(NSUInteger)limit{
    __block BOOL   running=YES;
    __block NSString *retVal;
    __block NSException *exception;
    __block NSTask *task;
    __block NSString *string;
    __block NSString *string2;

    NSDate *dt = [NSDate date];
    
    if (limit == 0){
        task = [[NSTask alloc] init];
        [task setLaunchPath: launchPath];
        
        if ([arguments count]) {
            [task setArguments: arguments];
        }
        
        NSPipe *pipe = [NSPipe pipe];
        NSPipe *pipe2 = [NSPipe pipe];
        
        [task setStandardOutput: pipe];
        [task setStandardError:pipe2];
        
        NSFileHandle *file = [pipe fileHandleForReading];
        NSFileHandle *file2 = [pipe2 fileHandleForReading];
        
        [task setCurrentDirectoryPath:directoryPath];
        [task launch];
        
        NSData *data = [file readDataToEndOfFile];
        NSString *string = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
        
        NSData *data2 = [file2 readDataToEndOfFile];
        NSString *string2 = [[NSString alloc] initWithData:data2 encoding: NSUTF8StringEncoding];
        
        
        retVal = string;
        NSLog(@" %@ begin to terminate" , launchPath);
        [task terminate];
        [task waitUntilExit];
        NSLog(@" %@ terminated" , launchPath);
        self.lastStatusCode = [task terminationStatus];
        
        if (_lastStatusCode != 0) {
            NSString *errorLog = [NSString stringWithFormat:@"%@\n=================\n%@", string, string2];
            exception = [NSException exceptionWithName:@"JDShellStandardError" reason:errorLog userInfo:nil];
            [exception raise];
        }

        return string;
    }

    dispatch_async(dispatch_queue_create("lauunchQueue", DISPATCH_QUEUE_CONCURRENT), ^(void){
        task = [[NSTask alloc] init];
        [task setLaunchPath: launchPath];
        
        if ([arguments count]) {
            [task setArguments: arguments];
        }
        
        NSPipe *pipe = [NSPipe pipe];
        NSPipe *pipe2 = [NSPipe pipe];
        
        [task setStandardOutput: pipe];
        [task setStandardError:pipe2];
        
        NSFileHandle *file = [pipe fileHandleForReading];
        NSFileHandle *file2 = [pipe2 fileHandleForReading];
        
        [task setCurrentDirectoryPath:directoryPath];
        [task launch];
        [task waitUntilExit];
        
        NSData *data = [file readDataToEndOfFile];
        string = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
        
        NSData *data2 = [file2 readDataToEndOfFile];
        string2 = [[NSString alloc] initWithData:data2 encoding: NSUTF8StringEncoding];
        
        retVal = string;
        running = NO;
    });
    

    while ([[NSDate date] timeIntervalSinceDate:dt] < (NSTimeInterval)limit) {
        [NSThread sleepForTimeInterval:0];
    }
    [task terminate];
    NSLog(@"NSTask Terminated");
    task = nil;

    self.lastStatusCode = [task terminationStatus];
    if (_lastStatusCode != 0) {
        NSString *errorLog = [NSString stringWithFormat:@"%@\n=================\n%@", string, string2];
        exception = [NSException exceptionWithName:@"JDShellStandardError" reason:errorLog userInfo:nil];
        [exception raise];
    }
    

    NSLog(@"NSTask Return");
    NSLog(retVal,nil);

    return retVal;
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

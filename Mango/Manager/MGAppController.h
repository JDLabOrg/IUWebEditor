//
//  MGAppController.h
//  Mango
//
//  Created by JD on 13. 2. 1..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>
#import "MGNewProjectWC.h"

@class MGProjectWC;
@class MGNewProjectWC;
@class MGNewFileWC;
@class MGMailWC;

@interface MGAppController : NSObject{
    MGNewProjectWC    *initWC;
    MGMailWC *mWC;
    
    NSString *currentActivity;
    NSMutableArray *activityStackLog;
}

@property NSString     *currentActivity;
@property MGProjectWC *pWC;


+(MGAppController*) controller;
+(void)log:(NSString*)log;
//- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo;

-(IBAction)undo:(id)sender;
- (IBAction)openConsolePanel:(id)sender;
- (IBAction)openNewProjectWindow:(id)sender;

- (IBAction)saveFile:(id)sender;


- (void)log:(NSString*)log;
- (void)pushLog:(NSString*)log;
- (void)popLog:(NSString*)log;
- (IBAction) openPrefPanel:(id)sender;


- (IBAction)toggleGhost:(id)sender;

- (IBAction)sendEmail:(id)sender;

-(NSArray *)IUSortDescriptors;


@end

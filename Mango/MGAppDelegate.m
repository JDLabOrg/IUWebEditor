//
//  MGAppDelegate.m
//  Mango
//
//  Created by JD on 13. 1. 26..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGAppDelegate.h"
#import "MGAppController.h"
#import "IUHttpLog.h"
#define kRecentOpenDocs @"recentOpenedDocs"

#import "MGSampleProjectSelectionVC.h"

@implementation MGAppDelegate {
    MGSampleProjectSelectionVC *tWC;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    
    BOOL didRun = [[NSUserDefaults standardUserDefaults] boolForKey:@"didRun"];
    if (didRun == 0) {
        [IUHttpLog sendNewUserLog];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"didRun"];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"webSimulatorView"];

    }

    NSArray *fontListArray = [[NSFontManager sharedFontManager] availableFontFamilies];
    [[NSUserDefaults standardUserDefaults] setObject:fontListArray forKey:@"fontList"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageRecentOpen:) name:@"MGProjectOpenNoti" object:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:@[@"positiveVT",@"negativeVT"] forKey:@"valueTransformers"];
    [[NSUserDefaults standardUserDefaults] setObject:@[@"click", @"hover"] forKey:@"triggerActions"];
    
    //send post to httplog
    [IUHttpLog sendRunLog];

    
    MGProjectWC *pWC = [[MGProjectWC alloc] initWithWindowNibName:@"MGProjectWC"];
    [pWC showWindow:nil];
    [pWC showNewProject:IUStartTypeLaunch];
    

    [[NSColorPanel sharedColorPanel] performSelector:@selector(close) withObject:nil afterDelay:0.1];
}




-(void)manageRecentOpen:(NSNotification*)noti{
    MGProjectWC *pWC = noti.object;
    NSString *path = pWC.project.filePath;
    NSMutableArray *openedDoc = [[[NSUserDefaults standardUserDefaults] objectForKey:kRecentOpenDocs] mutableCopy];
    if (openedDoc == nil) {
        openedDoc = [NSMutableArray array];
    }
    NSString *removeStr = nil;
    for (NSString *str in openedDoc) {
        if ([str isEqualToString:path]) {
            removeStr = str;
            break;
        }
    }
    [openedDoc removeObject:removeStr];
    
    [openedDoc addObject:path];
    if ([openedDoc count] > 8) {
        [openedDoc removeObjectAtIndex:0];
    }
    [[NSUserDefaults standardUserDefaults] setObject:openedDoc forKey:kRecentOpenDocs];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(BOOL)application:(NSApplication *)sender openFile:(NSString *)filename{
    MGProjectWC *pWC=[[MGProjectWC alloc] initWithWindowNibName:@"MGProjectWC" projectFilePath:filename];
    [pWC showWindow:nil];
    return YES;
}

-(void)openDocument:(id)sender{
    MGProjectWC *pWC=[[MGProjectWC alloc] initWithWindowNibName:@"MGProjectWC" projectFilePath:nil];
    [pWC showWindow:nil];
    [pWC showOpenProjectModal:nil];
}



- (IBAction)pressMenuBuild:(id)sender {
    MGProjectWC *pWC = (MGProjectWC*)[NSApp mainWindow].windowController;
    if ([pWC isKindOfClass:[MGProjectWC class]]) {
        [pWC build:self];
    }
}

/*

- (void)showTemplate{
    if (tWC == nil) {
        tWC = [[MGSampleProjectSelectionWC alloc] initWithWindowNibName:@"MGSampleProjectSelectionWC"];
    }
    [tWC showWindow:nil];
}
 */

- (void)openProjectAtPath:(NSString*)path{
    MGProjectWC *pWC=[[MGProjectWC alloc] initWithWindowNibName:@"MGProjectWC" projectFilePath:nil];
    [pWC showWindow:nil];
    [pWC loadProjectAtFilePath:path];
}

@end

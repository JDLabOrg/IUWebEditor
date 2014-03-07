//
//  MGAppController.m
//  Mango
//
//  Created by JD on 13. 2. 1..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGAppController.h"
#import "IUManager.h"

#import "MGNewProjectWC.h"
#import "MGNewFileWC.h"
#import "IUViewManager.h"
#import "MGMailWC.h"

static MGAppController *appController;

@implementation MGAppController

@synthesize currentActivity;

-(void)awakeFromNib{
    activityStackLog = [NSMutableArray array];
    appController = self;
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NSDisabledCharacterPaletteMenuItem"];
}

-(MGProjectWC*)getKeyPWC{
    MGProjectWC *_pwc = [NSApp mainWindow].windowController;
    if ([_pwc isKindOfClass:[MGProjectWC class]]) {
        return _pwc;
    }
    return nil;
}


+(MGAppController*)controller{
    return appController;
}

- (IBAction)saveFile:(id)sender{
    MGProjectWC *_pwc = [NSApp mainWindow].windowController;
    if ([_pwc isKindOfClass:[MGProjectWC class]]) {
        [_pwc saveAllProject];
    }
}



- (IBAction)openConsolePanel:(id)sender {
}

#pragma mark -
#pragma mark start new project

- (IBAction)openNewFileWindow:(id)sender {
    MGProjectWC *_pwc = [self getKeyPWC];
    [_pwc openNewFileWindow:sender];
}


//from menu new project
- (IBAction)openNewProjectWindow:(id)sender {
    MGProjectWC *wc = [[MGProjectWC alloc] initWithWindowNibName:@"MGProjectWC"];
    [wc showWindow:nil];
    [wc showNewProject:IUStartTypeNew];
}

- (IBAction)openTemplateProjectWindow:(id)sender {
    MGProjectWC *wc = [[MGProjectWC alloc] initWithWindowNibName:@"MGProjectWC"];
    [wc showWindow:nil];
    [wc showNewProject:IUStartTypeTemplate];
}

-(IBAction)undo:(id)sender{
    MGProjectWC *pWC = [self getKeyPWC];
    [[[pWC selectedIUManager] iuViewManager] disableUpdate:self];
    [pWC.selectedIUManager.undoManager undo];
    [[[pWC selectedIUManager] iuViewManager] enableUpdate:self];
}

    
- (NSRect)window:(NSWindow *)window willPositionSheet:(NSWindow *)sheet
       usingRect:(NSRect)rect
{
    rect.origin.y += 11;  // or as much as we need
    return rect;
}


+ (void)log:(NSString*)log{
    [appController log:log];
}

+ (void)logWithErrror:(NSError*)err{
    [appController log:[err description]];
}

- (void)log:(NSString*)log{
}

-(IBAction) openPrefPanel:(id)sender{
}

- (IBAction)toggleBorder:(id)sender{
 
    BOOL showBorder = [[NSUserDefaults standardUserDefaults] boolForKey:@"showBorder"];
    [[NSUserDefaults standardUserDefaults] setBool:!showBorder forKey:@"showBorder"];
    
}

-(IBAction)toggleShadow:(id)sender{
    BOOL showShadow = [[NSUserDefaults standardUserDefaults] boolForKey:@"showShadow"];
    [[NSUserDefaults standardUserDefaults] setBool:!showShadow forKey:@"showShadow"];
    
}

- (IBAction)toggleGhost:(id)sender{
        BOOL showGhost = [[NSUserDefaults standardUserDefaults] boolForKey:@"showGhost"];
        [[NSUserDefaults standardUserDefaults] setBool:!showGhost forKey:@"showGhost"];
}

- (void)pushLog:(NSString*)log{
    [activityStackLog insertObject:log atIndex:0];
    self.currentActivity = [activityStackLog objectAtIndex:0];
}

- (IBAction)sendEmail:(id)sender{
    mWC = [[MGMailWC alloc] initWithWindowNibName:@"MGMailWC"];
//    MGProjectWC *_pwc = [self getKeyPWC];
//    [NSApp beginSheet:mWC.window modalForWindow:_pwc.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
    [mWC showWindow:nil];
}


- (void)popLog:(NSString*)log{
    
    for (NSString *str in activityStackLog) {
        if ([str isEqualToString:log]) {
            [activityStackLog removeObject:str];
            break;
        }
    }
    if ([activityStackLog count]>0) {
        self.currentActivity = [activityStackLog objectAtIndex:0];
    }
    else {
        self.currentActivity = @"No Background Activity";
    }
}

- (BOOL)validateMenuItem:(NSMenuItem *)item {
    MGProjectWC *_pwc = [self getKeyPWC];
    if (_pwc) {
        return YES;
    }
    else{
        if (item.action == @selector(openNewProjectWindow:)
            || item.action == @selector(sendEmail:)
            || item.action == @selector(openTemplateProjectWindow:)
            ) {
            return YES;
        }
        return NO;
    }
}



-(NSArray *)IUSortDescriptors{
    return nil;
//    return @[DefinedIUSortDescriptor];
}


@end
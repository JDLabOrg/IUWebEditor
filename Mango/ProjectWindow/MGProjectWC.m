//
//  MGProjectWC.m
//  Mango
//
//  Created by JD on 13. 2. 8..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGProjectWC.h"
#import "IUManager.h"
#import "JDArrayDict.h"
#import "JDTransformer.h"
#import "IUController.h"
#import "MGFileItem.h"
#import "MGLogWC.h"
#import "IUViewManager.h"
#import "IUNote.h"
#import "MGAppDelegate.h"
#import "MGSourceWC.h"
#import "MGInspectorVC.h"
#import "IUClassInspector.h"
#import "MGNewFileWC.h"
#import "IUSyncWindowController.h"
#import "MGProjectModificationVC.h"
#import "IULeftVC.h"
#import "SFDefaultTab.h"
#import "IUCloseWindowController.h"
#import "IUScreenFrame.h"
#import "MGImageViewController.h"

NSString *const resourceFileName = @"Resource";

@interface MGProjectWC ()
@end

@implementation MGProjectWC{
    MGFileItem      *currFile;
    MGSourceWC      *sourceWC;
    IUCompileResult     *lastCompileResult;

    MGNewFileWC *newFileWC;
    IUSyncWindowController *syncWC;
    MGProjectModificationVC *modifyResource;
    
    BOOL isDataChanged;
}

@synthesize selectedIUManager;
@synthesize inspectorVC;
@synthesize leftVC;

@synthesize iuController;
@synthesize project;
@synthesize IUManagers;

#pragma mark -
#pragma mark Initialize

- (id)initWithWindowNibName:(NSString *)windowNibName projectFilePath:(NSString *)_projectFilePath;
{
    self = [super initWithWindowNibName:windowNibName];
    
    //Debug for Constraint
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];
    if (self) {
        if (_projectFilePath != nil) {
            [self loadProjectAtFilePath:_projectFilePath];
        }
   
    }
    
    return self;
}

-(void)loadPWC{
    /* Load LeftView, InspectorView*/
    [self.inspectorVC setPWC:self];
    [self.leftVC setPWC:self];
    self.imageVC = self.leftVC.objectIns.iVC;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(IUChanged:) name:@"IUChangedNotification" object:nil];
}


-(void)awakeFromNib{
    /******* Tool bar ***********/
    // tell the toolbar to show icons only by default
    [self.toolbar setDisplayMode:NSToolbarDisplayModeIconOnly];

    //text toolbar
    self.textToolbarVC = [[IUTextToolbarVC alloc] initWithNibName:@"IUTextToolbarVC" bundle:nil pWC:self];
    [self.textToolbarContainerV addSubviewFullFrame:self.textToolbarVC.view];

    
    sourceWC = [[MGSourceWC alloc] initWithWindowNibName:@"MGSourceWC"];
    modifyResource = [[MGProjectModificationVC alloc] initWithNibName:@"IUModificationProjectVC" bundle:nil];
    
    //connect View
    [self.bottomView addSubviewFullFrame:self.bottomMenuView];
    
    //Set filetabs
    tabView2.delegate = self;
    
    
    //bottom view
    [self.ghostImageView setPWC:self];
    
}

- (id)valueForUndefinedKey:(NSString *)key{
    NSLog(key,nil);
    assert(0);
    return nil;
}




#pragma mark -
#pragma mark manage Window

-(BOOL)windowShouldClose:(id)sender{
    if (isDataChanged) {
        IUCloseWindowController* closeWC = [[IUCloseWindowController alloc] initWithWindowNibName:@"IUCloseWindowController" withName:project.appName];
        
        [self.window beginSheet:closeWC.window completionHandler:^(NSModalResponse returnCode){
            [closeWC.window orderOut:nil];
            //save & close
            if (returnCode == NSModalResponseOK) {
                [self saveAllProject];
                [self.window close];
            }
            //don't save & close
            else if(returnCode == NSModalResponseStop){
                [self.window close];
            }
            //don't close
            else if(returnCode == NSModalResponseCancel){
                //nothing
            }
            
            
        }];
        
        return NO;
    }
    return YES;
}


- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo{
    [sheet close];
}


#pragma mark window-menu

-(void)pressMenuSync:(id)sender{
    //wanted new window
    syncWC  = [[IUSyncWindowController alloc] initWithWindowNibName:@"IUSyncWindow" PWC:self];
    //[syncWC.window setLevel:kCGNormalWindowLevel];
    [syncWC showWindow:nil];
}

-(void)pressMenuShowSource:(id)sender{
    
    [self showSourceWCWithIdx:0];
}


- (void)showOpenProjectModal:(id)sender{
    NSURL *url = [[JDFileUtil util] openFileByNSOpenPanel:nil withExt:@[@"iuproject"]];
    if (url) {
        NSString *projectFile = [url path];
        [self loadProjectAtFilePath:projectFile];
    }
    else{
        [self close];
    }
    
}

- (void)showCompileResult:(IUCompileResult*)result{
    lastCompileResult = result;
    NSAlert *alert = [NSAlert alertWithMessageText:@"Compile Finished" defaultButton:@"OK" alternateButton:@"open index file" otherButton:@"open current file" informativeTextWithFormat:@"success",nil];
    [alert beginSheetModalForWindow:self.window completionHandler:^(NSModalResponse returnCode){
        switch (returnCode) {
            // open index
            case 0:{
                NSURL *url =[NSURL fileURLWithPath:lastCompileResult.indexFilePath];
                [[NSWorkspace sharedWorkspace] openURL:url];
            }
            break;
            // open current
            case -1:{
                NSString *currentRootIU = self.selectedIUManager.rootIU.fileItem.name;
                NSString *path = [lastCompileResult.compiledFilePaths objectForKey:currentRootIU];
                if (path == nil) {
                    [JDLogUtil alert:@"No compiled output for this file"];
                    return;
                }
                NSURL *url =[NSURL fileURLWithPath:path];
                [[NSWorkspace sharedWorkspace] openURL:url];
            }
            break;
            case 1:
            default:
            break;
        }
    }];
    //    [alert beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:@selector(compileResultAlertDidEnd:returnCode:contextInfo:) contextInfo:nil];
    
}

#pragma mark -
#pragma mark manage IUData


-(void)IUChanged:(NSNotification*)noti{
    isDataChanged = YES;
}


#pragma mark manage project

-(void)saveAllProject{
    for (IUManager *manager in IUManagers) {
        [manager.rootIU saveAsFile];
    }
    [project save];
    isDataChanged = NO;
}


-(void)loadProjectAtFilePath:(NSString*)path{
    IUManagers = [[JDMutableArrayDict alloc] init];
    IUViewManagers = [[JDMutableArrayDict alloc] init];

    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *err;
    NSMutableDictionary *contentDict =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err] ;
    if (err) {
        [JDLogUtil log:@"load project" err:err];
        assert(0);
    }
    NSString *projectType = [contentDict objectForKey:@"projectType"];
    self.project = [[NSClassFromString(projectType) alloc] initWithContentOfFile:path];
    self.project.pWC = self;
    if (self.project == nil) {
        assert(0);
    }
    
    /* add to recent */
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"MGProjectOpenNoti" object:self]];
    
    [[NSDocumentController sharedDocumentController] noteNewRecentDocumentURL: [NSURL fileURLWithPath:path]];
    self.window.title = [NSString stringWithFormat:@"%@ - %@.iuproject", self.project.projectType, self.project.appName];
    [self.project copyResourceToResDir];
    
    [self loadPWC];
}


/* index : select tab
 * 0 : template project
 * 1 : new project
 * 2 : recent project
 */
-(void)showNewProject:(IUStartType)type{
    MGNewProjectWC* iWC = [[MGNewProjectWC alloc] initWithWindowNibName:@"MGNewProjectWC" PWC:self startType:type];
    [self.window beginSheet:iWC.window completionHandler:^(NSModalResponse returnCode){
        [iWC.window orderOut:nil];
        if (returnCode == NSModalResponseOK) {
            [self loadProjectAtFilePath:iWC.filePath];
        }
        if (returnCode == NSModalResponseCancel) {
            [self close];
        }
        
    }];
}



- (void)openNewFileWindow:(id)sender{
    
    newFileWC = [[MGNewFileWC alloc] initWithWindowNibName:@"MGNewFileWC" fileItem:[sender representedObject]];
    newFileWC.project = self.project;
    
    
    [self.window beginSheet:newFileWC.window completionHandler:^(NSModalResponse returnCode){
        [newFileWC.window orderOut:nil];
        if (returnCode == NSModalResponseOK) {
            
            
            IUFile *iu = [[NSClassFromString(newFileWC.selectedIUWidget.value) alloc] init];
            [iu instantiate];
            [iu setProperties:newFileWC.selectedIUWidget.param];
            
            MGFileItem *newFileItem = [[MGFileItem alloc] initWithContents:@{@"type": @"file", @"name":newFileWC.fullFileName}];
            
            if ([iu isKindOfClass:[IUPage class]]) {
                [self.project.rootFileItem.pageFileDirItem addFileItem:newFileItem];
                [self.project.pageFileItems setObject:newFileItem forKey:newFileItem.name];
                
            }
            else if ([iu isKindOfClass:[IUTemplate class]]) {
                [self.project.rootFileItem.templateFileDirItem addFileItem:newFileItem];
                [self.project.templateFileItems setObject:newFileItem forKey:newFileItem.name];
            }
            else if ([iu isKindOfClass:[IUComp class]]) {
                [self.project.rootFileItem.compFileDirItem addFileItem:newFileItem];
                [self.project.compFileItems setObject:newFileItem forKey:newFileItem.name];
            }
            [iu saveAsFileWithPath:newFileItem.absolutePath];
            
            [project save];
            
            [leftVC.fileIns reloadItem:newFileItem.parent];
            [leftVC.fileIns.outlineV selectItem:newFileItem];
            
        }
    }];
}

#pragma mark manage fileItem


-(IUViewManager*)selectedIUViewManager{
    return selectedIUManager.iuViewManager;
}


-(IUManager*)iuManagerOfFileItem:(MGFileItem*)fileItem{
    IUManager       *newManager     = [IUManagers objectForKey:fileItem.absolutePath];
    
    if (newManager == nil) {
        newManager = [[IUManager alloc] initWithFileItem:fileItem projectWindow:self];
        if (newManager == nil) {
            return nil;
        }
        [IUManagers setObject:newManager forKey:fileItem.absolutePath];
    }
    
    return newManager;
}

- (NSArray*)iuManagerOfFileItems:(NSArray*)fileItems{
    NSMutableArray *arr = [NSMutableArray array];
    for (MGFileItem *item in fileItems) {
        [arr addObject:[self iuManagerOfFileItem:item]];
    }
    return [arr copy];
}


- (IUManager*)iuManagerOfFileName:(NSString*)fileName{
    if (fileName == nil) {
        return nil;
    }
    MGFileItem *item = [project.rootFileItem childOfName:fileName];
    if (item == nil) {
        return nil;
    }
    return [self iuManagerOfFileItem:item];
}

/* Modify Project Resource Attributes*/
- (void)setProjectResource:(MGFileItem*)fileItem{
    //call IUModificationProjectVC attach centerV!
    NSLog(@"MGProjectWC call! in setProjectResource");
    if(self.selectedIUManager){
        [modifyResource setIUProject:self];
        NSRect centerSize = [self.centerV frame];
        [modifyResource.view setFrame:centerSize];
        [self.centerV setDocumentView:modifyResource.view];
        
        //control tab view
        [self addTab:fileItem];
        
    }
    
}

- (void)setCurrFile:(MGFileItem*)fileItem{
    if (fileItem == nil){
        return;
    }
    self.selectedIUManager.isSelected = NO;
    currFile = fileItem;
    IUManager       *newManager     = [IUManagers objectForKey:fileItem.absolutePath];
    
    if (newManager == nil) {
        newManager = [[IUManager alloc] initWithFileItem:fileItem projectWindow:self];
        [self.iuController rearrangeObjects];
        if (newManager == nil) {
            return;
        }
        [IUManagers setObject:newManager forKey:fileItem.absolutePath];
        
    }
    
    self.selectedIUManager = newManager;
    [self.selectedIUManager.iuViewManager reset]; // To apply changes in referenceIUs, currFile should reset the source
    self.selectedIUManager.isSelected = YES;
    
    [self.centerV setDocumentView:[self selectedIUViewManager]];
    
    //control tab view
    [self addTab:fileItem];

    /* redraw border */
    [[NSUserDefaults standardUserDefaults] setBool:[[NSUserDefaults standardUserDefaults] boolForKey:@"showBorder"] forKey:@"showBorder"];
    [[NSUserDefaults standardUserDefaults] setBool:[[NSUserDefaults standardUserDefaults] boolForKey:@"showShadow"] forKey:@"showShadow"];
    [NSThread detachNewThreadSelector:@selector(getAllIUFrame) toTarget:self withObject:nil];
}



-(void)removeFileItem:(MGFileItem*)item{
    
    //can't remove default file item
    //comp.coiu, template.tmiu
    if(item.defaultFile) return;
    
    NSLog(@"parent (remove pressed)-----");
    NSLog([item.parent.children description], nil);
    NSLog(@"-----------");
    
    NSLog(@"remove file : %@", [item description]);
    IUManager *iuManager = [self iuManagerOfFileItem:item];
    
    if (iuManager) {
        [iuManager.rootIU deleteAsFile];
        [item removeFromSuperFileItem];
        [iuManager.pWC.IUManagers removeObjectForKey:item.absolutePath];
        if(item.type == MGFileItemTypePGIU)
        [iuManager.pWC.project.pageFileItems removeObjectForKey:item.name];
        else if(item.type == MGFileItemTypeCOIU)
        [iuManager.pWC.project.compFileItems removeObjectForKey:item.name];
    }
    else{
        /* if file is not existed */
        [item removeFromSuperFileItem];
    }
    
    [leftVC.fileIns reloadItem:item.parent];
    [self removeTab:item];
    [self.project save];
    [JDLogUtil log:@"file" log:[NSString stringWithFormat:@"file removed : %@", item.absolutePath]];
    
    NSLog(@"parent (remove pressed 2)-----");
    NSLog([item.parent.children description], nil);
    NSLog(@"-----------");
}





#pragma mark -
#pragma mark copy & paste
-(void)copy:(id)sender{
    // do not use NSPasteBoard : there is no reason to use it.
    // just save to app delegate
    MGAppDelegate *appDelegate = (MGAppDelegate*)[NSApp delegate];
    appDelegate.IUPasteBoard = self.iuController.selectedObjects;
}


-(void)paste:(NSEvent*) theEvent{
    MGAppDelegate *appDelegate = (MGAppDelegate*)[NSApp delegate];
    NSArray *ius = appDelegate.IUPasteBoard;
    if ([ius count] == 0) {
        return;
    }
    if ([self.iuController.selectedObjects count] != 1) {
        return;
    }
    IUView *parent = [self.iuController.selectedObjects objectAtIndex:0];
    if ([parent isKindOfClass:[IUView class]] == NO) {
        parent = parent.parent;
    }
    else if ([ius count] == 1 && [ius objectAtIndex:0] == parent){
        parent = parent.parent;
    }
    
    [self.selectedIUManager pasteIUs:ius toIU:parent];
}



- (void)showSourceWCWithIdx:(NSUInteger)idx{
    
    sourceWC.selectedIU = [self.iuController.selectedObjects objectAtIndex:0];
    sourceWC.selectedIdx = idx;

    [self.window beginSheet:sourceWC.window completionHandler:^(NSModalResponse returnCode){
        [sourceWC.window orderOut:nil];
    }];
}

- (void)sync:(NSString*)remote branch:(NSString*)branch message:(NSString*)message{
    if ([remote length]==0 || [branch length]==0 || [message length]==0){
        [JDLogUtil alert:@"Input all fields (remote, branch, message)"];
        return;
    }
    @try {
        [self.project.gitUtil addAll];
        [self.project.gitUtil commit:message];
        [self.project.gitUtil push:remote branch:branch];
        [JDLogUtil alert:@"Success" title:@"Sync Result"];
    }
    @catch (NSException *exception) {
        int status = [[JDFileUtil util] lastStatusCode];
        if (status != 0) {
            [JDLogUtil alert:exception.reason];
        }
    }
}


- (void)callSetGhostImage{
    self.ghostPopover.behavior = NSPopoverBehaviorTransient;
    [self.ghostPopover showRelativeToRect:[self.ghostButton bounds] ofView:self.ghostButton preferredEdge:NSMinYEdge];
    self.inspectorVC.currentInsType = 0;
}


-(void)build:(id)sender{
    IUCompileResult *result = [self.project buildProject];
    [self showCompileResult:result];
}



#pragma mark - 
#pragma mark ScreenType
-(void)setSelectedScreenType:(IUScreenType)selectedScreenType{
    //view frame(webkit) resetSize
    _selectedScreenType = selectedScreenType;
    
    //화면을 resize 하고
    for (IUManager *manager in IUManagers){
        [manager.iuViewManager resetSizeWithScreenType:selectedScreenType];
        [manager.iuViewManager disableUpdate:self];
    }
    
    //notification을 불러서 각각 IUFrame의 CurrType 을 바꿔준다.
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ScreenTypeDidChangeNotification" object:self];
    
    //코드가 더러워졌으므로 그냥 리셋 한 번 돌린다.
    for (IUManager *manager in IUManagers){
        [manager.iuViewManager reset];
        [manager.iuViewManager enableUpdate:self];
    }

    [NSThread detachNewThreadSelector:@selector(getAllIUFrame) toTarget:self withObject:nil];
}


-(void)getAllIUFrame{
    [NSThread sleepForTimeInterval:0.2];
    [self.selectedIUManager.iuViewManager performSelectorOnMainThread:@selector(getAllIUFrame) withObject:nil waitUntilDone:YES];
}


#pragma mark -
#pragma mark TabView Part

-(void)addTab:(MGFileItem *)item{
    [tabView2 addTabWithRepresentedObject:item];
    
}
-(void)removeTab:(MGFileItem *)item{
    [tabView2 removeTabOfItem:item];
}

#pragma mark TabView Delegate
- (void)tabView:(SFTabView *)tabView didAddTab:(CALayer *)tab {
}

- (void)tabView:(SFTabView *)tabView didRemovedTab:(CALayer *)tab {
}

- (BOOL)tabView:(SFTabView *)tabView shouldSelectTab:(CALayer *)tab {
    return YES;
}

- (void)tabView:(SFTabView *)tabView didSelectTab:(CALayer *)tab {

    MGFileItem *fileItem;
    
    if([[((SFDefaultTab *)tab) representedObject] objectForKey:@"fileItem"] != nil){
        fileItem = [[((SFDefaultTab *)tab) representedObject] objectForKey:@"fileItem"];
    }else{
        DLog(@"Bug");
    }
    if(currFile != fileItem){
        [self.leftVC.fileIns setSelectRowFromTab:fileItem];
    }
}

- (void)tabView:(SFTabView *)tabView willSelectTab:(CALayer *)tab{
    
}

#pragma mark -
#pragma mark bottom View Part (Button Action)

- (IBAction)pressRefreshBtn:(id)sender {
    [self.selectedIUManager.iuViewManager reset];
}

- (IBAction)pressGhostBtn:(id)sender {
    BOOL showGhost = [[NSUserDefaults  standardUserDefaults] boolForKey:@"showGhost"];
    if(showGhost && self.selectedIUManager.rootIU.sampleImage == nil){
        //focus to image
    }
}



-(NSImage *)image:(NSString*)imageResourceString{
    return [self.imageVC image:imageResourceString];
}

#pragma mark -
#pragma mark undo

-(NSUndoManager *)windowWillReturnUndoManager:(NSWindow *)window{
    return self.selectedIUManager.undoManager;
}

@end

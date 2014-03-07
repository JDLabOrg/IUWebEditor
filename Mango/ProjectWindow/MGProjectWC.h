//
//  MGProjectWC.h
//  Mango
//
//  Created by JD on 13. 2. 8..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
#import "IUObjs.h"
#import "IUController.h"
#import "IUProject.h"
#import "MGCollectionViewItem.h"
#import "SFTabView.h"
#import "IUGhostImageView.h"
#import "MGNewProjectWC.h"
#import "IUTextToolbarVC.h"

@class IUManager;
@class IUViewManager;

@class MGInspectorVC;
@class MGPrefPanelWC;
@class JDOutlineView;
@class MGCollectionItem;
@class MGRootFileItem;
@class MGStackVC;
@class MGSourceVC;
@class MGLogWC;
@class IULeftVC;
@class MGImageViewController;
@class IUGhostImageView;
@class MGNewProjectWC;

@interface MGProjectWC : NSWindowController <NSWindowDelegate, SFTabViewDelegate>{
    
    __weak NSToolbar *_toolbar;
    NSString    *imgBaseURLStr;
    IUProject           *project;
    
    IUController        *iuController;
    IUManager       *selectedIUManager;
    JDMutableArrayDict  *IUManagers;
    JDMutableArrayDict  *IUViewManagers;
   
/*File tab View*/
    IBOutlet SFTabView *tabView2;

}

/*Manage part*/

@property IBOutlet IUController     *iuController;
@property IUManager                 *selectedIUManager;
@property JDMutableArrayDict  *IUManagers;
@property IUProject         *project;
@property MGImageViewController *imageVC;

@property (strong) IBOutlet NSArrayController *imageArrayController;

/* Toolbar */
@property (weak) IBOutlet NSToolbar *toolbar;

/* Text ToolBar*/
@property (weak) IBOutlet NSView *textToolbarContainerV;
@property IUTextToolbarVC *textToolbarVC;

/*Left View*/
@property IBOutlet IULeftVC *leftVC;


/* Right View*/
@property IBOutlet MGInspectorVC             *inspectorVC;
@property (strong) IBOutlet MGStackVC *stackVC;

- (IBAction)pressGhostBtn:(id)sender;

/* Center View*/
/* canvas view*/
@property (weak) IBOutlet NSScrollView *centerV;


/* bottom view connect: easy to manage bottom menu constraint */
@property (weak) IBOutlet NSView *bottomView;
@property (strong) IBOutlet NSView *bottomMenuView;

@property (assign) IBOutlet NSButton *ghostButton;
@property (strong) IBOutlet NSPopover *ghostPopover;
@property (weak) IBOutlet IUGhostImageView *ghostImageView;


- (IBAction)pressRefreshBtn:(id)sender;


/* decide screen type */
@property (nonatomic) IUScreenType selectedScreenType;


/* initialize */
-(id)initWithWindowNibName:(NSString *)windowNibName projectFilePath:(NSString*)path;

/* Window Menu, called from toolbar or appcontroller  */
- (void)openNewFileWindow:(id)sender;
- (void)pressMenuSync:(id)sender;
- (void)pressMenuShowSource:(id)sender;
- (void)showOpenProjectModal:(id)sender;
- (void)showCompileResult:(IUCompileResult*)result;
- (void)build:(id)sender;
- (void)showSourceWCWithIdx:(NSUInteger)idx;
- (void)sync:(NSString*)remote branch:(NSString*)branch message:(NSString*)message;
- (void)callSetGhostImage;

/* project current value*/
- (IUViewManager*) selectedIUViewManager;

/* manage project, file*/
- (void)showNewProject:(IUStartType)type;

- (void)saveAllProject;
- (void)loadProjectAtFilePath:(NSString*)path;

- (IUManager*)iuManagerOfFileItem:(MGFileItem*)fileItem;
- (NSArray*)iuManagerOfFileItems:(NSArray*)fileItems;
- (IUManager*)iuManagerOfFileName:(NSString*)fileName;

- (void)setProjectResource:(MGFileItem*)fileItem;
- (void)setCurrFile:(MGFileItem*)fileItem;

- (void)removeFileItem:(MGFileItem*)item;
-(NSImage *)image:(NSString*)imageResourceString;
@end
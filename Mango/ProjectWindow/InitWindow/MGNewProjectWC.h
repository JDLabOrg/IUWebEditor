//
//  MGInitWC3.h
//  Mango
//
//  Created by JD on 13. 5. 10..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
#import "MGNewProjectVC.h"
#import "IUDefinition.h"

@class  MGProjectWC;
@class MGSampleProjectSelectionVC;



@interface MGNewProjectWC : NSWindowController{
    __weak NSView *_mainV;
    MGProjectWC             *_pWC;
    IUProject           *_project;
    MGNewProjectVC *_nextVC;
    NSView *_defaultNextV;
    
    //startType
    IUStartType startType;
}
@property (weak) IBOutlet NSTabView *tabView;

/* new project */
@property (strong) IBOutlet NSView *firstV;
@property (weak) IBOutlet NSView *mainV;
@property (weak) IBOutlet NSButton *prevBtn;
@property (weak) IBOutlet NSButton *nextBtn;

@property (strong) IBOutlet NSArrayController *projectTypeAC;
@property (strong) IBOutlet NSView *defaultNextV;
@property (weak) IBOutlet NSCollectionView *collectionV;

/* template project*/
@property (weak) IBOutlet NSView *templateV;
@property  MGSampleProjectSelectionVC *templateProjectVC;

/* recent project*/
@property (strong) IBOutlet NSArrayController *recentArray;
@property (weak) IBOutlet NSTableView *recentTableV;
@property (weak) IBOutlet NSCollectionView *recentCollectV;

//return to window
@property NSString *filePath;

- (id)initWithWindowNibName:(NSString *)windowNibName PWC:(MGProjectWC*)pWC startType:(IUStartType)aStartType;
- (void)selectTabViewItemAtIndex:(NSInteger)index;
- (void)loadProject:(NSString *)loadPath type:(NSString *)type;

-(void)doubleClick:(id)sender;
    
//new project
- (IBAction)pressCancel:(id)sender;
- (IBAction)pressPrevBtn:(id)sender;
- (IBAction)pressNextBtn:(id)sender;
@end
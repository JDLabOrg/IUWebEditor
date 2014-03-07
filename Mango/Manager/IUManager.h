//
//  MGObjManager.h
//  Mango
//
//  Created by JD on 13. 2. 1..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>
#import "IUView.h"
#import "JDOutlineView.h"
#import "IUFile.h"
#import "IUPointLayer.h"

@class MGCanvasVC;
@class MGProjectWC;
@class IUCoordinationPointView;
@class MGFileItem;
@class IUPointLayer;
@class IUProject;
@class IUFrameManager;
@class IUViewManager;

@interface IUManager : NSResponder <NSOutlineViewDataSource, NSOutlineViewDelegate>
{
    MGFileItem        *fileItem;
    NSUInteger      *selectStatus;

    IUFile          *rootIU;
    IUObj           *lastIU;
    
    MGProjectWC     *pWC;

    
    BOOL    mouseDragged;
    BOOL    mouseClickedAtSelectedIU;
    
    NSUInteger      numOfIU;
    
    NSString *mouseIU;
    
    JDMutableArrayDict  *exposedIUs;
    NSMutableDictionary        *variables;
    
    IUCoordinationPointView *selectedPointV;
    NSDictionary        *autoHDict;
}

@property IUObj                 *clickedObj;
@property IUViewManager         *iuViewManager;
@property IUFrameManager        *frameManager;

@property NSMutableDictionary   *variables;
@property JDMutableArrayDict    *exposedIUs;
@property NSUInteger numOfIU;
@property (readonly) IUProject *project;

@property   NSInteger   currMouseX;
@property   NSInteger   currMouseY;
@property   NSInteger   currMouseInParentX;
@property   NSInteger   currMouseInParentY;
@property   NSPoint     currMouseInParent;
@property   IUView *currMouseParent;
@property MGProjectWC   *pWC;
@property IUFile        *rootIU;
@property BOOL          mouseDown;
@property (nonatomic) BOOL isSelected;

@property NSUndoManager *undoManager;


- (id)initWithFileItem:(MGFileItem*)fileItem projectWindow:(MGProjectWC*)pWC;
- (NSString*)makeNewIUName:(NSString*)className;
- (IUObj*)childIUOfName:(NSString*)name ofIU:(IUObj*)iu;
-(BOOL)validateName:(NSString*)name err:(NSError**)err;

-(void)mouseDown:(NSEvent*)theEvent;
-(void)mouseUp:(NSEvent*)theEvent;
-(void)mouseDragged:(NSEvent*)theEvent;



-(void)removeCurrentIU;

-(void)IUPointDown:(IUPointLayer*)pLayer event:(NSEvent*)event;

-(IUObj*)makeIU:(NSString*)iuType atViewManagerPoint:(NSPoint)vManagerPoint properties:(NSDictionary*)properties;

-(NSString*)filePath;


-(NSString*)fileNameOfFullIUName:(NSString*)fullIUName;
-(NSString*)IUNameOfFullIUName:(NSString*)fullIUName;

-(void)pasteIUs:(NSArray*)ius toIU:(IUView*)iu;
-(void)moveIU:(IUObj *)iu toDifferentParentIU:(IUView *)parentIU atIndex:(NSInteger)index;

#pragma mark objs embed in
-(BOOL)isSameParentforSelectedObjects;
-(NSMenuItem *)embedMenuItem;

@end
//
//  IUViewManager.h
//  Mango
//
//  Created by JD on 13. 5. 24..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>
#import "IUGridView.h"

@class IUManager;

@interface IUViewManager  : NSView{
    WebView     *editWebV;
    IUGridView  *gridView;    

    //Handle ID rootIU and project
    IUFile          *rootIU;
    MGProjectWC     *pWC;
    
}


@property     BOOL        isOpenTextView;
@property   NSString        *initialWebSource;
@property   NSMutableString *jsLog;

//@property int disableUpdateLevel;
//@property int disableSelectionLevel;

-(void)enableSelection:(id)sender;
-(void)disableSelection:(id)sender;

//Handle IUObj
@property   (nonatomic) IUManager   *manager;
@property   NSUInteger location;
@property   IUObj   *iu;


-(void)setIUNeedsDisplay:(IUObj*)obj type:(IUNeedsDisplayActionType)type;
-(void)setInsertedIUNeedsDisplay:(IUObj*)obj;
-(void)setDeletedIUNeedsDisplay:(IUObj*)obj;

-(void)resetSize;
-(void)resetSizeWithScreenType:(IUScreenType)type;


-(void)setGridGhostImage:(NSImage *)image;
-(void)setGridGhostXModifier:(NSUInteger)x;
-(void)setGridGhostYModifier:(NSUInteger)y;

-(void)reset;
-(void)update;

// disable refresh has depth!!! if you call disable refresh two times, you should call enable refresh two times, too;
-(void)disableUpdate:(id)sender;
-(void)enableUpdate:(id)sender;

-(BOOL)isUpdateEnabled;

#pragma mark -
#pragma mark call JS function

-(id)runOneLineJS:(NSString *)js;

-(CGFloat)getTextWidth:(IUText*)obj;
-(CGFloat)getTextHeight:(IUText*)obj;

-(CGFloat)getPercentWidth:(IUObj *)obj withX:(CGFloat)x;
-(CGFloat)getPercentHeight:(IUObj *)obj withY:(CGFloat)y;



-(void)setAssistantLine:(id)sender;
-(void)setBorderLayer:(id)sender;
-(void)setShadowLayer:(id)sender;

-(void)selectIUJS;
-(void)getAllIUFrame;

#pragma mark -
#pragma mark Text Editor
-(void)enableTextEditor:(IUObj *)clickedObj;
-(void)disableTextEditor;
-(void)makeTextVFirstResponder;
@end
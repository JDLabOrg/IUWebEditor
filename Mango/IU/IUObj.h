//
//  MGObject.h
//  Mango
//
//  Created by JD on 13. 1. 27..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>

#import "IUEventMouseOn.h"
#import "IUProperty.h"
#import "IUEvent.h"
#import "IUAssistantLayer.h"
#import "IUWidget.h"
#import "IUProject.h"
#import "JDKeyDelegatedTableView.h"
#import "IUScreenFrame.h"
#import "IUBorderLayer.h"
#import "IUShadowLayer.h"
#import "IUDefinition.h"

#define IUDirectionUp 0
#define IUDirectionDown 1
#define IUDirectionLeft 2
#define IUDirectionRight 3


@class IUFile;
@class IUView;
@class IUManager;
@class IUController;
@class IUBG;
@class IUFrame2;
@class IUCSS;
@class IUFrameManager;

@protocol IUObjProtocol <NSObject>
@optional
-(BOOL)shouldInsertIU:(IUObj **)insertedIU;
-(BOOL)shouldBeInsertedByUser:(IUView**)parent atIndex:(NSUInteger*)zIndex;

//current on protocol. not used
-(BOOL)shouldBeMovedByUser:(IUView*)newParent;
-(BOOL)shouldMoveIU:(IUObj*)moveIU;


-(BOOL)shouldChangeFlowLayoutByUserInput:(BOOL)flowLayout;
-(BOOL)shouldChangeZByUserInput:(NSInteger)z;
-(BOOL)shouldChangeBGColorByUserInput:(NSColor*)color;

@end


@interface IUObj : IUProperty <NSPasteboardWriting, JDKeyDelegateTableViewProtocol, NSTableViewDataSource, NSTableViewDelegate, IUObjProtocol, NSCopying>{
    NSDictionary *loadedDict;
    
    /* view system */
    NSDictionary        *objDict;
    NSString        *webSource;
    BOOL            showOverflow;
}



@property NSString  *displayText;


/* source */
@property   (nonatomic) NSString    *CSSSource;
@property   (nonatomic) NSString    *HTMLID;

/* following are properities */
@property (nonatomic) NSString      *name;
@property (nonatomic) NSString      *link;
@property (nonatomic) NSString      *divLink;
@property (nonatomic) BOOL          visible;
@property (nonatomic) float         opacity;
@property (nonatomic) NSString      *cursorType;
@property (nonatomic) NSString      *cursor;
@property BOOL          draggable;
@property BOOL          exposeBinding;
@property IUEvent       *event;
@property (nonatomic) BOOL          showOverflow;

/* structure */
@property (nonatomic, weak) IUManager     *iuManager;
@property IUFrame2       *iuFrame;
@property IUFrameManager *frameManager;
@property IUBG          *bg;
@property IUCSS         *css;
@property IUView       *parent;

/* structure for supported lines */
@property NSUInteger    lineLocation;
@property IUAssistantLayer* assitLayer;
@property BOOL          disableBorderLayer;
@property IUBorderLayer* borderLayer;
@property BOOL          enableShadowLayer;
@property IUShadowLayer *shadowLayer;


/* status */
@property BOOL          iuLoaded;
@property BOOL          loadFromFile;
@property NSInteger z;


- (IUProject*)project;

- (void)loadWithDict:(NSDictionary*)dict;
- (id)instantiate;
- (NSMutableDictionary*)dict;
- (void)iuLoad;
+ (NSImage*)classImage;
+ (NSString*)displayName;


- (NSMutableDictionary*)CSSDictWithScreenType:(IUScreenType)screenType;
- (NSMutableString*)CSSSourceWithScreenType:(IUScreenType)screenType;

- (NSMutableDictionary*)HTMLDict2;
- (NSMutableDictionary*)outputDict2;


/* web structure        */
/* override by subclass */
-(NSString*)HTMLTag2;
-(BOOL)appendClosingTag;
-(NSString*)preHTML2;
-(NSString*)postHTML2;

/* web */
-(NSString*)innerHTML2:(id)caller;
-(NSMutableString*)innerOutputHTML2;
-(void)autoSetIUName;


/* get information of object */
- (NSData*)IUMLData;
- (NSString*)fullIUName;
- (IUFile*)rootIU;


/* action */
- (BOOL)removeFromSuperIU:(id)sender;


//focus : if it is selected, and only it is selected, call it as 'focus'
-(BOOL)hasFocus;
-(IUObj*)requestFocusAvariableIU;

-(void)moveX:(CGFloat)x Y:(CGFloat)y;
-(void)moveMarginLeft:(CGFloat)left Top:(CGFloat)top;
-(void)moveLeftLine:(int)x originalRect:(NSRect)rect;
-(void)moveRightLine:(int)x originalRect:(NSRect)rect;
-(void)moveTopLine:(int)y originalRect:(NSRect)rect;
-(void)moveBottomLine:(int)y originalRect:(NSRect)rect;

- (void)moveTo:(NSUInteger)IUDirection;
- (void)flowLayoutMoveTo:(NSUInteger)IUDirection;


-(NSMenuItem*)subMenuSize;
-(NSUInteger)depth;

-(IUObj*)iuHitTest:(NSPoint)point;

-(NSMutableDictionary*)jsVariableDictionary;
-(NSMutableDictionary*)jsTriggerDictionary;
-(NSMutableDictionary*)jsReceiverDictionary;

-(void)setNeedsDisplayStartGrouping;;
-(void)setNeedsDisplayEndGrouping;
-(void)setNeedsDisplay:(IUNeedsDisplayActionType)type;

-(NSUInteger)index;

-(NSMutableString*)HTMLSource2:(id)sender;
-(NSMutableString*)outputHTMLSource2:(id)sender;
-(NSMutableString*)CSSStringForScreenType:(IUScreenType)type;


/*Right Menu*/
-(NSMenu*)popUpMenu;
+(IUWidget*)widget;


-(NSInteger)iuStyleType;
-(NSString*)HTMLChangeJavascript;
-(NSString*)CSSChangeJavascript;
-(NSString*)insertionJavascript;
-(void)javascriptDidInsert;


-(NSString*)HTMLClassString;
-(NSString*)outputHTMLClassString;

-(NSArray*)allParents;

-(void)fitToImage;

#pragma mark table
-(void)reloadMQTable;


-(void)becomeFocusedIU;


-(BOOL)shouldChangeXByUserInput:(CGFloat)x;
-(BOOL)shouldChangeYByUserInput:(CGFloat)y;
-(BOOL)shouldChangeWidthByUserInput:(CGFloat)w;
-(BOOL)shouldChangeHeightByUserInput:(CGFloat)h;

@end
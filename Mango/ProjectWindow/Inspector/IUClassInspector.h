//
//  IUClassInspector.h
//  Mango
//
//  Created by JD on 13. 2. 14..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
#import "MGProjectWC.h"

#import "IUInspectorViewItemManager.h"


@class MGCollectionItem;
@class IUController;
@class JDDragAndDropImageV;

@interface IUClassInspector : NSViewController <NSTableViewDataSource, NSTableViewDelegate, IUInspectorViewItemManagerDelegate, JDKeyDelegateTableViewProtocol>
{

}

@property MGProjectWC *pWC;
@property IUController      *iuController;

/* Inspector View */

@property (weak) IBOutlet NSTableView *tableV;

//cell
@property (strong) IBOutlet NSView *IUPage;

//not yet completed - it's view in xib but cut the connection
//@property (strong) IBOutlet NSView *IUGroup;

@property (strong) IBOutlet NSView *IUText;
@property (strong) IBOutlet NSView *IUTemplate;
@property (strong) IBOutlet NSView *IUHeader;
@property (strong) IBOutlet NSView *IUFooter;
@property (strong) IBOutlet NSView *IURender;
@property (strong) IBOutlet NSView *IUImage;
@property (strong) IBOutlet NSView *IUTableList;
@property (strong) IBOutlet NSView *IUObj;
@property (strong) IBOutlet NSView *IUHTML;
@property (strong) IBOutlet NSView *IUTwitter;
@property (strong) IBOutlet NSView *IUMovie;
@property (strong) IBOutlet NSView *IUWebMovie;
@property (strong) IBOutlet NSView *IUFBLike;
@property (strong) IBOutlet NSView *IUMailLink;
@property (strong) IBOutlet NSView *IUCarousel;
@property (strong) IBOutlet NSView *IUView;
@property (strong) IBOutlet NSView *IUTextFieldEdit;
@property (strong) IBOutlet NSView *IUTransitionView;

@property (weak) IBOutlet JDKeyDelegatedTableView *IUObjMQSizeTV;

@property (strong) IBOutlet NSView *IUOverlapImage;
/* make link page */
@property (strong) IBOutlet NSArrayController *selectedPageDiv;
@property bool onDivLink;


@property (weak) IBOutlet JDDragAndDropImageV *imageTransationImageV;


/* Methods */
//init
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pWC:(MGProjectWC*)_pWC;

//link
- (IBAction)selectedPage:(id)sender;
- (NSArray *)divLinkSortDescriptors;
-(void)reloadDataMQSize;

@end

//
//  IUBindInspector.h
//  Mango
//
//  Created by JD on 13. 2. 22..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
#import "MGProjectWC.h"
#import "IUInspectorViewItemManager.h"

#define numberOfBindItems 4
#define kHoverBinding       @"Mouse-on Event"
#define kVariableReceiver   @"Variable Receiver : Visible Condition"
#define kVariableFrameReceiver  @"Variable Receiver : Frame"
#define kVariableTrigger    @"Variable Trigger"
#define kWebLangVisibleBinding  @"Visible by script"


@interface IUBindInspector : NSViewController <NSTableViewDataSource, NSTableViewDelegate, IUInspectorViewItemManagerDelegate>{
    MGProjectWC *pWC;
    NSMutableArray  *itemNameArray;

}



@property MGProjectWC *pWC;
@property (weak) IBOutlet NSTableView *tableV;



@property (strong) IBOutlet NSView *variableTriggerV;
@property (strong) IBOutlet NSView *animationV;
@property (strong) IBOutlet NSView *hoverBindingV;
@property (strong) IBOutlet NSView *visibleBindingV;
@property (strong) IBOutlet NSView *visibleBindingVariableV;
@property (strong) IBOutlet NSView *webLangVisibleBindingV;
@property (strong) IBOutlet NSView *actionBindingV;
@property (strong) IBOutlet NSView *receiverFrameV;

//Methods
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pWC:(MGProjectWC*)_pWC;

@end
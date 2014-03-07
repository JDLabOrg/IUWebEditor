//
//  IUCSSInspector.h
//  Mango
//
//  Created by JD on 13. 8. 28..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
#import "IUInspectorViewItemManager.h"

@class MGProjectWC;

#define numberOfCSSItems 3
#define kIUInspectorCSSColor @"Color"
#define kIUInspectorCSSShadow @"Shadow"
#define kIUInspectorCSSBorder @"Border"


@interface IUCSSInspector : NSViewController <NSTableViewDelegate, NSTableViewDataSource, IUInspectorViewItemManagerDelegate>{

    NSMutableArray *itemNameArray;
    
}

@property   MGProjectWC *pWC;

@property (strong) IBOutlet NSView *colorV;
@property (strong) IBOutlet NSView *shadowV;
@property (strong) IBOutlet NSView *borderV;

@property (weak) IBOutlet NSTableView* tableV;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pWC:(MGProjectWC*)pWC;

@end

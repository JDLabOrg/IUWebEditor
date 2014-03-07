//
//  IUObjInspector.h
//  Mango
//
//  Created by JD on 13. 2. 2..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
#import "IUManager.h"
#import "MGProjectWC.h"

@interface IUObjInspector : NSViewController <NSTableViewDataSource>{
    IUManager *IUManager;
    MGProjectWC *pWC;
}
@property (strong) IBOutlet NSView *contentV;
@property (weak) IBOutlet NSScrollView *v;

@property IUManager *IUManager;
@property MGProjectWC   *pWC;
@end

//
//  StackVC.h
//  Mango
//
//  Created by JD on 13. 4. 11..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
@class IUController;
@class MGProjectWC;

@interface StackVC : NSViewController <NSOutlineViewDataSource, NSOutlineViewDelegate>{
    
    __weak NSOutlineView *_outlineV;
    IUController        *controller;
}

@property IBOutlet MGProjectWC     *pWC;
@property (weak) IBOutlet NSOutlineView *outlineV;
@property IBOutlet IUController *controller;
@end
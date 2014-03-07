//
//  MGInspectorVC.h
//  Mango
//
//  Created by JD on 13. 2. 2..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
#import "IUClassInspector.h"
#import "IUBindInspector.h"

#define IUInspectorTypeMax 3


@class IUManager;
@class MGProjectWC;
@class IUCSSInspector;

@interface MGInspectorVC : NSViewController{
    NSViewController *currentIns;
    IUBindInspector *bindIns;
    IUCSSInspector  *cssIns;
    MGProjectWC *pWC;
    
    NSInteger currentInsType;
}

@property NSInteger currentInsType;
@property IUClassInspector *classIns;

-(void)setPWC:(MGProjectWC *)pwc;

@end

//
//  MGInitVC.h
//  Mango
//
//  Created by JD on 13. 10. 4..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
#import "MGProjectWC.h"
#import "IUWidget.h"

@interface MGNewProjectVC : NSViewController

-(BOOL)pressFinishBtn;

@property BOOL          nextEnabled;

@property (weak) MGProjectWC *pWC;
@property (weak) IUProject  *project;
@property IUWidget *initilizeWidget;

@end

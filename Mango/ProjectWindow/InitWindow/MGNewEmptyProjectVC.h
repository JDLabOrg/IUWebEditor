//
//  MGInitProjectVC.h
//  Mango
//
//  Created by JD on 13. 8. 26..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
#import "MGNewProjectVC.h"

@interface MGNewEmptyProjectVC : MGNewProjectVC

@property NSString      *cloud;
@property NSString      *git;
@property NSString      *appName;

@property BOOL          gitSelectDisable;

@end

//
//  MGInitRackVC.h
//  Mango
//
//  Created by JD on 13. 5. 9..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
#import "MGNewEmptyProjectVC.h"
#import "MGNewProjectVC.h"

@interface MGNewRackProjectVC : MGNewEmptyProjectVC <NSAlertDelegate>

@property NSUInteger      cloudIdx;
@property NSUInteger      gitIdx;
@property BOOL              herokuResult;

@property NSString          *myID;
@property NSString          *myPasswd;

@end

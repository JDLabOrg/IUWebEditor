//
//  MGAppDelegate.h
//  Mango
//
//  Created by JD on 13. 1. 26..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
#import "MGAppController.h"
@interface MGAppDelegate : NSObject <NSApplicationDelegate>{
    
}
- (IBAction)pressMenuBuild:(id)sender;
- (void)openProjectAtPath:(NSString*)path;

@property (weak) IBOutlet MGAppController *appController;
@property NSArray   *IUPasteBoard;
@end
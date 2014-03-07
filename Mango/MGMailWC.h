//
//  MGMailWC.h
//  Mango
//
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

#import <Cocoa/Cocoa.h>

@interface MGMailWC : NSWindowController
- (IBAction)send:(id)sender;
@property (assign) IBOutlet NSTextView *msg;
@property (assign) IBOutlet NSTextFieldCell *email;
@end

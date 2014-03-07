//
//  MGSourceWC.h
//  Mango
//
//  Created by JD on 13. 10. 1..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>

@interface MGSourceWC : NSWindowController
@property   IUObj       *selectedIU;

/* connected with outlet */
@property   NSUInteger  selectedIdx;
@property   NSString    *showString;


-(void)update;

@end
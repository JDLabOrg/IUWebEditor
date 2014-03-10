//
//  MGStackVC.h
//  Mango
//
//  Created by JD on 13. 4. 14..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//
@class IUController;

#import <Cocoa/Cocoa.h>
@interface MGStackVC : NSViewController <NSOutlineViewDelegate>{
    NSArray *dragNodesArray;
    __weak IUController *_iuController;
    BOOL multipleKeyDown;
    
}

@property (weak) IBOutlet JDOutlineView *outlineV;
@property (unsafe_unretained) IBOutlet MGProjectWC *pWC;
@property (weak) IBOutlet IUController *iuController;

-(void)moveUpIU:(id)sender;
-(void)moveDownIU:(id)sender;
-(void)changeUpperParent:(id)sender;
@end

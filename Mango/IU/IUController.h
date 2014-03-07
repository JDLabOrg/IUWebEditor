//
//  IUController.h
//  Mango
//
//  Created by JD on 13. 4. 10..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
#import "JDKeyDelegatedTableView.h"
#import "IUObj.h"

@class IUManager;
@class IUView;

@interface IUController : NSTreeController{
}

@property (readonly) IBOutlet id selection;
- (IUObj*)firstSelection;
- (IUView*)parentOfSelectedObject;
- (NSArray *)selectedPedigree;
- (NSIndexPath*)indexPathOfObject:(id)anObject;
- (void)setSelectionObjects:(NSArray*)objects;
- (void)setSelectionObject:(id)anObject;
- (void)addSelectionObject:(id)anObject;
- (void)updateIU:(IUNeedsDisplayActionType)type;
@end
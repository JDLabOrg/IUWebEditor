//
//  MGClassSelectViewItem.m
//  Mango
//
//  Created by JD on 13. 4. 8..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGCollectionViewItem.h"
#import "MGCollectionItem.h"

@interface MGCollectionViewItem ()

@property (strong) IBOutlet NSPopover *popover;

@end

@implementation MGCollectionViewItem{
    NSPopover *_popover;
}

-(void)awakeFromNib{
}


-(void)togglePopover{
      _popover.behavior = NSPopoverBehaviorTransient;
      [_popover showRelativeToRect:self.view.bounds ofView:self.view preferredEdge:NSMaxYEdge];
    
}


-(void)hidePopup{
    [_popover close];
}

-(void)doubleClick:(id)sender{
    [self togglePopover];
}
@end

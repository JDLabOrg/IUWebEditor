//
//  MGClassSelectViewItem.h
//  Mango
//
//  Created by JD on 13. 4. 8..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>


@interface MGCollectionViewItem  : NSCollectionViewItem{
}

-(void)togglePopover;
-(void)doubleClick:(id)sender;

@end

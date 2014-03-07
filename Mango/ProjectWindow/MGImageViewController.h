//
//  MGImageViewController.h
//  Mango
//
//  Created by JD on 13. 4. 10..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
#import "MGCollectionItem.h"


@class MGProjectWC;

@interface MGImageViewController : NSViewController <NSCollectionViewDelegate, MGCollectionItemDelegate>{
    MGProjectWC *pWC;
    NSMutableArray  *imageDataArray;
    NSTextField     *activatedTF;
}

@property NSMutableArray *imageDataArray;

- (void)setPWC:(MGProjectWC *)pwc;
- (void)refreshImage;
-(NSImage *)image:(NSString*)imageResourceString;
@end

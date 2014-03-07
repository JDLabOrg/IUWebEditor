//
//  MGCanvasVC2.h
//  Mango
//
//  Created by JD on 13. 5. 24..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>
@class IUViewManager;
@class MGProjectWC;
@class MGCanvasVC2;

@interface MGCanvasV2 : JDView <NSDraggingDestination>{
}
@property (unsafe_unretained) IBOutlet MGCanvasVC2 *vc;
@end

@interface MGCanvasVC2 : NSViewController {
    MGProjectWC *pWC;
    IUViewManager *viewManager;
    NSMutableDictionary *canvasVs;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pWC:(MGProjectWC*)pWC;

@property MGProjectWC   *pWC;
@property IUViewManager *viewManager;
@end
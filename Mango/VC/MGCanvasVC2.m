//
//  MGCanvasVC2.m
//  Mango
//
//  Created by JD on 13. 5. 24..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGCanvasVC2.h"
#import "IUViewManager.h"
#import "IULayerOld.h"


@implementation  MGCanvasV2



- (void)keyDown:(NSEvent *)event{
    [self.vc.pWC.selectedIUManager keyDown:event];
}


@end

@implementation MGCanvasVC2
@synthesize viewManager;
@synthesize pWC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pWC:(MGProjectWC*)_pWC;
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        pWC=_pWC;
        canvasVs = [[NSMutableDictionary alloc] init];
        [pWC addObserver:self forKeyPath:@"selectedIUManager" options:NSKeyValueObservingOptionInitial context:nil];
    }
    return self;
}

- (BOOL)acceptsFirstResponder{
    return YES;
}



@end

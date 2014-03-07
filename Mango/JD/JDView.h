//
//  JDView.h
//  Mango
//
//  Created by JD on 13. 3. 30..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Cocoa/Cocoa.h>

@class JDView;
@protocol JDViewHitTestHooker <NSObject>
- (NSView *)hitTestOfView:(JDView*)view point:(NSPoint)aPoint;
@end

@interface JDView : NSView{
    
}
-(void)removeAllSubview;
@end

@interface JDImageView : NSImageView

@end

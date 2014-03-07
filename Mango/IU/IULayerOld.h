//
//  IULayer.h
//  Mango
//
//  Created by JD on 13. 5. 29..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <QuartzCore/QuartzCore.h>
#import "IUView3.h"


//layer order : coverLayer - contentsLayer - bgImageLayer
/* IULayer */
/* IULayer accesses full properties of IUView3 */
/* IUView3 does not manipulates IULayer directly */


@interface IULayerOld : CALayer{
    IUView3 *iuView;
    IUFrame *iuFrame;
    CALayer *coverLayer;
    CALayer *bgImageLayer;
    CATextLayer *contentsLayer;

    NSMutableArray *bgImageRepeatLayers;
}


-(id)initWithIUView:(IUView3*)_iuView;

@property CATextLayer *contentsLayer;
@end
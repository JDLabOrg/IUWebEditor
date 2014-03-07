//
//  IUAnimation.h
//  Mango
//
//  Created by JD on 13. 6. 7..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUDefinition.h"
#import "IUProperty.h"


@interface IUAnimation : IUProperty{
    IUAnimationDirection direction;
    float duration;
}
@property IUAnimationDirection direction;
@property float duration;

@end
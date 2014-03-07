//
//  IUViewPage.h
//  Mango
//
//  Created by JD on 13. 7. 16..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUView3.h"

@interface IUViewPage : IUView3

@property IUView3   *bgV;
-(id)initWithIUFrame:(IUFrame*)_iuFrame bgView:(IUView3*)bgV wantsLayer:(BOOL)wantsLayer;
@end
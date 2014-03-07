//
//  IUViewTextView.h
//  Mango
//
//  Created by JD on 13. 7. 14..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//


#import "IUFrame.h"

@interface IUViewTextView : IUView3 <NSTextViewDelegate>

@property NSString  *text;
@property NSTextView *cell;

- (id)initWithIUFrame:(IUFrame *)_iuFrame;

@end

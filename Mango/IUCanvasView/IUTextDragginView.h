//
//  IUTextDragginView.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 3. 6..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface IUTextDragginView : NSTextView

//connect To IUTextToolbarVC
@property IBOutlet id delegate;


@end

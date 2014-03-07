//
//  MGStackCellV.h
//  WebGenerator
//
//  Created by jd on 2/1/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface MGStackCellV : NSTableCellView
@property   IUObj   *objectValue;

-(void)startEdit;
-(void)endEdit;

@end

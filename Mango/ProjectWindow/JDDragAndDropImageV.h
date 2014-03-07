//
//  NSToolbarImageV.h
//  WebGenerator
//
//  Created by JD on 1/18/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface JDDragAndDropImageV : NSImageView


@property   IBOutlet id insertionObj;

-(void)setInsertionKeyPath:(NSString *)insertionKeyPath;
-(void)registerForImageDraggedType:(NSString *)newDraggedType;

@end

//
//  IUWidget.h
//  WebGenerator
//
//  Created by JD on 12/9/13.
//  Copyright (c) 2013 jdlab.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IUWidget : NSObject
@property NSString      *name;
@property NSImage       *image;
@property NSString      *desc;

@property id            value;
@property NSDictionary  *param;
@end

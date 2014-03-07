//
//  MGCollectionItem.m
//  Mango
//
//  Created by JD on 13. 4. 10..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGCollectionItem.h"
@implementation MGCollectionItem

-(id)init{
    self = [super init];
    if (self) {
    }
    self.desc = @"description for Item";
    return self;
}


-(id)initWithImage:(NSImage*)image name:(NSString*)name delegate:(id<MGCollectionItemDelegate>)delegate tag:(NSUInteger)tag{
    self = [super init];
    if (self) {
        self.image = image;
        self.name = name;
        self.delegate = delegate;
        self.tag = tag;
        
    }
    return self;
}


-(id)initWithImage:(NSImage*)image name:(NSString*)name delegate:(id<MGCollectionItemDelegate>)delegate{
    self = [super init];
    if (self) {
        self.image = image;
        self.name = name;
        self.delegate = delegate;
    }
    return self;
}
@end

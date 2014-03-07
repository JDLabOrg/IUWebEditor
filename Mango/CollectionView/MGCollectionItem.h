//
//  MGCollectionItem.h
//  Mango
//
//  Created by JD on 13. 4. 10..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>

@class MGCollectionItem;

@protocol MGCollectionItemDelegate <NSObject>

@end

@interface MGCollectionItem : NSObject {
}

@property NSString  *name;
@property NSImage  *image;
@property id        value;

@property id<MGCollectionItemDelegate> delegate;
@property NSUInteger tag;
@property NSString  *desc;
@property NSAttributedString *longDesc;

-(id)initWithImage:(NSImage*)_image name:(NSString*)_name delegate:(id<MGCollectionItemDelegate>)_delegate;
-(id)initWithImage:(NSImage*)_image name:(NSString*)_name delegate:(id<MGCollectionItemDelegate>)_delegate tag:(NSUInteger)_tag;

@end

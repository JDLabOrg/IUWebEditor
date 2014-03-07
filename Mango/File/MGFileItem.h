//
//  MGFileItem.h
//  Mango
//
//  Created by JD on 13. 5. 13..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import <Foundation/Foundation.h>
#import "IUDefinition.h"


@class MGRootFileItem;

@interface MGFileItem : NSObject {
    MGFileItemType  type;
    NSString        *name;
    NSMutableArray  *children;
}

// encode / decode
-(MGFileItem*) initWithContents:(NSDictionary*)contents;
+(MGFileItem*) fileItemWithName:(NSString*)name type:(MGFileItemType)type;
-(NSDictionary*)dict;

// get information
-(MGFileItem*) firstFileItemOfChildren;
-(NSUInteger) indexFromParent;
-(MGFileItem*) childOfName:(NSString*)childName;
-(BOOL)isDirectory;
-(NSString*) absolutePath;

// add or remove
-(void)removeFromSuperFileItem;
-(void)addFileItem:(MGFileItem*)object;
-(void)insertFileItem:(MGFileItem*)object atIndex:(NSUInteger)index;
-(void)insertFileItem:(MGFileItem*)object afterItem:(MGFileItem*)item;
-(NSArray*)subFileItemsWithExtension:(NSString*)extenstion;

@property   MGFileItemType  type;
@property   NSString        *name;
@property   NSMutableArray  *children;
@property   MGFileItem      *parent;
//defaultFile cant be removed (tamplate default, comp default)
@property   BOOL            defaultFile;

-(MGRootFileItem*)rootFileItem;

@end

@class IUProject;
@interface MGRootFileItem : MGFileItem{
    IUProject *proj;
}
+(MGRootFileItem*) fileItemWithName:(NSString*)name type:(MGFileItemType)type project:(IUProject*)project;
-(MGRootFileItem*) initWithContents:(NSDictionary*)contents fromProject:(IUProject*)_proj;

-(BOOL)createSubDirectoryAndFileItems;
-(MGFileItem*) pageFileDirItem;
-(MGFileItem*) compFileDirItem;
-(MGFileItem*) templateFileDirItem;
-(NSArray*)contents;
@end
//
//  MGFileItem.m
//  Mango
//
//  Created by JD on 13. 5. 13..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGFileItem.h"

@implementation MGFileItem
@synthesize type;
@synthesize children;
@synthesize name;

#pragma mark -
#pragma mark initialize

+(MGFileItem*) fileItemWithName:(NSString*)name type:(MGFileItemType)type{
    MGFileItem *item = [[MGFileItem alloc] init];
    item.name = name;
    item.type = type;
    if (item.type == MGFileItemTypeProject || item.type == MGFileItemTypeDir) {
        item.children = [NSMutableArray array];
    }
    item.defaultFile = NO;
    return item;
}


-(MGFileItem*) initWithContents:(NSDictionary*)contents{
    self = [super init];
    if (self) {
        self.defaultFile  = [[contents objectForKey:@"defaultFile"] boolValue];
        
        if ([[contents objectForKey:@"type"] isEqualToString:@"project"]) {
            self.type = MGFileItemTypeProject;
        }
        else if ([[contents objectForKey:@"type"] isEqualToString:@"directory"]) {
            self.type = MGFileItemTypeDir;
        }
        
        self.name = [contents objectForKey:@"name"];
        
        if([[self.name pathExtension] isEqualToString:@"pgiu"]){
            self.type = MGFileItemTypePGIU;
        }else if([[self.name pathExtension] isEqualToString:@"coiu"]){
            self.type = MGFileItemTypeCOIU;
        }else if([[self.name pathExtension] isEqualToString:@"tmiu"]){
            self.type = MGFileItemTypeTMIU;
        }
        
        if (self.type == MGFileItemTypeProject || self.type == MGFileItemTypeDir) {
            self.children = [NSMutableArray array];
            
            NSArray *childrenArray = [contents objectForKey:@"children"];
            for (NSDictionary *childContent in childrenArray) {
                [self addFileItem:[[MGFileItem alloc] initWithContents:childContent]];
            }
        }
        
        [self addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionPrior context:nil];
    }
    return self;
}

-(NSDictionary*)dict{
    NSMutableDictionary *myDict = [NSMutableDictionary dictionary];
    [myDict setObject:self.name forKey:@"name"];
    [myDict setBool:self.defaultFile forKey:@"defaultFile"];
    if (type == MGFileItemTypeDir) {
        [myDict setObject:@"directory" forKey:@"type"];
    }
    else{
        [myDict setObject:@"file" forKey:@"type"];
    }
    NSMutableArray *childrenArray = [NSMutableArray array];
    for (MGFileItem *child in children) {
        [childrenArray addObject:[child dict]];
    }
    if ([childrenArray count]) {
        [myDict setObject:childrenArray forKey:@"children"];
    }
    return myDict;
}

#pragma mark -
#pragma mark set attributes

-(void) nameWillChange{
    [self willChangeValueForKey:@"absolutePath"];
}

-(void)nameDidChange{
    [self didChangeValueForKey:@"absolutePath"];
}


-(MGFileItem*) firstFileItemOfChildren{
    for (MGFileItem* child in children) {
        if (child.type == MGFileItemTypePGIU
            || child.type == MGFileItemTypeTMIU
            || child.type == MGFileItemTypeCOIU) {
            return child;
        }
        else {
            if ([child firstFileItemOfChildren] != nil) {
                return [child firstFileItemOfChildren];
            }
        }
    }
    return nil;
}

-(MGRootFileItem*)rootFileItem{
    MGFileItem *item = self.parent;
    while (1) {
        item = item.parent;
        if (item.parent == nil) {
            if ([item isKindOfClass:[MGRootFileItem class]]) {
                return (MGRootFileItem*)item;
            }
            return nil;
        }
    }
}

-(NSArray*)subFileItemsWithExtension:(NSString*)extenstion{
    NSMutableArray *arr=[NSMutableArray array];
    if (self.type == MGFileItemTypeDir || self.type == MGFileItemTypeProject) {
        for (MGFileItem *item in self.children) {
            NSArray *appendArr = [item subFileItemsWithExtension:extenstion];
            [arr addObjectsFromArray:appendArr];
        }
    }
    if ([[self.name pathExtension] isEqualToString:extenstion]) {
        return @[self];
    }
    return arr;
}


-(NSString*)description{
    return [NSString stringWithFormat:@"%@ %@", [super description], self.absolutePath];
}

-(NSUInteger)indexFromParent{
    return [self.parent.children indexOfObject:self];
}

-(MGFileItem*) childOfName:(NSString*)childName{
    for (MGFileItem *child in children) {
        if (child.type == MGFileItemTypeDir) {
            MGFileItem *item = [child childOfName:childName];
            if (item) {
                return item;
            }
        }
        if ([child.name isEqualToString:childName]) {
            return child;
        }
    }
    return nil;
}

-(void)removeFromSuperFileItem{
    [self.parent.children removeObject:self];
}

-(BOOL)isDirectory{
    if (type == MGFileItemTypeProject || type == MGFileItemTypeDir) {
        return YES;
    }
    return NO;
}

- (BOOL)changeLastComponentName:(NSString*)lastComponentName{
    return NO;
}


-(void)insertFileItem:(MGFileItem*)object afterItem:(MGFileItem*)item{
    NSUInteger idx = [children indexOfObject:item];
    [self insertFileItem:object atIndex:idx+1];
}

-(void)addFileItem:(MGFileItem*)object{
    [[self mutableArrayValueForKey:@"children"] addObject:object];
    [object setParent:self];
}

-(void)insertFileItem:(MGFileItem*)object atIndex:(NSUInteger)index{
    [self.children insertObject:object  atIndex:index];
    [object setParent:self];
}

-(NSString*)absolutePath{
    return [[self.parent absolutePath] stringByAppendingPathComponent:self.name];
}


@end

@implementation MGRootFileItem

-(void)setProject:(IUProject*)_project{
    proj = _project;
}

+(MGRootFileItem*) fileItemWithName:(NSString*)name type:(MGFileItemType)type project:(IUProject *)project{
    MGRootFileItem *item = [[MGRootFileItem alloc] init];
    item.name = name;
    item.type = type;
    item.project = project;
    item.children = [NSMutableArray array];
    return item;
}

-(NSString*)absolutePath{
    return [proj.fileDir stringByAppendingPathComponent:proj.IUMLDir];
}

-(MGRootFileItem*) initWithContents:(NSArray*)childrenContent fromProject:(IUProject*)_proj{
    self = [super init];
    if (self) {
        self = [super init];
        [self addObserver:self forKeyPath:@"name" options:0 context:nil];

        self.type = MGFileItemTypeProject;
        self.name = _proj.appName;
        self.children = [NSMutableArray array];
        proj = _proj;
        
        for (NSDictionary *childContent in childrenContent) {
            [self addFileItem:[[MGFileItem alloc] initWithContents:childContent]];
        }
    }

    return self;
}

-(MGFileItem*) pageFileDirItem{
    return [self childOfName:@"page"];
}

-(MGFileItem*) compFileDirItem{
    return [self childOfName:@"comp"];
}

-(MGFileItem*) templateFileDirItem{
    return [self childOfName:@"template"];
}

-(BOOL)createSubDirectoryAndFileItems{
    MGFileItem *pageDir = [MGFileItem fileItemWithName:@"page" type:MGFileItemTypeDir];
    MGFileItem *templateDir = [MGFileItem fileItemWithName:@"template" type:MGFileItemTypeDir];
    MGFileItem *compDir = [MGFileItem fileItemWithName:@"comp" type:MGFileItemTypeDir];
    
    [self addFileItem:pageDir];
    [self addFileItem:templateDir];
    [self addFileItem:compDir];
    
    [JDFileUtil mkdirPath:pageDir.absolutePath atDirecory:@"/"];
    [JDFileUtil mkdirPath:templateDir.absolutePath atDirecory:@"/"];
    [JDFileUtil mkdirPath:compDir.absolutePath atDirecory:@"/"];
    
    return YES;
}

-(NSArray*)contents{
    NSMutableArray *array = [NSMutableArray array];
    for (MGFileItem *item in self.children) {
        [array addObject:item.dict];
    }
    return array;
    
}


@end

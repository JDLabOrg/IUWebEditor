//
//  IUController.m
//  Mango
//
//  Created by JD on 13. 4. 10..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUController.h"
#import "IUObjs.h"
#import "JDObjectExtension.h"

@implementation IUController

- (id)selection{
    if ([self.selectedObjects count] == 1) {
        return [[self selectedObjects] objectAtIndex:0];
    }
    return [super selection];
}

- (IUObj*)firstSelection{
    if ([self.selectedObjects count] > 0) {
        return [[self selectedObjects] objectAtIndex:0];
    }
    return nil;
}


-(IUView*)parentOfSelectedObject{
    if ([self.selectedObjects count] == 0) {
        return nil;
    }
    IUObj *selectedIU = [self.selectedObjects objectAtIndex:0];
    return selectedIU.parent;
}

-(NSArray*)selectedPedigree{
    if ([self.selectedObjects count]==0) {
        return nil;
    }
    
    IUObj *firstObj = [self.selectedObjects objectAtIndex:0];
    NSMutableArray *firstPedigrees = [[firstObj classPedigree] mutableCopy];
    NSMutableArray *retArray = [firstPedigrees mutableCopy];
    
    for (NSString *aPedigree in firstPedigrees) {
        for (IUObj *obj in self.selectedObjects) {
            Class class = NSClassFromString(aPedigree);
            if ([obj isKindOfClass:class] == NO) {
                [retArray removeObject:aPedigree];
            }
        }
    }
    
    return retArray;
}

+ (NSSet *)keyPathsForValuesAffectingSelectedPedigree {
    return [NSSet setWithObjects:@"selectedObjects", nil];
}

- (void)setSelectionObject:(id)anObject{
    [self willChangeValueForKey:@"selection"];
    if (anObject == nil) {
        return;
    }
    NSIndexPath *path = [self indexPathOfObject:anObject];
    [self setSelectionIndexPath:path];
    [self didChangeValueForKey:@"selection"];
}

- (void)addSelectionObject:(id)anObject{
    NSIndexPath *path = [self indexPathOfObject:anObject];
    [self addSelectionIndexPaths:@[path]];
}

-(IUObj*)objectAtIndexPath:(NSIndexPath *)indexPath{
    NSAssert([indexPath indexAtPosition:0] == 0, @"wrong index path");
    IUView *obj = [[self content] objectAtIndex:0];
    for (int i=1; i <indexPath.length; i++){
        NSUInteger index = [indexPath indexAtPosition:i];
        if ([obj.children count] > index) {
            //if object is deleted, out of range
            obj = [obj.children objectAtIndex:[indexPath indexAtPosition:i]];
        }
        else{
            return nil;
        }
    }
    return obj;
}

- (BOOL)setSelectionIndexPath:(NSIndexPath *)indexPath{
    IUObj *iu = [self objectAtIndexPath:indexPath];
    [iu becomeFocusedIU];
    return [super setSelectionIndexPath:indexPath];
}

- (BOOL)setSelectionIndexPaths:(NSArray *)indexPaths{
    for (NSIndexPath *indexPath in indexPaths) {
        IUObj *iu = [self objectAtIndexPath:indexPath];
        [iu becomeFocusedIU];
    }
    return [super setSelectionIndexPaths:indexPaths];
}


- (void)setSelectionObjects:(NSArray*)objects{
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (id anObject in objects) {
        [indexPaths addObject:[self indexPathOfObject:anObject]];
    }
    [self setSelectionIndexPaths:indexPaths];
}



- (NSIndexPath*)indexPathOfObject:(id)anObject
{
    return [self indexPathOfObject:anObject inNodes:[[self arrangedObjects] childNodes]];
}

- (NSIndexPath*)indexPathOfObject:(id)anObject inNodes:(NSArray*)nodes
{
    for(NSTreeNode* node in nodes)
    {
        if([[node representedObject] isEqual:anObject])
            return [node indexPath];
        if([[node childNodes] count])
        {
            NSIndexPath* path = [self indexPathOfObject:anObject inNodes:[node childNodes]];
            if(path)
                return path;
        }
    }
    return nil;
}

- (void)updateIU:(IUNeedsDisplayActionType)type{
    [self.firstSelection setNeedsDisplayStartGrouping];
    for (IUObj *iu in self.selectedObjects) {
        [iu setNeedsDisplay:type];
    }
    [self.firstSelection setNeedsDisplayEndGrouping];
}
@end

//
//  IUInsepctorItemArray.m
//  WebGenerator
//
//  Created by JD on 12/13/13.
//  Copyright (c) 2013 jdlab.org. All rights reserved.
//

#import "IUInspectorViewItemManager.h"
#import "IUInspectorCellVC.h"

@implementation IUInspectorViewItemManager{
    NSArray *titleVCs;
    NSArray *contentVs;
    NSMutableArray *visibleInfos;
}

-(id)init{
    self = [super init];
    return self;
}

-(void)setTitleVCs:(NSArray*)_titleVCs contentViews:(NSArray*)_contentVs{
    [self removeAllObjects];
    titleVCs = _titleVCs;
    contentVs = _contentVs;
    visibleInfos = [NSMutableArray array];
    for (int i=0; i<[_titleVCs count]; i++) {
        [visibleInfos addObject:@(YES)];
    }
    for (IUInspectorCellVC *titleVC in _titleVCs) {
        [titleVC addObserver:self forKeyPath:@"isViewExpanded" options:0 context:nil];
    }
    [_delegate IUInspectorItemArrayIsChanged:self];
}

-(void)isViewExpandedOfObject:(IUInspectorCellVC*)vc didChange:(NSDictionary*)change{
    NSUInteger idx = [titleVCs indexOfObject:vc];
    [visibleInfos replaceObjectAtIndex:idx withObject:@(vc.isViewExpanded)];
    [_delegate IUInspectorItemArrayIsChanged:self];
}

-(NSUInteger)countOfVisibleViews{
    NSUInteger retV = 0;
    for (int i=0; i<titleVCs.count; i++) {
        retV++;
        IUInspectorCellVC *vc = [titleVCs objectAtIndex:i];
        if (vc.isViewExpanded) {
            retV ++;
        }
    }
    return retV;
}

-(NSView*)viewForRow:(NSUInteger)row{
    int currentRow = 0;
    for (int i=0; i<[titleVCs count]; i++) {
        IUInspectorCellVC *vc = [titleVCs objectAtIndex:i];
        if (currentRow == row) {
            return vc.view;
        }
        
        if (vc.isViewExpanded) {
            if (currentRow +1 ==row){
                return [contentVs objectAtIndex:i];
            }
            currentRow = currentRow + 2;
        }
        else{
            currentRow = currentRow + 1;
        }
    }
    @throw NSRangeException;
}

-(void)removeAllObjects{
    for (IUInspectorCellVC *titleVC in titleVCs) {
        [titleVC removeObserver:self forKeyPath:@"isViewExpanded"];
    }
    titleVCs = nil;
    contentVs = nil;
    visibleInfos = nil;
}

-(void)dealloc{
    [self removeAllObjects];
}

@end

//
//  IUInsepctorItemArray.h
//  WebGenerator
//
//  Created by JD on 12/13/13.
//  Copyright (c) 2013 jdlab.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IUInspectorCellVC;

@class IUInspectorViewItemManager;

@protocol IUInspectorViewItemManagerDelegate <NSObject>
@required
- (void)IUInspectorItemArrayIsChanged:(IUInspectorViewItemManager*)inspectorItemArray;
@end


@interface IUInspectorViewItemManager : NSObject

@property id <IUInspectorViewItemManagerDelegate> delegate;

-(void)setTitleVCs:(NSArray*)titleVs contentViews:(NSArray*)contentVs;
-(NSView*)viewForRow:(NSUInteger)row;
-(void)removeAllObjects;
-(NSUInteger)countOfVisibleViews;

@end

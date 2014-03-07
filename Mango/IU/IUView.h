//
//  IUGroup.h
//  Mango
//
//  Created by JD on 13. 2. 3..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUObj.h"
#import "IUText.h"

#define IUZIndexAuto NSIntegerMax

@interface IUView : IUText{
    NSString        *formTarget;
    
    NSMutableArray  *cachedChildren;
    NSMutableArray  *children;
    
    BOOL    lockZIndex;
}

-(void)undoRemoveIU:(IUObj *)iu index:(NSInteger)index;
-(BOOL)removeIU:(IUObj *)iu;

-(BOOL)addIU:(IUObj *)iu error:(NSError**)error;
-(BOOL)insertIU:(IUObj *)iu atIndex:(NSInteger)index  error:(NSError**)error;

-(void)moveIU:(IUObj*)iu to:(NSInteger)zIndex;



-(NSUInteger)indexOfIU:(IUObj*)iu;
-(NSArray*)childrenIUinRect:(NSRect)rect;

@property NSMutableArray *children;

@property NSString      *formTarget;

//allChildren uses depth-first search
-(NSMutableArray*)allChildren;

-(NSMutableDictionary*)jsVariableDictionary;
-(NSMutableDictionary*)jsTriggerDictionary;
-(NSMutableDictionary*)jsReceiverDictionary;

-(BOOL)childHasFocus;
-(BOOL)preventMarginCollapse;
@end
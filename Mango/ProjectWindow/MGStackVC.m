//
//  MGStackVC.m
//  Mango
//
//  Created by JD on 13. 4. 14..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "MGStackVC.h"
#import "IUViewManager.h"
#import "IUTextPanelWC.h"
#import "IUTextFieldEdit.h"
#import "MGStackCellV.h"

@interface MGStackVC ()

@end

@implementation MGStackVC{
    JDOutlineView   *oView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    
    return self;
}

-(void)awakeFromNib{
    if(((JDOutlineView *)(self.view)).target == nil){
        oView = (JDOutlineView*)self.view;
        [oView registerForDraggedTypes:@[kNodesPBoardType, (id)kUTTypeIUType]];
        [oView setDraggingSourceOperationMask:NSDragOperationMove forLocal:NO];
        [oView setDoubleAction:@selector(doubleAction:)];
        [oView setTarget:self];
        [oView setDelegate:self];
        [oView setEnterKeyDelegate:self];
        [oView setDeleteKeyDelegate:self];
    }
}

#pragma mark -
#pragma mark outline cell delegate

-(void)doubleAction:(id)sender{
    
    if([self.iuController.selectedObjects count] == 1){
        IUObj *iu = self.iuController.selectedObjects[0];
        
        if ([iu isKindOfClass:[IUText class]]
            || [iu isKindOfClass:[IUTextFieldEdit class]] ) {
            [self.pWC.selectedIUViewManager enableTextEditor:iu];
            [[NSCursor IBeamCursor] push];
        }
        
    }

}

- (void)keyDown:(NSEvent *)theEvent{
    unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
    if (key == NSDeleteCharacter) {
        [self.pWC.selectedIUManager removeCurrentIU];
    }
    if (key == NSCarriageReturnCharacter) {
        MGStackCellV *v = [oView selectedView];
        [v startEdit];
    }
}

- (BOOL)control:(NSTextField *)control textShouldBeginEditing:(NSText *)fieldEditor{
    return YES;
}

- (BOOL)control:(NSTextField *)control textShouldEndEditing:(NSText *)fieldEditor{
    MGStackCellV *v = [oView selectedView];
    
    IUObj *iu = v.objectValue;
    NSString *newName = [fieldEditor string];
    
    if ([newName isEqualToString:iu.name]) {
        [v endEdit];
    }
    else{
        IUManager *manager = iu.iuManager;
        NSError *err;
        if ([manager validateName:newName err:&err] == NO){
            [JDLogUtil alert:err.localizedDescription];
            return NO;
        }
        iu.name = newName;
        [v endEdit];
    }
    return YES;
}

#pragma mark -
#pragma mark outline View delegate


- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id < NSDraggingInfo >)info item:(NSTreeNode*)item childIndex:(NSInteger)index{
	// find the index path to insert our dropped object(s)
    IUView *parent = [item representedObject];
    
    NSPasteboard *pBoard = info.draggingPasteboard;
	
    NSString *iuName = [pBoard stringForType:kUTTypeIUType];
    NSArray* newNodes;
    
    if (iuName) {
        IUObj *iu = [[NSClassFromString(iuName) alloc] init];
        [iu instantiate];
        [parent insertIU:iu atIndex:index error:nil];
        [iu iuLoad];
        iu.iuLoaded = YES;
        return YES;
    }
    else{
        // user is doing an intra app drag within the outline view:
        newNodes = dragNodesArray;
        
        for (NSInteger idx=[newNodes count] - 1; idx >= 0; idx--)
        {

            NSTreeNode *node = [newNodes objectAtIndex:idx];
            IUObj *iu = [node representedObject];
            // Group이 다를 때
            
            if (iu.parent != parent) {                
                [iu.iuManager moveIU:iu toDifferentParentIU:parent atIndex:index];
            }
            else{
                if (index==[[item childNodes] count]) {
                    index --;
                }
                [iu.parent moveIU:iu to:index];
            }
        }
        
        // keep the moved nodes selected
        NSMutableArray *indexPathList = [NSMutableArray array];
        for (NSUInteger i = 0; i < [newNodes count]; i++)
        {
            [indexPathList addObject:[[newNodes objectAtIndex:i] indexPath]];
        }
        [self.pWC.iuController setSelectionIndexPaths: indexPathList];
        return YES;
    }
}



- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard{
	[pboard declareTypes:[NSArray arrayWithObjects:kNodesPBoardType, nil] owner:self];
	dragNodesArray = items;
	return YES;
}

- (NSDragOperation)outlineView:(NSOutlineView *)ov validateDrop:(id <NSDraggingInfo>)info proposedItem:(id)item proposedChildIndex:(NSInteger)childIndex {
    if (childIndex == -1) {
        return NSDragOperationNone;
    }

    NSPasteboard *pBoard = info.draggingPasteboard;

    NSString *iuType =  [pBoard stringForType:(id)kUTTypeIUType];
    if (iuType) {
        return NSDragOperationCopy;
    }
    else{
        //순서가 뒤바뀐것은 허용 안함
        NSIndexPath *indexPath = [[item indexPath] indexPathByAddingIndex:childIndex];
        
        for (NSTreeNode *nodes in dragNodesArray) {
            NSIndexPath *dragPath = [nodes indexPath];
            
            NSLog(@"----");
            NSLog(@"indexPath: %@",[indexPath description]);
            NSLog(@"dragPath: %@",[dragPath description]);
            if ([indexPath compareAncestor:dragPath] == NSOrderedDescending) {
                NSLog(@"descending!");
                return NSDragOperationNone;
            }
        }
        
        IUObj *iu = [item representedObject];
        if ([iu isKindOfClass:[IUView class]]) {
            return NSDragOperationMove;
        }

    }
    return NSDragOperationNone;
}

- (BOOL)shouldCollapseAutoExpandedItemsForDeposited:(BOOL)deposited{
    return YES;
}

- (void)outlineView:(NSOutlineView *)outlineView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forItems:(NSArray *)draggedItems {
    NSLog(@"draggingSession started");
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item{
    return YES;
}

- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(NSTreeNode*)item {
    // Everything is setup in bindings
    NSTableCellView *cell= [outlineView makeViewWithIdentifier:@"cell" owner:self];
    return cell;

}

#pragma mark -
#pragma mark right menu
-(NSMenu *)defaultMenuForRow:(NSInteger)row{

    if([self.outlineV selectedRowIndexes].count > 1) return nil;
    
    BOOL enableUp = YES;
    BOOL enableDown = YES;
    BOOL enableChangeParent = YES;
    NSTreeNode *currentNode = [self.outlineV itemAtRow:row];
    NSTreeNode *parentNode = [currentNode parentNode];
    NSIndexPath *currentIndexPath = [currentNode indexPath];
    NSInteger currentIndex = [currentIndexPath indexAtPosition:[currentIndexPath length]-1];
    
    //1st item of children
    if(currentIndex ==0 ){
        enableUp = FALSE;
    }

    //last item of children
    if(currentIndex == [parentNode.childNodes count]-1){
        enableDown = FALSE;
    }

    
    //root Item && children of rootItem
    if( [currentIndexPath length]==1 || [currentIndexPath length]==2){
        enableChangeParent = FALSE;
    }

    NSMenu *popupMenu = [[NSMenu alloc] initWithTitle:@"StackVC:RightMenu"];
    
    //settting menuItem
    NSMenuItem *upperItem = [[NSMenuItem alloc] initWithTitle:@"Move Up" action:@selector(moveUpIU:) keyEquivalent:@""];
    [upperItem setRepresentedObject:currentNode];
    [upperItem setTarget:self];

    
    NSMenuItem *downItem = [[NSMenuItem alloc] initWithTitle:@"Move Down" action:@selector(moveDownIU:) keyEquivalent:@""];
    [downItem setRepresentedObject:currentNode];
    [downItem setTarget:self];
    
    NSMenuItem *changeParentItem = [[NSMenuItem alloc] initWithTitle:@"Change to upper parent" action:@selector(changeUpperParent:) keyEquivalent:@""];
    [changeParentItem setRepresentedObject:currentNode];
    [changeParentItem setTarget:self];
    
    
    //add Item
    if(enableUp){
        [popupMenu addItem:upperItem];
    }
    if(enableDown){
        [popupMenu addItem:downItem];
    }
    if(enableChangeParent){
        if(enableUp || enableDown){
            [popupMenu addItem:[NSMenuItem separatorItem]];
        }
        
        [popupMenu addItem:changeParentItem];
    }
    
    return popupMenu;
    
}
-(void)moveUpIU:(id)sender{
    NSTreeNode *currentNode = [sender representedObject];
    NSIndexPath *currentIndexPath = [currentNode indexPath];
    NSInteger currentIndex = [currentIndexPath indexAtPosition:[currentIndexPath length]-1];
    IUObj *iu = [currentNode representedObject];
    [iu.parent moveIU:iu to:currentIndex-1];
  
    // keep the moved nodes selected
    [self.pWC.iuController setSelectionObject:iu];
}

-(void)moveDownIU:(id)sender{
    NSTreeNode *currentNode = [sender representedObject];
    NSIndexPath *currentIndexPath = [currentNode indexPath];
    NSInteger currentIndex = [currentIndexPath indexAtPosition:[currentIndexPath length]-1];
    IUObj *iu = [currentNode representedObject];
    [iu.parent moveIU:iu to:currentIndex+1];
    
    // keep the moved nodes selected
    [self.pWC.iuController setSelectionObject:iu];
}
-(void)changeUpperParent:(id)sender{
    NSTreeNode *currentNode = [sender representedObject];
    NSIndexPath *currentIndexPath = [currentNode indexPath];
    NSInteger index = [currentIndexPath indexAtPosition:[currentIndexPath length]-2];
    
    IUObj *iu = [currentNode representedObject];
    IUView *parent= iu.parent.parent;
    
    [iu.iuManager moveIU:iu toDifferentParentIU:parent atIndex:index];
    // keep the moved nodes selected
    [self.pWC.iuController setSelectionObject:iu];
    
    
}


@end

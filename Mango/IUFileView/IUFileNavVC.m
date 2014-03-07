
//
//  IUFileNavVC.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 28..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import "IUFileNavVC.h"
#import "JDDataStructUtil.h"

@interface IUFileNavVC (){
        NSAlert *overWriteAlert;
}

@end

@implementation IUFileNavVC

@synthesize outlineV;
@synthesize rootItemArray;

#pragma mark -
#pragma mark initialization;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pWC:(MGProjectWC *)pwc
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        pWC = pwc;
        
    }
    return self;
}

#define LOCAL_REORDER_PASTEBOARD_TYPE @"l"

- (void)awakeFromNib{
    
        [self.outlineV registerForDraggedTypes:[NSArray arrayWithObjects:(id)@"ProjectNav",NSURLPboardType, nil]];
        [self.outlineV setDraggingSourceOperationMask:NSDragOperationMove forLocal:NO];
        awaked = YES;
        [pWC addObserver:self forKeyPath:@"project" options:NSKeyValueObservingOptionInitial context:nil];
}

-(void)projectDidChange{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        MGFileItem *item = [pWC.project.rootFileItem firstFileItemOfChildren];
        [self.outlineV selectItem:item];
    });
}

#pragma mark -
#pragma mark outlineview delegate

- (void)reloadData{
    [outlineV reloadData];
}

-(void)reloadItem:(id)item{
    [outlineV reloadItem:item reloadChildren:YES];
}

#pragma mark cell in outlineview

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(MGFileItem*)item {
    return (item == nil) ? 1 : [item.children count];
}


- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(MGFileItem*)item {
    return item.isDirectory;
}


- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(MGFileItem*)item {
    if (item == nil) {
        return pWC.project.rootFileItem;
    }
    else {
        MGFileItem *retItem = [item.children objectAtIndex:index];
        return retItem;
    }
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item{
    return 25;
}



- (NSView *)outlineView:(NSOutlineView *)outlineView viewForTableColumn:(NSTableColumn *)tableColumn item:(MGFileItem*)item {
    NSArray *cellArray;
    // Everything is setup in bindings
    [[NSBundle mainBundle] loadNibNamed:@"IUFileNavVCCell" owner:nil topLevelObjects:&cellArray];
    
    NSTableCellView *cell;
    
    for (id obj in cellArray) {
        if ([obj isKindOfClass:[NSTableCellView class]]) {
            cell = obj;
            break;
        }
    }

    [cell.textField setStringValue:item.name];

    switch(item.type){
        case MGFileItemTypePGIU:
            cell.imageView.image = [NSImage imageNamed:@"p_32"];
            break;
        case MGFileItemTypeTMIU:
            cell.imageView.image = [NSImage imageNamed:@"c_32"];
            break;
        case MGFileItemTypeCOIU:
            cell.imageView.image = [NSImage imageNamed:@"t_32"];
            break;
        default:
            cell.imageView.image = MGImageFolder;
    }
    cell.textField.font = [NSFont systemFontOfSize:20];
    return cell;
}



- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(MGFileItem*)item {
    assert(item.name != nil);
    return item.name;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item{
    return YES;
}


- (void)outlineViewSelectionDidChange:(NSNotification *)notification {
    if([outlineV selectedRow] < 0) return;
    MGFileItem *item = [outlineV itemAtRow:[outlineV selectedRow]];
    
    if (item.parent == nil){
        //modify resource folder
        [pWC setProjectResource:item];
    }
    else if (item.isDirectory) {
        [outlineV expandItem:item];
    }
    else{
        [pWC setCurrFile:item];
    }
}



#pragma mark - 
#pragma mark mouse Event (drag &drop) & keyevent (copy)


- (void)outlineView:(NSOutlineView *)outlineView didDragTableColumn:(NSTableColumn *)tableColumn{
    NSLog(@"drag");
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldReorderColumn:(NSInteger)columnIndex toColumn:(NSInteger)newColumnIndex{
    NSLog(@"reorder");
    return YES;
}


- (BOOL)outlineView:(NSOutlineView *)outlineView acceptDrop:(id < NSDraggingInfo >)info item:(MGFileItem*)item childIndex:(NSInteger)index{
    NSPasteboard *pBoard = info.draggingPasteboard;
    if ([pBoard.types containsObject:(id)NSURLPboardType]) {
        NSURL *url = [NSURL URLFromPasteboard:pBoard];
        //COPY Item
        NSString *fileName = [url lastPathComponent];
        NSString *newFilePath = [item.absolutePath stringByAppendingPathComponent:fileName];
        NSError *err;
        if ([[NSFileManager defaultManager] fileExistsAtPath:newFilePath isDirectory:NO]) {
            NSAlert *alertMsg = [NSAlert alertWithMessageText:@"Alert" defaultButton:@"Cancel" alternateButton:@"Use existed file" otherButton:@"Overwrite" informativeTextWithFormat:@"File aleady exists at target path. Do you want overwrite?"];
            // use exist : 0
            // overwrite : -1
            // cancel : 1
            NSInteger intV = [alertMsg runModal];
            switch (intV) {
                case 0:
                    // use exist
                {
                    return NO;
                }
                case -1:
                    //overwrite
                    [[NSFileManager defaultManager] removeItemAtPath:newFilePath error:&err];
                    break;
                case 1:
                default:
                    return NO;
            }
        }
        
        [[NSFileManager defaultManager] copyItemAtURL:url toURL:[NSURL fileURLWithPath:newFilePath] error:&err];
        if (err) {
            [JDLogUtil alert:err.localizedFailureReason];
            return NO;
        }
        
    }
    
    
    
    // local reorder
    /* TODO : 여러개 move 를 처리 */
    MGFileItem *draggedItem = [currentDraggedItems objectAtIndex:0];
    if (draggedItem.type == MGFileItemTypeProject ||
        draggedItem.type == MGFileItemTypeDir) {
        [JDLogUtil alert:@"You cannot move directory"];
        return NO;
    }
    
    if (draggedItem.parent != item) {
        [JDLogUtil alert:@"You cannot move to different directory"];
        return NO;
    }
    NSInteger oldIndex = [item.children indexOfObject:draggedItem];
    if (item == [draggedItem parent] && oldIndex == index) {
        return NO;
    }
    //    NSLog(@"%@ : %ld",[item name],index);
    if(item.type == MGFileItemTypePGIU){
        [pWC.project.pageFileItems removeObjectForKey:draggedItem.name];
        
    }else if(item.type == MGFileItemTypeCOIU){
        [pWC.project.compFileItems removeObjectForKey:draggedItem.name];
    }
    NSUInteger currentIndex = [draggedItem indexFromParent];
    [draggedItem removeFromSuperFileItem];
    NSUInteger toIndex;
    if (index == 0 || index==-1) {
        [item insertFileItem:draggedItem atIndex:0];
        toIndex =0;
    }
    else if (index == [item.children count]+1) {
        [item addFileItem:draggedItem];
        toIndex = index-1;
    }
    else if (index > currentIndex ){
        [item insertFileItem:draggedItem atIndex:index-1];
        toIndex = index-1;
    }
    else{
        [item insertFileItem:draggedItem atIndex:index];
        toIndex = index;
    }
    if (item.parent) {
        [outlineView reloadItem:[item parent] reloadChildren:YES];
    }
    
    if(item.type == MGFileItemTypePGIU){
        [pWC.project.pageFileItems insertObject:draggedItem forKey:draggedItem.name atIndex:toIndex];
    }else if(item.type == MGFileItemTypeCOIU){
        [pWC.project.compFileItems insertObject:draggedItem forKey:draggedItem.name atIndex:toIndex];
    }
    [pWC.project save];
    
    return YES;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView writeItems:(NSArray *)items toPasteboard:(NSPasteboard *)pboard{
    MGFileItem *draggedItem = [currentDraggedItems objectAtIndex:0];
    if (draggedItem.type == MGFileItemTypeProject || draggedItem.type == MGFileItemTypeDir) {
        return NO;
    }
    return YES;
}

- (NSDragOperation)outlineView:(NSOutlineView *)ov validateDrop:(id <NSDraggingInfo>)info proposedItem:(MGFileItem*)item proposedChildIndex:(NSInteger)childIndex {
    NSPasteboard *pBoard = info.draggingPasteboard;
    if ([pBoard.types containsObject:NSURLPboardType]) {
        NSURL *url = [NSURL URLFromPasteboard:pBoard];
        
        if ([item.name isEqualToString:@"page"] && [url.pathExtension isEqualToString:@"pgiu"]){
            return NSDragOperationCopy;
        }
        else if ([item.name isEqualToString:@"comp"] && [url.pathExtension isEqualToString:@"coiu"]){
            return NSDragOperationCopy;
        }
        else if ([item.name isEqualToString:@"template"] && [url.pathExtension isEqualToString:@"tmiu"]){
            return NSDragOperationCopy;
        }
    }
    else if ([pBoard.types containsObject:@"ProjectNav"]) {
        if (item.type == MGFileItemTypeDir){
            return NSDragOperationMove;
        }
    }
    return NSDragOperationNone;
}



- (void)outlineView:(NSOutlineView *)outlineView draggingSession:(NSDraggingSession *)session willBeginAtPoint:(NSPoint)screenPoint forItems:(NSArray *)draggedItems {
    currentDraggedItems = draggedItems;
    [session.draggingPasteboard setData:[NSData data] forType:@"ProjectNav"];
}


- (id <NSPasteboardWriting>)outlineView:(NSOutlineView *)outlineView pasteboardWriterForItem:(id)item {
    // there is no such method on apple official document, but apple official sample. it sucks.
    // 리턴하는 MGFileItem 은 PasteBoard 에 필요한 UTI와 데이터를 리턴하나 쓰는데는 아무데도 없음 ( Local Drag 로 체크하므로 )
    // 그렇다고 Nil을 리턴하면 동작 안함 -_- 뭐 이따위임 ㅠㅠ
    return item;
}

#pragma mark -
#pragma mark Call From other class

-(void)setSelectRowFromTab:(MGFileItem *)item{
    NSInteger selectedRow = [outlineV rowForItem:item];
    NSIndexSet *selectSet = [[NSIndexSet alloc] initWithIndex:selectedRow];
    [outlineV selectRowIndexes:selectSet byExtendingSelection:NO];
    
}


#pragma mark -
#pragma mark key Event handling


- (void)keyDown:(NSEvent *)theEvent{
    NSTableCellView *v =  [outlineV viewAtColumn:0 row:[outlineV selectedRow] makeIfNecessary:NO];
    
    MGFileItem* item = [outlineV itemAtRow:[outlineV selectedRow]];
    
    if(item.type == MGFileItemTypeDir
       || item.defaultFile){
        [v.textField setEditable:NO];
        return;
    }
    
    [v.textField setEditable:YES];
    [pWC.window makeFirstResponder:v.textField];
    NSString *str = v.textField.stringValue;
    NSUInteger idx = [[str substringToChar:'.'] length];
    [v.textField setDelegate:self];
    NSText* textEditor = [pWC.window fieldEditor:YES forObject:v.textField];
    NSRange range = {0, idx};
    [textEditor setSelectedRange:range];
    
}


- (BOOL)control:(NSControl *)control textShouldBeginEditing:(NSText *)fieldEditor {
    oldTextString = [fieldEditor.string copy];
    return YES;
}


- (BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor {
    if ([[fieldEditor string] length] == 0) {
        return NO;
    }
    
    MGFileItem* item = [outlineV itemAtRow:[outlineV selectedRow]];
    IUManager *iuManager = [pWC iuManagerOfFileItem:item];
    
    if ( [iuManager.rootIU renameAsFile:[[fieldEditor string] copy]] == NO){
        //[JDLogUtil alert:@"file exist in same path"];
        fieldEditor.string = oldTextString;
        return YES;
    }
    [pWC.project save];
    return YES;
}



- (void)setDropItem:(id)item dropChildIndex:(NSInteger)index{
    return;
}

- (BOOL)shouldCollapseAutoExpandedItemsForDeposited:(BOOL)deposited{
    return YES;
}



#pragma mark - 
#pragma mark popup right menu

-(NSMenu*)defaultMenuForRow:(NSInteger)row{
    
    //setting for new
    MGFileItem *item = [outlineV itemAtRow:row];
    [self.popupNewMI setRepresentedObject:item];
    
    
    return self.menu;
}


- (void)menuNeedsUpdate:(NSMenu *)menu{
    NSInteger clickedRow = outlineV.rightClickedIndex;
    MGFileItem* item = nil;
    BOOL clickedOnMultipleItems = NO;
    if (clickedRow == -1) {
        return;
    }
    item = [outlineV itemAtRow:clickedRow];
    
    [_popupCopyMI setEnabled:NO];
    [_popupRemoveMI setEnabled:NO];

    
    NSLog(@"menu needs update : %@", item);
    
    //setting for remove and copy menu
    clickedOnMultipleItems = [outlineV isRowSelected:clickedRow] && ([outlineV numberOfSelectedRows] > 1);
    if (clickedOnMultipleItems) {
        [_popupRemoveMI setEnabled:YES];
        return;
    }
    
    // item is directory
    if ([item isDirectory]) {
        [_popupRemoveMI setEnabled:YES];
        return;
    }

    //can't remove default item file
    if(item.defaultFile == NO){
        [_popupRemoveMI setEnabled:YES];
    }
    
    [_popupCopyMI setEnabled:YES];
    return;
}


- (IBAction)showInFinder:(id)sender {
    MGFileItem *item = [outlineV itemAtRow:[outlineV selectedRow]];
    NSURL *url = [NSURL fileURLWithPath:item.absolutePath];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:@[url]];
}

#pragma mark pressed menu button



- (IBAction)popupCopyPressed:(id)sender {
    
    NSInteger clickedRow = outlineV.rightClickedIndex;
    MGFileItem* item = [outlineV itemAtRow:clickedRow];
    NSTableCellView *v = [outlineV viewAtColumn:0 row:outlineV.rightClickedIndex makeIfNecessary:NO];
    [v.textField.window makeFirstResponder:nil];
    NSString *newFilePath = [[item absolutePath] stringByAppendFileNameWithExtensionUntouched:@"_copy"];
    NSString *appendingString = @"_copy";
    int i=0;
    //find file name!
    while (1) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:newFilePath]) {
            i++;
            appendingString = [NSString stringWithFormat:@"_copy_%d",i];
            newFilePath = [[item absolutePath] stringByAppendFileNameWithExtensionUntouched:appendingString];
            continue;
        }
        else{
            break;
        }
    }
    //not copy file
    [[NSFileManager defaultManager] copyItemAtPath:[item absolutePath] toPath:newFilePath error:nil];
    MGFileItem *parentItem = [item parent];
    NSDictionary *newItemDict = [MGUtil itemDict:[[item name] stringByAppendFileNameWithExtensionUntouched:appendingString] type:@"file"];
    MGFileItem *newItem = [[MGFileItem alloc]  initWithContents:newItemDict];
    [parentItem  insertFileItem:newItem afterItem:item];
    
    
    //add copy projectItems
    if(item.type == MGFileItemTypePGIU){
        NSUInteger currentIndex = [pWC.project.pageFileItems indexOfObject:item];
        [pWC.project.pageFileItems insertObject:newItem forKey:newItem.name atIndex:currentIndex+1];
        
    }
    else if(item.type == MGFileItemTypeCOIU){
        NSUInteger currentIndex = [pWC.project.compFileItems indexOfObject:item];
        [pWC.project.compFileItems insertObject:newItem forKey:newItem.name atIndex:currentIndex+1];
    }
    
    [outlineV reloadItem:parentItem reloadChildren:YES];
    [pWC.project save];
    
}




- (IBAction)popupRemovePressed:(id)sender {
    
    NSInteger clickedRow = outlineV.rightClickedIndex;
    NSTableCellView *v = [outlineV viewAtColumn:0 row:outlineV.rightClickedIndex makeIfNecessary:NO];
    [v.textField.window makeFirstResponder:nil];
    MGFileItem* item = [outlineV itemAtRow:clickedRow];
    [pWC removeFileItem:item];
    
    
}


@end

//
//  MGObjManager.m
//  Mango
//
//  Created by JD on 13. 2. 1..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUManager.h"
#import "IUViewManager.h"
#import "IUFrameManager.h"

#import "MGProjectWC.h"
#import "IUPage.h"
#import "IUObj.h"
#import "IUView.h"
#import "IUText.h"
#import "JDUIUtil.h"
#import "MGInspectorVC.h"
#import "IUHttpLog.h"
#import "IUCSS.h"
#import "IUTextPanelWC.h"
#import "IUCarousel.h"
#import "IUTextFieldEdit.h"

@interface IUUndoMoveInfo : NSObject

@property NSInteger originalIndex;
@property IUView    *originalParent;
@property IUObj     *obj;
@property CGFloat   pixelX;
@property CGFloat   pixelY;
@property CGFloat   pixelW;
@property CGFloat   pixelH;
@property CGFloat   percentX;
@property CGFloat   percentY;
@property CGFloat   percentW;
@property CGFloat   percentH;


@end

@implementation IUUndoMoveInfo
@end


@interface  IUManagerMouseSession : NSObject

@property   NSEvent *downEvent;
@property   IUObj   *clickedObj;
@property   IUPointLayer    *clickedPLayer;

@property   (assign)  NSPoint draggedDistance;
@property   (assign)  NSRect mouseDownIURect;

-(NSPoint)diffFromLocationInWindow:(NSPoint)point;

@end

@implementation IUManagerMouseSession
-(NSPoint)diffFromLocationInWindow:(NSPoint)point{
    return [JDUIUtil pointDiff:self.downEvent.locationInWindow from:point];
}

@end


@implementation IUManager {
    IUProject       *project;
    BOOL            _undoGrouping;
    IUManagerMouseSession   *mouseSession;
    BOOL        mouseDown;
//    NSMutableDictionary *dict;
}


@synthesize rootIU;

@synthesize pWC;
@synthesize numOfIU;

@synthesize exposedIUs;
@synthesize variables;
@synthesize iuViewManager;
@synthesize mouseDown;
@synthesize project;
/*
 클릭이 될 때마다 상태에 변화를 준다.
 */

- (NSString*)makeNewIUName:(NSString*)className{
    self.numOfIU ++;
    while (1) {
        NSString *newIUName = [NSString stringWithFormat:@"%@_%lu",className,self.numOfIU];
        if ([self childIUOfName:newIUName ofIU:nil]== nil) {
            return newIUName;
        }
        self.numOfIU++;
    }
}

-(IUObj*)childIUOfName:(NSString*)name ofIU:(IUObj*)iu{
    if (iu == nil){
        iu = rootIU;
    }
    if ([name isEqualToString:iu.name]){
        return iu;
    }
    else{
        if ([iu isKindOfClass:[IUView class]]){
            for (IUObj* child in ((IUView*)iu).children){
                if ([self childIUOfName:name ofIU:child] != nil){
                    return [self childIUOfName:name ofIU:child];
                }
            }
        }
    }
    return nil;
}



- (void)awakeFromNib{
    NSLog(@"awake from Nib ERROR : IT SHOULD NOT BE CALLED");
}

-(NSString*)filePath{
    return fileItem.absolutePath;
}


- (id)initWithFileItem:(MGFileItem*)_fileitem projectWindow:(MGProjectWC*)_pWC
{
    self = [super init];
    if (self) {
        // until now, data delegate * datasource does not set
        fileItem = _fileitem;
        if ([[NSFileManager defaultManager] fileExistsAtPath:fileItem.absolutePath] == NO) {
            NSString *errMsg = [NSString stringWithFormat:@"File does not exist %@", _fileitem];
            [JDLogUtil alert:errMsg];
            return nil;
        }
        pWC = _pWC;
        [self willChangeValueForKey:@"project"];
        project = pWC.project;
        [self didChangeValueForKey:@"project"];
        
        IUViewManager *newViewManager = [[IUViewManager alloc] init];
        self.iuViewManager = newViewManager;
        
        IUFrameManager *frameManager = [[IUFrameManager alloc] init];
        frameManager.manager = self;
        self.frameManager = frameManager;
        
        exposedIUs = [[JDMutableArrayDict alloc] init];
        variables = [NSMutableDictionary dictionary];
        
        NSData *loadingData = [NSData dataWithContentsOfFile:fileItem.absolutePath];
        NSError *err;
        NSMutableDictionary *dict =  [NSJSONSerialization JSONObjectWithData:loadingData options:NSJSONReadingMutableContainers error:&err] ;
        if (err) {
            NSLog([err description],nil);
            assert(0);
        }
        NSLog(@"JSON LOADED for %@", _fileitem.absolutePath);
        
        NSString *className = [dict objectForKey:@"type"];
        [newViewManager disableUpdate:self];
        [newViewManager disableSelection:self];

        rootIU = [[NSClassFromString(className) alloc] init];
        rootIU.iuManager = self;
        newViewManager.manager = self;


        
        /*
         * IUContainer Handle!!!!
         * IUContainer is old name => it's Group
         */

        id value = [dict objectForKey:@"IUContainer"];
        if(value != nil){
            [dict setObject:value forKey:@"IUView"];
            [dict removeObjectForKey:@"IUContainer"];
        }
        rootIU.loadFromFile = YES;
        [rootIU loadWithDict:dict];
        [rootIU iuLoad];
        rootIU.iuLoaded = YES;
        rootIU.fileItem = fileItem;
        
        //        NSLog(@"IU Manager Assigned Root IU");
        [[NSNotificationCenter defaultCenter] postNotificationName:@"IUManagerDidLoad" object:self];
        [self.iuViewManager enableUpdate:self];
        [self.iuViewManager enableSelection:self];
        self.undoManager = [[NSUndoManager alloc] init];
    }
    return self;
}



-(void)mouseDown:(NSEvent*)theEvent{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"IUManagerMouseDown" object:self];
    mouseDragged = NO;
    mouseDown = YES;

    
    if (theEvent.clickCount == 1
        && [theEvent type] == NSLeftMouseDown) {
        [self.undoManager beginUndoGrouping];
        _undoGrouping = YES;
    }
    
    NSPoint pnt = [iuViewManager convertPoint:theEvent.locationInWindow fromView:nil];
    IUObj *clickedObj = [rootIU iuHitTest:pnt];
    IUObj *focusObj = [clickedObj requestFocusAvariableIU];
    self.clickedObj = focusObj;
    mouseSession = [[IUManagerMouseSession alloc] init];
    mouseSession.clickedObj = self.clickedObj;
    mouseSession.downEvent = theEvent;
    

    
    if ([theEvent modifierFlags]& NSCommandKeyMask) {
        NSLog(@"command");
        pWC.iuController.selectionIndexPath = nil;
        return;
    }
    
    if (theEvent.clickCount == 2) {
        if([self.clickedObj isKindOfClass:[IUText class]]
           || [self.clickedObj isKindOfClass:[IUTextFieldEdit class]]){
            [self.iuViewManager enableTextEditor:self.clickedObj];
        }
        return;
    }
    else if (theEvent.clickCount == 1) {
        if ([pWC.iuController.selectedObjects containsObject:self.clickedObj]) {
            mouseClickedAtSelectedIU = YES; // not worked now

        }
        else{
            mouseClickedAtSelectedIU = NO;
            if ((theEvent.modifierFlags & NSShiftKeyMask) == NO) {
                [pWC.iuController setSelectionObject:self.clickedObj];
                [self.clickedObj becomeFocusedIU];
            }
            else {
                NSUInteger depth = pWC.iuController.firstSelection.depth;
                if (self.clickedObj.depth == depth) {
                    [pWC.iuController addSelectionObject:self.clickedObj];
                }
            }
            [self.iuViewManager disableTextEditor];
        }
    }
    
}

-(void)IUPointDown:(IUPointLayer*)pLayer event:(NSEvent*)event{
    [self.undoManager beginUndoGrouping];
    _undoGrouping = YES;
    mouseDown = YES;
    pLayer.dragging = YES;
    [self.iuViewManager.window disableCursorRects];
    [pLayer.cursor push];
    
    mouseSession = [[IUManagerMouseSession alloc] init];
    mouseSession.downEvent = event;
    mouseSession.clickedPLayer = pLayer;
    mouseSession.mouseDownIURect = mouseSession.clickedPLayer.iu.iuFrame.currentScreenFrame.mixedframe;

    NSLog(@"IUPoint Down: %@", [pLayer description]);
}



-(void)mouseDragged:(NSEvent*)theEvent{

    if ([theEvent modifierFlags]& NSCommandKeyMask) {
        mouseDragged = YES;
    }
    
    NSPoint diff = [mouseSession diffFromLocationInWindow:theEvent.locationInWindow];
    NSPoint movePoint = [JDUIUtil pointDiff:mouseSession.draggedDistance from:diff];
    movePoint = NSMakePoint(round(movePoint.x), round(movePoint.y));

//    [JDLogUtil log:@"diff" point:diff];
//    [JDLogUtil log:@"movePoint" point:movePoint];
//    [JDLogUtil log:@"draggedDistance" point:mouseSession.draggedDistance];
    
    mouseSession.draggedDistance = NSMakePoint(mouseSession.draggedDistance.x + movePoint.x, mouseSession.draggedDistance.y + movePoint.y);

    //drag로 사이즈를 늘릴때
    if (mouseSession.clickedPLayer) {
        
        IUObj   *iu = mouseSession.clickedPLayer.iu;
        
        if (mouseSession.clickedPLayer.location == kIULocationBotLeft ||
            mouseSession.clickedPLayer.location == kIULocationMidLeft ||
            mouseSession.clickedPLayer.location == kIULocationTopLeft  ) {
            
            [iu moveLeftLine:diff.x originalRect:mouseSession.mouseDownIURect];
        }
        if (mouseSession.clickedPLayer.location == kIULocationBotRight ||
            mouseSession.clickedPLayer.location == kIULocationMidRight ||
            mouseSession.clickedPLayer.location == kIULocationTopRight  ) {
            [iu moveRightLine:diff.x originalRect:mouseSession.mouseDownIURect];
        }
        if (mouseSession.clickedPLayer.location == kIULocationTopLeft ||
            mouseSession.clickedPLayer.location == kIULocationTopRight ||
            mouseSession.clickedPLayer.location == kIULocationTopCenter  ) {
            [iu moveTopLine:(-1)*diff.y originalRect:mouseSession.mouseDownIURect];
        }
        if (mouseSession.clickedPLayer.location == kIULocationBotLeft ||
            mouseSession.clickedPLayer.location == kIULocationBotRight ||
            mouseSession.clickedPLayer.location == kIULocationBotCenter ) {
            [iu moveBottomLine:(-1)*diff.y originalRect:mouseSession.mouseDownIURect];
        }
        [iu setNeedsDisplay:IUNeedsDisplayActionCSS];
        return;
    }
    //drag로 움직일때
    for (IUObj *iu in pWC.iuController.selectedObjects) {
        if (iu.draggable == YES) {
            if(iu.iuFrame.currentScreenFrame.flowLayout){
                [iu moveMarginLeft:movePoint.x Top:(-1)*movePoint.y];
            }else{
                [iu moveX:movePoint.x Y:(-1)*movePoint.y];
            }
        }
    }
}

#pragma mark -
#pragma mark PointCalibration

//when make IU
-(NSPoint)makeIUpointCalibration:(NSPoint)locationInWindow inIU:(IUView *)iu{
    NSPoint pnt = [iuViewManager convertPoint:locationInWindow fromView:nil];
    NSPoint parentPnt = iu.iuFrame.gridFrameFromScreen.origin;
    
    pnt.x -= parentPnt.x;
    pnt.y -= parentPnt.y;
    
    
    return pnt;
}

#pragma mark -
#pragma mark mouse event

-(void)mouseUp:(NSEvent*)theEvent{
    if (_undoGrouping) {
        [self.undoManager endUndoGrouping];
        _undoGrouping = NO;
    }
    mouseSession.clickedPLayer.dragging = NO;
    mouseSession = nil;
    mouseDown = NO;
    if ([NSCursor currentCursor] != [NSCursor arrowCursor] && [NSCursor currentCursor] != [NSCursor IBeamCursor]) {
        NSLog(@"EnableCursorRect");
        [NSCursor pop];
        [self.iuViewManager.window enableCursorRects];
    }
}



-(void)removeCurrentIU{
    [self.iuViewManager disableUpdate:self];
    [self.iuViewManager disableSelection:self];

    NSArray *selectedObjs= pWC.iuController.selectedObjects;
    for (IUObj *iu in selectedObjs){
        [iu.parent removeIU:iu];
    }
    
    [self.iuViewManager enableUpdate:self];
    [self.iuViewManager enableSelection:self];
    [pWC.iuController setSelectionObject:nil];

    [pWC.iuController rearrangeObjects];
}

#pragma mark -
#pragma mark move

-(void)moveSelection:(NSUInteger)option{
    if ([pWC.iuController.selectedObjects count] != 1) {
        return;
    }
    IUObj *selectedObj = pWC.iuController.selection;
    switch (option) {
        case 0:
            if (selectedObj.parent) {
                [pWC.iuController setSelectionObject:selectedObj.parent];
            }
            break;
        case 1:
            if (selectedObj.parent && selectedObj.index > 0 ) {
                [pWC.iuController setSelectionObject:[selectedObj.parent.children objectAtIndex:selectedObj.index -1]];
            }
            break;
        case 2:
            if (selectedObj.parent && selectedObj.index <= [selectedObj.parent.children count] - 2 ) {
                [pWC.iuController setSelectionObject:[selectedObj.parent.children objectAtIndex:selectedObj.index + 1]];
            }
            break;
        case 3:
        default:
            if ([selectedObj isKindOfClass:[IUView class]] ) {
                IUView *groupObj = (IUView*)selectedObj;
                if ([groupObj.children count] > 0 ) {
                    [pWC.iuController setSelectionObject:[groupObj.children objectAtIndex:0]];
                }
            }
            break;
    }
}

- (void)keyDown:(NSEvent *)event
{
    unichar key = [[event charactersIgnoringModifiers] characterAtIndex:0];
    NSLog(@"keyDown");
    if(key == NSDeleteCharacter)
    {
        [self removeCurrentIU];
    }
    else if ([event modifierFlags] & NSNumericPadKeyMask) {
        if ([event modifierFlags] & NSCommandKeyMask) {
            switch (event.keyCode) {
                case 126: //up
                    [self moveSelection:0]; return;
                case 123: // left
                    [self moveSelection:1]; return;
                case 124: // right
                    [self moveSelection:2]; return;
                case 125: // down;
                default:
                    [self moveSelection:3]; return;
            }
            return;
        }
        [self.iuViewManager disableUpdate:self];
        if ([event isARepeat]) {
            [self interpretKeyEvents:[NSArray arrayWithObject:event]];
            [self interpretKeyEvents:[NSArray arrayWithObject:event]];
            [self interpretKeyEvents:[NSArray arrayWithObject:event]];
            [self interpretKeyEvents:[NSArray arrayWithObject:event]];
        }
        [self interpretKeyEvents:[NSArray arrayWithObject:event]];
        [self.iuViewManager enableUpdate:self];
    }
    else {
        [super keyDown:event];
    }
}

-(void)moveUp:(id)sender
{
    for (IUObj *iu in [pWC.iuController selectedObjects]) {
        if(iu.iuFrame.currentScreenFrame.flowLayout){
            [iu flowLayoutMoveTo:IUDirectionUp];
        }else{
            [iu moveTo:IUDirectionUp];
        }
    }
}

-(void)moveDown:(id)sender
{
    for (IUObj *iu in [pWC.iuController selectedObjects]) {
        if(iu.iuFrame.currentScreenFrame.flowLayout){
            [iu flowLayoutMoveTo:IUDirectionDown];
        }else{
            [iu moveTo:IUDirectionDown];
        }
    }
}

-(void)moveLeft:(id)sender
{
    for (IUObj *iu in [pWC.iuController selectedObjects]) {
        if(iu.iuFrame.currentScreenFrame.flowLayout){
            [iu flowLayoutMoveTo:IUDirectionLeft];
        }else{
            [iu moveTo:IUDirectionLeft];
        }
    }
}

-(void)moveRight:(id)sender
{
    for (IUObj *iu in [pWC.iuController selectedObjects]) {
        if(iu.iuFrame.currentScreenFrame.flowLayout){
            [iu flowLayoutMoveTo:IUDirectionRight];
        }else{
            [iu moveTo:IUDirectionRight];
        }
    }
}

#pragma mark -
#pragma mark embed

-(BOOL)isSameParentforSelectedObjects{
    
    NSArray *objects = [pWC.iuController selectedObjects];
    IUView *parent = ((IUObj *)objects[0]).parent;
    BOOL sameParent = YES;
    for(IUObj *obj in objects){
        if([obj.parent isNotEqualTo:parent]){
            sameParent = NO;
        }
    }
    return sameParent;
}

-(NSMenuItem *)embedMenuItem{
    NSMenuItem *embedItem = [[NSMenuItem alloc] initWithTitle:@"Embed In IUView" action:@selector(embedInIUs:) keyEquivalent:@""];
    [embedItem setTarget:self];
    return embedItem;
}
-(void)embedInIUs:(id)sender{
    DLog(@"embedInIus");
    [self.iuViewManager disableSelection:self];

    NSArray *objects = [pWC.iuController selectedObjects];
    NSRect parentRect = NSMakeRect(100000, 100000, 0, 0);
    IUView *parentIU = ((IUObj *)objects[0]).parent;
    
    //make rect
    for(IUObj *obj in objects){
        NSRect currentRect = NSMakeRect(obj.iuFrame.currentScreenFrame.pixelX,
                                        obj.iuFrame.currentScreenFrame.pixelY,
                                        obj.iuFrame.currentScreenFrame.pixelWidth,
                                        obj.iuFrame.currentScreenFrame.pixelHeight
                                        );
        if(parentRect.origin.x > currentRect.origin.x){
            parentRect.origin.x = currentRect.origin.x;
        }
        if(parentRect.size.width < currentRect.origin.x + currentRect.size.width){
            parentRect.size.width = currentRect.origin.x + currentRect.size.width;
        }
        if(parentRect.origin.y > currentRect.origin.y){
            parentRect.origin.y = currentRect.origin.y;
        }
        if(parentRect.size.height < currentRect.origin.y + currentRect.size.height){
            parentRect.size.height = currentRect.origin.y + currentRect.size.height;
        }
    }
    
    parentRect.size.width -= parentRect.origin.x;
    parentRect.size.height -= parentRect.origin.y;
    
    //make new parent
    IUView *newParent = [[[IUView alloc] init] instantiate];
    [newParent setIuManager:self];
    newParent.iuFrame.defaultScreenFrame.pixelRect = parentRect;
    newParent.iuFrame.currentScreenFrame.pixelRect = parentRect;
    [newParent iuLoad];
    newParent.iuLoaded = YES;
    [parentIU addIU:newParent error:nil];
    
    for(IUObj *obj in objects){
        if ([obj shouldBeMovedByUser:newParent] == NO || [newParent shouldMoveIU:obj] == NO) {
            return;
        }
    }

    //move iu to new parent from old parent
    for(IUObj *obj in objects){
        [self moveIU:obj toDifferentParentIU:newParent atIndex:-1];
    }
    
    [self.pWC.iuController rearrangeObjects];
    [self.iuViewManager enableSelection:self];
    [self.pWC.iuController setSelectionObjects:objects];

    
}


#pragma mark -
#pragma mark manageIU

-(void)undoMoveIU:(IUUndoMoveInfo*)info{
    [self.iuViewManager disableUpdate:self];
    [info.obj.parent setNeedsDisplay:IUNeedsDisplayActionHTML];
    
    NSAssert([info.obj.parent removeIU:info.obj], @"wrong");
    NSAssert([info.originalParent insertIU:info.obj atIndex:info.originalIndex error:nil], @"wrong");

    info.obj.iuFrame.currentScreenFrame.pixelX = info.pixelX;
    info.obj.iuFrame.currentScreenFrame.pixelY = info.pixelY;
    info.obj.iuFrame.currentScreenFrame.pixelWidth = info.pixelW;
    info.obj.iuFrame.currentScreenFrame.pixelHeight = info.pixelH;
    info.obj.iuFrame.currentScreenFrame.percentX = info.percentX;
    info.obj.iuFrame.currentScreenFrame.percentY = info.percentY;
    info.obj.iuFrame.currentScreenFrame.percentWidth = info.percentH;
    info.obj.iuFrame.currentScreenFrame.percentHeight = info.percentW;
    
    
    [info.originalParent setNeedsDisplay:IUNeedsDisplayActionHTML];
    [self.iuViewManager enableUpdate:self];
}

-(void)moveIU:(IUObj *)iu toDifferentParentIU:(IUView *)parentIU atIndex:(NSInteger)index{
    //외부에서 ShouldMove를 부른 후 들어와야 함
    IUUndoMoveInfo *moveInfo = [[IUUndoMoveInfo alloc] init];
    moveInfo.originalIndex = iu.index;
    moveInfo.originalParent = iu.parent;
    moveInfo.obj = iu;
    moveInfo.pixelX = iu.iuFrame.currentScreenFrame.pixelX;
    moveInfo.pixelY = iu.iuFrame.currentScreenFrame.pixelY;
    moveInfo.pixelW = iu.iuFrame.currentScreenFrame.pixelWidth;
    moveInfo.pixelH = iu.iuFrame.currentScreenFrame.pixelHeight;
    moveInfo.percentX = iu.iuFrame.currentScreenFrame.percentX;
    moveInfo.percentY = iu.iuFrame.currentScreenFrame.percentY;
    moveInfo.percentH = iu.iuFrame.currentScreenFrame.percentHeight;
    moveInfo.percentW = iu.iuFrame.currentScreenFrame.percentWidth;
    
    [self.undoManager registerUndoWithTarget:self selector:@selector(undoMoveIU:) object:moveInfo];

    [self.undoManager disableUndoRegistration];
    NSAssert([iuViewManager isUpdateEnabled], @"Should update enabled");
    
    if([iu.parent removeIU:iu] == NO){
        assert(0);
    }

    //retain original x, y, w, h
    //make fit to new parent rect
    //percent flag off for changing time
    //move to parent!
    BOOL flagX = iu.iuFrame.currentScreenFrame.percentFlagX;
    BOOL flagY = iu.iuFrame.currentScreenFrame.percentFlagY;
    BOOL flagW = iu.iuFrame.currentScreenFrame.percentFlagWidth;
    BOOL flagH = iu.iuFrame.currentScreenFrame.percentFlagHeight;
    if(flagX){
        iu.iuFrame.currentScreenFrame.percentFlagX = NO;
    }
    if(flagY){
        iu.iuFrame.currentScreenFrame.percentFlagY = NO;
    }
    if(flagW){
        iu.iuFrame.currentScreenFrame.percentFlagWidth = NO;
    }
    if(flagH){
        iu.iuFrame.currentScreenFrame.percentFlagHeight = NO;
    }
    
    NSRect parentRect = parentIU.iuFrame.gridFrameFromScreen;
    NSPoint parentPoint = parentRect.origin;
    NSPoint iuPoint = iu.iuFrame.gridOriginFromScreen;

    //add obj!
    if(index < 0){
        [parentIU addIU:iu error:nil];
    }
    else{
        [parentIU insertIU:iu atIndex:index error:nil];
    }
    
    if(NSPointInRect(iuPoint, parentRect)){
        iu.iuFrame.currentScreenFrame.pixelX = iuPoint.x - parentPoint.x;
        iu.iuFrame.currentScreenFrame.pixelY = iuPoint.y - parentPoint.y;
    }
    else{
        iu.iuFrame.currentScreenFrame.pixelX = 5;
        iu.iuFrame.currentScreenFrame.pixelY = 5;
    }
    [iu setNeedsDisplay:IUNeedsDisplayActionCSS];
    
    
    [self.iuViewManager selectIUJS];
    
    if(flagX){
        iu.iuFrame.currentScreenFrame.percentFlagX = YES;
    }
    if(flagY){
        iu.iuFrame.currentScreenFrame.percentFlagY = YES;
    }
    if(flagW){
        iu.iuFrame.currentScreenFrame.percentFlagWidth = YES;
    }
    if(flagH){
        iu.iuFrame.currentScreenFrame.percentFlagHeight = YES;
    }
    [self.undoManager enableUndoRegistration];
}


-(IUView *)findParentIU:(IUObj *)hitIU newIU:(IUObj *)newIU{
    if([hitIU isKindOfClass:[IUView class]]){
        if([hitIU respondsToSelector:@selector(shouldInsertIU:)]){
            if([hitIU shouldInsertIU:&newIU]){
                return (IUView *)hitIU;
            }
            else{
                return [self findParentIU:hitIU.parent newIU:newIU];
            }
        
        }else{
            return (IUView *)hitIU;
        }
    }else{
        return [self findParentIU:hitIU.parent newIU:newIU];
    }
    return nil;
}

-(IUObj*)makeIU:(NSString*)iuType atViewManagerPoint:(NSPoint)vManagerPoint properties:(NSDictionary *)properties{
    NSPoint pnt = [self makeIUpointCalibration:vManagerPoint inIU:nil];
    IUObj *hitIU = [rootIU iuHitTest:pnt];
    if (hitIU) {
        [self.iuViewManager disableUpdate:self];
        [self.iuViewManager disableSelection:self];

        IUObj *iu = [[NSClassFromString(iuType) alloc] init];
        /*for the undomanager
         * 내부에서 children을 넣는 경우에 undomanager가 없어서 동작하지 않음.
         * makeIU로 생성되는 IU들은 manager를 바로 할당시켜줌.
        */
        [iu setIuManager:self];
        IUView *parentIU = [self findParentIU:hitIU newIU:iu];
        if(parentIU == nil){
            [JDLogUtil alert:@"Error : can't find parent IU" ];
            return nil;
        }

        NSPoint pntInParent = [self makeIUpointCalibration:vManagerPoint inIU:parentIU];
        [iu instantiate];
        [iu setProperties:properties];
        if ([iu shouldChangeXByUserInput:pntInParent.x]) {
            iu.iuFrame.defaultScreenFrame.pixelX = pntInParent.x;
        }
        if ([iu shouldChangeYByUserInput:pntInParent.y]) {
            iu.iuFrame.defaultScreenFrame.pixelY = pntInParent.y;
        }
        NSUInteger idx = parentIU.children.count;
        
        if ([iu respondsToSelector:@selector(shouldBeInsertedByUser:atIndex:)]) {
            if ([iu shouldBeInsertedByUser:&parentIU atIndex:&idx] == NO) {
                [self.iuViewManager enableUpdate:self];
                [self.iuViewManager enableSelection:self];
                return nil;
            }
        }
        if ([parentIU insertIU:iu atIndex:idx error:nil] == NO){
            [self.iuViewManager enableUpdate:self];
            [self.iuViewManager enableSelection:self];
            return nil;
        }
        [iu iuLoad];
        iu.iuLoaded = YES;
        if (iu.bg.img) {
            [iu fitToImage];
        }
 
        
        [self.iuViewManager enableUpdate:self];
        [self.pWC.iuController rearrangeObjects];
        [self.pWC.iuController setSelectionObject:iu];
        [self.iuViewManager enableSelection:self];
        
        
        //Open Text Panel after select object.
        /*
        if([iu isKindOfClass:[IUText class]]){
            IUTextPanelWC *iuTextPanel =  [IUTextPanelWC sharedInstanceWithPWC:self.pWC];
            [iuTextPanel showWindow:nil];
        }
         */


        return iu;
    }
    return nil;
}



-(NSString*)fileNameOfFullIUName:(NSString*)fullIUName{
    NSArray *arr = [fullIUName componentsSeparatedByString:@"__"];
    return [arr objectAtIndex:[arr count]-3];
}

-(NSString*)IUNameOfFullIUName:(NSString*)fullIUName{
    NSArray *arr = [fullIUName componentsSeparatedByString:@"__"];
    return [arr objectAtIndex:[arr count]-1];
}

#pragma mark -
#pragma mark Rightmenu- align

-(void)alignLeft{
    NSArray *selectedIUs = pWC.iuController.selectedObjects;
    IUObj *iu = [selectedIUs objectAtIndex:0];
    CGFloat iux = iu.iuFrame.currentScreenFrame.pixelX;
    
    for(IUObj *obj in selectedIUs){
        CGFloat movePointX = iux - obj.iuFrame.currentScreenFrame.pixelX ;
        [obj moveX:movePointX Y:0];
    }
    
}
-(void)alignRight{
    NSArray *selectedIUs = pWC.iuController.selectedObjects;
    IUObj *iu = [selectedIUs objectAtIndex:0];
    CGFloat iux = iu.iuFrame.currentScreenFrame.pixelX + iu.iuFrame.currentScreenFrame.pixelWidth;
    
    for(IUObj *obj in selectedIUs){

        CGFloat movePointX =iux - obj.iuFrame.currentScreenFrame.pixelWidth-obj.iuFrame.currentScreenFrame.pixelX;
        [obj moveX:movePointX Y:0];
    }
    
}
-(void)alignCenter{
    NSArray *selectedIUs = pWC.iuController.selectedObjects;
    IUObj *iu = [selectedIUs objectAtIndex:0];
    CGFloat iux = iu.iuFrame.currentScreenFrame.pixelX + (iu.iuFrame.currentScreenFrame.pixelWidth /2);
    
    for (IUObj *obj in selectedIUs){
        CGFloat movePointX = iux - (obj.iuFrame.currentScreenFrame.pixelWidth/2) - obj.iuFrame.currentScreenFrame.pixelX ;
        [obj moveX:movePointX Y:0];
    }
    
    
}
-(void)alignTop{
    NSArray *selectedIUs = pWC.iuController.selectedObjects;
    IUObj *iu = [selectedIUs objectAtIndex:0];
    CGFloat iuy = iu.iuFrame.currentScreenFrame.pixelY;
    
    for(IUObj *obj in selectedIUs){
        CGFloat movePointY = iuy- obj.iuFrame.currentScreenFrame.pixelY;
        [obj moveX:0 Y:movePointY];
    }
    
}
-(void)alignBottom{
    NSArray *selectedIUs = pWC.iuController.selectedObjects;
    IUObj *iu = [selectedIUs objectAtIndex:0];
    CGFloat iuy = iu.iuFrame.currentScreenFrame.pixelY + iu.iuFrame.currentScreenFrame.pixelHeight;
    
    for(IUObj *obj in selectedIUs){
        CGFloat movePointY = iuy - obj.iuFrame.currentScreenFrame.pixelHeight - obj.iuFrame.currentScreenFrame.pixelY;
        [obj moveX:0 Y:movePointY];
    }
    
}
-(void)alignMiddle{
    NSArray *selectedIUs = pWC.iuController.selectedObjects;
    IUObj *iu = [selectedIUs objectAtIndex:0];
    CGFloat iuy = iu.iuFrame.currentScreenFrame.pixelY + iu.iuFrame.currentScreenFrame.pixelHeight/2;
    
    for(IUObj *obj in selectedIUs){
        CGFloat movePointY = iuy - obj.iuFrame.currentScreenFrame.pixelHeight/2 - obj.iuFrame.currentScreenFrame.pixelY;
        [obj moveX:0 Y:movePointY];
    }
    
}


#pragma mark -
#pragma mark copy & paste

-(void) pasteIUs:(NSArray*)ius toIU:(IUView*)parent{
    [self.iuViewManager disableUpdate:self];
    IUObj *copiedObj;
    for (IUObj *iu in ius){
        IUObj *newIU = [iu copy];
        if ([newIU isKindOfClass:[IUView class]]) {
            NSArray *allChildren = [(IUView*)newIU allChildren];
            for (IUObj *child in allChildren) {
                NSString *newName = [NSString stringWithFormat:@"%@_copy", child.name];
            
                if ([self validateName:newName err:nil] == NO) {
                    int i = 1;
                    while (1) {
                        i++;
                        newName = [NSString stringWithFormat:@"%@_copy%d", child.name, i];
                        if ([self validateName:newName err:nil]) {
                            break;
                        }
                    }
                }
                child.name = newName;
            }
        }
        copiedObj = newIU;
        NSString *newName = [NSString stringWithFormat:@"%@_copy", iu.name];
        if ([self validateName:newName err:nil] == NO) {
            int i = 1;
            while (1) {
                i++;
                newName = [NSString stringWithFormat:@"%@_copy%d", iu.name, i];
                if ([self validateName:newName err:nil]) {
                    break;
                }
            }
        }
        newIU.name = newName;
        [parent addIU:newIU error:nil];
        
        //same parent : move to original Point+10px
        if([iu.parent isEqualTo:parent]){
            for (NSString *frame in newIU.iuFrame.screenFrameDict) {
                IUScreenFrame *screenFrame = [newIU.iuFrame.screenFrameDict objectForKey:frame];
                if(screenFrame.loaded){
                    if ([newIU shouldChangeXByUserInput:screenFrame.pixelX + 10]) {
                        screenFrame.pixelX = screenFrame.pixelX + 10;
                        screenFrame.percentX = screenFrame.percentX +5;
                    }
                    if ([newIU shouldChangeYByUserInput:screenFrame.pixelY + 10]) {
                        screenFrame.pixelY = screenFrame.pixelY + 10;
                        screenFrame.percentY = screenFrame.percentY+5;
                    }
                }
            }
        }
        //copy from other parent : move to (0, 0)
        else{
            for (NSString *frame in newIU.iuFrame.screenFrameDict) {
                IUScreenFrame *screenFrame = [newIU.iuFrame.screenFrameDict objectForKey:frame];
                if(screenFrame.loaded){
                    if ([newIU shouldChangeXByUserInput:0]) {
                        screenFrame.pixelX = 0;
                        screenFrame.percentX =0;
                    }
                    if ([newIU shouldChangeYByUserInput:0]) {
                        screenFrame.pixelY = 0;
                        screenFrame.percentX =0;
                    }
                }
            }
        }
        if ([newIU isKindOfClass:[IUText class]]) {
            [(IUText *)newIU attributeTextContextDidChange];
        }
    }
    
    [self.pWC.iuController rearrangeObjects];
    [parent setNeedsDisplay:IUNeedsDisplayActionAll];
    [self.iuViewManager enableUpdate:self];
    [self.pWC.iuController setSelectionObject:copiedObj];
}

-(BOOL)validateName:(NSString*)name err:(NSError *__autoreleasing *)err{
    if ([name characterAtIndex:0] >= '0' && [name characterAtIndex:0] <='9') {
        NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey : @"Name cannot start with number" };
        if (err != nil) {
            *err  = [[NSError alloc] initWithDomain:@"IU" code:1 userInfo:userInfoDict];
        }
        return NO;
    }
    if ([name length] == 0) {
        NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey : @"Name cannot have zero length" };
        if (err != nil) {
            *err  = [[NSError alloc] initWithDomain:@"IU" code:1 userInfo:userInfoDict];
        }
        return NO;
    }
    IUObj *iu = [self childIUOfName:name ofIU:nil];
    if (iu) {
        NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey : @"Duplicated name"};
        if (err != nil) {
            *err  = [[NSError alloc] initWithDomain:@"IU" code:1 userInfo:userInfoDict];
        }
        return NO;
    }
    return YES;
}

@end

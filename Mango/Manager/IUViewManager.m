
//
//  IUViewManager.m
//  Mango
//
//  Created by JD on 13. 5. 24..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUViewManager.h"
#import "IUController.h"
#import "IUManager.h"
#import "IUPointLayer.h"
#import "IUObj.h"
#import "IUFrameManager.h"
#import "JDCursor.h"
#import "IUTextToolbarVC.h"

@implementation IUViewManager{
    int    disableUpdateLevel;
    int    disableSelectionLevel;
    
    NSMutableString *cachedJS;
    NSMutableSet *HTMLChangedIUs;
    NSMutableSet *CSSChangedIUs;
    NSMutableSet *insertedIUs;
    NSMutableSet *deletedIUs;
    NSMutableString *disableLog;;
    BOOL loaded;
    WebScriptObject *scriptObject;
    BOOL    mouseDown;
}


/* Initialized Part */

-(id)init{
    self = [super init];
    if (self) {
        
        [self registerForDraggedTypes:@[(id)kUTTypeIUType]];

        [self addObserver:self forKeyPaths:@[@"self.manager.rootIU.iuFrame.currentScreenFrame.pixelHeight",
                                             @"self.manager.rootIU.iuFrame.currentScreenFrame.pixelWidth",
                                             @"self.manager.rootIU.templateIU.body.iuFrame.currentScreenFrame.pixelY"
                                             ] options:0 context:@"@selector(resetSize)"];

        HTMLChangedIUs = [NSMutableSet set];
        CSSChangedIUs = [NSMutableSet set];
        insertedIUs = [NSMutableSet set];
        deletedIUs = [NSMutableSet set];
        self.jsLog = [NSMutableString string];
        cachedJS = [NSMutableString string];
        disableLog = [NSMutableString string];
        
        
        /*Web Source Part*/
        //editWebV can intercept event: Need to nextResponder remapping
        editWebV = [[WebView alloc] initWithFrame:self.frame frameName:@"canvasWebview" groupName:@"canvas"];
        editWebV.resourceLoadDelegate = self;
        editWebV.frameLoadDelegate = self;
        [editWebV.mainFrame.frameView setAllowsScrolling:NO];
        [self addSubviewFullFrame:editWebV];
        
    }
    return self;
}

-(void)dealloc{
    [self removeObserver:self forKeyPaths:@[@"self.manager.rootIU.iuFrame.currentScreenFrame.pixelHeight",
                                            @"self.manager.rootIU.iuFrame.currentScreenFrame.pixelWidth",
                                            @"self.manager.rootIU.templateIU.body.iuFrame.currentScreenFrame.pixelY"
                                            ]];
    NSLog(@"error");
    assert(0);
}




-(void)setManager:(IUManager *)manager{
    _manager = manager;
    rootIU = _manager.rootIU;
    pWC = manager.pWC;
   

    //apply template size to view frame
    [self resetSizeWithScreenType:IUScreenTypeDefault];

    //setting gridView
    gridView = [[IUGridView alloc] init];
    [self addSubviewFullFrame:gridView positioned:NSWindowAbove relativeTo:editWebV];
    
    
    /*Initialize Web View */
    [pWC.iuController addObserver:self forKeyPath:@"selectedObjects" options:NSKeyValueObservingOptionInitial context:nil];
    [pWC addObserver:self forKeyPath:@"selectedScreenType" options:0 context:nil];
    
    
    //put image and then set position
    NSImage *image = [[NSImage alloc] initWithContentsOfFile: [rootIU.project.absoluteResDirPath stringByAppendingPathComponent:rootIU.sampleImage]];
    [gridView setSampleImage:image];
    [gridView setSampleImageXModifier:rootIU.sampleImageXModifier];
    [gridView setSampleImageYModifier:rootIU.sampleImageYModifier];
    
  
}


#pragma mark -
#pragma mark WEB View


- (void)webView:(WebView *)sender didFinishLoadForFrame:(WebFrame *)frame {
    if (frame == [frame findFrameNamed:@"_top"]) {
        scriptObject = [sender windowScriptObject];
        [scriptObject setValue:self forKey:@"MyApp"];
        [scriptObject evaluateWebScript:@"console = { log: function(msg) { MyApp.consoleLog_(msg); } }"];
    }
}
- (void)consoleLog:(NSString *)aMessage {
    if ([aMessage isKindOfClass:[NSString class]] == NO) {
        return;
    }
    if ([aMessage length] > 14 && [[aMessage substringToIndex:12] isEqualToString:@"IURunResult:"]) {
        NSLog(@"IUJSRun Arrived");
        NSString *jsonStr = [aMessage substringFromIndex:12];
        NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e = nil;
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e] ;
        [self.manager.frameManager setAutoPixelFrame:dictionary];
    }
    NSLog(@"JSLog: %@", aMessage);
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)aSelector {
    if (aSelector == @selector(consoleLog:)) {
        return NO;
    }
    
    return YES;
}


/* JavaScript Part */
#pragma mark -
#pragma mark JavaScript

-(void)addJavascript:(NSString*)javascript{
    for (IUFile *file in rootIU.referenceIUs) {
        [file.iuManager.iuViewManager addJavascript:javascript];
    }
    [cachedJS appendString:javascript];
    [cachedJS appendString:@"\n"];
}

-(NSString *)stringSelectedIUNames{
    
    NSMutableArray *selectedIUArray = [NSMutableArray array];
    for(IUObj *obj in pWC.iuController.selectedObjects){
        if(![selectedIUArray containsObject:obj.fullIUName]){
            [selectedIUArray addObject:obj.fullIUName];
        }
        
    }
   
    NSString *arrayString = [selectedIUArray componentsJoinedByString:@"','"];
    return [[NSString alloc] initWithFormat:@"['%@']", arrayString];

}

-(NSString*)stringInsertedIUNames{
    
    NSMutableArray *selectedIUArray = [NSMutableArray array];
    
    
    for(IUObj *obj in insertedIUs){
        if(![selectedIUArray containsObject:obj.fullIUName]){
            [selectedIUArray addObject:obj.fullIUName];
        }
        
    }
    
    [selectedIUArray addObject:self.manager.rootIU.fullIUName];
    NSString *arrayString = [selectedIUArray componentsJoinedByString:@"','"];
    return [[NSString alloc] initWithFormat:@"['%@']", arrayString];
    
    
}

-(void)getAllIUFrame{
    NSLog(@"get ALl IUFrame");
    [cachedJS setString:@" "];
    [self finalizeJavascript];
}

-(void)finalizeJavascript{
    if ([cachedJS length]) {
        NSString *wrappedJS = [NSString stringWithFormat:@"IUJSRun(\"%@\")", [cachedJS stringEscape]];
        NSString *newFrameStr = [editWebV stringByEvaluatingJavaScriptFromString:wrappedJS];
        NSData *jsonData = [newFrameStr dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e = nil;
        
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
        cachedJS = [NSMutableString string];

        [self.jsLog appendString:wrappedJS];
        [self.jsLog appendString:@"\n"];
        [self.jsLog appendString:@"\n"];

        if (e) {
            NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [JDLogUtil log:@"finanlizeError" err:e];
            NSLog(str, nil);
            return;
        }
        if(dictionary == nil) return;

        
        NSDictionary *pixelDict = [dictionary objectForKey:@"pixel"];
        NSDictionary *percentDict = [dictionary objectForKey:@"percent"];
        [self.manager.frameManager setAutoPixelFrame:pixelDict];
        [self.manager.frameManager setAutoPercentFrame:percentDict];
        
        DLog("%@", wrappedJS);
    }
}

-(CGFloat)getPercentWidth:(IUObj *)obj withX:(CGFloat)x{
    NSString *js = [NSString stringWithFormat:@"$('[iuname = %@]').getPercentWidth(%f)", obj.fullIUName, x];
    NSString *retValue = [editWebV stringByEvaluatingJavaScriptFromString:js];
    return [retValue floatValue];
    
}

-(CGFloat)getPercentHeight:(IUObj *)obj withY:(CGFloat)y{
    NSString *js = [NSString stringWithFormat:@"$('[iuname = %@]').getPercentHeight(%f)", obj.fullIUName, y];
    NSString *retValue = [editWebV stringByEvaluatingJavaScriptFromString:js];
    return [retValue floatValue];
    
}

-(CGFloat)getTextWidth:(IUText*)obj{
    NSString *js = [NSString stringWithFormat:@"$('[iuname = %@]').textWidth()", obj.fullIUName];
    NSString *retValue = [editWebV stringByEvaluatingJavaScriptFromString:js];
    return [retValue floatValue];
}

-(CGFloat)getTextHeight:(IUText*)obj{
    NSString *js = [NSString stringWithFormat:@"$('[iuname = %@]').textHeight()", obj.fullIUName];
    NSString *retValue = [editWebV stringByEvaluatingJavaScriptFromString:js];
    return [retValue floatValue];
}

-(id)runOneLineJS:(NSString *)js{
    return [editWebV stringByEvaluatingJavaScriptFromString:js];
}


-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

-(void)reset{
    loaded = NO;
    [deletedIUs removeAllObjects];
    [insertedIUs removeAllObjects];
    [HTMLChangedIUs removeAllObjects];
    [CSSChangedIUs removeAllObjects];
    [self update];
}

-(BOOL)isUpdateEnabled{
    if (disableUpdateLevel) {
        return NO;
    }
    return YES;
}

-(void)update{
    if (disableUpdateLevel == YES) {
//        DLog("==================================\n%@", disableLog);
        return;
    }
    if (rootIU.iuLoaded){
        if (loaded == NO) {
            //시작할때만 로딩
            NSMutableString *viewSource = [[NSMutableString alloc] initWithString:[rootIU source:IUSourceTypeEditor]];
            self.initialWebSource = viewSource;
            [_jsLog setString:@""];
            [editWebV.mainFrame loadHTMLString:viewSource baseURL:pWC.project.fileURL];
            loaded = YES;
        }
        else {
            if ([insertedIUs count]==0 && [HTMLChangedIUs count] == 0 && [CSSChangedIUs count] == 0 && [deletedIUs count] == 0) {
                return;
            }

            for (IUObj *obj in insertedIUs) {
                [self addJavascript:obj.insertionJavascript];
            }
            for (IUObj *obj in HTMLChangedIUs) {
                [self addJavascript:obj.HTMLChangeJavascript];
            }
            for (IUObj *obj in CSSChangedIUs) {
                [self addJavascript:obj.CSSChangeJavascript];
            }
            for (IUObj *obj in deletedIUs) {
                NSString *styleJavascript = [NSString stringWithFormat:@"setIUStyle('%@', null, %ld);", obj.fullIUName, [obj iuStyleType]];
                NSString *htmlJavascript = [NSString stringWithFormat:@"$(\"[iuname=%@]\").remove()", obj.fullIUName];
                [self addJavascript:styleJavascript];
                [self addJavascript:htmlJavascript];
            }
            [self finalizeJavascript];
            
            //after insertion.
            for(IUObj *obj in insertedIUs){
                [obj javascriptDidInsert];
            }
        }
    }
    [CSSChangedIUs removeAllObjects];
    [HTMLChangedIUs removeAllObjects];
    [insertedIUs removeAllObjects];
    [deletedIUs removeAllObjects];
    
}

-(void)selectIUJS{
    if (disableSelectionLevel) {
        return;
    }
    NSString *stringJS = [NSString stringWithFormat:@"selectIU(%@)", [self stringSelectedIUNames]];
    NSString *newFrameStr = [editWebV stringByEvaluatingJavaScriptFromString:stringJS];
    

    NSData *jsonData = [newFrameStr dataUsingEncoding:NSUTF8StringEncoding];
    if ([jsonData length] == 0) {
        return;
    }
    NSError *e = nil;
    
    NSDictionary *percentDict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
    if (e) {
        [JDLogUtil log:@"finanlizeError" err:e];
        return;
    }
    
    [self.manager.frameManager setAutoPercentFrame:percentDict];
}


-(void)disableUpdate:(id)sender{
    @synchronized(self){
        [disableLog appendFormat:@"before disable by %@   : [%d]\n", [sender description], disableUpdateLevel];
        disableUpdateLevel ++;
        [disableLog appendFormat:@"after disable by %@   : [%d]\n\n", [sender description], disableUpdateLevel];
    }
}

-(void)enableSelection:(id)sender{
    @synchronized(self){
        disableSelectionLevel ++;
        if (disableSelectionLevel == 0) {
            [self selectIUJS];
        }
    }
}

-(void)disableSelection:(id)sender{
    @synchronized(self){
        disableSelectionLevel --;
    }
}

-(void)enableUpdate:(id)sender{
    @synchronized(self){
        [disableLog appendFormat:@"before enable by %@   : [%d]\n", [sender description], disableUpdateLevel];
        if ([sender isKindOfClass:[IUManager class]]) {
        }
        disableUpdateLevel --;
        if (disableUpdateLevel == 0) {
            [self update];
        }
        if (disableUpdateLevel == -1) {
            assert(0);
        }
        [disableLog appendFormat:@"after by %@   : [%d]\n\n", [sender description], disableUpdateLevel];
    }
}

/* Set XXX NeedDisplay */
#pragma mark -
#pragma mark SetXXXDisplay

-(void)setInsertedIUNeedsDisplay:(IUObj*)obj{
    BOOL skipFlag = NO;
    IUView *objAsGroup;
    if ([obj isKindOfClass:[IUView class]]) {
        objAsGroup = (IUView*)obj;
    }
    
    NSArray *childrenWithObj = [objAsGroup.allChildren arrayByAddingObject:obj];
    for (IUObj *child in childrenWithObj) {
        [HTMLChangedIUs removeObject:child];
        [CSSChangedIUs removeObject:child];
        [deletedIUs removeObject:child];
    }
    for (IUObj *iu in obj.allParents) {
        if ([HTMLChangedIUs containsObject:iu] || [insertedIUs containsObject:iu]) {
            skipFlag = YES;
            break;
        }
    }
    if (obj && (skipFlag == NO) ) {
        if ([obj isKindOfClass:[IUView class]]) {
            for (IUObj *iu in ((IUView*)obj).allChildren ) {
                [deletedIUs removeObject:iu];
                [HTMLChangedIUs removeObject:iu];
                [insertedIUs removeObject:iu];
            }
        }
        [deletedIUs removeObject:self];
        [CSSChangedIUs removeObject:obj];
        [HTMLChangedIUs removeObject:obj];
        [insertedIUs addObject:obj];
    }
    if (disableUpdateLevel == NO) {
        [self update];
    }
}

-(void)setIUNeedsDisplay:(IUObj*)obj type:(IUNeedsDisplayActionType)type{
    if (obj) {
        if ([insertedIUs containsObject:obj] || [deletedIUs containsObject:obj]) {
            return;
        }
        if (type == IUNeedsDisplayActionCSS) {
            [CSSChangedIUs addObject:obj];
        }
        else if (type == IUNeedsDisplayActionHTML){
            [HTMLChangedIUs addObject:obj];
        }
        else if (type == IUNeedsDisplayActionAll){
            [CSSChangedIUs addObject:obj];
            [HTMLChangedIUs addObject:obj];
        }
        else{
            assert(0);
        }
    }
    if (disableUpdateLevel == NO) {
        [self update];
    }
}

-(void)setDeletedIUNeedsDisplay:(IUObj*)obj{
    if (obj) {
        if ([obj isKindOfClass:[IUView class]]) {
            for (IUObj *child in [(IUView*)obj allChildren]) {
                [insertedIUs removeObject:obj];
                [HTMLChangedIUs removeObject:obj];
                [CSSChangedIUs removeObject:obj];
                [deletedIUs removeObject:obj];
            }
        }
        [insertedIUs removeObject:obj];
        [HTMLChangedIUs removeObject:obj];
        [CSSChangedIUs removeObject:obj];
        [deletedIUs addObject:obj];
    }
    if (disableUpdateLevel == NO) {
        [self update];
    }
}


#pragma mark -
#pragma mark frame,size

-(BOOL)isFlipped{
    return YES;
}

-(void)setFrame:(NSRect)frameRect{
    [super setFrame:frameRect];
}

// 현재 사이즈를 뷰 사이즈에 맞춰줌

-(void)resetSize{
    [self resetSizeWithScreenType:self.manager.pWC.selectedScreenType];
}

-(void)resetSizeWithScreenType:(IUScreenType)type{
    NSRect viewSize = [self.manager.rootIU.iuFrame boundWithType:type];
    
    //check loaded
    if(viewSize.size.width ==0 && viewSize.size.height==0){//not yet loaded
        //set to default
        viewSize = NSMakeRect(0, 0, 1024, 1370);
    }

    if ([self.manager.rootIU isKindOfClass:[IUPage class]]) {
        viewSize.size.height += self.manager.frameManager.templatePoint.y;
    }

    switch (type) {
        case IUScreenTypeDefault:{
            IUScreenFrame *frame = [rootIU.iuFrame screenFrame:IUScreenTypeDefault];
            viewSize.size.width = frame.pixelWidth;
        }
            break;
        case IUScreenTypeTablet:
            viewSize.size.width = IUScreenTabletSize;
            break;
        case IUScreenTypeMobile:
            viewSize.size.width = IUScreenMobileSize;
            break;
        default:
            assert(0);
    }
    
    self.frame = viewSize;
    return;

}
/***************************************************************************************************/

#pragma mark -
#pragma mark Event Part
/*
 *****************************
 * pass to appropriate class!
 *****************************
 */


/*clicked IU change*/
-(void)selectedObjectsDidChange{
    if (pWC.selectedIUManager == self.manager) {
        gridView.selectedIUs = pWC.iuController.selectedObjects;
        [self selectIUJS];
    }
    [pWC.textToolbarVC resetToolBarState];
}

-(BOOL)acceptsFirstResponder{
    return YES;
}


-(NSView *)hitTest:(NSPoint)aPoint{
    if(self.isOpenTextView){
        return [super hitTest:aPoint];
    }
    return self;
}

#pragma mark dragging (makeIU)
- (NSDragOperation)draggingEntered:(id<NSDraggingInfo>)sender{
    return NSDragOperationEvery;
}

-(BOOL)performDragOperation:(id<NSDraggingInfo>)sender{
    NSPasteboard *pBoard = sender.draggingPasteboard;
    
    NSString *iuType =  [pBoard stringForType:(id)kUTTypeIUType];
    NSDictionary *iuDict;
    NSData *data = [pBoard dataForType:kUTTypeIUProperty];
    if (data) {
        iuDict =  [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    }
    
    NSPoint pnt = [sender draggingLocation];
    pnt = [JDUIUtil pointRoundf:pnt];
    if ([_manager makeIU:iuType atViewManagerPoint:pnt properties:iuDict ]){
        [self becomeFirstResponder];
        return YES;
    }
    return NO;
}


#pragma mark mouseEvent

- (void)mouseDown:(NSEvent *)theEvent{
    NSPoint point = [self convertPoint:theEvent.locationInWindow fromView:nil];
    //Drag & operation (rect resize)
    for(CALayer *sublayer in gridView.layer.sublayers){
        if([sublayer isKindOfClass:[IUPointLayer class]]
           && NSPointInRect(point, sublayer.frame)){
            [self.manager IUPointDown:(IUPointLayer *)sublayer event:theEvent];
            return;
        }
    }
    
    if ([NSCursor currentCursor] == [NSCursor openHandCursor]) {
        [self.window disableCursorRects];
        [[NSCursor closedHandCursor] push];
    }
    else if ([NSCursor currentCursor] == [NSCursor pointingHandCursor]) {
        [self.window disableCursorRects];
        [[NSCursor crosshairCursor] push];
    }
    
    [_manager mouseDown:theEvent];
    mouseDown = YES;
    [super mouseDown:theEvent];
}

-(void)mouseUp:(NSEvent *)theEvent{
    [_manager mouseUp:theEvent];
    mouseDown = NO;
    [super mouseUp:theEvent];
}

-(void)mouseDragged:(NSEvent *)theEvent{
    if(self.isOpenTextView == NO){
        //text editor 창이 열려있으면 iu는 움직이지 않는다.
        [_manager mouseDragged:theEvent];
    }
    [super mouseDragged:theEvent];
}


-(void)mouseMoved:(NSEvent *)theEvent{
    if ([NSCursor currentCursor] == [NSCursor arrowCursor]) {
        [self.window invalidateCursorRectsForView:self];
    }
    [super mouseMoved:theEvent];
}

- (void)resetCursorRects{
    NSArray *allChildren = [[self.manager.rootIU allChildren] arrayByAddingObject:self.manager.rootIU];
    for (IUObj *iu in allChildren) {
        BOOL noMoveFlag = iu.iuFrame.horizontalCenter & iu.iuFrame.verticalCenter;
        if (iu.draggable && noMoveFlag == NO ) {
            [self addCursorRect:[iu.iuFrame gridFrameFromScreen] cursor:[NSCursor openHandCursor]];
        }
        else{
            [self addCursorRect:[iu.iuFrame gridFrameFromScreen]  cursor:[NSCursor pointingHandCursor]];
        }
    }
    
    NSPoint hotspot = NSPointMake(12, 12);
    for (IUPointLayer *pLayer in gridView.pointLayers) {
        NSRect modifiedRect = pLayer.frame;
        switch ( ((IUPointLayer *)pLayer).location) {
            case  kIULocationTopLeft:
            case  kIULocationBotRight:
            {
                NSImage *img = [NSImage imageNamed:@"ResizeNW-SE"];
                JDCursor *cursor = [[JDCursor alloc] initWithImage:img hotSpot:hotspot];
                [self addCursorRect:modifiedRect cursor:cursor];
                [cursor setOnMouseExited:YES];
                pLayer.cursor = cursor;
                break;
            }
            case  kIULocationTopCenter:
            case  kIULocationBotCenter:
            {
                NSImage *img = [NSImage imageNamed:@"ResizeN-S"];
                JDCursor *cursor = [[JDCursor alloc] initWithImage:img hotSpot:hotspot];
                [self addCursorRect:modifiedRect cursor:cursor];
                pLayer.cursor = cursor;
                break;
            }
            case  kIULocationTopRight:
            case  kIULocationBotLeft:
            {
                NSImage *img = [NSImage imageNamed:@"ResizeNE-SW"];
                NSCursor *cursor = [[NSCursor alloc] initWithImage:img hotSpot:hotspot];
                [self addCursorRect:modifiedRect cursor:cursor];
                pLayer.cursor = cursor;
                break;
            }
            case  kIULocationMidLeft:
            case  kIULocationMidRight:{
                NSImage *img = [NSImage imageNamed:@"ResizeE-W"];
                NSCursor *cursor = [[NSCursor alloc] initWithImage:img hotSpot:hotspot];
                [self addCursorRect:modifiedRect cursor:cursor];
                pLayer.cursor = cursor;
                break;
            }
        }
    }
}

//right mouse down, pass to gridView
//* policy : gridView can only know IUObj content
-(void)rightMouseDown:(NSEvent *)theEvent{
    if(self.isOpenTextView == NO){
        //select IU (left mouse down)
        [self mouseDown:theEvent];
        //show right popup menu
        [gridView rightMouseDown:theEvent withIUManager:self.manager];
    }
}

//** keyboard handler
//* only handle direction arrow keys & delete key
//* call IUManager!
-(void)keyDown:(NSEvent *)theEvent{
    unichar key = [[theEvent charactersIgnoringModifiers] characterAtIndex:0];
    switch(key){
            //delete IUObject
        case NSDeleteCharacter:
            
            //move IUObject
        case NSLeftArrowFunctionKey:
        case NSRightArrowFunctionKey:
        case NSUpArrowFunctionKey:
        case NSDownArrowFunctionKey:
            //manage keydown event IUManager
            [_manager keyDown:theEvent];
            break;
        default:
            break;
    }
    [super keyDown:theEvent];
}

#pragma mark -
#pragma mark Text Editor
-(void)enableTextEditor:(IUObj *)clickedObj{
    self.isOpenTextView = YES;
    NSRect currectRect = clickedObj.iuFrame.gridFrameFromScreen;
    NSScrollView *scrollV = pWC.textToolbarVC.textEditV;
    [self addSubview:scrollV];
    [scrollV setFrame:currectRect];
    [scrollV setHidden:NO];
    [pWC.textToolbarVC resetToolBarState];
    [pWC.window makeFirstResponder:scrollV];

}

-(void)makeTextVFirstResponder{
    NSScrollView *scrollV = pWC.textToolbarVC.textEditV;
    [pWC.window makeFirstResponder:scrollV];
}

-(void)disableTextEditor{
    self.isOpenTextView = NO;
    NSScrollView *scrollV = pWC.textToolbarVC.textEditV;
    [scrollV removeFromSuperview];
    [pWC.window makeFirstResponder:self];
}


#pragma mark -
#pragma mark - gridView

/* GHOSTIMAGE SETTING */
-(void)setGridGhostImage:(NSImage *)image{
    gridView.sampleImage = image;
}

-(void)setGridGhostXModifier:(NSUInteger)x{
    gridView.sampleImageXModifier = x;
}
-(void)setGridGhostYModifier:(NSUInteger)y{
    gridView.sampleImageYModifier = y;
}

#pragma mark -

-(void)setAssistantLine:(id)sender{
    [gridView setAssistantLine:sender];
}

-(void)setBorderLayer:(id)sender{
    [gridView setBorderLayer:sender];
}

-(void)setShadowLayer:(id)sender{
    [gridView setShadowLayer:sender];
}
@end

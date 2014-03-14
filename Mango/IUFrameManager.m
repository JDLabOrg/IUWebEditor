//
//  IUFrame2.m
//  WebGenerator
//
//  Created by JD on 11/16/13.
//  Copyright (c) 2013 jdlab.org. All rights reserved.
//

#import "IUFrameManager.h"
#import "IUObj.h"
#import "IUManager.h"
#import "IUViewManager.h"
#import "IUCSS.h"
#import "IUBody.h"
#import "IUNaviLinkBarItem.h"
#import "IUFixedGroup.h"
#import "IUCarouselItem.h"
#import "IUCarouselItemBox.h"

#pragma mark -
#pragma mark IUFrameManager

@interface IUFrameManager()
@end


@implementation IUFrameManager

-(id)init{
    self = [super init];
    if (self) {
    }
    return self;
}


-(void)setAutoPixelFrame:(NSDictionary *)dict{
    NSLog(@"setAutoPixelFrame For %@", self.manager.rootIU.description);
    NSLog([dict description],nil);
    //window width가 0이면 autoframe 을 돌리지 않는다
//    NSDictionary *window = [dict objectForKey:@"window"];
//    if ([[window objectForKey:@"width"] intValue] == 0) {
//        return;
//    }
    for (NSString *fullIUName in dict) {
        if ([fullIUName isEqualToString:@"window"] || [fullIUName isEqualToString:@"document"]) {
            continue;
        }
        NSString *fileName = [self.manager fileNameOfFullIUName:fullIUName];
        NSString *IUName = [self.manager IUNameOfFullIUName:fullIUName];
        NSDictionary *IUDict = [dict objectForKey:fullIUName];
        
        if ([fileName isEqualToString:[self.manager.filePath nameWithoutExtensionAsFile]]) {
            IUObj *obj = [self.manager childIUOfName:IUName ofIU:nil];
            
            BOOL  changed;
            
            CGFloat left = [[IUDict objectForKey:@"left"] floatValue];
            CGFloat top = [[IUDict objectForKey:@"top"] floatValue];
            CGFloat width = [[IUDict objectForKey:@"width"] floatValue];
            CGFloat height = [[IUDict objectForKey:@"height"] floatValue];
            
            
            //setting width
            if (obj.iuFrame.currentScreenFrame.pixelWidth != width) {
                changed = YES;
                obj.iuFrame.currentScreenFrame.pixelWidth = width;
            }
            //setting height
            if (obj.iuFrame.currentScreenFrame.pixelHeight != height) {
                changed = YES;
                obj.iuFrame.currentScreenFrame.pixelHeight = height;
            }
            
            
            /* setting only width and height
             * Ignore position
             */
            if([obj isKindOfClass:[IUCarouselItem class]]) continue;
            

            
            //setting X
            if (obj.iuFrame.currentScreenFrame.pixelX  != left){
                changed = YES;
                obj.iuFrame.currentScreenFrame.pixelX = left;
            }
            
            //setting Y
            if (obj.iuFrame.currentScreenFrame.pixelY != top) {
                changed = YES;
                obj.iuFrame.currentScreenFrame.pixelY = top;
            }
            
            
            //setting flowlayout
            if (obj.iuFrame.currentScreenFrame.flowLayout) {
                CGFloat marginTop = [[IUDict objectForKey:@"marginTop"] floatValue];
                CGFloat marginLeft =[[IUDict objectForKey:@"marginLeft"] floatValue];
                
                //setting margin top
                if(obj.iuFrame.currentScreenFrame.pixelMarginTop != marginTop){
                    changed = YES;
                    obj.iuFrame.currentScreenFrame.pixelMarginTop = marginTop;
                }
                //setting margin left
                if(obj.iuFrame.currentScreenFrame.pixelMarginLeft != marginLeft){
                    changed = YES;
                    obj.iuFrame.currentScreenFrame.pixelMarginLeft = marginLeft;
                }
            }
            [obj.iuFrame changeRect];
        }
    }
}

-(void)setAutoPercentFrame:(NSDictionary*)dict{
//    NSLog(@"AutoFrame Received");
//    NSLog([dict description],nil);
    //window width가 0이면 autoframe 을 돌리지 않는다
    for (NSString *fullIUName in dict) {
        if ([fullIUName isEqualToString:@"window"] || [fullIUName isEqualToString:@"document"]) {
            continue;
        }
        NSString *fileName = [self.manager fileNameOfFullIUName:fullIUName];
        NSString *IUName = [self.manager IUNameOfFullIUName:fullIUName];
        NSDictionary *IUDict = [dict objectForKey:fullIUName];
        
        if ([fileName isEqualToString:[self.manager.filePath nameWithoutExtensionAsFile]]) {
            IUObj *obj = [self.manager childIUOfName:IUName ofIU:nil];
            
            CGFloat percentLeft = [[IUDict objectForKey:@"percentLeft"] floatValue];
            CGFloat percentTop = [[IUDict objectForKey:@"percentTop"] floatValue];
            CGFloat percentWidth = [[IUDict objectForKey:@"percentWidth"] floatValue];
            CGFloat percentHeight = [[IUDict objectForKey:@"percentHeight"] floatValue];
            
            //setting X
            if(obj.iuFrame.currentScreenFrame.percentX != percentLeft){
                obj.iuFrame.currentScreenFrame.percentX = percentLeft;
            }
            
            //setting Y
            if( obj.iuFrame.currentScreenFrame.percentY != percentTop ){
                obj.iuFrame.currentScreenFrame.percentY = percentTop;
            }
            
            //setting width
            if( obj.iuFrame.currentScreenFrame.percentWidth != percentWidth ){
                obj.iuFrame.currentScreenFrame.percentWidth = percentWidth;
            }
            
            //setting height
            if( obj.iuFrame.currentScreenFrame.percentHeight != percentHeight ){
                obj.iuFrame.currentScreenFrame.percentHeight = percentHeight;
            }
            
            CGFloat percentMarginTop = [[IUDict objectForKey:@"percentMarginTop"] floatValue];
            CGFloat percentMarginLeft = [[IUDict objectForKey:@"percentMarginLeft"] floatValue];
            
            //setting margin top
            if(obj.iuFrame.currentScreenFrame.percentMarginTop != percentMarginTop){
                obj.iuFrame.currentScreenFrame.percentMarginTop = percentMarginTop;
            }
            
            //setting margin left
            if(obj.iuFrame.currentScreenFrame.percentMarginLeft != percentMarginLeft){
                obj.iuFrame.currentScreenFrame.percentMarginLeft = percentMarginLeft;
            }
            
            
            
        }
    }

}

-(NSPoint)templatePoint{
    IUPage *pageIU = (IUPage *)self.manager.rootIU;
    return NSPointMake(pageIU.templateIU.body.iuFrame.currentScreenFrame.pixelX, pageIU.templateIU.body.iuFrame.currentScreenFrame.pixelY);
}

@end

#pragma mark -
#pragma mark IUFrame2 Start
#pragma mark Initialize

@implementation IUFrame2

@synthesize currentScreenFrame;

+(NSMutableArray*)propertyList{
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:@[@"verticalCenter",
                 @"horizontalCenter",
                 @"autoHeight",
                 @"fixed"
                 ]];
    return array;
}

-(id)init{
    self = [super init];
    if (self) {
        self.screenFrameDict = [[NSMutableDictionary alloc] init];
        for(int i=0; i<NumberOfIUScreentType; i++){
            IUScreenFrame *temp = [[IUScreenFrame alloc] init];
            [temp bind:@"iu" toObject:self withKeyPath:@"iu" options:nil];
            switch (i) {
                case 0: temp.type = IUScreenTypeDefault; break;
                case 1: temp.type = IUScreenTypeTablet; break;
                case 2: temp.type = IUScreenTypeMobile; break;
                default:
                    assert(0);
                    break;
            }
            if(i == IUScreenTypeDefault){
                currentScreenFrame = temp;
                currentScreenFrame.loaded = YES;
            }
            
            [self.screenFrameDict setObject:temp forKey:[IUScreenFrame stringForScreenType:i]];
        }

    }
    return self;
}

-(IUScreenFrame*)defaultScreenFrame{
    return [self screenFrame:IUScreenTypeDefault];
}

-(void)iuFrameLoad{
    self.loaded = YES;
    if(self.iu.iuManager.pWC.selectedScreenType != IUScreenTypeDefault){
        [self setCurrentScreenType:self.iu.iuManager.pWC.selectedScreenType];
    }

    
    for(int i=0; i<NumberOfIUScreentType; i++){
        IUScreenFrame *temp = [self.screenFrameDict objectForKey:[IUScreenFrame stringForScreenType:i]];
        [temp bind:@"undoManager" toObject:self withKeyPath:@"undoManager" options:nil];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenTypeDidChange) name:@"ScreenTypeDidChangeNotification" object:nil];
}


-(void)dealloc{
    if(self.loaded){
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        
    }
}



#pragma mark -
#pragma mark dict

-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [self exportPropertyFromDictOfClass:[IUFrame2 class]];
    //save screenDictionary
    for(int i=0; i<NumberOfIUScreentType; i++){
        NSString *key = [IUScreenFrame stringForScreenType:i];
        IUScreenFrame *temp = [self.screenFrameDict objectForKey:key];
        if (temp.loaded){
            NSMutableDictionary *screenDict = [temp dict];
            [dict setObject:screenDict forKey:key];
        }
    }
    return dict;
}

-(void)loadWithDict:(NSDictionary *)dict{
    
    //load screenDictionary
    for(int i=0; i<NumberOfIUScreentType; i++){
        NSString *key = [IUScreenFrame stringForScreenType:i];
        IUScreenFrame *temp = [self.screenFrameDict objectForKey:key];
        
        if(temp != nil){
            [temp loadWithDict:[dict objectForKey:key]];
            temp.loaded = YES;
            
            if(self.iu.iuManager.pWC.project.disableMobileType
               && i == IUScreenTypeMobile){
                temp.loaded = false;
            }
            
            if(self.iu.iuManager.pWC.project.disableTabletType
               && i == IUScreenTypeTablet){
                temp.loaded = false;
            }
        }
        
        
    }
    
    [self importPropertyFromDict:dict ofClass:[IUFrame2 class]];
}

#pragma mark Notification


-(IUFrame2*)superIUFrame{
    return _iu.parent.iuFrame;
}


-(void)changeRect{
    [self willChangeValueForKey:@"frame"];
    _frame = NSMakeRect(self.currentScreenFrame.pixelX, self.currentScreenFrame.pixelY, self.currentScreenFrame.pixelWidth, self.currentScreenFrame.pixelHeight);
    [self didChangeValueForKey:@"frame"];
    [self willChangeValueForKey:@"bound"];
    [self didChangeValueForKey:@"bound"];
    
    [self willChangeValueForKey:@"gridFrameFromScreen"];
    _bound = NSMakeRect(0, 0, self.currentScreenFrame.pixelWidth, self.currentScreenFrame.pixelHeight);
    if([self.iu isKindOfClass:[IUView class]]){
        for(IUObj *obj in ((IUView *)self.iu).children){
            [obj.iuFrame changeParentFrame];
            
        }
    }
    [self didChangeValueForKey:@"gridFrameFromScreen"];
}


-(NSRect)frameWithType:(IUScreenType)type{
    IUScreenFrame *screenFrame = [self.screenFrameDict objectForKey:[IUScreenFrame stringForScreenType:type]];
    return NSMakeRect(screenFrame.pixelX, screenFrame.pixelY, screenFrame.pixelWidth, screenFrame.pixelHeight);
}
-(NSRect)boundWithType:(IUScreenType)type{
    IUScreenFrame *screenFrame = [self.screenFrameDict objectForKey:[IUScreenFrame stringForScreenType:type]];
    return NSMakeRect(0, 0, screenFrame.pixelWidth, screenFrame.pixelHeight);
}

#pragma mark -
#pragma mark ScreenSetting

-(void)screenTypeDidChange{
    [self setCurrentScreenType:self.iu.iuManager.pWC.selectedScreenType];
}

-(void)setCurrentScreenType:(IUScreenType)screenType{
    [self willChangeValueForKey:@"currentScreenFrame"];
    
    IUScreenFrame *origin = currentScreenFrame;
    currentScreenFrame = [self.screenFrameDict objectForKey:[IUScreenFrame stringForScreenType:screenType]];
    [currentScreenFrame copyWithOrigin:origin];
    
    [self didChangeValueForKey:@"currentScreenFrame"];
}

-(IUScreenFrame *)screenFrame:(IUScreenType)type{
    return [self.screenFrameDict objectForKey:[IUScreenFrame stringForScreenType:type]];
}


#pragma mark -
#pragma mark frame, origin from Root

-(NSRect)frameFromScreen{
    NSPoint origin = [self originFromScreen];
    return NSRectMake(origin.x, origin.y, self.currentScreenFrame.pixelWidth, self.currentScreenFrame.pixelHeight);
}

-(NSRect)gridFrameFromScreen{
    NSPoint origin = [self gridOriginFromScreen];
    
    if([self.iu isKindOfClass:[IUCarouselItemBox class]]){
        return NSRectMake(origin.x, origin.y, self.iu.parent.iuFrame.currentScreenFrame.pixelWidth, self.currentScreenFrame.pixelHeight);

    }

    return NSRectMake(origin.x, origin.y, self.currentScreenFrame.pixelWidth, self.currentScreenFrame.pixelHeight);
}


-(NSPoint)gridOriginFromScreen{
    if ([self.iu isKindOfClass:[IUPage class]]) {
        NSPoint templatePoint = self.iu.iuManager.frameManager.templatePoint;
        return NSMakePoint(templatePoint.x + self.currentScreenFrame.pixelX,templatePoint.y+self.currentScreenFrame.pixelY);
    }
    else if([self.iu isKindOfClass:[IUCarouselItem class]]){
        return [self.iu.parent.iuFrame gridOriginFromScreen];
    }
    else if ([self.iu isKindOfClass:[IUFixedGroup class]]){
        return NSMakePoint(self.currentScreenFrame.pixelX, self.currentScreenFrame.pixelY);
        
    }
    else if (self.iu.parent == nil){
        return NSZeroPoint;
    }
    else {
        NSPoint parentPoint = [self.superIUFrame gridOriginFromScreen];
        NSPoint parentCSSPoint = NSMakePoint(self.iu.parent.css.leftBorderSize, self.iu.parent.css.topBorderSize);
        return NSMakePoint( self.currentScreenFrame.pixelX+parentPoint.x + parentCSSPoint.x,
                           self.currentScreenFrame.pixelY+parentPoint.y + parentCSSPoint.y);
    }
}
-(NSPoint)originFromScreen{
    if (self.iu.parent == nil) {
        return self.frameManager.templatePoint;
    }
    else {
        return NSPointMake(self.superIUFrame.originFromScreen.x + self.currentScreenFrame.pixelX, self.superIUFrame.originFromScreen.y + self.currentScreenFrame.pixelY);
    }
}

-(NSPoint)originFromRoot{
    if (self.iu.parent == nil) {
        return NSZeroPoint;
    }
    else {
        return NSPointMake(self.superIUFrame.originFromRoot.x + self.currentScreenFrame.pixelX, self.superIUFrame.originFromRoot.y + self.currentScreenFrame.pixelY);
    }
}

-(void)changeParentFrame{
    self.rootGridPoint =  [self gridOriginFromScreen];
}

#pragma mark -
#pragma mark setting one click

-(void)setFullWidth{
    [self.iu setNeedsDisplayStartGrouping];
    self.currentScreenFrame.percentFlagWidth = YES;
    self.currentScreenFrame.pixelX = 0;
    self.currentScreenFrame.percentX = 0;
    self.currentScreenFrame.percentWidth = 100;
    [self.iu setNeedsDisplay:IUNeedsDisplayActionAll];
    [self.iu setNeedsDisplayEndGrouping];
}


-(void)setAutoHeight:(BOOL)autoHeight{
    _autoHeight = autoHeight;
    [self.iu setNeedsDisplay:IUNeedsDisplayActionAll];
}

-(void)setVerticalCenter:(BOOL)verticalCenter{
    _verticalCenter = verticalCenter;
    if(_verticalCenter) self.disableY = YES;
    else self.disableY = NO;
    [self.iu setNeedsDisplay:IUNeedsDisplayActionHTML];
}
-(void)setHorizontalCenter:(BOOL)horizontalCenter{
    _horizontalCenter = horizontalCenter;
    
    if(_horizontalCenter) self.disableX = YES;
    else self.disableX = NO;
    
    [self.iu setNeedsDisplay:IUNeedsDisplayActionHTML];
}




#pragma mark -
#pragma mark CCSDict


-(NSDictionary *)CSSDictWithScreenType:(IUScreenType)screenType{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    IUScreenFrame *frameForScreen = [self.screenFrameDict objectForKey:[IUScreenFrame stringForScreenType:screenType]];
    if(frameForScreen == nil) return dict;
    if(!frameForScreen.loaded) return dict;
    
    [dict putFloat:frameForScreen.width forKey:@"width" param:@{kMDExModifier: frameForScreen.widthModifier}];
    [dict putFloat:frameForScreen.height forKey:@"height" param:@{kMDExModifier: frameForScreen.heightModifier}];
    

    
    //margin---------------------
    if (frameForScreen.flowLayout) {
        [dict putString:@"relative" forKey:@"position" param:nil];
        [dict putFloat:frameForScreen.marginLeft    forKey:@"margin-left"      param:@{kMDExModifier: frameForScreen.marginLeftModifier, kMDExIgnoreZero:@YES}];
        [dict putFloat:frameForScreen.marginRight   forKey:@"margin-right"     param:@{kMDExModifier: frameForScreen.marginRightModifier, kMDExIgnoreZero:@YES}];
        [dict putFloat:frameForScreen.marginTop     forKey:@"margin-top"       param:@{kMDExModifier: frameForScreen.marginTopModifier, kMDExIgnoreZero:@YES}];
        [dict putFloat:frameForScreen.marginBottom forKey:@"margin-bottom" param:@{kMDExModifier: frameForScreen.marginBottomModifier, kMDExIgnoreZero:@YES}];
        
    }
    else{
        if(_fixed){
            [dict putString:@"fixed" forKey:@"position" param:nil];
        }
        [dict putFloat:frameForScreen.x forKey:@"left" param:@{kMDExModifier: frameForScreen.xModifier}];
        [dict putFloat:frameForScreen.y forKey:@"top" param:@{kMDExModifier: frameForScreen.yModifier, kMDExIgnoreZero:@YES}];

        
    }
    
    if (self.autoHeight) {
        [dict removeObjectForKey:@"height" param:nil];
    }
    return dict;
}

-(BOOL)hasFlowLayout{
    for (id key in self.screenFrameDict) {
        IUScreenFrame *f = [self.screenFrameDict objectForKey:key];
        if (f.flowLayout) {
            return YES;
        }
    }
    return NO;
}

@end
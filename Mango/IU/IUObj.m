 //
//  MGObject.m
//  Mango
//
//  Created by JD on 13. 1. 27..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUObjs.h"
#import "IUObj.h"
#import "IUView.h"
#import "IUManager.h"
#import "MGProjectWC.h"
#import "IUBG.h"
#import "IUViewManager.h"
#import "IULayerOld.h"
#import "IUCSS.h"
#import "IUProject.h"
#import "IUEventVariableReceiver.h"
#import "IUEventVariableFrameReceiver.h"
#import "IUEventVariableTrigger.h"
#import "IUEventMouseOn.h"
#import "IUFrameManager.h"
#import "IUWidget.h"
#import "IUScreenFrame.h"
#import "MGInspectorVC.h"


@interface IUObj () <NSTableViewDataSource, NSTableViewDelegate>
@property (strong) IBOutlet NSView *inspectorV;
@end

@implementation IUObj

@synthesize showOverflow;

#pragma mark -
#pragma mark class info

+(NSImage*)classImage{
    
    Class curClass = [self class];
    while (curClass != [IUObj class]) {
        NSString *imageName = NSStringFromClass(curClass);
        NSImage *img = [NSImage imageNamed:imageName];
        if (img) {
            return img;
        }
        curClass = [curClass superclass];
    }
    return [NSImage imageNamed:@"IUObj"];
}

+(NSString*)displayName{
    if ([self.className isEqualToString:@"IUObj"]) {
        return @"Object";
    }
    NSString *className = NSStringFromClass([self class]);
    if ( [[className substringToIndex:2] isEqualToString:@"IU"]) {
        return [className substringFromIndex:2];
    }
    return className;
}

- (id)copyWithZone:(NSZone *)zone{
    IUObj *copiedIU = [[[self class] allocWithZone:zone] init];
    [copiedIU loadWithDict:self.dict];
    copiedIU.name = [self.iuManager makeNewIUName:self.className];
    copiedIU.HTMLID = copiedIU.name;
    copiedIU.iuManager = self.iuManager;
    [copiedIU iuLoad];
    copiedIU.iuLoaded = YES;
    return copiedIU;
}

#pragma mark -
#pragma mark initialize / delloc


-(void)setIuManager:(IUManager *)iuManager{
    _iuManager = iuManager;
    self.iuFrame.frameManager = self.iuManager.frameManager;
    if (self.name == nil) {
        self.name = [_iuManager makeNewIUName:self.className];
        self.HTMLID = self.name;
    }
}

- (id)init;
{
    self = [super init];
    if (self) {
        self.iuFrame = [[IUFrame2 alloc] init];
        self.iuFrame.frameManager = self.iuManager.frameManager;
        self.iuFrame.iu = self;
        
        self.bg = [[IUBG alloc] initWithIU:self];
        self.css = [[IUCSS alloc] initWithIU:self];
        self.draggable = YES;
        //binder//
        self.event = [[IUEvent alloc] initWithOwner:self];
    }
    return self;
}


+(id)IU{
    IUObj* obj = [[[self class] alloc] init];
    [obj instantiate];
    obj.name = [NSString stringWithFormat:@"%@Default",[NSString stringWithUTF8String: class_getName([obj class])]];
    
    return obj;
}

-(id)instantiate{
    self.visible = YES;
    self.cursor = @"Auto";
    self.opacity = 1;
    
    self.iuFrame.defaultScreenFrame.pixelWidth = 100;
    self.iuFrame.defaultScreenFrame.pixelHeight = 70;
    self.iuFrame.fixed = NO;
    
    [self.bg setRandomOpaqueColor];
    
    
    self.HTMLID = self.name;
    self.draggable = YES;

    self.lineLocation = 0;
    self.disableBorderLayer = FALSE;
    return self;
}

#pragma mark -
#pragma mark undo

+(NSMutableArray *)undoPropertyList{
    NSMutableArray *array = [[NSMutableArray alloc] initWithArray:@[@"HTMLID",
             @"name",
             @"link",
             @"divLink",
             @"visible",
             @"opacity",
             @"cursorType",
             @"cursor"
             ]];
    return array;
}

#pragma mark -
#pragma mark save/load

-(void)loadWithDict:(NSDictionary*)dict{
    loadedDict = dict;
    objDict = [dict objectForKey:@"IUObj"];
    [self importPropertyFromDict:objDict ofClass:[IUObj class]];
}


- (NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [self exportPropertyFromDictOfClass:[IUObj class]];
    [dict setObject:[_iuFrame dict] forKey:@"frame"];
    [dict setObject:[_bg dict] forKey:@"bg"];
    [dict setObjectRemoveNil:[_event dict] forKey:@"event"];
    [dict setObjectRemoveNil:[_css dict] forKey:@"css"];
    
    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithObject:NSStringFromClass([self class]) forKey:@"type"];
    [retDict setObject:dict forKey:@"IUObj"];
    return retDict;
}

-(void)iuLoad{
    /* get frame */

    NSAssert(_iuManager!=nil, @"Should Have IUManager");
    
    if (objDict) {
        NSDictionary *frameDict = [objDict objectForKey:@"frame"];
        [_iuFrame loadWithDict:frameDict];
        NSDictionary *bgDict = [objDict objectForKey:@"bg"];
        [_bg loadWithDict:bgDict];
        NSDictionary *eventDict = [objDict objectForKey:@"event"];
        if (eventDict) {
            [_event loadWithDict:eventDict];
        }
        NSDictionary *CSSDict2 = [objDict objectForKey:@"css"];
        if (CSSDict2) {
            [_css loadWithDict:CSSDict2];
        }
    }
    
    [self.iuFrame iuFrameLoad];
    [self.iuManager.iuViewManager setBorderLayer:self];
    [self.iuManager.iuViewManager setShadowLayer:self];

    //binding undoManager
    [self bind:@"undoManager" toObject:self.iuManager withKeyPath:@"undoManager" options:nil];
    [self.css bind:@"undoManager" toObject:self.iuManager withKeyPath:@"undoManager" options:nil];
    [self.iuFrame bind:@"undoManager" toObject:self.iuManager withKeyPath:@"undoManager" options:nil];
    [self.bg bind:@"undoManager" toObject:self.iuManager withKeyPath:@"undoManager" options:nil];

    
    [self addObserver:self forKeyPaths:@[ @"HTMLID", @"link", @"divLink"] options:0 context:@"@selector(setNeedsDisplayHTML)"];
    [self addObserver:self
          forKeyPaths:@[@"opacity", @"visible", @"showOverflow",  @"cursor", @"z"]
              options:0 context:@"@selector(setNeedsDisplayCSS)"];
    
    
    [self addObserver:self forKeyPath:@"parent" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial context:@"parent"];
    [self addObserver:self forKeyPath:@"exposeBinding" options:NSKeyValueObservingOptionInitial context:@"exposeBinding"];
    [self addObserver:self forKeyPath:@"opacity" options:NSKeyValueObservingOptionInitial context:nil];
    [self addObserver:self forKeyPath:@"visible" options:NSKeyValueObservingOptionInitial context:nil];

}


-(void)dealloc{
    if (_iuManager) {
        [self removeObserver:self forKeyPath:@"x"];
        [self removeObserver:self forKeyPath:@"y"];
        [self removeObserver:self forKeyPath:@"width"];
        [self removeObserver:self forKeyPath:@"height"];
        [self removeObserver:self forKeyPath:@"fullHeight"];
        [self removeObserver:self forKeyPath:@"fullWidth"];
        
        [self removeObserver:self forKeyPath:@"bgX"];
        [self removeObserver:self forKeyPath:@"bgY"];
        [self removeObserver:self forKeyPath:@"bgImgFileName"];
        [self removeObserver:self forKeyPath:@"bgImgRepeat"];
        
        [self removeObserver:self forKeyPath:@"bgColor"];
        [self removeObserver:self forKeyPath:@"parent"];
        
        [self removeObserver:self forKeyPath:@"viewFrame"];
        
        
        
        if (self.parent) {
            [self.parent removeObserver:self forKeyPath:@"width"];
            [self.parent removeObserver:self forKeyPath:@"height"];
        }
    }
}


#pragma mark -
#pragma mark make property


+(NSArray*)propertyList{
    return @[@"name",@"exposeBinding",@"cursor",@"link", @"visible",@"opacity", @"HTMLID", @"showOverflow", @"divLink", @"z"];
}


-(void)autoSetIUName{
    self.name = [self.iuManager makeNewIUName:self.className];
    self.HTMLID = self.name;
}

-(void)setName:(NSString *)name{
    if (name == _name) {
        return;
    }
    _name = [name copy];
    self.HTMLID = [name copy];
    [self setNeedsDisplay:IUNeedsDisplayActionAll];
}

-(void)setOpacity:(float)opacity{
    _opacity = roundf(opacity*10) / 10;
}

#pragma mark -
#pragma mark setNeedXXXDisplay

-(void)setNeedsDisplayHTML{
    [self setNeedsDisplay:IUNeedsDisplayActionHTML];
}

-(void)setNeedsDisplayCSS{
    [self setNeedsDisplay:IUNeedsDisplayActionCSS];
}


-(void)setNeedsDisplayStartGrouping{
    [self.iuManager.iuViewManager disableUpdate:self];
}

-(void)setNeedsDisplayEndGrouping{
    [self.iuManager.iuViewManager enableUpdate:self];
}

-(void)setNeedsDisplay:(IUNeedsDisplayActionType)type{
    [self refreshDisplayText];
    [self reloadMQTable];
    [self.iuManager.iuViewManager setIUNeedsDisplay:self type:type];
}

#pragma mark -
#pragma mark Make HTML

-(NSString*)HTMLTag2{
    return @"div";
}

-(NSString*)preHTML2{
    if (self.link) {
        if ([[self.link pathExtension] isEqualToString:@"pgiu" ]){
            NSString *linkStr = [self.link stringByChangeExtension:@"html"];
            if([self.divLink length] > 0){
                linkStr = [linkStr stringByAppendingString:[NSString stringWithFormat:@"#%@", self.divLink]];
            }
            return [NSString stringWithFormat:@"<a href=%@>", linkStr];
            
        }
        return [NSString stringWithFormat:@"<a href=%@>", self.link ];
        
    }
    return @"";
}

-(NSString*)postHTML2{
    if (self.link) {
        return @"</a>";
    }
    return @"";
}

-(BOOL)appendClosingTag{
    return YES;
}

-(NSString*)innerHTML2:(id)caller{
    return nil;
}

-(NSMutableString*)innerOutputHTML2{
    return nil;
}



-(NSMutableString*)HTMLSource2:(id)caller{
    NSDictionary *dict = [[self HTMLDict2] objectForKey:@"default"];
    
    NSMutableString *retStr= [NSMutableString string];
    [retStr appendFormat:@"%@", self.preHTML2];
    [retStr appendFormat:@"        <%@ ", self.HTMLTag2];
    
    for (NSString *key in dict) {
        [retStr appendFormat: @" %@='%@'", key, [dict objectForKey:key]];
    }
    [retStr appendString:@" >"];
    
    NSString *innerStr = [self innerHTML2:caller];
    if (innerStr) {
    
        [retStr appendString:innerStr];
    }
    if ([self appendClosingTag]) {
        [retStr appendFormat:@"  </%@>", self.HTMLTag2];
    }
    [retStr appendFormat:@"%@", self.postHTML2];
    return retStr;
}

-(NSMutableString*)outputHTMLSource2:(id)sender{
    NSDictionary *dict = [[self outputDict2] objectForKey:@"default"];
    
    NSMutableString *retStr= [NSMutableString string];
    [retStr appendFormat:@"%@", self.preHTML2];
    [retStr appendFormat:@"  <%@ ", self.HTMLTag2];
    
    for (NSString *key in dict) {
        [retStr appendFormat: @" %@='%@'", key, [dict objectForKey:key]];
    }
    NSString *inner = self.innerOutputHTML2;
    if (inner) {
        [retStr appendString:@" >\n  "];
        NSString *tempStr = inner;
        [retStr appendString:tempStr];
    }
    else{
        [retStr appendString:@" >"];
    }
    if ([self appendClosingTag]) {
        [retStr appendFormat:@"</%@>", self.HTMLTag2];
    }
    [retStr appendFormat:@"%@", self.postHTML2];
    return retStr;
}



#pragma mark -
#pragma mark Make CSS


//Change javascript, insertionJavascript
-(NSMutableString*)CSSStringForScreenType:(IUScreenType)type{
    NSDictionary *dict = [[self CSSDictWithScreenType:type] objectForKey:@"default"];
    NSMutableString *retStr = [NSMutableString string];
    
    for (NSString * key in dict) {
        [retStr appendFormat:@"%@ : %@; ", key, [dict objectForKey:key] ];
    }
    return retStr;
}


#pragma mark -
#pragma Manage Dict

- (NSMutableDictionary*)CSSDictWithScreenType:(IUScreenType)screenType{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict merge:[self.iuFrame CSSDictWithScreenType:screenType]];
    
    if (screenType == IUScreenTypeDefault) {
        [dict putString:[self.bg.color rgbString] forKey:@"background-color" param:nil];
        
        if (self.bg.img) {
            NSString *imgURL = [NSString stringWithFormat:@"url(%@/%@)",self.project.resDir, self.bg.img];
            [dict putString:imgURL forKey:@"background-image" param:nil];
        }
        
        
        if (self.bg.color) {
            [dict putString:[self.bg.color rgbString] forKey:@"background-color" param:nil];
        }
        
        self.bg.x ?
        [dict putInt:_bg.x forKey:@"background-position-x" param:@{kMDExModifier: kMDExModifierPixel}] : nil;
        
        self.bg.y ?
        [dict putInt:_bg.y forKey:@"background-position-y" param:@{kMDExModifier: kMDExModifierPixel}] : nil;
        
        self.bg.imgRepeat==YES ?
        [dict putString:@"repeat" forKey:@"background-repeat" param:nil] : nil;
        
        if (self.visible == NO) {
            [dict putString:@"hidden" forKey:@"visibility" param:nil];
        }
        if (self.showOverflow == NO) {
            [dict putString:@"hidden" forKey:@"overflow" param:nil];
        }
        
        if (self.bg.bgSize > IUBGSizeNone) {
            
            switch (self.bg.bgSize) {
                case IUBGSizeCenter:
                    [dict putString:@"center" forKey:@"background-position" param:nil];
                    break;
                case IUBGSizeStretch:
                    [dict putString:@"100% 100%" forKey:@"background-size" param:nil];
                    break;
                case IUBGSizeCover:
                    [dict putString:@"cover" forKey:@"background-size" param:nil];
                    break;
                case IUBGSizeContain:
                    [dict putString:@"contain" forKey:@"background-size" param:nil];
                    break;
                default:
                    break;
            }
        }
        
        [dict merge:_css.CSSDict2];
        if (self.opacity != 1) {
            [dict putFloat:self.opacity forKey:@"opacity" param:nil];
        }
        
        
        if (_event.mouseOn) {
            if (_event.mouseOn.bgX != _bg.y) {
                [dict putInt:_event.mouseOn.bgX forKey:@"background-position-x" param:@{kMDExOutputDictKey:@"hover", kMDExModifier: kMDExModifierPixel}];
            }
            if (_event.mouseOn.bgY != _bg.x) {
                [dict putInt:_event.mouseOn.bgY forKey:@"background-position-y" param:@{kMDExOutputDictKey:@"hover", kMDExModifier: kMDExModifierPixel}];
            }
            if (_event.mouseOn.enableBGColor == YES) {
                [dict putString:[_event.mouseOn.bgColor rgbString] forKey:@"background-color" param:@{kMDExOutputDictKey:@"hover"}];
            }
        }
        
        [dict putInt:_z forKey:@"z-index" param:nil];
        if ([self.cursor isEqualToString:@"Auto"] == NO) {
            [dict putString:self.cursor forKey:@"cursor" param:nil];
        }
    }
    return dict;
}



-(NSMutableDictionary*)HTMLDict2{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict putString:[self fullIUName] forKey:@"IUName" param:nil];
    [dict putString:[self HTMLClassString] forKey:@"class" param:nil];
    if (_event.variableTrigger.variable) {
        [dict putString:@"YES" forKey:@"IUClickable" param:nil];
    }
    
    if (self.HTMLID) {
        [dict putString:self.HTMLID forKey:@"id" param:nil];
    }
    
    if (self.iuFrame.currentScreenFrame.flowLayout){
        
        if(self.iuFrame.currentScreenFrame.percentFlagMarginTop
           || self.iuFrame.currentScreenFrame.percentFlagMarginBottom){
            [dict putInt:1 forKey:@"percentHeightMargin" param:nil];
            [dict putFloat:self.iuFrame.currentScreenFrame.percentMarginTop forKey:@"marginTop" param:nil];
            [dict putFloat:self.iuFrame.currentScreenFrame.percentMarginBottom forKey:@"marginBottom" param:nil];
            
        }
    }
    
    if(self.iuFrame.verticalCenter){
        [dict putInt:1 forKey:@"verticalCenter" param:nil];
    }
    if(self.iuFrame.horizontalCenter){
        [dict putInt:1 forKey:@"horizontalCenter" param:nil];
    }

    return dict;
    
}

-(NSMutableDictionary*)outputDict2{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict putString:[self fullIUName] forKey:@"IUName" param:nil];
    [dict putString:[self outputHTMLClassString] forKey:@"class" param:nil];
    if (_event.variableTrigger.variable) {
        [dict putString:@"YES" forKey:@"IUClickable" param:nil];
    }
    
    if (self.HTMLID) {
        [dict putString:self.HTMLID forKey:@"id" param:nil];
    }
    if (self.iuFrame.currentScreenFrame.flowLayout){
        
        if(self.iuFrame.currentScreenFrame.percentFlagMarginTop
           || self.iuFrame.currentScreenFrame.percentFlagMarginBottom){
            [dict putInt:1 forKey:@"percentHeightMargin" param:nil];
            [dict putFloat:self.iuFrame.currentScreenFrame.percentMarginTop forKey:@"marginTop" param:nil];
            [dict putFloat:self.iuFrame.currentScreenFrame.percentMarginBottom forKey:@"marginBottom" param:nil];
            
        }
    }
    if(self.iuFrame.verticalCenter){
        [dict putInt:1 forKey:@"verticalCenter" param:nil];
    }
    if(self.iuFrame.horizontalCenter){
        [dict putInt:1 forKey:@"horizontalCenter" param:nil];
    }
    return dict;
}





#pragma mark -
#pragma mark only in IUObj
#pragma mark -
#pragma mark IUManaging

- (NSData*)IUMLData{
    /* mutate to JSON */
    NSError *err;
    NSData *data = [NSJSONSerialization dataWithJSONObject:[self dict] options:0 error:&err];
    if (err) {
        [JDLogUtil log:@"save error" err:err];
    }
    return data;
}



- (BOOL)removeFromSuperIU:(id)sender{
    if (sender != self.parent) {
        NSLog(@"it cannot be!");
        return NO;
    }
    else{
        [self.borderLayer removeFromSuperlayer];
        [self.assitLayer removeFromSuperlayer];
        [self.shadowLayer removeFromSuperlayer];

        [self.iuManager.iuViewManager setDeletedIUNeedsDisplay:self];
        return YES;
    }
}



-(void)fitToImage{
    DLog(@"");
    [self.iuManager.iuViewManager disableUpdate:self];
    NSSize bgsize = [self.bg image].size;
    self.iuFrame.currentScreenFrame.pixelWidth =  bgsize.width;
    self.iuFrame.currentScreenFrame.pixelHeight = bgsize.height;
    [self setNeedsDisplayCSS];
    [self.iuManager.iuViewManager enableUpdate:self];
    
}



-(void)parentDidChange:(NSDictionary*)change{
    //remove old observer and add new observer
    IUObj *old = [change objectForKey:NSKeyValueChangeOldKey];
    if ([old isKindOfClass:[NSNull class]] == NO) {
        [old removeObserver:self forKeyPath:@"width"];
        [old removeObserver:self forKeyPath:@"height"];
        [old removeObserver:self forKeyPath:@"viewFrame"];
    }
    
    IUObj *new = [change objectForKey:NSKeyValueChangeNewKey];
    [new addObserver:self forKeyPath:@"width" options:0 context:@"parentFrame"];
    [new addObserver:self forKeyPath:@"height" options:NSKeyValueObservingOptionInitial context:@"parentFrame"];
    [new addObserver:self forKeyPath:@"viewFrame" options:NSKeyValueObservingOptionInitial context:@"parentFrame"];
}


-(BOOL)isLeaf{
    return YES;
}

-(IUObj*)requestFocusAvariableIU{
    return self;
}

-(BOOL)hasFocus{
    if (_iuManager.pWC.iuController.selection == self) {
        return YES;
    }
    return NO;
}

-(NSString*)description{
    return [NSString stringWithFormat:@"%@ [%@]",[super description], _name];
}

-(IUObj*)iuHitTest:(NSPoint)point{
    if(self.visible == NO) return nil;
    NSPoint roundedPoint = [JDUIUtil pointRound:point];
    NSRect currentFrame = self.iuFrame.gridFrameFromScreen;
    //Add one pixel for current frame for easy click
    NSRect modifiedFrame = NSRectMake(currentFrame.origin.x -1, currentFrame.origin.y-1, currentFrame.size.width+3, currentFrame.size.height+3);
    if(NSPointInRect(roundedPoint, modifiedFrame)) return self;
    
    return nil;
}



-(void)buildAndShowWebSourceForLocalView{
}


-(NSUInteger)depth{
    if (self.parent == nil) {
        return 0;
    }
    return self.parent.depth + 1;
}


-(IUFile*)rootIU{
    IUObj *obj = self;
    while (1) {
        if (obj.parent) {
            obj = (IUObj*)obj.parent;
        }
        else{
            if ([obj isKindOfClass:[IUFile class]]) {
                return (IUFile*)obj;
            }
            return nil;
        }
    }
}


-(IUProject*)project{
    return _iuManager.project;
}


#pragma mark -
#pragma mark move

//input : diffX, diffy
//output : (currentX+diffX), (currentY+diffY);
-(void)moveX:(CGFloat)x Y:(CGFloat)y{
    [self.iuManager.iuViewManager disableUpdate:self];

    if(self.iuFrame.currentScreenFrame.percentFlagX){
        if ([self shouldChangeXByUserInput:x]) {
            CGFloat modifiedX = [self.iuManager.iuViewManager getPercentWidth:self withX:x];
            self.iuFrame.currentScreenFrame.percentX += modifiedX;
        }
    }
    else{
        if ([self shouldChangeXByUserInput:x]) {
            self.iuFrame.currentScreenFrame.pixelX += x;
        }
        
    }
    if(self.iuFrame.currentScreenFrame.percentFlagY){
        if ([self shouldChangeYByUserInput:y]) {
            CGFloat modifiedY = [self.iuManager.iuViewManager getPercentHeight:self withY:y];
            self.iuFrame.currentScreenFrame.percentY += modifiedY;
        }
    }
    else{
        if ([self shouldChangeYByUserInput:y]) {
            self.iuFrame.currentScreenFrame.pixelY += y;
        }
    }
    [self setNeedsDisplay:IUNeedsDisplayActionCSS];
    [self.iuManager.iuViewManager enableUpdate:self];
}

-(void)moveMarginLeft:(CGFloat)left Top:(CGFloat)top{
    [self.iuManager.iuViewManager disableUpdate:self];
    
    if(self.iuFrame.currentScreenFrame.percentFlagMarginLeft){
        if ([self shouldChangeXByUserInput:left]) {
            CGFloat modifiedLeft = [self.iuManager.iuViewManager getPercentWidth:self withX:left];
            self.iuFrame.currentScreenFrame.percentMarginLeft  += modifiedLeft;
        }
    }
    else{
        if ([self shouldChangeXByUserInput:left]) {
            self.iuFrame.currentScreenFrame.pixelMarginLeft += left;
        }
    }
    if(self.iuFrame.currentScreenFrame.percentFlagMarginTop){
        if ([self shouldChangeYByUserInput:top]) {
            CGFloat modifiedTop = [self.iuManager.iuViewManager getPercentHeight:self withY:top];
            self.iuFrame.currentScreenFrame.percentMarginTop += modifiedTop;
            [self setNeedsDisplay:IUNeedsDisplayActionHTML];
        }
    }
    else{
        if ([self shouldChangeYByUserInput:top]) {
            self.iuFrame.currentScreenFrame.pixelMarginTop += top;
        }
    }
    [self setNeedsDisplay:IUNeedsDisplayActionCSS];
    [self.iuManager.iuViewManager enableUpdate:self];

}

-(void)moveTo:(NSUInteger)IUDirection{
    if (_draggable) {
        [self.iuManager.iuViewManager disableUpdate:self];
        
        CGFloat percentUnitX, percentUnitY = 0;
        if(self.iuFrame.currentScreenFrame.percentFlagX){
            percentUnitX = [self.iuManager.iuViewManager getPercentWidth:self withX:1];
            
        }
        if(self.iuFrame.currentScreenFrame.percentFlagY){
            percentUnitY = [self.iuManager.iuViewManager getPercentHeight:self withY:1];
        }
        
        switch (IUDirection) {
            case IUDirectionUp:
                if ([self shouldChangeYByUserInput:self.iuFrame.currentScreenFrame.pixelY-1]) {
                    if(self.iuFrame.currentScreenFrame.percentFlagY)
                        self.iuFrame.currentScreenFrame.percentY -= percentUnitY;
                    else
                        self.iuFrame.currentScreenFrame.pixelY--;
                }
                break;
            case IUDirectionDown:
                if ([self shouldChangeYByUserInput:self.iuFrame.currentScreenFrame.pixelY+1]) {
                    if(self.iuFrame.currentScreenFrame.percentFlagY)
                        self.iuFrame.currentScreenFrame.percentY += percentUnitY;
                    else
                        self.iuFrame.currentScreenFrame.pixelY++;
                }
                 break;
            case IUDirectionLeft:
                if ([self shouldChangeXByUserInput:self.iuFrame.currentScreenFrame.pixelX+1]) {
                    if(self.iuFrame.currentScreenFrame.percentFlagX)
                        self.iuFrame.currentScreenFrame.percentX -= percentUnitX;
                    else
                        self.iuFrame.currentScreenFrame.pixelX--;
                }
                break;
            case IUDirectionRight:
                if ([self shouldChangeXByUserInput:self.iuFrame.currentScreenFrame.pixelX+1]) {
                    if(self.iuFrame.currentScreenFrame.percentFlagX)
                        self.iuFrame.currentScreenFrame.percentX += percentUnitX;
                    else
                        self.iuFrame.currentScreenFrame.pixelX++;
                }
                break;
            default: break;
        }
    }
    [self setNeedsDisplayCSS];
    [self.iuManager.iuViewManager enableUpdate:self];
}

-(void)flowLayoutMoveTo:(NSUInteger)IUDirection{
    if (_draggable) {
        
        [self.iuManager.iuViewManager disableUpdate:self];
        
        CGFloat percentUnitX, percentUnitY;
        if(self.iuFrame.currentScreenFrame.percentFlagX){
            percentUnitX = [self.iuManager.iuViewManager getPercentWidth:self withX:1];
            
        }
        if(self.iuFrame.currentScreenFrame.percentFlagY){
            percentUnitY = [self.iuManager.iuViewManager getPercentHeight:self withY:1];
        }
        
        switch (IUDirection) {
            case IUDirectionUp:
            if (self.iuFrame.disableY == NO) {
                if(self.iuFrame.currentScreenFrame.percentFlagMarginTop)
                self.iuFrame.currentScreenFrame.percentMarginTop -= percentUnitY;
                else
                self.iuFrame.currentScreenFrame.pixelMarginTop--;
            }
            break;
            case IUDirectionDown:
            if (self.iuFrame.disableY == NO) {
                if(self.iuFrame.currentScreenFrame.percentFlagY)
                self.iuFrame.currentScreenFrame.percentMarginTop += percentUnitY;
                else
                self.iuFrame.currentScreenFrame.pixelMarginTop++;
            }
            break;
            case IUDirectionLeft:
            if (self.iuFrame.disableX == NO) {
                if(self.iuFrame.currentScreenFrame.percentFlagX)
                self.iuFrame.currentScreenFrame.percentMarginLeft -= percentUnitX;
                else
                self.iuFrame.currentScreenFrame.pixelMarginLeft--;
            }
            break;
            case IUDirectionRight:
            if (self.iuFrame.disableX == NO) {
                if(self.iuFrame.currentScreenFrame.percentFlagX)
                self.iuFrame.currentScreenFrame.percentMarginLeft += percentUnitX;
                else
                self.iuFrame.currentScreenFrame.pixelMarginLeft++;
            }
            break;
            default: break;
        }
    }
    if(self.iuFrame.currentScreenFrame.flowLayout) [self setNeedsDisplay:IUNeedsDisplayActionHTML];
    [self setNeedsDisplayCSS];
    
    [self.iuManager.iuViewManager enableUpdate:self];
}



-(void)moveLeftLine:(int)x originalRect:(NSRect)rect{
    
    if(x > 0 && abs(x) >= rect.size.width){
        self.iuFrame.currentScreenFrame.pixelX = rect.origin.x + rect.size.width;
        self.iuFrame.currentScreenFrame.percentX = [self.iuManager.iuViewManager getPercentWidth:self withX:self.iuFrame.currentScreenFrame.pixelX];
        self.iuFrame.currentScreenFrame.pixelWidth = 0;
        self.iuFrame.currentScreenFrame.percentWidth =0;
        return;
    }
    
    CGFloat percentX =0;
    CGFloat originalPercentX =0;
    CGFloat originalPercentWidth =0;

    if(self.iuFrame.currentScreenFrame.percentFlagX || self.iuFrame.currentScreenFrame.percentFlagWidth
       || self.iuFrame.currentScreenFrame.percentFlagMarginLeft){
        percentX = [self.iuManager.iuViewManager getPercentWidth:self withX:x];
        originalPercentX = [self.iuManager.iuViewManager getPercentWidth:self withX:rect.origin.x];
        originalPercentWidth = [self.iuManager.iuViewManager getPercentWidth:self withX:rect.size.width];
    }
    
    if (self.iuFrame.horizontalCenter) {
        x *= 2;
        percentX *=2;
    }
    
    if (self.iuFrame.currentScreenFrame.flowLayout) {
        if (self.iuFrame.currentScreenFrame.percentFlagMarginLeft) {
            if ([self shouldChangeXByUserInput:originalPercentX + percentX]) {
                self.iuFrame.currentScreenFrame.percentMarginLeft = originalPercentX + percentX;
            }
        }
        else{
            if ([self shouldChangeXByUserInput:rect.origin.x + x]) {
                self.iuFrame.currentScreenFrame.pixelMarginLeft = rect.origin.x + x;
            }
        }
        
    }
    else {
        if (self.iuFrame.currentScreenFrame.percentFlagX) {
            if ([self shouldChangeXByUserInput:originalPercentX + percentX]) {
                self.iuFrame.currentScreenFrame.percentX = originalPercentX + percentX;
            }
        }
        else{
            if ([self shouldChangeXByUserInput:rect.origin.x + x]) {
                self.iuFrame.currentScreenFrame.pixelX = rect.origin.x + x;
            }
        }
    }
    
    
    if (self.iuFrame.currentScreenFrame.percentFlagWidth) {
        if ([self shouldChangeWidthByUserInput:originalPercentWidth - percentX]) {
            self.iuFrame.currentScreenFrame.percentWidth = originalPercentWidth - percentX;
        }
    }
    else {
        if ([self shouldChangeWidthByUserInput:rect.size.width - x]) {
            self.iuFrame.currentScreenFrame.pixelWidth = rect.size.width - x;
        }
    }
}

-(void)moveRightLine:(int)x originalRect:(NSRect)rect{
    
    if(x < 0 && abs(x) >= rect.size.width){
        self.iuFrame.currentScreenFrame.pixelWidth =0;
        self.iuFrame.currentScreenFrame.percentWidth=0;
        return;
    }

    CGFloat modifiedX  = x;
    if (self.iuFrame.horizontalCenter) {
        modifiedX *=2;
    }

    if (self.iuFrame.currentScreenFrame.percentFlagWidth) {
        modifiedX = [self.iuManager.iuViewManager getPercentWidth:self withX:x];
        CGFloat originalWidth = [self.iuManager.iuViewManager getPercentWidth:self withX:rect.size.width];

        if ([self shouldChangeWidthByUserInput:originalWidth + modifiedX] ){
            self.iuFrame.currentScreenFrame.percentWidth = originalWidth + modifiedX;
        }
    }
    else{
        if ([self shouldChangeWidthByUserInput:rect.size.width + modifiedX]){
            self.iuFrame.currentScreenFrame.pixelWidth = rect.size.width + modifiedX;
        }
    }
}

-(void)moveTopLine:(int)y originalRect:(NSRect)rect{
    
    if([self shouldChangeHeightByUserInput:y] == NO) return;
    
    
    if( rect.size.height - y <= 0){
        self.iuFrame.currentScreenFrame.percentHeight = 0;
        self.iuFrame.currentScreenFrame.pixelHeight = 0;
        return;
    }
    
    [self.iuManager.iuViewManager disableUpdate:self];

    CGFloat percentY = 0;
    CGFloat percentOriginalHeight =0;
    CGFloat percentOriginalY = 0;
    if(self.iuFrame.currentScreenFrame.percentFlagY || self.iuFrame.currentScreenFrame.percentFlagHeight
       || self.iuFrame.currentScreenFrame.percentFlagMarginTop){
        percentY = [self.iuManager.iuViewManager getPercentHeight:self withY:y];
        percentOriginalHeight = [self.iuManager.iuViewManager getPercentHeight:self withY:rect.size.height];
        percentOriginalY = [self.iuManager.iuViewManager getPercentHeight:self withY:rect.origin.y];
    }
    
    if (self.iuFrame.verticalCenter) {
        y *= 2;
        percentY *=2;
    }
    
    //for flow layout
    if(self.iuFrame.currentScreenFrame.flowLayout){
        if(self.iuFrame.currentScreenFrame.percentFlagMarginTop){
            self.iuFrame.currentScreenFrame.percentMarginTop = percentOriginalY + percentY;
        }
        else{
            self.iuFrame.currentScreenFrame.pixelMarginTop = rect.origin.y + y;
        }
        [self setNeedsDisplay:IUNeedsDisplayActionAll];
        
    }

    //for absolute-layout
    else{
        if(self.iuFrame.currentScreenFrame.percentFlagY){
            self.iuFrame.currentScreenFrame.percentY = percentOriginalY + percentY;
        }
        else{
            self.iuFrame.currentScreenFrame.pixelY = rect.origin.y + y;
        }
    }
    
    if(self.iuFrame.currentScreenFrame.percentFlagHeight){
        self.iuFrame.currentScreenFrame.percentHeight = percentOriginalHeight - percentY;
    }
    else
        self.iuFrame.currentScreenFrame.pixelHeight = rect.size.height - y;
    
    [self setNeedsDisplay:IUNeedsDisplayActionCSS];
    [self.iuManager.iuViewManager enableUpdate:self];

}

-(void)moveBottomLine:(int)y originalRect:(NSRect)rect{
    if (self.iuFrame.autoHeight) {
        self.iuFrame.autoHeight = NO;
    }
    if(rect.size.height - (y*(-1)) <=0){
        self.iuFrame.currentScreenFrame.percentHeight = 0;
        self.iuFrame.currentScreenFrame.pixelHeight = 0;
        return;

    }

    CGFloat modifiedY = y;
    if (self.iuFrame.verticalCenter) {
        modifiedY *=2;
    }
    if(self.iuFrame.currentScreenFrame.percentFlagHeight){
        modifiedY = [self.iuManager.iuViewManager getPercentHeight:self withY:y];
        CGFloat originalPercentHeight = [self.iuManager.iuViewManager getPercentHeight:self withY:rect.size.height];
        if ([self shouldChangeHeightByUserInput:originalPercentHeight + modifiedY]) {
            self.iuFrame.currentScreenFrame.percentHeight = originalPercentHeight + modifiedY;
        }
    }
    else{
        if ([self shouldChangeHeightByUserInput:rect.size.height + modifiedY]) {
            self.iuFrame.currentScreenFrame.pixelHeight = rect.size.height + modifiedY;
        }
    }
}

-(void)exposeBindingDidChange{
    if (_exposeBinding) {
        [_iuManager.exposedIUs setObject:self forKey:self.name];
    }
    else{
        [_iuManager.exposedIUs removeObjectForKey:self.name];
    }
}



#pragma mark -
#pragma mark copy/paste

- (NSArray *)writableTypesForPasteboard:(NSPasteboard *)pasteboard {
    NSArray *ret= [self.name writableTypesForPasteboard:pasteboard];
    return ret;
}

- (id)pasteboardPropertyListForType:(NSString *)type {
    id ret= [self.name pasteboardPropertyListForType:type];
    return ret;
}



- (NSPasteboardWritingOptions)writingOptionsForType:(NSString *)type pasteboard:(NSPasteboard *)pasteboard {
    if ([self.name respondsToSelector:@selector(writingOptionsForType:pasteboard:)]) {
        return [self.name writingOptionsForType:type pasteboard:pasteboard];
    } else {
        return 0;
    }
}



#pragma mark -
#pragma mark enable/disable

-(BOOL)enableUndo{
    return YES;
}

-(id)valueForUndefinedKey:(NSString *)key{
    return nil;
}




#pragma mark -
#pragma mark HTML Compile Setting
-(NSString*)fullIUName{
    NSString *fileName = [self.iuManager.filePath nameWithoutExtensionAsFile];
    NSString *fullIUName = [NSString stringWithFormat:@"__F__%@__I__%@", fileName, _name];
    return fullIUName;
}


-(void)refreshDisplayText{
    NSMutableString *retStr = [NSMutableString stringWithFormat:@"%@ [z : %ld]: ", self.name, self.z];
    
    if (self.visible == NO) {
        [retStr appendString:@"Hidden, "];
    }
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@" :,"];
    self.displayText = [retStr stringByTrimmingCharactersInSet:set];;
}

-(NSMutableDictionary*)jsVariableDictionary{
    //get js variable
    if (self.event.variableTrigger.isExtern == NO &&
        [self.event.variableTrigger.variable length]) {
        NSDictionary *contentDict = @{@"value": @(_event.variableTrigger.initialValue), @"range":@(_event.variableTrigger.range)};
        return [@{_event.variableTrigger.variable: contentDict} mutableCopy];
    }
    return nil;
}

-(NSMutableDictionary*)jsTriggerDictionary{
    //get js variable
    if ([self.event.variableTrigger.event length] && self.event.variableTrigger.variable) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:_event.variableTrigger.event forKey:@"event"];
        [dict setObject:_event.variableTrigger.variable forKey:@"variable"];
        NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithObject:dict forKey:self.fullIUName];
        return retDict;
    }
    return nil;
}

-(NSMutableDictionary*)jsReceiverDictionary{
    NSMutableDictionary *retDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *contentDict = [NSMutableDictionary dictionary];
    [retDict setObject:contentDict forKey:self.fullIUName];
    
    if (_event.variableReceiver.valid) {
        [contentDict setObject:_event.variableReceiver.dict forKey:@"visible"];
    }
    if (self.event.variableFrameReceiver.valid) {
        [contentDict setObject:_event.variableFrameReceiver.dict forKey:@"frame"];
    }
    if ([contentDict count]) {
        return retDict;
    }
    return nil;
}

-(NSString*)HTMLClassString{
    NSMutableString *str = [NSMutableString string];
    for (NSString *class in self.classPedigree) {
        [str appendString:class];
        [str appendString:@" "];
    }
    
    if([self.iuManager.pWC.iuController.selectedObjects containsObject:self]){
        [str appendString:@"selectedIUObj"];
        [str appendString:@" "];
    }

    [str trim];
    return str;
}

-(NSString*)outputHTMLClassString{
    NSMutableString *str = [NSMutableString string];
    for (NSString *class in self.classPedigree) {
        [str appendString:class];
        [str appendString:@" "];
    }
   
    [str trim];
    return str;
}

-(NSUInteger)index{
    return [self.parent.children indexOfObject:self];
}

#pragma mark -
#pragma mark Right Menu

/**********************************/
// If you add right menu item
// overriding this menu
-(NSMenu*)popUpMenu{
    NSMenu *popUpMenu = [[NSMenu alloc] initWithTitle:@"IURightMenu"];

    /*Image menu item*/
    NSMenuItem *fullWidth = [[NSMenuItem alloc] initWithTitle:@"Full width" action:@selector(setFullWidth) keyEquivalent:@""];
    fullWidth.target = self.iuFrame;
    [popUpMenu addItem:fullWidth];

    [popUpMenu addItem:[self subMenuSize]];
    [popUpMenu addItem:[self subMenuAlign]];
    [popUpMenu addItem:[self subMenuArrange]];
    [popUpMenu addItem:[self subMenuAssistLine]];

    NSMenuItem *insertAfter = [popUpMenu addItemWithTitle:@"Insertn IU After" action:@selector(insertAfter) keyEquivalent:@"" target:self];
    if (self.parent == nil || self.iuFrame.currentScreenFrame.flowLayout == NO) {
        [insertAfter setAction:nil];
    }
    return popUpMenu;
}

-(void)insertAfter{
    NSAssert(self.iuFrame.currentScreenFrame.flowLayout, @"Only framelayout works");
    
}

-(NSMenuItem*)subMenuAlign{
    /*Align menu item*/
    /*items are more than 2*/
    NSMenuItem *align = [[NSMenuItem alloc] initWithTitle:@"Align" action:nil keyEquivalent:@""];
    NSMenu *subAlignMenu = [[NSMenu alloc] init];
    
    NSArray *selectedIUs = self.iuManager.pWC.iuController.selectedObjects;
    
    if([selectedIUs count] ==1){
        [subAlignMenu addItemWithTitle:@"Center" action:@selector(pageAlignCenter) keyEquivalent:@"" target:self];
    }
    else if([selectedIUs count] > 1){
        [subAlignMenu addItemWithTitle:@"Left" action:@selector(alignLeft) keyEquivalent:@"" target:self.iuManager];
        [subAlignMenu addItemWithTitle:@"Center" action:@selector(alignCenter) keyEquivalent:@"" target:self.iuManager];
        [subAlignMenu addItemWithTitle:@"Right" action:@selector(alignRight) keyEquivalent:@"" target:self.iuManager];
        [subAlignMenu addItemWithTitle:@"Top" action:@selector(alignTop) keyEquivalent:@"" target:self.iuManager];
        [subAlignMenu addItemWithTitle:@"Middle" action:@selector(alignMiddle) keyEquivalent:@"" target:self.iuManager];
        [subAlignMenu addItemWithTitle:@"Bottom" action:@selector(alignBottom) keyEquivalent:@"" target:self.iuManager];
        
    }
    [align setSubmenu:subAlignMenu];
    return align;
}

-(NSMenuItem*)subMenuArrange{
    /*Arrange Menu item*/
    NSMenuItem *arrange = [[NSMenuItem alloc] initWithTitle:@"Arrange" action:nil keyEquivalent:@""];
    NSMenu *subArrangeMenu = [[NSMenu alloc] init];
    [subArrangeMenu addItemWithTitle:@"Bring to Front" action:@selector(bringToFront) keyEquivalent:@"" target:self];
    [subArrangeMenu addItemWithTitle:@"Send to Back" action:@selector(sendToBack) keyEquivalent:@"" target:self];
    [subArrangeMenu addItemWithTitle:@"Bring Forward" action:@selector(bringForward) keyEquivalent:@"" target:self];
    [subArrangeMenu addItemWithTitle:@"Send Backward" action:@selector(sendBackward) keyEquivalent:@"" target:self];
    [arrange setSubmenu:subArrangeMenu];
    return arrange;
}


-(NSMenuItem*)subMenuSize{
    
    NSMenuItem *size = [[NSMenuItem alloc] initWithTitle:@"Size To Fit" action:nil keyEquivalent:@""];
    NSMenu *subImageMenu = [[NSMenu alloc] init];
    NSMenuItem *imageItem = [subImageMenu addItemWithTitle:@"Image" action:@selector(fitToImage) keyEquivalent:@"" target:self];
    [size setSubmenu:subImageMenu];
    if (self.bg.image == nil) {
        [imageItem  setAction:nil];
    }
    return size;
}

    

-(NSMenuItem*)subMenuAssistLine{
    /* Draw support lines*/
    NSMenuItem *supportLines = [[NSMenuItem alloc] initWithTitle:@"Support lines" action:nil keyEquivalent:@""];
    NSMenu *subLinesMenu = [[NSMenu alloc] init];
    NSArray *lineNames = @[@"Left", @"Center", @"Right", @"Top", @"Middle", @"Bottom", @"Select All", @"Deselect All"];
    
    NSUInteger index=0;
    for(NSString *name in lineNames){
        
        if([name isEqualToString:@"Select All"]){
            [subLinesMenu addItem:[NSMenuItem separatorItem]];
        }
        
        NSMenuItem *lineItem = [[NSMenuItem alloc] initWithTitle:name action:@selector(setAssistantLine:) keyEquivalent:@""];
        [lineItem setTarget:self.iuManager.iuViewManager];
        [lineItem setRepresentedObject:self];
        [lineItem setTag:index];
        
        NSInteger currentstate = (pow(2, index));
        
        bool state = self.lineLocation & currentstate;
        [lineItem setState:state];
        
        [subLinesMenu addItem:lineItem];
        index++;
        
    }
    
    [supportLines setSubmenu:subLinesMenu];

    return supportLines;
}




/* Arrange */
#pragma mark Rightmenu - Arrange
-(void)bringToFront{
    NSArray *sibling = self.parent.children;
    NSInteger maxZ = 1;
    for (IUObj *iu in sibling) {
        if (iu.z >= maxZ) {
            maxZ = iu.z + 1;
        }
    }
    self.z = maxZ;
    [self setNeedsDisplay:IUNeedsDisplayActionCSS];
}

-(void)sendToBack{
    NSArray *sibling = self.parent.children;
    NSInteger minZ = 0;
    for (IUObj *iu in sibling) {
        if (iu.z <= minZ) {
            minZ = iu.z - 1;
        }
    }
    self.z = minZ;
    [self setNeedsDisplay:IUNeedsDisplayActionCSS];
}

-(void)sendBackward{
    self.z--;;
    [self setNeedsDisplay:IUNeedsDisplayActionCSS];
}

-(void)bringForward{
    self.z++;
    [self setNeedsDisplay:IUNeedsDisplayActionCSS];
}

#pragma mark Rightmenu - Align


-(void)pageAlignCenter{
    /*
    IUObj *parent = self.parent;
    CGFloat iux = (parent.iuFrame.width /2);
    
    self.iuFrame.x = iux - (self.iuFrame.width/2);
     */
    
}

+(IUWidget*)widget{
    IUWidget *widget = [[IUWidget alloc] init];
    widget.name = self.displayName;
    widget.image = self.classImage;
    widget.desc = NSLocalizedString(self.className, @"");
    widget.value = self.className;
    widget.param = nil;
    return widget;
}


#pragma mark -
#pragma mark table view delegate & data source


-(void)reloadMQTable{
    [self.iuManager.pWC.inspectorVC.classIns reloadDataMQSize];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView{
    return NumberOfIUScreentType;
}


-(void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    IUScreenType selectedType;
    switch (row) {
        case 0: selectedType = IUScreenTypeDefault; break;
        case 1: selectedType = IUScreenTypeTablet; break;
        case 2: selectedType = IUScreenTypeMobile; break;
        default:
            assert(0);
            break;
    }

    IUScreenFrame * current = [self.iuFrame screenFrame:selectedType ];

    if(!current.loaded){
        [cell setTextColor:[NSColor grayColor]];
    }else{
        [cell setTextColor:[NSColor blackColor]];
    }
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    id object;
    NSString *screenType = [IUScreenFrame stringForScreenType:(IUScreenType)row];
    IUScreenFrame * current = [self.iuFrame.screenFrameDict objectForKey:screenType];
    NSString *identifier = [tableColumn identifier];
    
    if([identifier isEqualToString:@"type"]){
        object = [screenType substringFromIndex:12];
    }
    else if([identifier isEqualToString:@"x"]){
        object = [NSString stringWithFormat:@"%.0f%@", current.x, current.xModifier];
        
    }else if([identifier isEqualToString:@"y"]){
        object = [NSString stringWithFormat:@"%.0f%@", current.y, current.yModifier];
        
    }else if([identifier isEqualToString:@"width"]){
        object = [NSString stringWithFormat:@"%.0f%@", current.width, current.widthModifier];
        
    }else if([identifier isEqualToString:@"height"]){
        object = [NSString stringWithFormat:@"%.0f%@", current.height, current.heightModifier];
    }else{
        NSAssert1(NO, @"Unhandled table column identifier %@", identifier);
    }
    
    object = [object stringByReplacingOccurrencesOfString:kMDExModifierPercent withString:@"%"];
    
    return object;
    

}

- (BOOL)tableView:(NSTableView *)tableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    return NO;

}

-(BOOL)tableView:(NSTableView*)tableView keyDown:(unichar)key{
    if ([tableView.identifier isEqualToString:@"IUObj"]) {
        if(tableView.selectedRow == IUScreenTypeDefault){
            NSBeep();
            return YES;
        }
        
        NSString *screentType = [IUScreenFrame stringForScreenType:(IUScreenType)tableView.selectedRow];
        IUScreenFrame * current = [self.iuFrame.screenFrameDict objectForKey:screentType];

        //delete media query 
        if(key == NSDeleteCharacter && current.loaded){
            [self setNeedsDisplayStartGrouping];
            current.loaded = NO;
            [current copyWithOrigin:[self.iuFrame.screenFrameDict objectForKey:[IUScreenFrame stringForScreenType:IUScreenTypeDefault]]];
            
            [self setNeedsDisplay:IUNeedsDisplayActionAll];
            [self setNeedsDisplayEndGrouping];

        }
        return YES;
    }
    return NO;
}

-(BOOL)tableView:(NSTableView *)tableView endEditing:(NSText *)textObject row:(NSUInteger)row column:(NSUInteger)column{
    /*
     NSString *screenType = [IUFrameForScreenType stringForScreenType:row];
     NSInteger value = [[textObject string] integerValue];
     NSString *variable;
     switch (column) {
     case 0: assert(0); break;
     case 1: variable = @"x";break;
     case 2: variable = @"y";break;
     case 3: variable = @"width";break;
     case 4: variable = @"height";break;
     default:
     break;
     }
     
     if (![screenType isEqualToString:self.iuManager.pWC.selectedScreenType]) {
     [self.iuFrame setCurrentType:screenType];
     }
     [self.iuFrame setValue:@(value) forKey:variable];
     */
    return YES;
}


#pragma mark -
#pragma mark CSS


-(NSMutableString*)CSSSourceWithScreenType:(IUScreenType)screenType{
    NSDictionary *CSSDict = [self CSSDictWithScreenType:screenType];
    NSMutableString *retStr = [NSMutableString string];
    for (NSString *dictKey in CSSDict) {
        /* default 만 해당됨 */
        if ([dictKey isEqualToString:@"default"]) {
            [retStr appendFormat:@"[IUName = %@]{", [self fullIUName]];
        }
        else{
            [retStr appendFormat:@"[IUName = %@]:%@{", [self fullIUName], dictKey];
        }
        
        NSDictionary *subDict = [CSSDict objectForKey:dictKey];
        for (NSString * key in subDict) {
            [retStr appendFormat:@"%@ : %@; ", key, [subDict objectForKey:key] ];
        }
        
        [retStr appendString:@"}"];
    }
    return retStr;
}

-(NSString*)HTMLChangeJavascript{
    return [NSString stringWithFormat:@"$(\"[iuname=%@]\").replaceWith(\"%@\")", self.fullIUName, [[self HTMLSource2:self] stringEscape]];
}

-(NSInteger)iuStyleType{
    /*
     * setIUstyle (iuname, style, type)
     * iuname  : iuname
     * style : css attributes
     * type :
     * 0 - import default css files
     * 1 - default type
     * 2 - max 1024;
     * 3 - tablet
     * 4 - mobile
     */
    NSInteger styleType = (NSInteger)self.iuFrame.currentScreenFrame.type+1;
    
    return styleType;
}

-(NSString*)CSSChangeJavascript{
   
    return [NSString stringWithFormat:@"setIUStyle('%@', '%@', %ld);", self.fullIUName, [[self CSSStringForScreenType:self.iuManager.pWC.selectedScreenType] stringEscape], [self iuStyleType]]; //여기서 빌드
}

-(NSString*)insertionJavascript{
    NSMutableString *js = [NSMutableString stringWithFormat:@"setIUStyle('%@', '%@', %ld);\n", self.fullIUName, [[self CSSStringForScreenType:self.iuManager.pWC.selectedScreenType] stringEscape], [self iuStyleType]];
    [js appendFormat:@"setIUStyle('%@', '%@', 1);\n", self.fullIUName, [[self CSSStringForScreenType:IUScreenTypeDefault] stringEscape]];
    [js appendFormat:@"insertIU('%@', %lu, '%@')", self.parent.fullIUName, self.index , [[self HTMLSource2:self] stringEscape]];
    return js;

}

-(void)javascriptDidInsert{
    //nothing to do in IUObj.
    //to be called after insert javascript.
    
}


-(NSArray*)allParents{
    NSMutableArray *arr = [NSMutableArray array];
    IUObj *obj = self;
    while (1) {
        obj = obj.parent;
        [arr addObject:obj];
        if (obj.parent == nil) {
            return arr;
        }
    }
}

-(BOOL)shouldChangeXByUserInput:(CGFloat)x{
    if (self.iuFrame.horizontalCenter) {
        return NO;
    }
    return YES;
}

-(BOOL)shouldChangeYByUserInput:(CGFloat)y{
    if (self.iuFrame.verticalCenter) {
        return NO;
    }
    return YES;
}

-(BOOL)shouldChangeWidthByUserInput:(CGFloat)w{
    return YES;
}

-(BOOL)shouldChangeHeightByUserInput:(CGFloat)h{
    return YES;
}


-(BOOL)shouldChangeFlowLayoutByUserInput:(BOOL)flowLayout{
    return YES;
}

-(BOOL)shouldChangeBGColorByUserInput:(NSColor *)color{
    return YES;
}

-(void)becomeFocusedIU{
    //do nothing
    return;
}

@end
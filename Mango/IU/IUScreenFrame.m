//
//  IUFrameForScreenType.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 1. 2..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "IUScreenFrame.h"
#import "IUObj.h"

@implementation IUScreenFrame

-(id)init{
    self = [super init];
    if(self){
        self.loaded = NO;
        _extraData = [NSMutableDictionary dictionary];
    }
    return self;
}

+(NSMutableArray *)undoPropertyList{
    NSMutableArray *array = [super undoPropertyList];
    [array addObjectsFromArray:@[@"flowLayout",
                                 @"percentX", @"percentY", @"percentWidth", @"percentHeight",
                                 @"pixelX", @"pixelY", @"pixelWidth", @"pixelHeight",
                                 @"percentFlagX", @"percentFlagY",
                                 @"percentFlagWidth", @"percentFlagHeight",
                                 
                                 @"percentMarginLeft", @"percentMarginRight",
                                 @"percentMarginTop", @"percentMarginBottom",
                                 @"pixelMarginLeft", @"pixelMarginRight",
                                 @"pixelMarginTop", @"pixelMarginBottom",
                                 @"percentFlagMarginLeft", @"percentFlagMarginRight",
                                 @"percentFlagMarginTop", @"percentFlagMarginBottom",
                                 ]];
    return array;
}

/* extraData!
 * fontSize와 같은 mq에 필요한 데이터들을 저장.
 * 각자 저장할때는 iuFrame.currentScreenFrameWillChange, DidChange를 이용해서 save&load
 * example : iuTextView.m 
 * iuFrame_currentScreenFrameWillChange
 * iuFrame_currentScreenFrameDidChange
 */
-(id)valueForUndefinedKey:(NSString *)key{
    return [_extraData objectForKey:key];
}

+(NSString *)stringForScreenType:(IUScreenType) i{
    switch(i){
        case IUScreenTypeDefault:
            return @"IUScreenTypeDefault";
        case IUScreenTypeTablet:
            return @"IUScreenTypeTablet";
        case IUScreenTypeMobile:
            return @"IUScreenTypeMobile";
        default:
            return @"";
    }
}


-(void)copyWithOrigin:(IUScreenFrame *)origin{
    if(!self.loaded){
        
        [self willChangeValueForKey:@"extraData"];
        _extraData = [origin.extraData mutableCopy];
        [self didChangeValueForKey:@"extraData"];
        
        self.percentFlagX = origin.percentFlagX;
        self.percentFlagY = origin.percentFlagY;
        self.percentFlagWidth = origin.percentFlagWidth;
        self.percentFlagHeight = origin.percentFlagHeight;
        
        self.pixelX = origin.pixelX;
        self.pixelY = origin.pixelY;
        self.pixelWidth = origin.pixelWidth;
        self.pixelHeight = origin.pixelHeight;
        
        self.percentX = origin.percentX;
        self.percentY = origin.percentY;
        self.percentWidth = origin.percentWidth;
        self.percentHeight = origin.percentHeight;
        
        self.percentFlagMarginTop = origin.percentFlagMarginTop;
        self.percentFlagMarginBottom = origin.percentFlagMarginBottom;
        self.percentFlagMarginLeft = origin.percentFlagMarginLeft;
        self.percentFlagMarginRight = origin.percentFlagMarginRight;
        
        self.pixelMarginTop = origin.pixelMarginTop;
        self.pixelMarginBottom = origin.pixelMarginBottom;
        self.pixelMarginLeft = origin.pixelMarginLeft;
        self.pixelMarginRight = origin.pixelMarginRight;
        
        self.percentMarginTop = origin.percentMarginTop;
        self.percentMarginBottom = origin.percentMarginBottom;
        self.percentMarginLeft = origin.percentMarginLeft;
        self.percentMarginRight = origin.percentMarginRight;
        
        self.flowLayout = origin.flowLayout;
        
        if([self.iu isKindOfClass:[IUPage class]]){
            self.percentFlagWidth = YES;
            self.percentWidth = 100;
            
            //set Pixel;
            if(self.type == IUScreenTypeTablet)
                self.pixelWidth = IUScreenTabletSize;
            else if(self.type == IUScreenTypeMobile)
                self.pixelWidth = IUScreenMobileSize;
            
        }
        
        self.loaded = YES;
    }
}

-(NSRect)absoluteframe{
    return NSRectMake(self.pixelX, self.pixelY, self.pixelWidth, self.pixelHeight);
}


-(NSRect)mixedframe{
    CGFloat x = (self.flowLayout ?  self.marginLeft: self.pixelX);
    CGFloat y = (self.flowLayout ?  self.marginTop: self.pixelY );

    return NSRectMake(x, y, self.pixelWidth, self.pixelHeight);
}


#pragma mark-
#pragma mark dict

+(NSArray*)propertyList{
    NSMutableArray *array = [[self autoPropertyList] mutableCopy];
    [array removeObjectsInArray:@[@"iu", @"extraData", @"loaded"]];
    
    return array;
}


-(NSMutableDictionary *)dict{
    NSMutableDictionary *dict = [self exportPropertyFromDictOfClass:[IUScreenFrame class]];
    if (self.extraData) {
        [dict setObject:self.extraData forKey:@"extraData"];
    }
    return dict;
}

-(void)loadWithDict:(NSDictionary *)dict{
    [self importPropertyFromDict:dict ofClass:[IUScreenFrame class]];
    NSDictionary *newExtraData = [dict objectForKey:@"extraData"];
    for (NSString *str in newExtraData) {
        id value = [newExtraData objectForKey:str];
        [self.extraData setObject:value forKey:str];
    }
}

#pragma mark -
#pragma mark flowlayout

-(void)setFlowLayout:(BOOL)flowLayout{
    _flowLayout = flowLayout;
    
    //flow layout 일시는 margin top 건드림
    //안그럼 두개가 꼬이므로
    if(flowLayout){
        self.percentFlagX = NO;
        self.percentFlagY = NO;
 
    }
    [self.iu setNeedsDisplay:IUNeedsDisplayActionAll];
}


#pragma mark -
#pragma mark pixelXXX, percentXXX

-(void)setPixelRect:(CGRect)rect{
    _pixelX = rect.origin.x;
    _pixelY = rect.origin.y;
    _pixelWidth = rect.size.width;
    _pixelHeight = rect.size.height;
}

-(void)setPixelWidth:(CGFloat)pixelWidth{
    _pixelWidth = pixelWidth;
}

-(void)setPixelX:(CGFloat)pixelX{
        _pixelX = pixelX;
}

-(void)setPercentX:(CGFloat)percentX{
        _percentX = percentX;
}

-(void)setPixelY:(CGFloat)pixelY{
    if (pixelY > 1000) {
        
    }
        _pixelY = pixelY;
}

-(void)setPixelMarginTop:(CGFloat)pixelMarginTop{
    _pixelMarginTop = pixelMarginTop;
}
-(void)setPercentY:(CGFloat)percentY{
        _percentY = percentY;
}


-(void)setPercentWidth:(CGFloat)percentWidth{
    if (percentWidth == INFINITY) {
        assert(0);
    }
    _percentWidth = percentWidth;
}

#pragma mark -
#pragma mark percent

-(CGFloat)x{
    if(self.percentFlagX)
        return self.percentX;
    else
        return self.pixelX;
}
-(CGFloat)y{
    if(self.percentFlagY)
        return self.percentY;
    else
        return self.pixelY;
}
-(CGFloat)width{
    if(self.percentFlagWidth)
        return self.percentWidth;
    else
        return self.pixelWidth;
}
-(CGFloat)height{
    if(self.percentFlagHeight)
        return self.percentHeight;
    else
        return self.pixelHeight;
}

#pragma mark margin

-(CGFloat)marginLeft{
    if(self.percentFlagMarginLeft)
        return self.percentMarginLeft;
    else
        return self.pixelMarginLeft;
}
-(CGFloat)marginRight{
    if(self.percentFlagMarginRight)
        return self.percentMarginRight;
    else
        return self.pixelMarginRight;
}
-(CGFloat)marginTop{
    if(self.percentFlagMarginTop){
        return self.percentMarginTop;
    }
    else{
        return self.pixelMarginTop;
    }
}
-(CGFloat)marginBottom{
    if(self.percentFlagMarginBottom)
        return self.percentMarginBottom;
    else
        return self.pixelMarginBottom;
}

#pragma mark -
#pragma mark modifier

-(NSString *)xModifier{
    if(self.percentFlagX)
        return kMDExModifierPercent;
    else
        return kMDExModifierPixel;

}
-(NSString *)yModifier{
    if(self.percentFlagY)
        return kMDExModifierPercent;
    else
        return kMDExModifierPixel;

    
}
-(NSString *)widthModifier{
    if(self.percentFlagWidth)
        return kMDExModifierPercent;
    else
        return kMDExModifierPixel;
}
-(NSString *)heightModifier{
    if(self.percentFlagHeight)
        return kMDExModifierPercent;
    else
        return kMDExModifierPixel;
}

#pragma mark margin

-(NSString *)marginLeftModifier{
    if(self.percentFlagMarginLeft)
        return kMDExModifierPercent;
    else
        return kMDExModifierPixel;
}
-(NSString *)marginRightModifier{
    if(self.percentFlagMarginRight)
        return kMDExModifierPercent;
    else
        return kMDExModifierPixel;
}
-(NSString *)marginTopModifier{
    if(self.percentFlagMarginTop)
        return kMDExModifierPercent;
    else
        return kMDExModifierPixel;
}
-(NSString *)marginBottomModifier{
    if(self.percentFlagMarginBottom)
        return kMDExModifierPercent;
    else
        return kMDExModifierPixel;
}

#pragma mark undo
-(void)IUScreenFrameUndoInvocation{
    [self.iu setNeedsDisplayStartGrouping];
    [self.iu setNeedsDisplay:IUNeedsDisplayActionCSS];
    [self.iu setNeedsDisplayEndGrouping];
}

@end

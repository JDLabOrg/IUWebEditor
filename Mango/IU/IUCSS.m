//
//  IUCSS.m
//  Mango
//
//  Created by JD on 13. 8. 29..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUCSS.h"

@implementation IUCSSBorder
-(id)init{
    self = [super init];
    self.color = [NSColor grayColor];
    return self;
}
@end

@implementation IUCSS{
    BOOL    valueChanging;
}

+(NSArray*)propertyListExclude{
    return @[@"CSSDict2", @"enable", @"iu"];
}

+(NSMutableArray *)undoPropertyList{
    NSMutableArray * array = [super undoPropertyList];
    [array addObjectsFromArray:@[@"enable", @"BGGradientEnable", @"BGcolor1",
                                 @"BGColor2",
                                 @"boxShadowEnable", @"boxShadowColor",
                                 @"boxShadowVertical", @"boxShadowHorizontal",
                                 @"boxShadowSpread", @"boxShadowBlur",
                                 @"boxBorderEnable", @"borderSize",
                                 @"borderColor", @"borderRadius",
                                 @"topBorderSize", @"leftBorderSize",
                                 @"rightBorderSize", @"bottomBorderSize",
                                 @"topBorderColor", @"leftBorderColor",
                                 @"rightBorderColor", @"bottomBorderColor",
                                 @"topLeftBorderRadius", @"topRightBorderRadius",
                                 @"bottomLeftBorderRadius", @"bottomRightBorderRadius"
                                 ]];
     return array;
}
-(id)initWithIU:(IUObj *)obj{
    self = [super init];
    self.iu = obj;
    
    [self addObserver:self forKeyPaths:[IUCSS propertyList] options:0 context:@"css"];
    
    
    self.boxShadowColor = [NSColor blackColor];
    self.topBorderColor = [NSColor blackColor];
    self.leftBorderColor = [NSColor blackColor];
    self.bottomBorderColor = [NSColor blackColor];
    self.rightBorderColor = [NSColor blackColor];
    
    self.borderSize = 0;
    self.borderColor = [NSColor blackColor];
    self.borderRadius = 0;
    self.disableBorder = NO;
    self.disableShadow = NO;
    
    return self;
    
}
-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [self exportPropertyFromDictOfClass:[IUCSS class]];
    [dict removeObjectForKey:@"borderSize"];
    [dict removeObjectForKey:@"borderColor"];
    [dict removeObjectForKey:@"borderRadius"];
    
    return dict;
}

-(void)loadWithDict:(NSDictionary *)dict{
    [self importPropertyFromDict:dict ofClass:[IUCSS class]];
}



-(void)cssContextDidChange{
    
    
    //boxShadow
    if(_boxShadowHorizontal || _boxShadowVertical || _boxShadowBlur || _boxShadowSpread){
        _boxShadowEnable = true;
    }else{
        _boxShadowEnable = false;
    }
    
    //boxBorder
    if(_topLeftBorderRadius || _topRightBorderRadius || _bottomLeftBorderRadius || _bottomRightBorderRadius
       || _topBorderSize || _leftBorderSize || _rightBorderSize || _bottomBorderSize){
        _boxBorderEnable = true;
        
    }else{
        _boxBorderEnable = false;
    }
    //BGGradient
    
    //if(_BGColor1 != _BGColor2){
    if( _BGGradientEnable){
        if(_BGColor1 == nil) _BGColor1 = [NSColor blackColor];
        if(_BGColor2 == nil) _BGColor2 = [NSColor blackColor];
    }
    
    [self dictDidMake];
    
    [self.iu setNeedsDisplay:IUNeedsDisplayActionCSS];
}

-(void)dictDidMake{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    if (_boxShadowEnable) {
        NSString *boxShadowStr = [NSString stringWithFormat:@"%dpx  %dpx %dpx %dpx %@",
                                  _boxShadowHorizontal, _boxShadowVertical, _boxShadowBlur, _boxShadowSpread,
                                  [_boxShadowColor rgbString]];
        [dict putString:boxShadowStr forKey:@"box-shadow" param:nil];
    }
    if (_boxBorderEnable) {
        [dict putInt:_topLeftBorderRadius forKey:@"border-top-left-radius" param:@{kMDExModifier: kMDExModifierPixel, kMDExIgnoreZero: @YES}];
        [dict putInt:_topRightBorderRadius forKey:@"border-top-right-radius" param:@{kMDExModifier: kMDExModifierPixel, kMDExIgnoreZero: @YES}];
        [dict putInt:_bottomLeftBorderRadius forKey:@"border-bottom-left-radius" param:@{kMDExModifier: kMDExModifierPixel, kMDExIgnoreZero: @YES}];
        [dict putInt:_bottomRightBorderRadius forKey:@"border-bottom-right-radius" param:@{kMDExModifier: kMDExModifierPixel, kMDExIgnoreZero: @YES}];
        
        if (_topBorderSize) {
            [dict putString:[NSString stringWithFormat:@"%dpx solid %@", _topBorderSize, [_topBorderColor rgbString]]
                     forKey:@"border-top" param:nil];
        }
        if (_leftBorderSize) {
            [dict putString:[NSString stringWithFormat:@"%dpx solid %@", _leftBorderSize, [_leftBorderColor rgbString]]
                     forKey:@"border-left" param:nil];
        }
        if (_rightBorderSize) {
            [dict putString:[NSString stringWithFormat:@"%dpx solid %@", _rightBorderSize, [_rightBorderColor rgbString]]
                     forKey:@"border-right" param:nil];
        }
        if (_bottomBorderSize) {
            [dict putString:[NSString stringWithFormat:@"%dpx solid %@", _bottomBorderSize, [_bottomBorderColor rgbString]]
                     forKey:@"border-bottom" param:nil];
        }
        
        [self.iu.iuFrame changeRect];

    }
    if (_BGGradientEnable) {
        [dict putString:[_BGColor1 rgbString] forKey:@"background-color" param:nil];
        NSString    *webKitStr = [NSString stringWithFormat:@"-webkit-gradient(linear, left top, left bottom, color-stop(0.05, %@), color-stop(1, %@));", _BGColor1.rgbString, _BGColor2.rgbString];
        NSString    *mozStr = [NSString stringWithFormat:@"	background:-moz-linear-gradient( center top, %@ 5%%, %@ 100%% );", _BGColor1.rgbString, _BGColor2.rgbString];
        NSString    *ieStr = [NSString stringWithFormat:@"filter:progid:DXImageTransform.Microsoft.gradient(startColorstr='%@', endColorstr='%@', GradientType=0)", _BGColor1.rgbString, _BGColor2.rgbString];
        NSString *bgStr = [webKitStr stringByAppendingFormat:@"%@ %@", mozStr, ieStr];
        [dict putString:bgStr forKey:@"background" param:nil];
    }
    if (valueChanging == NO) {
        if (_topLeftBorderRadius == _topRightBorderRadius &&
            _topLeftBorderRadius == _bottomLeftBorderRadius &&
            _topLeftBorderRadius == _bottomRightBorderRadius
            ) {
            NSString *newValue = [NSString stringWithFormat:@"%d", _topLeftBorderRadius];
            if ([newValue isEqualToString:_borderRadius] == NO) {
                if (self.borderRadius != newValue) {
                    self.borderRadius = newValue;
                }
            }
        }
        else{
            if (self.borderRadius != NSMultipleValuesMarker) {
                self.borderRadius = NSMultipleValuesMarker;
            }
        }
        if (_topBorderSize == _leftBorderSize &&
            _topBorderSize == _rightBorderSize &&
            _topBorderSize == _bottomBorderSize
            ) {
            NSString *newValue = [NSString stringWithFormat:@"%d", _topBorderSize];
            if ([newValue isEqualToString:_borderSize] == NO) {
                if (self.borderSize != newValue) {
                    self.borderSize = newValue;
                }
            }
        }
        else{
            if (self.borderSize != NSMultipleValuesMarker) {
                self.borderSize = NSMultipleValuesMarker;
            }
        }
    }
    self.CSSDict2 = dict;
    self.enable = _BGGradientEnable || _boxShadowEnable || _boxBorderEnable;
}


-(void)borderSizeDidChange{
    if (self.borderSize == NSMultipleValuesMarker ||
        self.borderSize == NSNoSelectionMarker ||
        self.borderSize == NSNotApplicableMarker) {
        return;
    }
    valueChanging = YES;
    self.topBorderSize = [self.borderSize intValue];
    self.leftBorderSize = [self.borderSize intValue];
    self.rightBorderSize = [self.borderSize intValue];
    self.bottomBorderSize = [self.borderSize intValue];
    valueChanging = NO;
}

-(void)borderRadiusDidChange{
    if (self.borderRadius == NSMultipleValuesMarker ||
        self.borderRadius == NSNoSelectionMarker ||
        self.borderRadius == NSNotApplicableMarker) {
        return;
    }
    valueChanging = YES;
    self.topLeftBorderRadius = [self.borderRadius intValue];
    self.topRightBorderRadius = [self.borderRadius intValue];
    self.bottomLeftBorderRadius = [self.borderRadius intValue];
    self.bottomRightBorderRadius = [self.borderRadius intValue];
    valueChanging = NO;
}



-(void)borderColorDidChange{
    self.topBorderColor = self.bottomBorderColor = self.leftBorderColor = self.rightBorderColor = self.borderColor;
}

-(void)dealloc{
    [self removeObserver:self forKeyPaths:[IUCSS propertyList]];
    
}

@end

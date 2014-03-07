//
//  IUTextFieldEdit.m
//  Mango
//
//  Created by JD on 9/11/13.
//  Copyright (c) 2013 JD. All rights reserved.
//

#import "IUTextFieldEdit.h"

@implementation IUTextFieldEdit

-(id)instantiate{

    [super instantiate];
    self.bg.color = [NSColor whiteColor];
    self.iuFrame.defaultScreenFrame.pixelHeight= 30;
    self.fontColor = [NSColor brownColor];
    self.fontName = @"Helvetica";
    self.fontSize = 17;
    [self.iuFrame.defaultScreenFrame.extraData setValue:@(17) forKey:@"fontSize"];
    self.sampleText = @"place holder : color change input value, not place holder";
    self.attributeText = [[NSAttributedString alloc] initWithString:self.sampleText];

    return self;
}

+(NSArray*)propertyList{
    return @[@"formName", @"fontColor", @"fontName", @"fontSize", @"sampleText"];
}
+(NSMutableArray *)undoPropertyList{
    NSMutableArray *array = [super undoPropertyList];
    [array addObjectsFromArray:@[@"fontColor", @"fontName", @"fontSize", @"sampleText"]];
    return array;
}

-(void)loadWithDict:(NSDictionary *)dict{
    [super loadWithDict:dict];
    NSDictionary *myDict = [dict objectForKey:@"IUTextFieldEdit"];
    if (myDict) {
        [self importPropertyFromDict:myDict ofClass:[IUTextFieldEdit class]];
        self.fontColor = [[myDict objectForKey:@"fontColor"] color];

    }
}

-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [super dict];
    NSMutableDictionary *myDict = [self exportPropertyFromDictOfClass:[IUTextFieldEdit class]];
    [myDict setObject:[self.fontColor rgbString] forKey:@"fontColor"];
    [dict setObject:myDict forKey:@"IUTextFieldEdit"];
    return dict;
}

-(void)iuLoad{
    [super iuLoad];
    [self addObserver:self forKeyPath:@"sampleText" options:0 context:nil];
    [self addObserver:self forKeyPath:@"attributeText" options:0 context:nil];
    [self addObserver:self forKeyPaths:@[@"fontName", @"fontColor", @"fontSize"] options:0 context:@"fontAttribute"];
}
-(void)dealloc{
    [self removeObserver:self forKeyPath:@"sampleText"];
    [self removeObserver:self forKeyPath:@"attributeText"];
    [self removeObserver:self forKeyPaths:@[@"fontName", @"fontColor", @"fontSize"]];
}

#pragma mark -
#pragma mark 

-(void)setFontSize:(CGFloat)fontSize{
    [self.iuFrame.currentScreenFrame.extraData setObject:@(fontSize) forKey:@"fontSize"];
}
-(CGFloat)fontSize{
    NSNumber *fontSize = [self.iuFrame.currentScreenFrame.extraData objectForKey:@"fontSize"];
    if (fontSize == nil) {
        fontSize = [self.iuFrame.defaultScreenFrame.extraData objectForKey:@"fontSize"];
    }
    if (fontSize == nil) {
        [self.iuFrame.defaultScreenFrame.extraData setObject:@(17) forKey:@"fontSize"];
        fontSize = [self.iuFrame.defaultScreenFrame.extraData objectForKey:@"fontSize"];
    }
    return [fontSize floatValue];
}

-(void)fontAttributeContextDidChange{
    [self setNeedsDisplay:IUNeedsDisplayActionCSS];

}

- (void)sampleTextDidChange{
    
    if (self.sampleText == nil) {
        self.sampleText = @"";
    }
    
    [self setNeedsDisplay:IUNeedsDisplayActionAll];
}

- (void)attributeTextDidChange{
    self.sampleText = [self.attributeText string];
}

#pragma mark -
#pragma mark HTML

-(NSMutableDictionary*)HTMLDict2{
    NSMutableDictionary *dict = [super HTMLDict2];
    if (self.sampleText) {
        [dict putString:self.sampleText forKey:@"placeholder" param:nil];
    }
    return dict;
}

-(NSMutableDictionary*)outputDict2{
    NSMutableDictionary *dict = [super HTMLDict2];
    if (self.sampleText) {
        [dict putString:self.sampleText forKey:@"placeholder" param:nil];
    }
    if (self.formName) {
        [dict putString:self.formName forKey:@"name" param:nil];
    }
    return dict;
}

-(NSString*)HTMLTag2{
    return @"input";
}

-(NSString*)innerHTML2:(id)caller{
    return nil;
}

-(NSString *)innerOutputHTML2{
    return nil;
}

-(BOOL)appendClosingTag{
    return NO;
}

#pragma mark -
#pragma mark CSS
-(NSMutableDictionary*)CSSDictWithScreenType:(IUScreenType)screenType{
    NSMutableDictionary *localCSSDict = [super CSSDictWithScreenType:screenType];
    
    NSString *screenStrType = [IUScreenFrame stringForScreenType:screenType];
    IUScreenFrame * current = [self.iuFrame.screenFrameDict objectForKey:screenStrType];
    
    NSNumber *number= [current.extraData objectForKey:@"fontSize"];
    CGFloat currentFontSize = self.fontSize;
    if (number != nil) {
        currentFontSize = [number floatValue];
    }

    
    NSNumber *fontSize = [[self.iuFrame screenFrame:screenType].extraData objectForKey:@"fontSize"];
    if (fontSize) {
        [localCSSDict putFloat:[fontSize floatValue] forKey:@"font-size" param:@{kMDExModifier: kMDExModifierPixel}];
    }
    
    [localCSSDict putString:self.fontName forKey:@"font-family" param:nil];
    [localCSSDict putString:[self.fontColor rgbString] forKey:@"color" param:nil];

    if (self.event.mouseOn) {
        if (self.event.mouseOn.enableTextColor == YES) {
            [localCSSDict putString:[self.event.mouseOn.textColor rgbString] forKey:@"color" param:@{kMDExOutputDictKey:@"hover"}];
        }
        
    }
    return localCSSDict;
}

#pragma mark -
#pragma mark RightMenu
-(NSMenuItem* )subMenuSize{
    //TextView has FitToText
    //TextEdit cannot : there is no width & height
    NSMenuItem *size = [super subMenuSize];
    NSMenuItem *textFitItem = [size.submenu itemWithTitle:@"Text"];
    [size.submenu removeItem:textFitItem];
    return size;
}
@end

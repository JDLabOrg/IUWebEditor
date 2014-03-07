//
//  IUText.m
//  Mango
//
//  Created by JD on 13. 2. 3..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUText.h"
#import "IUManager.h"
#import "IUViewManager.h"


@implementation IUText

@synthesize variable;
@synthesize sampleText;
@synthesize fontColor;
@synthesize alignmentIdx;

+(NSString*)getIconFileName{
    return IUTextIconFileName;
}

+(NSArray*)propertyList{
    //custom managment for fontColor
    return @[ @"variable",  @"headingLevel", @"enableHeading", @"lineHeight"];
}

+(NSMutableArray *)undoPropertyList{
    NSMutableArray *array = [super undoPropertyList];
    [array addObjectsFromArray: @[ @"variable",  @"headingLevel", @"enableHeading", @"attributeText", @"lineHeight"]];
     return array;
}

-(id)instantiate{
    [super instantiate];
    self.fontColor = [NSColor blackColor];
    self.fontSize = 17;
    self.sampleText = @"";
    self.enableHeading = FALSE;
    self.headingLevel = 0;
    self.lineHeight = IUTextLineHeightAuto;
    self.alignmentIdx = NSCenterTextAlignment;
    return self;
}


-(NSDictionary *)iuTextAttributeDict{

    
    NSFontManager *fontManager  = [NSFontManager sharedFontManager];
    NSFont *font = [fontManager fontWithFamily:@"Helvetica"
                                        traits:0
                                        weight:0
                                          size:self.fontSize];
    
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
    [pStyle setAlignment:self.alignmentIdx];
    [pStyle setLineSpacing:self.lineHeight];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          font, NSFontAttributeName,
                          pStyle, NSParagraphStyleAttributeName,
                          self.fontColor, NSForegroundColorAttributeName,
                          nil];
    
    
    return dict;
}

-(void)iuLoad{
    [super iuLoad]; // BG가 여기서 로딩됨
    
    self.event.mouseOn.disableText = NO;
    
    if(self.htmlText != nil){
        //load from dict
        [self saveAttributeTextFromHtmlText];
    }
    else if(sampleText != nil){
        //laod from initialize
        self.attributeText = [[NSMutableAttributedString alloc]  initWithString:self.sampleText attributes:[self iuTextAttributeDict]];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(screenTypeDidChange) name:@"ScreenTypeDidChangeNotification" object:nil];
    [self addObserver:self forKeyPaths:@[@"attributeText",
                                         @"attributeText.length",
                                         //text lineHeight 조정
                                         @"iuFrame.currentScreenFrame.pixelHeight",
                                         @"lineHeight"] options:NSKeyValueObservingOptionInitial context:@"attributeText"];
    [self addObserver:self forKeyPaths:@[@"enableHeading", @"headingLevel"] options:0 context:@"heading"];
    [self addObserver:self forKeyPath:@"iuFrame.currentScreenFrame" options:NSKeyValueObservingOptionPrior context:nil];
}

-(void)dealloc{
    [self removeObserver:self forKeyPaths:@[@"fontSize"]];
    [self removeObserver:self forKeyPath:@"attributeText"];
    [self removeObserver:self forKeyPath:@"headingLevel"];
    [self removeObserver:self forKeyPath:@"iuFrame.currentScreenFrame"];
}


-(void)loadWithDict:(NSDictionary*)dict{
    [super loadWithDict:dict];
    NSMutableDictionary *myDict = [dict objectForKey:@"IUText"];
    [self importPropertyFromDict:myDict ofClass:[IUText class]];
}
    

-(NSMutableDictionary*)dict{
    NSMutableDictionary *dict = [super dict];
    if (dict) {
        NSMutableDictionary *myDict = [self exportPropertyFromDictOfClass:[IUText class]];
        [dict setObject:myDict forKey:@"IUText"];
        
    }
    //escape//
    return dict;
}


/*Property Change */
-(void)headingContextDidChange{
    DLog(@"level : %lu", self.headingLevel);
    if(self.enableHeading){
        [self setNeedsDisplay:IUNeedsDisplayActionHTML];
    }
}

-(NSString *)htmlText{
    NSString *htmlStr = [self.iuFrame.currentScreenFrame.extraData objectForKey:@"htmlString"];
    if(htmlStr == nil){
        htmlStr = [self.iuFrame.defaultScreenFrame.extraData objectForKey:@"htmlString"];
    }

    return htmlStr;
}
-(void)setHtmlText:(NSString *)htmlText{
    if(htmlText == nil){
        [self.iuFrame.currentScreenFrame.extraData removeObjectForKey:@"htmlString"];
    }
    else{
        [self.iuFrame.currentScreenFrame.extraData setObject:htmlText forKey:@"htmlString"];
    }
}

-(void)screenTypeDidChange{
    if(self.htmlText != nil){
        //if has screenTypeDidChange and be set attributedText
        [self saveAttributeTextFromHtmlText];

    }
}

#pragma mark -
#pragma mark manage attributeString

-(NSMutableAttributedString *)changeURLtoRelativeURL:(NSAttributedString *)attributeString
{
    NSUInteger length = attributeString.length;
    NSRange    effectiveRange = NSMakeRange(0, 0);
    NSMutableAttributedString *resultString = [[NSMutableAttributedString alloc] initWithAttributedString:attributeString];

    
    while(NSMaxRange(effectiveRange) <length){
        NSURL *attrVal;
        
        attrVal = [attributeString attribute:NSLinkAttributeName atIndex:NSMaxRange(effectiveRange) effectiveRange:&effectiveRange];
        
        if(attrVal != nil &&
           [[attrVal absoluteString] containsString:@"file:///"]){
            NSString *newURL = [[attrVal absoluteString] substringFromIndex:@"file:///".length];
            [resultString addAttribute:NSLinkAttributeName value:newURL range:effectiveRange];
        }
    }
    return resultString;
}

-(void)saveAttributeTextFromHtmlText{
    NSURL *aBaseURL= [NSURL URLWithString:@""];
    self.attributeText =  [[NSMutableAttributedString alloc]
                           initWithHTML:[self.htmlText dataUsingEncoding:NSUTF8StringEncoding]
                           baseURL:aBaseURL
                           documentAttributes:nil];
    NSInteger length = self.attributeText.length;
    if(length > 0){
        NSString *lastChar = [[self.attributeText attributedSubstringFromRange:NSMakeRange(length-1, 1)] string];
        if([lastChar isEqualToString:@"\n"]){
            self.attributeText = [[self.attributeText attributedSubstringFromRange:NSMakeRange(0, length-1)] mutableCopy];
        }
    }
    self.attributeText = [self changeURLtoRelativeURL:self.attributeText];
}

-(NSInteger)numberOfLines{
    if(self.attributeText.length ==0 ) return 0;
    NSString *str = [self.attributeText string];
    NSArray *lines = [str componentsSeparatedByString:@"\n"];
    return [lines count];
}

-(void)saveHTMLTextFromattributeText{
    NSMutableAttributedString *currentStr = [self.attributeText mutableCopy];
    NSInteger lines = [self numberOfLines];
    if(lines != 0){
        CGFloat currentLineHeight = self.lineHeight;
        if(self.lineHeight ==IUTextLineHeightAuto){
            currentLineHeight = floor(self.iuFrame.currentScreenFrame.pixelHeight/([self numberOfLines]));
        }
        NSMutableParagraphStyle *newParagraph = [currentStr attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil];
        [newParagraph setMinimumLineHeight:currentLineHeight];
        [newParagraph setMaximumLineHeight:currentLineHeight];
        [currentStr addAttribute:NSParagraphStyleAttributeName value:newParagraph range:NSMakeRange(0, [currentStr length])];
    }
    
    
    
    NSDictionary *documentAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        NSHTMLTextDocumentType, NSDocumentTypeDocumentAttribute,
                                        [NSURL URLWithString:@""], NSBaseURLDocumentOption,
                                        nil];
    NSData *htmlData = [currentStr dataFromRange:NSMakeRange(0, currentStr.length) documentAttributes:documentAttributes error:NULL];
    self.htmlText = [[NSString alloc] initWithData:htmlData encoding:NSUTF8StringEncoding];
    
    //reset minimumHeight
    if(lines != 0){
        NSMutableParagraphStyle *newParagraph = [currentStr attribute:NSParagraphStyleAttributeName atIndex:0 effectiveRange:nil];
        [newParagraph setMinimumLineHeight:0];
        [newParagraph setMaximumLineHeight:0];
        [currentStr addAttribute:NSParagraphStyleAttributeName value:newParagraph range:NSMakeRange(0, [currentStr length])];
    }
    
    
    
}


- (void)attributeTextContextDidChange{
    
    [self setNeedsDisplayStartGrouping];
    if(self.attributeText != nil){
        [self saveHTMLTextFromattributeText];
        [self.iuFrame.currentScreenFrame.extraData setObject:[self CSSDictWithIuNameFromAttributedString] forKey:@"textCSSDict"];
        [self setNeedsDisplay:IUNeedsDisplayActionAll];
        
    }else{
        self.htmlText = nil;
        [self.iuFrame.currentScreenFrame.extraData removeObjectForKey:@"textCSSDict"];
        [self setNeedsDisplay:IUNeedsDisplayActionAll];
    }
    [self setNeedsDisplayEndGrouping];

}


- (void)mouseDown:(NSEvent *)theEvent{
    NSLog(@"MD");
}


#pragma mark -
#pragma mark Make HTML Part
#pragma mark -
#pragma mark AttributedString to HTML

-(NSMutableString*)CSSSourceWithScreenType:(IUScreenType)screenType{
    NSMutableString *retStr = [super CSSSourceWithScreenType:screenType];
    
    //add attributeString style
    NSDictionary *textCSSDict =[[self.iuFrame screenFrame:screenType].extraData objectForKey:@"textCSSDict"];
    if(textCSSDict){
        for(NSString *key in textCSSDict){
            NSString *cssValue = [textCSSDict objectForKey:key];
            [retStr appendFormat:@"[IUName = %@]{%@}\n", key, cssValue];
            
            if (self.event.mouseOn) {
                if (self.event.mouseOn.enableTextColor == YES) {
                    [retStr appendFormat:@"[IUName = %@]:hover{color : %@}\n", key, [self.event.mouseOn.textColor rgbString] ];
                }
                
            }
        }
    }
    return retStr;
}

-(NSString *)CSSFromAttributedString{
    NSRange start = [self.htmlText rangeOfString:@"<style type=\"text/css\">"];
    NSRange end = [self.htmlText rangeOfString:@"</style>"];
    NSRange styleRange = NSMakeRange(start.location+start.length, end.location - start.location - start.length);
    return [self.htmlText substringWithRange:styleRange];
}

-(NSMutableDictionary *)CSSDictWithIuNameFromAttributedString{
    NSMutableDictionary *retDict = [NSMutableDictionary dictionary];
    NSMutableDictionary *originDict = [self CSSDictFromAttributedString];
    for(NSString *key in originDict){
        NSArray *keys = [key componentsSeparatedByString:@"."];
        NSString *newKey = [[NSString alloc] initWithFormat:@"%@_%@_%@", self.fullIUName, keys[0], keys[1]];
        NSString *value = [originDict objectForKey:key];
        
        [retDict setObject:value forKey:newKey];
    }
    
    return retDict;
}

-(NSMutableDictionary *)CSSDictFromAttributedString{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *cssStr = [self CSSFromAttributedString];
    cssStr = [cssStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    cssStr = [cssStr stringByReplacingOccurrencesOfString:@"'" withString:@""];

    
    NSArray *cssArray = [cssStr componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"{}"]];
    NSMutableArray *keyArray = [NSMutableArray array];
    NSMutableArray *valueArray = [NSMutableArray array];
    NSInteger i =0;

    for(NSString *str in cssArray){
        if(str.length ==0) continue;
        if(i %2 ==0){
            NSString *keyStr = [str trim];
            [keyArray addObject:keyStr];
        }
        if(i%2 ==1){
            [valueArray addObject:[str stringByAppendingString:@";"]];
        }
        i++;
    }
    i=0;
    

    for(NSString *key in keyArray){
        NSMutableString *value = [[NSMutableString alloc] initWithString:[valueArray objectAtIndex:i]];
        if([value containsString:@"font:"]){
            //find => margin: 0.0px 0.0px 0.0px 0.0px; font: 12.0px Helvetica
            //divide font => font-family, font-size
            //font(CSS) reset other attributes
            NSRange fontRange = [value rangeOfString:@"font:"];
            NSRange endRange = [value rangeOfString:@";" options:0 range:NSMakeRange(fontRange.location, value.length-fontRange.location)];
            NSString *fontStr = [value substringFromIndex:(fontRange.length+fontRange.location+1) toIndex:endRange.location];
            if(fontStr != nil){
                NSArray *fontArray = [fontStr componentsSeparatedByString:@" "];
                NSString *newFontStr = [NSString stringWithFormat:@"font-size: %@; font-family: %@;", fontArray[0], fontArray[1]];
                [value replaceCharactersInRange:NSMakeRange(fontRange.location, endRange.location-fontRange.location+1) withString:newFontStr];
            }
            
        }

        [dict setObject:value forKey:key];
        i++;
    }
    
  
   
    
    return dict;
}

-(NSString *)HTMLFromAttributedString{
    NSRange start = [self.htmlText rangeOfString:@"<body>"];
    NSRange end = [self.htmlText rangeOfString:@"</body>"];
    NSRange htmlRange = NSMakeRange(start.location+start.length, end.location - start.location - start.length);
    return [self.htmlText substringWithRange:htmlRange];
}

-(NSString *)HTMLwithIUNameFromAttributedString{
    NSMutableString *htmlPart = [[NSMutableString alloc] initWithString:[self HTMLFromAttributedString]];
    NSMutableDictionary *dict = [self CSSDictFromAttributedString];
    
    for(NSString *key in dict){
        //keys[0] == hdml class, keys[1] == className
        // <p class="p2"> ; p keys[0] ; p2 keys[1]
        NSArray *keys = [key componentsSeparatedByString:@"."];
        NSString *newKey = [[NSString alloc] initWithFormat:@"<%@ class=\"%@\">", keys[0], keys[1]];
        NSString *iuname = [[NSString alloc] initWithFormat:@"%@_%@_%@", self.fullIUName, keys[0], keys[1]];
        NSString *iuNameAttribute = [[NSString alloc] initWithFormat:@" IUName='%@'", iuname];
        
        NSRange cssRange = [htmlPart rangeOfString:newKey];
        while(cssRange.length != 0){
            NSInteger index = cssRange.location + cssRange.length -1;
            [htmlPart insertString:iuNameAttribute atIndex:index];
            NSInteger startIndex = cssRange.location + cssRange.length + iuNameAttribute.length;
            NSRange findRange = NSMakeRange(startIndex,  htmlPart.length - startIndex);
            cssRange = [htmlPart rangeOfString:newKey options:0 range:findRange];
        }
        
        
    }
    return htmlPart;
}


#pragma mark -
#pragma mark IUText HTML

-(NSString *)HTMLTag2{
    NSString *HTMLTag = [super HTMLTag2];
    
    if(self.enableHeading){
        NSInteger currentLevel = self.headingLevel+1;
        HTMLTag= [[NSString alloc] initWithFormat:@"h%ld", (long)currentLevel];

    }
    return HTMLTag;
}
-(NSString*)innerOutputHTML2{
    if (self.variable) {
        if ([self.rootIU isKindOfClass:[IUComp class]]) {
            return [self.project.compiler statementOfVariableInComp:self.variable];
        }
        else{
            return [self.project.compiler statementOfVariable:self.variable];
        }
    }
    else{
        if(self.htmlText == nil) return @"";
        return [[NSString alloc] initWithFormat:@"%@",
                [self HTMLwithIUNameFromAttributedString]];
    }
}

-(NSString*)innerHTML2:(id)caller{
    if(self.htmlText == nil) return @"";
    return [[NSString alloc] initWithFormat:@"%@",
            [self HTMLwithIUNameFromAttributedString]];

}


#pragma mark -
#pragma mark JavaScript
-(NSString *)insertionJavascript{
    NSMutableString *js = [[NSMutableString alloc] initWithString:[super insertionJavascript]];
    [js appendString:@";\n"];
    
    //add attributeString style
    NSDictionary *textCSSDict =[[self.iuFrame screenFrame:self.iuManager.pWC.selectedScreenType].extraData objectForKey:@"textCSSDict"];
    if(textCSSDict){
        for(NSString *key in textCSSDict){
            NSString *cssValue = [textCSSDict objectForKey:key];
            [js appendFormat:@"setIUStyle('%@', '%@', 1);\n", [key stringEscape], cssValue];
        }
    }
    return js;
}

-(NSString *)CSSChangeJavascript{
    NSMutableString *js = [[NSMutableString alloc] initWithString:[super CSSChangeJavascript]];
    [js appendString:@"\n"];
    
    //add attributeString style
    NSDictionary *textCSSDict =[[self.iuFrame screenFrame:self.iuManager.pWC.selectedScreenType].extraData objectForKey:@"textCSSDict"];
    if(textCSSDict){
        for(NSString *key in textCSSDict){
            NSString *cssValue = [textCSSDict objectForKey:key];
            [js appendFormat:@"setIUStyle('%@', '%@', %ld);\n", key, [cssValue stringEscape], [self iuStyleType]];
        }
    }
    return js;
}


#pragma mark -
#pragma mark RightMenu

-(NSMenu*)popUpMenu{
    NSMenu *menu = [super popUpMenu];
    
    NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:@"Font Size To Fit" action:@selector(fitFontSize) keyEquivalent:@""];
    item.target = self;
    [menu addItem:item];
    
    return menu;
}

-(NSMenuItem* )subMenuSize{
    NSMenuItem *size = [super subMenuSize];
    NSMenu *subImageMenu =  size.submenu;
    [subImageMenu addItemWithTitle:@"Text" action:@selector(fitToText) keyEquivalent:@"" target:self];
    [size setSubmenu:subImageMenu];
    return size;
    
}

#pragma mark rightMenu selector

-(void)fitFontSize{
    
    NSInteger currentlines = [[self.sampleText componentsSeparatedByString:@"\n"] count];
    self.fontSize = floorf( self.iuFrame.currentScreenFrame.pixelHeight / currentlines );
    
}

-(void)fitToText{
    [self setNeedsDisplayStartGrouping];
    self.iuFrame.currentScreenFrame.pixelWidth = [self.iuManager.iuViewManager getTextWidth:self];
    self.iuFrame.currentScreenFrame.pixelHeight = [self.iuManager.iuViewManager getTextHeight:self];
    [self setNeedsDisplay:IUNeedsDisplayActionCSS];
    [self setNeedsDisplayEndGrouping];
}
@end
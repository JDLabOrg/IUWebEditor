//
//  IUTopToolBar2VC.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 3. 3..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "IUTextToolbarVC.h"
#import "IUViewManager.h"
#import "IUTextFieldEdit.h"

@interface IUTextToolbarVC ()

@end

@implementation IUTextToolbarVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pWC:(MGProjectWC *)aPWC
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        self.pWC = aPWC;

    }
    return self;
}

-(void)awakeFromNib{
    self.textV.textStorage.delegate = self;
    self.currentStorage = self.textV.textStorage;

}
-(void)dealloc{
}

#pragma mark -
#pragma mark Toolbar default

-(NSDictionary *)currentDictionary{
    NSRange currentRange = [self.textV selectedRange];
    NSTextStorage *storage = [self.textV textStorage];
    
    if(storage.length ==0 ||
       currentRange.length ==0 ){
        return [self.textV typingAttributes];
    }
    
    NSInteger index = currentRange.location;
    NSDictionary *currentDict = [storage attributesAtIndex:index effectiveRange:nil];
    return currentDict;
}

-(NSFont *)currentFont{
    
    NSFont *_currentFont = [self.currentDictionary objectForKey:NSFontAttributeName];
    return _currentFont;
}
-(NSParagraphStyle *)currentParagraph{
    
    NSMutableParagraphStyle *_currentParagraph = [self.currentDictionary objectForKey:NSParagraphStyleAttributeName];
    return _currentParagraph;
}

-(NSTextStorage *)storage{
    return [self.textV textStorage];
}

-(IUObj *)currentIU{
    IUObj *obj = self.pWC.iuController.selection;
    if([obj isKindOfClass:[IUText class]]){
        self.selectType = IUSelectTypeText;
        return obj;
    }
    else if([obj isKindOfClass:[IUTextFieldEdit class]]){
        self.selectType = IUSelectTypeTextFieldEdit;
        return obj;
    }
    
    self.selectType = IUSelectTypeNone;
    return nil;
}

-(IUText *)currentIUText{
    return (IUText *)[self currentIU];

}
-(IUTextFieldEdit *)currentIUTextFieldEdit{
    return (IUTextFieldEdit *)[self currentIU];
}





#pragma mark range
-(NSRange)currentRange{
    return [self.textV selectedRange];
}

-(NSRange)saveRange{
    NSRange range = [self.textV selectedRange];
    
    if (range.length==0){
        range = NSMakeRange(0, [self.storage length]);
    }
    return range;
}
-(NSRange)wholeRange{
    return NSMakeRange(0, [self.storage length]);
}




#pragma mark -
#pragma mark setting value
#pragma mark fontName

- (IBAction)clickFontNameBtn:(id)sender {
    NSPopUpButton *btn = sender;
    NSMenuItem *item = [btn selectedItem];
    NSString *selectedFontName = item.title;
    
    NSFont *newFont = [[NSFontManager sharedFontManager] convertFont:self.currentFont toFamily:selectedFontName];
    if(self.selectType == IUSelectTypeText){
        [self setNewAttribute:NSFontAttributeName value:newFont range:self.saveRange];
    }
    else if (self.selectType == IUSelectTypeTextFieldEdit){
        [self currentIUTextFieldEdit].fontName = newFont.familyName;
    }
    
}

#pragma mark fontSize

-(BOOL)control:(NSControl *)control textShouldEndEditing:(NSText *)fieldEditor{
    if([[control identifier] isEqualToString:@"fontSize"]){
        CGFloat fontsize = [[fieldEditor string] floatValue];
        self.currentFontSize = fontsize;
        [self updateFontSizeControls];
    }
    return YES;
}

- (IBAction)clickFonSizeStepper:(id)sender {
    CGFloat stepperValue = [sender floatValue];
    self.currentFontSize = stepperValue;
    [self updateFontSizeControls];
}

-(void)updateFontSizeControls{
    
    [self.fontSizeField setStringValue:[NSString stringWithFormat:@"%.f", self.currentFontSize]];
    [self.fontSizeStepper setIntegerValue:roundf(self.currentFontSize)];
}

- (void)setCurrentFontSize:(CGFloat)currentFontSize{
    if(self.selectType == IUSelectTypeText){
        NSFont *newFont = [[NSFontManager sharedFontManager] convertFont:self.currentFont toSize:currentFontSize];
        [self setNewAttribute:NSFontAttributeName value:newFont range:self.saveRange];
    }
    else if(self.selectType == IUSelectTypeTextFieldEdit){

        [self currentIUTextFieldEdit].fontSize = currentFontSize;
    }
}

-(CGFloat)currentFontSize{
    if(self.selectType == IUSelectTypeText){
        return self.currentFont.pointSize;
    }
    else if (self.selectType == IUSelectTypeTextFieldEdit){
        return [self currentIUTextFieldEdit].fontSize;
    }
    
    return 0;
}

#pragma mark Color

-(void)setCurrentColor:(NSColor *)currentColor{
    if(self.selectType == IUSelectTypeText){
        [self setNewAttribute:NSForegroundColorAttributeName value:currentColor range:self.saveRange];
    }
    else if (self.selectType == IUSelectTypeTextFieldEdit){
        [self currentIUTextFieldEdit].fontColor = currentColor;
    }
    
}
-(NSColor *)currentColor{
    NSColor *color;
    
    if(self.selectType == IUSelectTypeText){
        color = [self.currentDictionary objectForKey:NSForegroundColorAttributeName];
    }
    else if (self.selectType == IUSelectTypeTextFieldEdit){
        color = [self currentIUTextFieldEdit].fontColor;
    }
    
    if(color == nil){
        color = [NSColor blackColor];
    }
    return color;
}
#pragma mark bold, italic, under

- (IBAction)clickFontTraitsControl:(id)sender {
    NSInteger clickedSegment = [sender selectedSegment];
    NSInteger currentIdx = [[sender cell] tagForSegment:clickedSegment];
    BOOL currentValue;
    switch (currentIdx) {
        case 0://bold
            currentValue = self.bold;
            [self.fontTraitsControl setSelected:!currentValue forSegment:currentIdx];
            [self setBold:!currentValue];
            break;
        case 1://italic
            currentValue = self.italic;
            [self.fontTraitsControl setSelected:!currentValue forSegment:currentIdx];
            [self setItalic:!currentValue];
            break;
        case 2://underline
            currentValue = self.underline;
            [self.fontTraitsControl setSelected:!currentValue forSegment:currentIdx];
            [self setUnderline:!currentValue];
            break;
        default:
            break;
    }
    
}
-(void)setBold:(BOOL)bold{
    NSFont *newFont;
    if(bold){
        newFont = [[NSFontManager sharedFontManager] convertFont:self.currentFont toHaveTrait:NSBoldFontMask];
    }else{
        newFont = [[NSFontManager sharedFontManager] convertFont:self.currentFont toNotHaveTrait:NSBoldFontMask];

    }
    [self setNewAttribute:NSFontAttributeName value:newFont range:self.saveRange];
    

}
-(BOOL)bold{
    NSInteger traits = [[NSFontManager sharedFontManager] traitsOfFont:self.currentFont];
    return traits & NSBoldFontMask;
}

-(void)setItalic:(BOOL)italic{
    NSFont *newFont;
    if(italic){
        newFont = [[NSFontManager sharedFontManager] convertFont:self.currentFont toHaveTrait:NSItalicFontMask];
    }else{
        newFont = [[NSFontManager sharedFontManager] convertFont:self.currentFont toNotHaveTrait:NSItalicFontMask];
        
    }
    [self setNewAttribute:NSFontAttributeName value:newFont range:self.saveRange];
}

-(BOOL)italic{
    NSInteger traits = [[NSFontManager sharedFontManager] traitsOfFont:self.currentFont];
    return traits & NSItalicFontMask;
}

-(void)setUnderline:(BOOL)underline{
    
    [self setNewAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithBool:underline]  range:self.saveRange];

}
-(BOOL)underline{
    return [[self.currentDictionary objectForKey:NSUnderlineStyleAttributeName] boolValue];
}

#pragma mark -
#pragma mark align
- (IBAction)clickTextAlignControl:(id)sender {
    NSInteger clickedSegment = [sender selectedSegment];
    NSInteger currentIdx = [[sender cell] tagForSegment:clickedSegment];
    NSMutableParagraphStyle *newParagraph = [self.currentParagraph mutableCopy];
    
    switch (currentIdx) {
        case 0://left
            [newParagraph setAlignment:NSLeftTextAlignment];
            break;
        case 1://middle
            [newParagraph setAlignment:NSCenterTextAlignment];
            break;
        case 2://right
            [newParagraph setAlignment:NSRightTextAlignment];
            break;
        case 3://normal
            [newParagraph setAlignment:NSJustifiedTextAlignment];
            break;
        default:
            break;
    }

    [self setNewAttribute:NSParagraphStyleAttributeName value:newParagraph range:self.saveRange];
}

-(NSInteger)currentAlignment{
    NSTextAlignment align = [self currentParagraph].alignment;
    NSInteger index =0;
    switch (align) {
        case NSLeftTextAlignment:
        case NSJustifiedTextAlignment:
        case NSNaturalTextAlignment:
            index =0;
            break;
        case NSRightTextAlignment:
            index =2;
            break;
        case NSCenterTextAlignment:
            index = 1;
            break;
        default:
            break;
    }
    return index;
}

#pragma mark spacing (lineHeight)

-(NSString *)currentlineHeight{
    IUText *obj = [self currentIUText];
    if(obj == nil){
        return @"Spacing";
    }
    if(obj.lineHeight == IUTextLineHeightAuto){
        return @"Auto";
    }
    NSString *spacingStr = [NSString stringWithFormat:@"%.1f", obj.lineHeight/self.currentFontSize];
    return spacingStr;

}

- (IBAction)clickLineSpacing:(id)sender {
    NSComboBox *comboBox = sender;
    if([comboBox indexOfSelectedItem] < 0) return;
    NSString *selectedStr = [comboBox itemObjectValueAtIndex:[comboBox indexOfSelectedItem]];
    IUText *obj = [self currentIUText];
    if([selectedStr isEqualToString:@"Auto"]){
        obj.lineHeight = IUTextLineHeightAuto;
    }else{
        obj.lineHeight = [selectedStr floatValue]*self.currentFontSize;
    }
}



#pragma mark link
/*
-(void)setLinkStr:(NSString *)linkStr{
    if([linkStr length] == 0 ){
        return;
    }
    [self setNewAttribute:NSLinkAttributeName value:linkStr range:self.saveRange];
}
-(NSString *)linkStr{
    NSString *link = [[self currentDictionary] objectForKey:NSLinkAttributeName];
    if(link == nil){
        return @"";
    }
    return link;
}
*/
#pragma mark -
#pragma mark typing Dictionary

-(void)setNewAttribute:(NSString *)name value:(id)value range:(NSRange)range;
{
    [self.storage beginEditing];
    [self.storage addAttribute:name value:value range:range];
    [self.storage endEditing];
    [self.textV didChangeText];
    [self setNewTypingDictionaryWithAttributes:name value:value];
    
}

-(void)setNewTypingDictionaryWithAttributes:(NSString *)name value:(id)value{
    NSMutableDictionary *dict =  [[self.textV typingAttributes] mutableCopy];
    [dict removeObjectForKey:name];
    [dict setObject:value forKey:name];
    [self.textV setTypingAttributes:dict];
}



#pragma mark toolbar state


-(NSDictionary *)defaultDictionary{
   
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    IUText *textObj = [self currentIUText];
    
    //initailize
    NSMutableParagraphStyle *defaultParagraph = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    //align
    [defaultParagraph setAlignment:textObj.alignmentIdx];
    [defaultParagraph setLineSpacing:textObj.lineHeight];
    
    //font
    NSFont *font = [NSFont fontWithName:@"Helvetica" size:textObj.fontSize];
    
    [self.textV setDefaultParagraphStyle:defaultParagraph];
    [self.textV setFont:font];
    
    [dict setObject:defaultParagraph forKey:NSParagraphStyleAttributeName];
    [dict setObject:font forKey:NSFontAttributeName];

    
    return dict;
}



-(void)resetToolBarState{//when change selected IUobj
    
    id selection = self.pWC.iuController.selection;
    [self currentIU];

    if(selection == NSMultipleValuesMarker
       || selection == NSNoSelectionMarker
       || self.selectType == IUSelectTypeNone){
        [self disableToolBar];
        
    }else{
    
        if([self storage].length == 0
           && self.selectType == IUSelectTypeText){
            [self.textV setTypingAttributes:[self defaultDictionary]];
        }
        else if (self.selectType == IUSelectTypeTextFieldEdit){
            [self.textV setDefaultParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
        }
        
        [self setCurrentStateForToolBar];
    }
}

-(void)disableToolBar{
    
    [self.fontTraitsControl setEnabled:NO];
    [self.textAlignControl setEnabled:NO];
    [self.lineSpacingComboBox setEnabled:NO];
    [self.fontNameBtn setEnabled:NO];
    [self.fontSizeStepper setEnabled:NO];
    [self.fontSizeField setEnabled:NO];
    [self.fontColorBtn setEnabled:NO];
}


-(void)setCurrentStateForToolBar{

    NSString *fontName;
    
    if(self.selectType == IUSelectTypeText){
        
        //fontName
        fontName = [self currentFont].familyName;
        
        /*current font traits*/
        [self.fontTraitsControl setEnabled:YES];
        [self.fontTraitsControl setSelected:self.bold forSegment:0];
        [self.fontTraitsControl setSelected:self.italic forSegment:1];
        [self.fontTraitsControl setSelected:self.underline forSegment:2];
        
        
        //align
        [self.textAlignControl setEnabled:YES];
        [self.textAlignControl setSelected:YES forSegment:[self currentAlignment]];
        
        [self.lineSpacingComboBox setEnabled:YES];
        [self.lineSpacingComboBox setStringValue:[self currentlineHeight]];
        /*
         if(self.linkStr != nil){
         [self.linkTextField setStringValue:self.linkStr];
         }
         */
    }
    else if (self.selectType == IUSelectTypeTextFieldEdit){
        fontName = [self currentIUTextFieldEdit].fontName;
        
        [self.fontTraitsControl setEnabled:NO];
        [self.textAlignControl setEnabled:NO];
        [self.lineSpacingComboBox setEnabled:NO];
    }
    
    [self.fontNameBtn setEnabled:YES];
    if(fontName){
        [self.fontNameBtn setTitle:fontName];
    }
    
    //fontSize
    [self updateFontSizeControls];
    [self.fontSizeStepper setEnabled:YES];
    [self.fontSizeField setEnabled:YES];
    
    //color
    [self.fontColorBtn setEnabled:YES];
    [self.fontColorBtn setColor:self.currentColor];
   
    
}

#pragma mark textView - bgcolor
- (IBAction)bgColorChangeBtnClick:(id)sender {
    
    NSColor *currentColor =  [self.textV backgroundColor];
    if([currentColor isEqualTo:[NSColor whiteColor]]){
        [self.textV setBackgroundColor:[NSColor blackColor]];
        [self.textV setInsertionPointColor:[NSColor whiteColor]];
    }
    else{
        [self.textV setBackgroundColor:[NSColor whiteColor]];
        [self.textV setInsertionPointColor:[NSColor blackColor]];
    }
}



#pragma mark -
#pragma mark delegate
#pragma mark textView

-(void)textViewDidChangeSelection:(NSNotification *)notification{
    [self setCurrentStateForToolBar];
}

//call from IUTextDraggingView : escview
-(void)endEditing{
    [self.pWC.selectedIUViewManager disableTextEditor];
}


@end

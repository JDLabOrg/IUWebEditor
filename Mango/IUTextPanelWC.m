//
//  IUTextPanelWC.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2014. 1. 23..
//  Copyright (c) 2014년 jdlab.org. All rights reserved.
//

#import "IUTextPanelWC.h"
#import "IUText.h"


static IUTextPanelWC *gIUTextPanel = nil;

@interface IUTextPanelWC ()
@property (nonatomic) MGProjectWC* pWC;
@end

@implementation IUTextPanelWC{
}

#pragma mark sharedpanel

+(IUTextPanelWC *)sharedInstanceWithPWC:(MGProjectWC *)pWC{
    if(gIUTextPanel == nil){
        gIUTextPanel = [[IUTextPanelWC alloc] initWithWindowNibName:@"IUTextPanelWC"];
    }
    [gIUTextPanel setPWC:pWC];
    return gIUTextPanel;
}

#pragma mark -

-(void)showWindow:(id)sender{
    [[NSColorPanel sharedColorPanel] close];
    NSColorPanel *colorPanel = [NSColorPanel sharedColorPanel];
    [colorPanel setTarget:nil];
    [super showWindow:sender];
}

-(void)windowDidResignKey:(NSNotification *)notification{
    [self close];
}

-(void)close{
    if ([NSCursor currentCursor] == [NSCursor IBeamCursor]) {
        [[NSApp mainWindow] enableCursorRects];
        [NSCursor pop];
    }
    [super close];
}

 
-(void)windowDidBecomeKey:(NSNotification *)notification{
    [self.window makeFirstResponder:self.textV];
}

-(id)initWithWindowNibName:(NSString *)windowNibName
{
    self = [super initWithWindowNibName:windowNibName];
    
    if(self){
    }
    
    return self;
}

-(void)windowDidLoad{
}
-(void)setPWC:(MGProjectWC *)pwc{
    _pWC = pwc;
}
#pragma mark -
#pragma mark bgcolor

- (IBAction)bgColorChangBtnClick:(id)sender {
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
#pragma mark Link
- (IBAction)clickLinkBtn:(id)sender {
    [self.textV orderFrontLinkPanel:sender];
}

- (NSRange)textView:(NSTextView *)textView willChangeSelectionFromCharacterRange:(NSRange)oldSelectedCharRange toCharacterRange:(NSRange)newSelectedCharRange{
//    NSLog(@"textV change : %@", [self.textV.attributedString string]);
    IUText *obj = self.pWC.iuController.selection;
    if([obj isKindOfClass:[IUText class]] == NO){
        return newSelectedCharRange;
    }
    NSAttributedString *currentString = obj.attributeText;
    

    NSInteger index = [self.textV selectedRange].location;
    if(currentString.length == 0 || index >= currentString.length){
        return newSelectedCharRange;
    }
    
    NSDictionary *currentDict = [currentString attributesAtIndex:index effectiveRange:nil];
    NSString *urlString = [currentDict objectForKey:NSLinkAttributeName];
    self.linkStr = urlString;
    
//    NSLog(@"URL : %@", urlString);
    return newSelectedCharRange;
}


@end

//
//  IUNaviLinkBarItem.m
//  WebGenerator
//
//  Created by JD on 1/2/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "IUNaviLinkBarItem.h"
#import "IUNaviLinkBar.h"

@implementation IUNaviLinkBarItem

-(void)iuLoad{
    [super iuLoad];
    self.alignmentIdx = 1;
    self.draggable = NO;
    
    self.iuFrame.disableX = YES;
}

-(BOOL)shouldChangeXByUserInput:(CGFloat)x{
    return NO;
}

-(BOOL)shouldChangeYByUserInput:(CGFloat)y{
    return NO;
}

-(NSString*)HTMLTag2{
    return @"li";
}

-(NSMutableDictionary*)CSSDictWithScreenType:(IUScreenType)screenType{
    NSMutableDictionary *CSSDict = [super CSSDictWithScreenType:screenType];
    [CSSDict putString:@"left" forKey:@"float" param:nil];
    return CSSDict;
}

-(id)instantiate{
    [super instantiate];
    self.sampleText = @"Lorem Ipsum";
    self.iuFrame.defaultScreenFrame.percentFlagY = NO;
    self.iuFrame.defaultScreenFrame.percentFlagX = YES;
    self.iuFrame.defaultScreenFrame.percentFlagWidth = YES;
    self.iuFrame.defaultScreenFrame.percentHeight = 100;
    self.iuFrame.disableX = YES;
    self.iuFrame.disableY = YES;
    self.iuFrame.disableWidth= YES;
    return self;
}

-(BOOL)shouldBeInsertedByUserByUser:(IUView *__autoreleasing *)parent atIndex:(NSInteger *)zIndex{
    if ([*parent isKindOfClass:[IUNaviLinkBar class]]) {
        return YES;
    }
    return NO;
}

-(NSString*)insertionJavascript{
    NSString *htmlJavascript;
    if (self.index == 0) {
        htmlJavascript = [NSString stringWithFormat:@"$($(\"[iuname=%@]\").children()[0]).prepend(\"%@\")", self.parent.fullIUName, [[self HTMLSource2:self ] stringEscape]];
    }
    else {
        htmlJavascript = [NSString stringWithFormat:@"$($(\"[iuname=%@]\").children()[0]).children().eq(%lu).after(\"%@\")", self.parent.fullIUName, self.index -1, [[self HTMLSource2:self] stringEscape]];
    }
    return htmlJavascript;
}
@end

//
//  IUNaviLinkBar.m
//  WebGenerator
//
//  Created by JD on 1/2/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "IUNaviLinkBar.h"
#import "IUNavi.h"
#import "IUNaviLinkBarItem.h"

@implementation IUNaviLinkBar{
    BOOL instantiate;
}

-(id)init{
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"iuFrame.y" options:0 context:nil];
    }
    return self;
}

-(id)instantiate{
    [super instantiate];
    IUNaviLinkBarItem *item = [[IUNaviLinkBarItem alloc] init];
    [item instantiate];
    [self addIU:item error:nil];
    
    IUNaviLinkBarItem *item2 = [[IUNaviLinkBarItem alloc] init];
    [item2 instantiate];
    [self addIU:item2 error:nil];
    
    [self.iuFrame setFullWidth];
    return self;

}


-(BOOL)shouldChangeXByUserInput:(CGFloat)x{
    return NO;
}

-(BOOL)shouldChangeYByUserInput:(CGFloat)y{
    if ([self.parent isKindOfClass:[IUNavi class]]) {
        return YES;
    }
    return NO;
}

-(BOOL)shouldChangeZByUserInput:(NSInteger)z{
    if (z==1000) {
        return YES;
    }
    return NO;
}

-(NSMutableString*)innerOutputHTML2{
    NSMutableString *str = [NSMutableString stringWithString:@"<ul>"];
    for (IUObj *childIU in self.children) {
        if ([childIU outputHTMLSource2:self]) {
            [str appendString:[childIU outputHTMLSource2:self]];
            [str appendString:@"\n"];
        }
    }
    [str appendString:@"</ul>"];
    return str;
}
-(NSString*)innerHTML2:(id)caller{
    NSMutableString *str = [NSMutableString stringWithString:@"<ul>"];
    for (IUObj *childIU in self.children) {
        if ([childIU HTMLSource2:caller]) {
            [str appendString:[childIU HTMLSource2:caller]];
            [str appendString:@"\n"];
        }
    }
    [str appendString:@"</ul>"];
    return str;
}

-(NSString*)HTMLTag2{
    return @"nav";
}


-(BOOL)shouldInsertIU:(IUObj **)insertedIU{
    IUObj *iu = *insertedIU;
    if ([iu isKindOfClass:[IUNaviLinkBarItem class]]) {
        return YES;
    }
    return NO;
}

-(BOOL)shouldBeInsertedByUser:(IUView *__autoreleasing *)parent atIndex:(NSUInteger *)index{
    *index = 0;
    if ([*parent isKindOfClass:[IUNavi class]] == NO) {
        *parent = (*parent).rootIU;
        self.z = 1000;
    }
    return YES;
}


-(BOOL)IUDidInsertedByUserAction:(IUView*)parent atIndex:(NSInteger)zIndex{
    /*
    self.iuFrame.y = 0;
    self.iuFrame.x = 0;
     */
    return YES;
}


@end

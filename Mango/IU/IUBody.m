//
//  IUBody.m
//  Mango
//
//  Created by JD on 13. 8. 9..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUBody.h"

@implementation IUBody

-(id)instantiate{
    [super instantiate];
    
    self.draggable = NO;
    self.iuFrame.disableY = YES;
    [self.iuFrame setFullWidth];
    self.iuFrame.defaultScreenFrame.flowLayout = YES;
    self.iuFrame.disableHeight = YES;
    self.iuFrame.defaultScreenFrame.percentFlagHeight = NO;
    self.iuFrame.defaultScreenFrame.pixelHeight = 1230;
    self.iuFrame.horizontalCenter = YES;
    self.bg.color = [NSColor whiteColor];
    return self;
}



#pragma mark -
#pragma mark HTML


-(NSMutableDictionary*)outputDict2{
    NSMutableDictionary *dict = [super outputDict2];
    [dict removeObjectForKey:@"height" param:nil];
    return dict;
}

-(NSString*)innerHTML2:(id)caller{
    NSString *retStr = [super innerHTML2:caller];
    return [retStr stringByAppendingString:@"<!-_IUPage_HTML_-!>"];
}

-(NSString*)innerOutputHTML2{
    NSString *retStr = [super innerOutputHTML2];
    return [retStr stringByAppendingString:@"<!-_IUPage_HTML_-!>"];
}

- (NSMutableDictionary*)CSSDictWithScreenType:(IUScreenType)screenType{
    NSMutableDictionary *dict = [super CSSDictWithScreenType:screenType];
    [dict removeObjectForKey:@"height" param:nil];
    return dict;
}


- (BOOL)removeFromSuperIU:(id)sender{
    NSBeep();
    return NO;
}

@end

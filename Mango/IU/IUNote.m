//
//  IUNote.m
//  Mango
//
//  Created by JD on 13. 7. 10..
/// Copyright (c) 2004-2013, JDLab  / Yang Joodong
/// All rights reserved. Licensed under the GPL.
/// See the GNU General Public License for more details. (/LICENSE)

//

#import "IUNote.h"
#import "MGFileItem.h"


@implementation IUNote

-(id)instantiate{
    [super instantiate];
    self.iuFrame.defaultScreenFrame.pixelWidth = 1024;
    self.iuFrame.defaultScreenFrame.pixelHeight = 728;
    self.templateName = @"template.tmiu";
    
    IUText *titleV = (IUText*)[[[IUText alloc] init] instantiate];
    [self insertIU:titleV atIndex:0 error:nil];
    titleV.sampleText = @"Title";
    titleV.headingLevel = 1;
    titleV.enableHeading = YES;
    titleV.iuFrame.defaultScreenFrame.pixelX = 50;
    titleV.iuFrame.defaultScreenFrame.pixelY = 60;
    titleV.iuFrame.defaultScreenFrame.pixelHeight = 80;
    titleV.iuFrame.defaultScreenFrame.pixelWidth = 924;
    titleV.iuFrame.horizontalCenter = YES;
    titleV.alignmentIdx = NSCenterTextAlignment;
    titleV.fontColor= [NSColor whiteColor];
    titleV.bg.color = nil;
    titleV.fontSize = 45;
    titleV.name = @"Title";

    IUText *content = (IUText*)[[[IUText alloc] init] instantiate];
    [self insertIU:content atIndex:1 error:nil];

    content.iuFrame.horizontalCenter = YES;
    content.iuFrame.defaultScreenFrame.pixelX = 100;
    content.iuFrame.defaultScreenFrame.pixelY = 210;
    content.iuFrame.defaultScreenFrame.pixelHeight = 450;
    content.iuFrame.defaultScreenFrame.pixelWidth = 824;

    content.sampleText = @" - content";
    content.bg.color = nil;
    content.alignmentIdx = NSLeftTextAlignment;
    content.fontSize = 42;
    content.lineHeight = IUTextLineHeightAuto;
    content.fontColor= [NSColor whiteColor];
    content.name = @"content";
    
    self.bg.color = nil;
    return self;
}

-(void)iuLoad{
    [super iuLoad];
    self.iuFrame.disableHeight = YES;
    self.iuFrame.disableX = YES;
    self.iuFrame.disableY = YES;

}

-(NSMutableDictionary*)sourceReplacementDict:(IUSourceType)type{
    NSMutableDictionary *dict = [super sourceReplacementDict:type];
    if (type == IUSourceTypeOutput) {
        NSMutableArray *arr = [NSMutableArray array];
        for (MGFileItem *item in self.fileItem.parent.children) {
            [arr addObject:[item.name stringByChangeExtension:@"html"]];
        }
        dict[@"_IUProjectInfo_"][@"pageFiles"] = arr;
        dict[@"_IUProjectInfo_"][@"currentPage"] = [self.fileItem.name stringByChangeExtension:@"html"];
    }
    return dict;
}

@end

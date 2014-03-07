//
//  IUResponsiveContainer.m
//  WebGenerator
//
//  Created by JD on 12/27/13.
//  Copyright (c) 2013 jdlab.org. All rights reserved.
//

#import "IUResponsiveContainer.h"
#import "IUViewManager.h"

@implementation IUResponsiveContainer{
    BOOL    instatiated;
}

-(id)instantiate{
    [super instantiate];
    self.iuFrame.horizontalCenter = YES;
    self.iuFrame.verticalCenter = YES;
    self.iuFrame.defaultScreenFrame.flowLayout = NO;
    self.iuFrame.disableHorizontalCenter = YES;
    self.iuFrame.disableVerticalCenter = YES;
    instatiated = YES;

    return self;
}

-(void)setIuManager:(IUManager *)iuManager{
    [super setIuManager:iuManager];
    if (instatiated) {
        self.iuFrame.defaultScreenFrame.pixelWidth = iuManager.iuViewManager.frame.size.width * 0.9;
        self.iuFrame.defaultScreenFrame.pixelHeight = self.parent.iuFrame.currentScreenFrame.pixelHeight * 0.9;
    }
}


-(BOOL)removeFromSuperIU:(id)sender{
    NSBeep();
    return NO;
}

@end

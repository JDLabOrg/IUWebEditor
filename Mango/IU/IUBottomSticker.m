//
//  IUBottomSticker.m
//  WebGenerator
//
//  Created by JD on 1/23/14.
//  Copyright (c) 2014 jdlab.org. All rights reserved.
//

#import "IUBottomSticker.h"

@implementation IUBottomSticker

-(id)instantiate{
    [super instantiate];
    [self.iuFrame setFullWidth];
    return self;
}
/*
-(BOOL)shouldChangeFlowLayoutByUserInput:(BOOL)flowLayout{
    return NO;
}
 */

-(BOOL)shouldChangeYByUserInput:(CGFloat)y{
    return NO;
}

-(BOOL)shouldBeInsertedByUser:(IUView *__autoreleasing *)parent atIndex:(NSUInteger *)zIndex{
    self.iuFrame.currentScreenFrame.pixelX = 0;
    return YES;
}

@end

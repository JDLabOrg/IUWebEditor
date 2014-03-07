//
//  IUFileViewController.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 28..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "IULeftFirstTabVC.h"
#import "IUFileNavVC.h"

@class MGProjectWC;

@interface IULeftVC : NSViewController{
        MGProjectWC     *pWC;
    NSViewController    *currentIns;
    
}

@property IULeftFirstTabVC   *objectIns;
@property IUFileNavVC     *fileIns;

@property NSInteger currentInsType;

-(void)setPWC:(MGProjectWC *)pwc;


@end


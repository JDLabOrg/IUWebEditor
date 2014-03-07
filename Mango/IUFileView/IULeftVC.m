//
//  IUFileViewController.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 28..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import "IULeftVC.h"
#import "IUFileNavVC.h"
#import "MGImageViewController.h"

@interface IULeftVC ()

@end

@implementation IULeftVC
@synthesize currentInsType;


-(void)awakeFromNib{
    NSLog(@"IUFileVC awake!!!");
    [self addObserver:self forKeyPath:@"currentInsType" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld|NSKeyValueObservingOptionInitial context:nil];
    

    
}
-(void)dealloc{
    [self removeObserver:self forKeyPath:@"currentInsType"];
}
-(void)setPWC:(MGProjectWC *)pwc{
    pWC = pwc;
    self.objectIns = [[IULeftFirstTabVC alloc] initWithNibName:@"IULeftFirstTabVC" bundle:nil pWC:pWC];
    self.fileIns = [[IUFileNavVC alloc] initWithNibName:@"IUFileNavVC" bundle:nil pWC:pWC];
    [self.view addSubviewFullFrame:self.objectIns.view];
    [self.view addSubviewFullFrame:self.fileIns.view];
    
    [self hideInsView];
    [self.objectIns.view setHidden:NO];
    
    [self.view setNeedsDisplay:YES];
    
}

-(void)hideInsView{
    [self.objectIns.view setHidden:YES];
    [self.fileIns.view setHidden:YES];
}

-(void)currentInsTypeDidChange{
    
    if (currentInsType == 0){ // object ins
        [self hideInsView];
        [self.objectIns.view setHidden:NO]; return;
    }
    else if (currentInsType == 1){// file ins
        [self hideInsView];
        [self.fileIns.view setHidden:NO]; return;
    }
    
    return;
    
}

@end


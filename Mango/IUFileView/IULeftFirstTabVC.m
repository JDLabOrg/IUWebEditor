//
//  IUObjectInspector.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 11. 28..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import "IULeftFirstTabVC.h"
#import "MGImageViewController.h"
#import "MGClassSelectVC.h"

@interface IULeftFirstTabVC ()

@end

@implementation IULeftFirstTabVC

@synthesize iVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil pWC:(MGProjectWC *)pwc
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        self.pWC = pwc;
    }
    return self;
}

-(void)awakeFromNib{
    [self.iVC setPWC:self.pWC];
    [self.classSelectVC setPWC:self.pWC];
    [self.iVC refreshImage];
    [self.imageArrayController rearrangeObjects];
}


- (IBAction)pressOpenImageFolder:(id)sender {
    NSURL *url =[NSURL fileURLWithPath:self.pWC.project.absoluteResDirPath];
    [[NSWorkspace sharedWorkspace] openURL:url];
}

- (IBAction)showHelpPopover:(id)sender {
    self.helpPopover.behavior = NSPopoverBehaviorTransient;
    [self.helpPopover showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxXEdge];
}

- (IBAction)reloadImage:(id)sender {
    [self.iVC refreshImage];
    [self.imageArrayController rearrangeObjects];
}

@end

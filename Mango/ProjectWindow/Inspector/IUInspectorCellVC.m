//
//  IUInspectorItemVC.m
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 12. 11..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import "IUInspectorCellVC.h"

@interface IUInspectorCellVC ()

@end

@implementation IUInspectorCellVC


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil name:(NSString *)aName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  
    if (self) {
        self.displayName = [NSString stringWithFormat:@"  %@", aName];
        self.isViewExpanded = YES;
    }
    return self;
}

-(void)awakeFromNib{
    [self.rightBtn setTitle:@"Hide" withColor:[NSColor controlTextColor]];
}

-(void)setDisplayName:(NSString *)displayName{
    _displayName = displayName;
}

-(void)setIsViewExpanded:(BOOL)viewExtension{
    _isViewExpanded = viewExtension;
    if (viewExtension) {
        [self.rightBtn setTitle:@"Hide" withColor:[NSColor controlTextColor]];
    }
    else{
        [self.rightBtn setTitle:@"Show" withColor:[NSColor selectedMenuItemColor]];
    }
}

- (IBAction)toggleView:(id)sender {
    self.isViewExpanded = !self.isViewExpanded;
}

@end
//
//  IUInspectorItemVC.h
//  WebGenerator
//
//  Created by ChoiSeungmi on 2013. 12. 11..
//  Copyright (c) 2013년 jdlab.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface IUInspectorCellVC : NSViewController{
    
}

@property (readonly) NSString *displayName;
@property (readonly) BOOL isViewExpanded;


@property (weak) IBOutlet NSButton *rightBtn;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil name:(NSString *)aName;
@end
